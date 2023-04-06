/*******************************************************************************************
*  NOMBRE                 : RequerimientosAutomaticosCaseHandler
*  TIPO                   : APEX CLASS
*  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS COBRANZA - PRODUCCIÓN INDIVIDUALES
* 
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 09/11/2018 - I. SALAZAR       - Creación Clase
*  1.1     - 20/03/2019 - I. SALAZAR	   - Se agrega envio de correo a Cobranzas Vida y Recepción Pagos.
* *****************************************************************************************/
public class RequerimientosAutomaticosCaseHandler implements TriggerHandler.HandlerInterface {
    public void handle() {
        Set<String> ORIGENES = new Set<String>{'Cobranzas Vida','Recepción Pagos','Producción Individuales'};
            
            if (Trigger.isInsert && Trigger.isBefore) {
                Id recordTypeAtencion = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Atención').getRecordTypeId();
                for (Case caso : (Case[])Trigger.new) {
                    if (ORIGENES.contains(caso.Origin) && String.isNotBlank(caso.SuppliedEmail) && caso.RecordTypeId == recordTypeAtencion) {
                        caso.Negocio__c = 'Negocio General';
                        caso.Tipo_de_Solicitante__c = 'No identificado';
                        
                        switch on caso.Origin {
                            when 'Producción Individuales' {
                                caso.Canal__c = 'Producción Individuales';
                                caso.CASO_Categoria__c = 'General';
                                caso.Detalle_Solicitud__c = 'Producción Individuales';
                            }
                            when 'Recepción Pagos' {
                                caso.Canal__c = 'Recepción Pagos';
                                caso.CASO_Categoria__c = 'Cobranza';
                                caso.Detalle_Solicitud__c = 'Cobranza General';
                            }
                            when else {
                                caso.Canal__c = 'Cobranzas Vida';
                                caso.CASO_Categoria__c = 'Cobranza';
                                caso.Detalle_Solicitud__c = 'Cobranza General';  
                            }
                        }       
                    }
                }
            }
        
        if (Trigger.isInsert && Trigger.isAfter) {
            Id recordTypeSolicitudes = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').getRecordTypeId();
            for (Case CASO_Principal : (Case[])Trigger.new) {
                Id recordTypeAtencion = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Atención').getRecordTypeId();
                if (ORIGENES.contains(CASO_Principal.Origin) && String.isNotBlank(CASO_Principal.SuppliedEmail) && CASO_Principal.RecordTypeId == recordTypeAtencion) {
                    Case cHijo1 = new Case();
                    cHijo1.RecordTypeId = recordTypeSolicitudes;
                    cHijo1.ParentId = CASO_Principal.Id;
                    chijo1.Negocio__c = CASO_Principal.Negocio__c;
                    cHijo1.OwnerId = CASO_Principal.OwnerId;
                    cHijo1.AccountId = CASO_Principal.AccountId;
                    cHijo1.ContactId = CASO_Principal.ContactId;
                    cHijo1.Priority = CASO_Principal.Priority;
                    cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_Electronico__c;
                    cHijo1.Tipo_de_Solicitante__c = CASO_Principal.Tipo_de_Solicitante__c;
                    cHijo1.Canal__c = CASO_Principal.Canal__c;
                    cHijo1.Origin = CASO_Principal.Origin;    
                    cHijo1.Tipo_de_Requerimiento__c = 'Solicitudes';                                               
                    cHijo1.Tipo_de_Cliente__c = CASO_Principal.Tipo_de_Cliente__c;    
                    cHijo1.Nombre_Solicitante__c = CASO_Principal.Nombre_Solicitante__c;
                    cHijo1.RUT_Solicitante__c = CASO_Principal.RUT_Solicitante__c;
                    cHijo1.Telefono_Solicitante__c = CASO_Principal.Telefono_Solicitante__c;
                    cHijo1.Correo_electronico_Solicitante__c = CASO_Principal.Correo_electronico_Solicitante__c;
                    cHijo1.Region_Solicitante__c = CASO_Principal.Region_Solicitante__c;
                    cHijo1.Ciudad_Solicitante__c = CASO_Principal.Ciudad_Solicitante__c;
                    cHijo1.Comuna_Solicitante__c = CASO_Principal.Comuna_Solicitante__c;
                    cHijo1.Direccion_Solicitante__c = CASO_Principal.Direccion_Solicitante__c;                        
                    /*  sección tipificación	*/
                    cHijo1.Subject = CASO_Principal.Subject;
                    cHijo1.Description = Caso_Principal.Description;
                    cHijo1.Problema__c = Caso_Principal.Problema__c;
                    cHijo1.Entrega_Respuesta__c = Caso_Principal.Entrega_Respuesta__c;
                    //cHijo1.CASO_N_Poliza__c = Caso_Principal.CASO_N_Poliza__c;
                    cHijo1.Fecha_Hora_de_Cierre__c = Caso_Principal.Fecha_Hora_de_Cierre__c;
                    cHijo1.Fecha_Cierre_Tope__c = Caso_Principal.Fecha_Cierre_Tope__c;                        
                    /* Informacion Requerimiento*/
                    cHijo1.CASO_Categoria__c = caso_principal.CASO_Categoria__c;
                    cHijo1.Detalle_Solicitud__c = caso_principal.Detalle_Solicitud__c;
                    cHijo1.Detalle_Operacion__c = caso_principal.Detalle_Operacion__c;  
                    cHijo1.SuppliedEmail = CASO_Principal.SuppliedEmail;
                    insert cHijo1;   
                    
                    //Derivación de Caso
                    string ID_RASIG_SOLICITUD;
                    Database.DMLOptions dmo = new Database.DMLOptions();
                    ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                    dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                    cHijo1.setOptions(dmo);
                    List<Case> lsC = new List<Case>();
                    cHijo1.Status = 'Back Office';
                    cHijo1.CASO_Deriva_a_UR__c = true;
                    lsC.add(cHijo1);
                    Database.update(lsC,dmo);
                    CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
                    CLAsign.AsignarCaso(cHijo1);
                    
                    //Validar si propietario es Manuel Poblete
                    try {
                        Case caso = new Case();
                        if (!Test.isRunningTest()) 
                        {
                            caso = [SELECT Id, OwnerId, CreatedById, ContactId, SuppliedEmail, Origin FROM Case WHERE Id =: cHijo1.Id];
                        }
                        else
                        {
                            caso.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
                            caso = [SELECT Id, OwnerId, CreatedById, ContactId, SuppliedEmail, Origin FROM Case WHERE Id =: cHijo1.Id];
                        }
                        
                        if(caso != null){
                            system.debug('@@@@ INFO CASO => ' + caso);
                            String Propietario = caso.OwnerId;
                            system.debug('@@@@ TIPO PROPIETARIO (USER/QUEUE) => ' + Propietario.substring(0, 3));
                            if(Propietario.substring(0, 3) == '005'){
                                User u = [SELECT Id, FirstName, Username, LastName, Name FROM User WHERE Id =: caso.OwnerId];
                                system.debug('@@@@ USUARIO => ' + u.Name);
                                if(u != null && u.Name == 'Manuel Eduardo Poblete López'){                            
                                    caso.OwnerId = caso.CreatedById;
                                    caso.Status = 'En Proceso';
                                    caso.CASO_Responsable_UR__c = null;
                                    caso.CASO_Resultado_Derivaci_n__c = 'NO EXISTE REGLA DE ASIGNACIÓN...';
                                    update caso;
                                }
                            } else {
                                caso.CASO_Resultado_Derivaci_n__c = 'CORRECTA ASIGNACIÓN...';
                                update caso;
                                system.debug('@@@@ -> Envio de Correo Caso ' + caso);
                                List<String> direcciones = new List<String>();
                                OrgWideEmailAddress[] fromAddresses = null;
                                EmailTemplate template = null;
                                
                                if (caso.Origin == 'Producción Individuales') {                        
                                	fromAddresses = [select id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'produccionindividual@security.cl'];
                                    template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Creacion_de_Casos_Produccion_Individuales' LIMIT 1];
                                }
                                
                                if (caso.Origin == 'Cobranzas Vida') {
                                    fromAddresses = [select id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'cobranzasvida@security.cl'];
                                    template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Creacion_de_Casos_Cobranzas_Vida' LIMIT 1];
                                }
                                
                                if (caso.Origin == 'Recepción Pagos') {
                                    fromAddresses = [select id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = 'recepcionpagos@security.cl'];
                                    template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Creacion_de_Casos_Cobranzas_Vida' LIMIT 1];                                    
                                }
                              
                               
                                OrgWideEmailAddress fromAddress = null;
                                
                                if (!fromAddresses.isEmpty())
                                    fromAddress = fromAddresses[0];
                                
                                direcciones.add(caso.SuppliedEmail);
                                Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
                                
                                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                                message.setTargetObjectId(caso.ContactId);
                                message.setToAddresses(direcciones);
                                message.setWhatId(caso.Id);
                                message.setTemplateId(template.Id);
                                
                                if (fromAddress != null)
                                    message.setOrgWideEmailAddressId(fromAddress.Id);
                                
                                message.setSaveAsActivity(true);
                                messages.add(message);
                                Messaging.reserveSingleEmailCapacity(messages.size());
                                
                                if (!Test.isRunningTest())
                                    Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(messages);
                            }
                        }
                    } catch(Exception ex){
                        system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                        system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
                    }  
                }				
            }
        }
    }
    
}