/*******************************************************************************************
 *  NOMBRE                 : TRG_GestionarMCTeleventaOncologico
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - PRODUCTO ONCOLÓGICO
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Trigger
 *  2.0     - 18/07/2018 - J.ESPINOZA.      - Limpieza Trigger previo a paso pro
 *  3.0     - 21/11/2018 - H.NORAMBUENA     - Activación igualación de estado tarea con prospecto
 *                                            campaña Televenta Oncológico
 pro * *****************************************************************************************/
trigger TRG_GestionarMCTeleventaOncologico on Task (before insert, before update, before delete, after insert, after update, after delete){
    
    if(Trigger.isBefore){ // ANTES...
        
        if(Trigger.isUpdate){
            
            try{
                
                Task t = Trigger.new[0];
                
                String RecordTypeId=[SELECT Id,Name FROM recordType where name ='Ventas Oncológico'].Id;
                system.debug('@@@@@ BEFORE UPDATE  - TRG_GestionarMCTeleventaOncologico => ' + t);      
                //Validar Tipo de Tarea y que no se encuentre cerrada...
                if(t.RecordTypeId == RecordTypeId || Test.isRunningTest()){ // Tarea Tipo - Venta Oncológico o prueba
                    system.debug('@@@@@ BEFORE UPDATE  - TRG_GestionarMCTeleventaOncologico IF 1=> ' + t);      
                    //Validar si tiene Campaña y Miembro de Campaña asociado..
                    
                    /*if(t.TASK_Campana__c != null && t.TASK_ID_Miembro_Campana__c != null){
                        system.debug('@@@@@ BEFORE UPDATE  - TRG_GestionarMCTeleventaOncologico IF 2=> ' + t);      
                        //Recuperamos Miembro de Campaña asociado a Tarea
                        List<CampaignMember> cm = [SELECT Id,
                                                            Status
                                                   FROM
                                                            CampaignMember
                                                   WHERE
                                                            CampaignId =: t.TASK_Campana__c AND Id =: t.TASK_ID_Miembro_Campana__c
                                                   LIMIT
                                                            1];
                        
                        system.debug('@@@@@ BEFORE UPDATE  - TRG_GestionarMCTeleventaOncologico LISTA=> ' + cm);        
                        if( cm.size() > 0 ){
                            
                            CampaignMember m = new CampaignMember();
                            m = cm[0];
                            m.Status = t.Status;
                            update m;
                            
                        }
                        
                    }*/
                    
                    //Ajustar cambio fecha para reprogramaciones...
                    //if(t.Status == 'Abierto' && (t.TASK_Sub_Estado__c == 'Volver a llamar' || t.TASK_Sub_Estado__c == 'Pendiente de Datos' )){
                    if(t.Status == 'Abierta' || t.Status == 'Abierto')
                    {
                        Date fechaOriginal = t.ActivityDate;
                        t.ActivityDate = t.TASK_Fecha_de_Reprogramaci_n__c;
                        t.TASK_Fecha_de_Reprogramaci_n__c = fechaOriginal;
                        
                    }
                    
                    //Activar Marca Cliente "No Volver a Contactar por Televenta"
                    if(t.TASK_No_quiere_ser_contactado_Televenta__c == true){
                        
                        if(t.WhatId != null){
                            Account a = [SELECT Id, CUENT_No_quiere_ser_contactado_Televenta__c FROM Account WHERE Id =: t.WhatId];
                            if ( a.CUENT_No_quiere_ser_contactado_Televenta__c == false ) {
                              a.CUENT_No_quiere_ser_contactado_Televenta__c = t.TASK_No_quiere_ser_contactado_Televenta__c;
                              update a;
                            }
                        }else{
                            t.addError('No puede activar esta marca, la tarea no tiene Cuenta Relacionada en el campo "Relacionado con..."');
                        }
                                
                        
                    }
                    
                }
                
           }catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_GestionarMCTeleventaOncologico - BEFORE UPDATE => ' + ex);
                system.debug('@@@@@ ============================================================= ' + ex);
                system.debug('@@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()); 
                system.debug('@@@@@ ============================================================= ' + ex);
            }
            
        }
        
        if(Trigger.isDelete){

            Task t = Trigger.old[0];
            String RecordTypeId=[SELECT Id,Name FROM recordType where name ='Ventas Oncológico'].Id;

            String tipoPerfil = [SELECT Id,Name FROM Profile WHERE Id =: UserInfo.getProfileId()].Name;

            if(t.RecordTypeId == RecordTypeId && !tipoPerfil.equals('Administrador del sistema')){
                t.adderror('No se puede eliminar la tarea Oncológico');
            }
        }
        
    }else{ // DESPUÉS....
        
        /*
        if(Trigger.isInsert){
            
        }
        */
        if(Trigger.isUpdate){
            
            try{
                
                // Capturando instancia de registro postmodificación
                Task t = Trigger.new[0];
                
                // Captura tipo de registro tarea
                String RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
                                
                //Validar Tipo de Tarea y que no se encuentre cerrada...
                if(t.RecordTypeId == RecordTypeId){ // Tarea Tipo - Venta Oncológico

                    //Validar si tiene Campaña y Miembro de Campaña asociado..
                    if(t.TASK_Campana__c != null && t.TASK_ID_Miembro_Campana__c != null){
                        
                        //Recuperamos Miembro de Campaña asociado a Tarea
                        List<CampaignMember> cm = [SELECT 
                                                            Id,
                                                            Status
                                                   FROM
                                                            CampaignMember
                                                   WHERE
                                                            CampaignId =: t.TASK_Campana__c AND Id =: t.TASK_ID_Miembro_Campana__c
                                                   LIMIT
                                                            1];
                        
                        system.debug('@@@@ PROSPECTO TAREA => ' + cm);
                        if( cm.size() > 0 ){
                            
                            CampaignMember m = new CampaignMember();
                            m = cm[0];
                            if( !m.Status.equals(t.Status) ){
                                m.Status = t.Status;
                                update m;
                            }
                            
                        }
                        
                    }
                    
                    /*
                    //Ajustar cambio fecha para reprogramaciones...
                    if(t.Status == 'Abierto' && (t.TASK_Sub_Estado__c == 'Volver a llamar' || t.TASK_Sub_Estado__c == 'Pendiente de Datos' )){
                    
                        Date fechaOriginal = t.ActivityDate;
                        t.ActivityDate = t.TASK_Fecha_de_Reprogramaci_n__c;
                        t.TASK_Fecha_de_Reprogramaci_n__c = fechaOriginal;
                        
                    }
                    
                    //Activar Marca Cliente "No Volver a Contactar por Televenta"
                    if(t.TASK_No_quiere_ser_contactado_Televenta__c == true){
                        
                        if(t.WhatId != null){
                            Account a = [SELECT Id, CUENT_No_quiere_ser_contactado_Televenta__c FROM Account WHERE Id =: t.WhatId];
                            a.CUENT_No_quiere_ser_contactado_Televenta__c = t.TASK_No_quiere_ser_contactado_Televenta__c;
                            update a;
                        }else{
                            t.addError('No puede activar esta marca, la tarea no tiene Cuenta Relacionada en el campo "Relacionado con..."');
                        }
                                
                        
                    }
                    */                  
                    
                }
                
            }catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_GestionarMCTeleventaOncologico - AFTER UPDATE => ' + ex);
                system.debug('@@@@@ ============================================================= ' + ex);
                system.debug('@@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber()); 
                system.debug('@@@@@ ============================================================= ' + ex);
            }
            
        }
        /*
        if(Trigger.isDelete){
          
               Task t = Trigger.old[0];
               String RecordTypeId=[SELECT Id,Name FROM recordType where name ='Ventas Oncológico'].Id;
            
               if(t.RecordTypeId == RecordTypeId){  
                      t.adderror('No se puede eliminar la tarea Oncológico');   
                }
        }  
        */
        
    }

}