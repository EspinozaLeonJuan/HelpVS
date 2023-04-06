/*******************************************************************************************
 *  NOMBRE                 : TRG_GestorMiembrosCampanaTeleventa
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - PRODUCTO ONCOLÓGICO
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Trigger
 *  1.1     - 30/10/2018 - H.NORAMBUENA     - Marca Nuevo Cliente: 
 *                                            Líneas 115 y 116
 *                                            Líneas 146 y 147
 *                                            Líneas 173 y 174
 *  1.2     - 15/05/2019 - I.SALAZAR        - Validaciones cliente nuevo - existente 
 *  1.3     - 15/06/2020 - JP. Hernández    - Validaciones para campañas tipo de registro no Links
 * *****************************************************************************************/
trigger TRG_GestorMiembrosCampanaTeleventa on CampaignMember (before insert, before update, before delete, 
                                                              after insert, after update, after delete){
if(!Trigger.isDelete){  
    
   String campaignIdlead = '';
   Integer index = 0;                                                                                                                                  
    for(CampaignMember item : trigger.new){
        if (item.WEB_UPLOAD__c == true)
        {
            system.debug('@@@@ EXIT --> '+ item.WEB_UPLOAD__c);
            return;
        }
        campaignIdlead = item.CampaignId;
        Index++;
        if(index == 1){
           break; 
        }  
      system.debug('ID DE CAMPAÑA :' + campaignIdlead);   
    }
                                                                  
    String campaignType = [SELECT id, type FROM campaign WHERE id=: campaignIdlead].type;
    system.debug('TIPO DE CAMPAÑA :' + campaignType);                                                             
                                                                                                    

    if((!campaignType.equals('Televenta-Links')) && (!campaignType.equals('Salud Protegida'))){                                                               
    if(Trigger.isAfter){ // DESPUES...
        
        if(Trigger.isInsert){
        
            try{
                //Capturar copia del registro antes de insertar...
                for(CampaignMember cm: Trigger.new) {  
                            
                                    system.debug('@@@@@ AFTER INSERT MC => ' + cm);

                    // En produccion es 0120H000001QUFTQA4
                    String RecordTypeId='';
                            
                    RecordTypeId=[select id from RecordType where name='Prospectos Campañas - Ventas Oncológico'].Id;

                    if (RecordTypeId==null)
                    {
                        RecordTypeId='';
                    }

                    system.debug('@@@@@ VARIABLE RECORDTYPE  => ' + RecordTypeId);

                    if((cm.ContactId != null || cm.LeadId != null) &&
                       cm.MCAMP_WS_Equifax_Consumido__c == false &&
                       cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c == false &&
                       cm.MCAMP_Actualizar_Nuevo_Cliente__c == false ){

                        //Recuperación RUT Usuario que esta ejecutando la carga de Miembros de Campañas
                        //o asociando Miembros en Salesforce CRM...
                        string usuario = [select Id,
                                                 Name,
                                                 RUT_Usuario__c
                                          from
                                                User
                                          where
                                                Id =: UserInfo.getUserId()].RUT_Usuario__c;

                        string rutPersona = cm.MCAMP_Carga_RUT__c + '-' + cm.MCAMP_Carga_Dv__c;
                        system.debug('@@@@ RUT PESONA A CONSULTA EQUIFAX => ' + rutPersona);

                        //Valida y actualiza datos con equifax
                        CLS_LlamadaWSonco.consultarDatosEquifaxOnco('BHUERTA', rutPersona, cm.Id);

                    }

                                                    
                       }
                      
                
            }catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_GestorMiembrosCampanaTeleventa - AFTER INSERT => ' + ex);
            }

        }

        if(Trigger.isUpdate){

        }

        if(Trigger.isDelete){

        }

    }else{ // ANTES...
        
        if(Trigger.isInsert){
            
            try{
                for(CampaignMember cm: Trigger.new) {
                                                                    
                               //Capturar copia del registro antes de insertar...
                    //CampaignMember cm = Trigger.new[0];

                    system.debug('@@@@ BEFORE INSERT - CARGA BATCH => ' + cm);

                    //Miembros que se cargan por proceso BATCH

                    String recordTypeVentaOnco=[select id from RecordType where name='Prospectos Campañas - Ventas Oncológico' limit 1].id;

                    if( cm.RecordTypeId == recordTypeVentaOnco  && cm.ContactId == null && cm.LeadId == null){

                        system.debug('@@@@ BEFORE INSERT - PASO IF');

                        //Validación cobertura existente...

                        regBATCH__c reg = new regBATCH__c();
                        reg.IdRegistro__c = cm.Id;
                        insert reg;

                        List<Campaign> campana = [Select
                                                  Id,
                                                  CAMPA_Ejecutivo_Televenta__c,
                                                  IsActive,
                                                  CAMP_Producto__c,
                                                  EndDate
                                                  From
                                                  Campaign
                                                  Where
                                                  Id =: cm.CampaignId];

                        if(campana.size() >0){
                            Campaign cam = new Campaign();
                            cam = campana[0];
                            cm.MCAMP_Campana_Activa__c = cam.IsActive;
                            cm.MCAMP_Ejecutivo_Televenta__c = cam.CAMPA_Ejecutivo_Televenta__c;
                            cm.MCAMP_Tipo_Producto__c = cam.CAMP_Producto__c;
                            cm.MCAMP_Fecha_Fin_Campana__c = cam.EndDate;
                            //cm.CampaignId = cam.Id;
                        }else{
                            return;
                        }


                        // Proceso validaciòn cliente Oncològico
                        if(cm.MCAMP_Tipo_Producto__c != null && cm.MCAMP_Tipo_Producto__c == '19'){

                            //Recuperamos registros de clientes (Cuentas) para validar la existencia como cliente actual
                            //04-06-2019 Sólo es cliente si posee pólizas individuales activas
                            
                            List<Account> cliente = [select Id,
                                                     RecordTypeId,
                                                     PersonContactId,
                                                     PersonBirthdate,
                                                     CUENT_No_quiere_ser_contactado_Televenta__c,
                                                     Rut_contacto__pc,
                                                     Firstname,
                                                     Lastname,
                                                     CUENT_Participando_en_Campana_Oncologica__c,
                                                     Cantidad_Polizas_Activas__c
                                                     from
                                                     Account
                                                     where
                                                     Rut__c =: cm.MCAMP_Carga_RUT__c];

                            if(cliente.size() > 0){

                                Account a = new Account();
                                a = cliente[0];
                               
                                cm.ContactId = a.PersonContactId;
                                if (a.Cantidad_Polizas_Activas__c > 0) {
                                    cm.MCAMP_Es_cliente__c = true;
                                    cm.MCAMP_Tipo_Cliente__c = 'Existente';
                                } else {
                                    cm.MCAMP_Es_cliente__c = false;
                                    cm.MCAMP_Tipo_Cliente__c = 'Nuevo';                                    
                                }

                                cm.MCAMP_Carga_Fecha_Nacimiento__c = a.PersonBirthdate;
                                cm.MCAPM_Carga_Primer_Nombre__c = a.FirstName;
                                cm.MCAMP_Carga_Apellido_Paterno__c = a.LastName;

                            }else{

                                //Recuperamos la información del prospecto desde el objeto Leads
                                List<Lead> prospecto = [select Id,
                                                        Firstname,
                                                        Lastname,
                                                        Email,
                                                        Phone,
                                                        PROSP_Carga_Apellido_Materno__c,
                                                        PROSP_Carga_Email_2__c,
                                                        PROSP_Carga_RUT__c,
                                                        PROSP_Carga_Tel_fono_2__c,
                                                        PROSPE_Carga_Fecha_Nacimiento__c,
                                                        PROSP_No_quiere_ser_contactado_Televenta__c
                                                        from
                                                        Lead
                                                        where
                                                        PROSP_Carga_RUT__c =: cm.MCAMP_Carga_RUT__c and RecordTypeId = '0120H000001QUFSQA4']; //0120H000001QUFSQA4 - 0120H000001QUFSQA4

                                if(prospecto.size() > 0){
                                    Lead l = new Lead();
                                    l = prospecto[0];
                                    cm.LeadId = l.Id;
                                    cm.MCAMP_Es_cliente__c = false;
                                    cm.MCAMP_Tipo_Cliente__c = 'Nuevo';
                                    cm.MCAMP_Carga_Fecha_Nacimiento__c = l.PROSPE_Carga_Fecha_Nacimiento__c;
                                    cm.MCAPM_Carga_Primer_Nombre__c = l.FirstName;
                                    cm.MCAMP_Carga_Apellido_Paterno__c = l.LastName;

                                }
                                else{
                                    Lead nCliente = new Lead();
                                    String RecordTypeIdProspecto=[select id from RecordType where name='Prospecto - Televenta Oncológico'].id;
                                    nCliente.RecordTypeId = RecordTypeIdProspecto;
                                    //nCliente.RecordTypeId =  cm.RecordTypeId;
                                    //nCliente.FirstName = 'NN';
                                    //nCliente.LastName = 'NN';
                                    nCliente.FirstName = cm.MCAPM_Carga_Primer_Nombre__c != null ? cm.MCAPM_Carga_Primer_Nombre__c : 'NN' ;
                                    nCliente.LastName = cm.MCAMP_Carga_Apellido_Paterno__c != null ? cm.MCAMP_Carga_Apellido_Paterno__c : 'NN' ;
                                    nCliente.PROSP_Carga_RUT__c = cm.MCAMP_Carga_RUT__c;
                                    //nCliente.PROSP_Carga_Apellido_Materno__c = 'NN';
                                    nCliente.PROSP_Carga_Apellido_Materno__c = cm.MCAMP_Carga_Apellido_Materno__c != null ? cm.MCAMP_Carga_Apellido_Materno__c : 'NN' ;
                                    nCliente.Phone = cm.MCAMP_Carga_Tel_fono_1__c;
                                    nCliente.PROSP_Carga_Tel_fono_2__c = cm.MCAMP_Carga_Tel_fono_2__c;
                                    nCliente.Email = cm.MCAMP_Carga_Email_1__c;
                                    nCliente.PROSP_Carga_Email_2__c = cm.MCAMP_Carga_Email_2__c;
                                    nCliente.PROSPE_Carga_Fecha_Nacimiento__c = cm.MCAMP_Carga_Fecha_Nacimiento__c;

                                    system.debug('@@@@ BEFORE INSERT - new LEAD => ' + nCliente);
                                    insert nCliente;

                                    cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;

                                    system.debug('@@@@ BEFORE INSERT - DESPUES INSERTAR LEAD => ' + nCliente);
                                    cm.LeadId = nCliente.Id;
                                    cm.MCAMP_Es_cliente__c = false;
                                    cm.MCAMP_Tipo_Cliente__c = 'Nuevo';
                                }
                            }

                        }

                        // Proceso validaciòn cliente APEG
                        if(cm.MCAMP_Tipo_Producto__c != null && cm.MCAMP_Tipo_Producto__c == '66'){

                            //Recuperamos registros de clientes (Cuentas) para validar la existencia como cliente actual
                            List<Account> cliente = [select Id,
                                                     RecordTypeId,
                                                     PersonContactId,
                                                     PersonBirthdate,
                                                     CUENT_No_quiere_ser_contactado_Televenta__c,
                                                     Rut_contacto__pc,
                                                     Firstname,
                                                     Lastname,
                                                     CUENT_Participando_en_Campana_Oncologica__c
                                                     from
                                                     Account
                                                     where
                                                     Rut__c =: cm.MCAMP_Carga_RUT__c AND Cantidad_Polizas_Activas__c > 0];
                            // Se agrega filtro de Cantidad_Polizas_Activas__c para determinar si posee pólizas IND activas
                            if(cliente.size() > 0){

                                Account a = new Account();
                                a = cliente[0];
                                cm.ContactId = a.PersonContactId;
                                cm.MCAMP_Es_cliente__c = true;
                                cm.MCAMP_Tipo_Cliente__c = 'Existente';
                                cm.MCAMP_Carga_Fecha_Nacimiento__c = a.PersonBirthdate;
                                cm.MCAPM_Carga_Primer_Nombre__c = a.FirstName;
                                cm.MCAMP_Carga_Apellido_Paterno__c = a.LastName;

                            } else {
                                cm.addError('El rut ingresado no es cliente.');
                                return;
                            }

                        }

                        /*
                        List<Campaign> campana = [Select
                                                  Id,
                                                  CAMPA_Ejecutivo_Televenta__c,
                                                  IsActive
                                                  From 
                                                  Campaign
                                                  Where
                                                  Id =: cm.CampaignId];
                        if(campana.size() >0){
                            Campaign cam = new Campaign();
                            cam = campana[0];
                            cm.MCAMP_Campana_Activa__c = cam.IsActive;
                            cm.MCAMP_Ejecutivo_Televenta__c = cam.CAMPA_Ejecutivo_Televenta__c;
                        }
                        */


                    }else{
                            system.debug('Lead no entró a trigger miembro de campaña');
                            }
  
                      }
                    
                    
                   
                
            }
            catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_GestorMiembrosCampanaTeleventa - BEFORE INSERT => ' + ex);
                system.debug('@@@@@ ERROR - TRG_GestorMiembrosCampanaTeleventa - BEFORE INSERT Linea => ' + ex.getLineNumber());
            }

        }

        if(Trigger.isUpdate){

            try{
                //Capturar copia del registro despues de actualiza
                for(CampaignMember cm: Trigger.new) {
                                       
                    
                        //CampaignMember cm = Trigger.new[0];
                        system.debug('@@@@@ Despues actualizar => ' + cm);
    
    
                          String RecordTypeId='';
    
                        RecordTypeId=[select id from RecordType where name='Prospectos Campañas - Ventas Oncológico'].Id;
    
                        if (RecordTypeId==null)
                        {
                            RecordTypeId='';
                        }
    
    
    
                        if((cm.ContactId != null || cm.LeadId != null) && (cm.RecordTypeId == RecordTypeId )){
                            system.debug('@@@@@ Despues IF 1 => ' + cm.RecordTypeId);
                             system.debug('@@@@@ CM => ' + cm);
                            // Generar tareas...
                            if(cm.MCAMP_Campana_Activa__c == true &&
                               cm.MCAMP_Ejecutivo_Televenta__c != null &&
                               cm.MCAMP_Enviado_Email_1_Producto_Onco__c == true && //
                               (cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c == null
                               || cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c == '')
                               &&
                               //cm.MCAMP_WS_Equifax_Consumido__c == true &&
                               //cm.MCAMP_Enviado_Email_1_Producto_Onco__c == true &&
                               cm.MCAMP_Es_Asegurable__c == 'S' && cm.MCAMP_WS_Producto_Oncol_gico_Consumido__c == true ){
                                system.debug('@@@@@ Despues IF 2 => ' );

                                /*
                                CLS_GeneracionTareasCampanaTeleventa gT = new CLS_GeneracionTareasCampanaTeleventa();
                                Task t = new Task();
                                t = gT.generarTareaCampanaTeleventaOncologico(cm);
                                if(t != null){
                                    cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = t.Id;
                                }*/
                                CLS_TV_GeneracionTareasCampagna genTa = new CLS_TV_GeneracionTareasCampagna(cm.CampaignId);
                                Task t = genTa.generaTarea(cm);
                                if(t != null){
                                    cm.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = t.Id;
                                }

                            }
                        }
                    

            }
            
            }
            catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_GestorMiembrosCampanaTeleventa - BEFORE UPDATE => ' + ex);
            }

        }

        if(Trigger.isDelete){

        }

    }
} 
}
}