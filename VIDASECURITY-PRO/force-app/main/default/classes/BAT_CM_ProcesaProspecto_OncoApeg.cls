/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-31-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-21-2021   Juan Espinoza León   Initial Version
**/
global class BAT_CM_ProcesaProspecto_OncoApeg implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {  
    public String IdCampagna {get; set;}
   
    
    public BAT_CM_ProcesaProspecto_OncoApeg(string idCmp) {
        this.IdCampagna = idCmp;  
         system.debug('@@@@ this.IdCampagna: ' + this.IdCampagna);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) { 
        String query =  'SELECT Id, IsDeleted, CampaignId, LeadId, ContactId, Status, HasResponded, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, FirstRespondedDate, RecordTypeId, Salutation, '+
        'Name, FirstName, LastName, Title, Street, City, State, PostalCode, Country, Email, Phone, Fax, MobilePhone, Description, DoNotCall, HasOptedOutOfEmail, HasOptedOutOfFax, LeadSource, CompanyOrAccount, '+
        'Type, LeadOrContactId, LeadOrContactOwnerId, Agente__c, Causa_No_Contacto__c, Cerrado__c, Cerrado_por__c, Comentarios__c, Correo_Electronico__c, Enviar_Ley__c, Fecha_de_Activacion__c, Nombre_Empleador__c, '+
        'Numero_de_Poliza__c, Poliza__c, Producto__c, RUT_Empleador__c, Razon_Social_Empleador__c, Recibio_Ley__c, Sucursal__c, Supervisor__c, MCAMP_Abierto_Email_N1_Producto_Onco__c, MCAMP_Campana_Activa__c, '+
        'MCAMP_Carga_Apellido_Materno__c, MCAMP_Carga_Apellido_Paterno__c, MCAMP_Carga_Dv__c, MCAMP_Carga_Email_1__c, MCAMP_Carga_Email_2__c, MCAMP_Carga_Fecha_Nacimiento__c, MCAMP_Carga_Poliza_Mandatoria__c, '+
        'MCAMP_Carga_RUT__c, MCAMP_Carga_Tel_fono_1__c, MCAMP_Carga_Tel_fono_2__c, MCAMP_Codigo_Producto__c, MCAMP_Ejecutivo_Televenta__c, MCAMP_Enviado_Email_1_Producto_Onco__c, MCAMP_Es_Asegurable__c, '+
        'MCAMP_Es_cliente__c, MCAMP_Fecha_Fin_Campana__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c, MCAMP_Plan__c, MCAMP_Prima_IVA_CLP__c, MCAMP_Prima_IVA_UF__c, MCAMP_Prima_Neta_CLP__c, MCAMP_Prima_Neta_UF__c, '+
        'MCAMP_Ramo__c, MCAMP_Revision__c, MCAMP_Script_Televenta__c, MCAMP_Tarifa_CLP__c, MCAMP_Tarifa_UF__c, MCAMP_Tasa_Riesgo__c, MCAMP_Tipo_Folio__c, MCAMP_WS_Equifax_Consumido__c, MCAMP_WS_Producto_Oncol_gico_Consumido__c, '+
        'MCAPM_Carga_Primer_Nombre__c, WS_Tiene_Producto_Oncologico__c, MCAMP_Tipo_Cliente__c, MCAMP_Actualizar_Nuevo_Cliente__c, MCAMP_Resultado_Carga_Integracion__c, MCAMP_Tipo_Producto__c '+
        'FROM CampaignMember WHERE CampaignId = \'' + String.escapeSingleQuotes(this.IdCampagna) + '\' and MCAMP_Actualizar_Nuevo_Cliente__c = true';
 
         system.debug('@@@@ query: ' + query);
 
         return Database.getQueryLocator(query);
     }
 
     global void execute(Database.BatchableContext bc, List<CampaignMember> miembros) {
 
         // Control errores
         boolean ERR_EQUIFAXWS = false;
         String ERR_MENSAJE_EQUIWS = '', ERR_LINEA_EQUIWS = '';
         
         boolean ERR_PRODONCOWS = false;  
         String ERR_MENSAJE_PRONCOWS = '', ERR_LINEA_PRONCOWS = '';
 
         List<Lead> leads = new List<Lead>();
 
         for (CampaignMember cm : miembros) {
 
            CLS_CM_ProcesaProspecto_OncoApeg.Retorno rConsultaPersona = new  CLS_CM_ProcesaProspecto_OncoApeg.Retorno();
 
             if (cm.MCAMP_Tipo_Producto__c == '19' && cm.MCAMP_WS_Equifax_Consumido__c == false)
             {
                 rConsultaPersona = CLS_CM_ProcesaProspecto_OncoApeg.ObtenerDatosProspecto(cm);
                 cm = rConsultaPersona.campaignMember;
     
                 if (rConsultaPersona.lead != null)
                 {
                     leads.add(rConsultaPersona.lead);
                 }
             }
 
             CLS_CM_ProcesaProspecto_OncoApeg.Retorno rConsultaProducto = CLS_CM_ProcesaProspecto_OncoApeg.ObtieneProducto(cm);
             cm = rConsultaProducto.campaignMember;
 
             CLS_CM_ProcesaProspecto_OncoApeg.Retorno rValidacionAsegurado = CLS_CM_ProcesaProspecto_OncoApeg.ValidacionAsegurado(cm);
             cm = rValidacionAsegurado.campaignMember;
 
             if (cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c && cm.MCAMP_WS_Equifax_Consumido__c)
             {
                 cm.MCAMP_Actualizar_Nuevo_Cliente__c = false;
             }
             else {
                 cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
             }
 
             cm.MCAMP_Resultado_Carga_Integracion__c = cm.MCAMP_Resultado_Carga_Integracion__c + '\nProceso carga/integración del registro finalizado';
 
             system.debug('@@@@ rConsultaPersona.ERR_WS '+rConsultaPersona.ERR_WS);
             system.debug('@@@@ rConsultaProducto.ERR_WS '+rConsultaProducto.ERR_WS);
             system.debug('@@@@ rValidacionAsegurado.ERR_WS '+rValidacionAsegurado.ERR_WS);
            
             if (!rConsultaPersona.ERR_WS && !rConsultaProducto.ERR_WS  && !rValidacionAsegurado.ERR_WS)
             {
                 if(cm.MCAMP_Ejecutivo_Televenta__c != null && String.isBlank(cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c)  &&
                 cm.MCAMP_Es_Asegurable__c == 'S' && cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c == true ){
                     CLS_TV_GeneracionTareasCampagna genTa = new CLS_TV_GeneracionTareasCampagna(cm.CampaignId);
                     Task t = genTa.generaTarea(cm);
                     if(t != null){
                         cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = t.Id;
                     }
                 }
             }
             
             if (Test.isRunningTest())
             {
                 rConsultaPersona.ERR_WS = true;
                 rConsultaProducto.ERR_WS = true;
                 rValidacionAsegurado.ERR_WS = true;
             }
 
             if(rConsultaPersona.ERR_WS){
 
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 String[] toAddresses = new String[] {'juespinoza@security.cl'};
                     mail.setToAddresses(toAddresses);
                 mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                 mail.setReplyTo('juespinoza@security.cl');
                 mail.setsubject('@@@@ TELEVENTA ONCO - WS EQUIFAX');
                 mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Consulta Persona, mayor detalle en el siguiente mensaje:<br><br>' + 
                 rConsultaPersona.ERR_MENSAJE_WS + '<br><br>Línea: ' + rConsultaPersona.ERR_LINEA_WS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                 
                 if (!Test.isRunningTest()) {
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }
             }
 
             if(rConsultaProducto.ERR_WS){
                 
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 String[] toAddresses = new String[] {'juespinoza@security.cl'};
                     mail.setToAddresses(toAddresses);
                 mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                 mail.setReplyTo('juespinoza@security.cl');
                 mail.setsubject('@@@@ TELEVENTA ONCO - WS PRODUCTO ONCOLÓGICO');
                 mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Producto Oncológico, mayor detalle en el siguiente mensaje:<br><br>' + 
                 rConsultaProducto.ERR_MENSAJE_WS + '<br><br>Línea: ' + rConsultaProducto.ERR_LINEA_WS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                 
                 if (!Test.isRunningTest()) {
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }                        
             }   
 
             if(rValidacionAsegurado.ERR_WS){
                 
                 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                 String[] toAddresses = new String[] {'juespinoza@security.cl'};
                     mail.setToAddresses(toAddresses);
                 mail.setSenderDisplayName('Soporte SF | Televenta Oncológico');
                 mail.setReplyTo('juespinoza@security.cl');
                 mail.setsubject('@@@@ TELEVENTA ONCO - WS TARIFICACION');
                 mail.setHtmlBody('Estimados: <br><br>Se ha producido un error en la llamada WS Tarificación Oncológico, mayor detalle en el siguiente mensaje:<br><br>' + 
                 rValidacionAsegurado.ERR_MENSAJE_WS + '<br><br>Línea: ' + rValidacionAsegurado.ERR_LINEA_WS + '<br><br>Atte.,<br><br>Administrador CRM Vida Security');
                 
                 if (!Test.isRunningTest()) {
                     Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                 }                        
             }   
 
         }
 
         update leads;
         update miembros;
 
     }
 
     global void finish(Database.BatchableContext bc) {
      
         system.debug('@@@@@ Ha finalizado trabajo actualizacion de miembro de campaña...');
     }

}