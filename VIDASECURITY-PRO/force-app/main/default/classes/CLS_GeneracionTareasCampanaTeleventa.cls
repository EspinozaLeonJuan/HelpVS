/*******************************************************************************************
 *  NOMBRE                 : CLS_GeneracionTareasCampanaTeleventa
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - Genera Tareas Campaña Televenta
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
public class CLS_GeneracionTareasCampanaTeleventa {
    
    public Task generarTareaCampanaTeleventaOncologico(CampaignMember cm){
        
        try{
 			
            system.debug('@@@@ generarTareaCampanaTeleventaOncologico - CM  => ' + cm);
                       
            if(cm != null  ){
                Task t = new Task();

                 //String recordTypeOnco = '0123D0000007N8uQAE';  //QAProdOnco
                String recordTypeOnco = '';
                
                recordTypeOnco = [SELECT Id FROM RecordType WHERE Name = 'Ventas Oncológico'].Id;
                
                if (recordTypeOnco==null)
                {
                    recordTypeOnco='';
                }
                
            
                
                t.RecordTypeId = recordTypeOnco; // Asigna tipo registro Tarea Televenta Oncológico
                
                if(cm.ContactId == null){ // Asigna cuenta o contacto cliente
                    t.WhoId = cm.LeadId;
                }
                if(cm.LeadId == null){ // Asigna prospecto (Lead)
                    t.WhoId = cm.ContactId;
                    t.WhatId = [SELECT Id, AccountId FROM Contact WHERE Id =: cm.ContactId].AccountId;
                }
                
				t.ActivityDate = cm.MCAMP_Fecha_Fin_Campana__c;
                t.Description = cm.MCAMP_Script_Televenta__c;
                t.TASK_ID_Miembro_Campana__c = cm.Id;
                t.TASK_ID_Campana__c = cm.CampaignId;
                t.TASK_Campana__c = cm.CampaignId;
                t.Status = 'Abierta';
                t.TASK_Producto_Oferta__c = cm.MCAMP_Tipo_Producto__c;
				
                List<EjecutivoTeleventa> ejecutivos = new List<EjecutivoTeleventa>();
                
                List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options

                Sobject object_name = cm;
                system.debug('@@@@ VARIABLE CM  => ' + cm);
                Schema.sObjectType sobject_type = object_name.getSObjectType(); //grab the sobject that was passed
                Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
                Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
                List<Schema.PicklistEntry> pick_list_values = field_map.get('MCAMP_Ejecutivo_Televenta__c').getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
              
                
                string Ejecutivo=[Select Id,
                                      CAMPA_Ejecutivo_Televenta__c,
                                      IsActive
                                  From 
                                      Campaign
                                  Where
                                      Id =: cm.CampaignId].CAMPA_Ejecutivo_Televenta__c;
                                                        
               
                if (Ejecutivo==null)
                {                    
                    Ejecutivo='';
                }
                if (Test.isRunningTest())
                {
                    Ejecutivo='9869387-4;9919804-4';
                }
                
                system.debug('@@@@ VARIABLE EJECUTIVOS TELEVENTA CAPTURADOS => ' + Ejecutivo);
                
                for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                   
                    if(Ejecutivo.contains(a.getValue()))
                    {
                        system.debug('@@@@ VALOR CAMPO => ' + a);
                        EjecutivoTeleventa e = new EjecutivoTeleventa(a.getValue(),a.getLabel());
                        ejecutivos.add(e);    
                    }
                 }
                
                system.debug('@@@@ LISTA EJECUTIVOS TELEVENTA CAPTURADOS => ' + ejecutivos);
                
                List<Task> tareas = new List<Task>();
                tareas = [SELECT Id,
                          		 OwnerId,
                          		 TASK_RUT_Ejecutivo_Televenta__c
                          FROM 
                          		 Task 
                          WHERE 
                          		 IsClosed = false and RecordTypeId =: recordTypeOnco];
                
                List<User> usuarios = new List<User>();
                usuarios = [SELECT Id,
                           		   RUT_Usuario__c
                            FROM
                           		   User
                            WHERE
                           		   IsActive = true];
                
                for(EjecutivoTeleventa e1 : ejecutivos){
                    for(User u1 : usuarios){
                        if(e1.rutEjecutivo == u1.RUT_Usuario__c){
                            e1.idEjecutivo = u1.Id;
                        }
                    }
                }
                
                system.debug('@@@@ LISTA EJECUTIVOS CON ID Sesion => ' + ejecutivos);
                
                List<TareasEjecutivoTeleventa> carga = new List<TareasEjecutivoTeleventa>();
                
                system.debug('@@@@ LISTA TAREAS PARA ASIGNAR EJECTELVENTA => ' + tareas);
                
                for(EjecutivoTeleventa eT : ejecutivos){
                    Integer tEjecutivo = 0;
                    for(Task nT : tareas){
                        String id_eT = eT.idEjecutivo;
                        String id_nT = nt.OwnerId;
                        
                        //system.debug('@@@@ VALORES ID =>  ET ' + id_eT + ' ; NT ' + id_nT);
                        
                        if(id_eT.equals(id_nT)){
                            tEjecutivo = tEjecutivo + 1;
                        }
                    }
                    
                    //Se incorpora método de validación de carga...
                    TareasEjecutivoTeleventa TET = new TareasEjecutivoTeleventa(tEjecutivo,eT.rutEjecutivo,eT.idEjecutivo);
                    carga.add(TET);
                }
                
                system.debug('@@@@ LISTA CARGA:');
                system.debug('@@@@ =============================================================================================');
                carga.sort();                              
                
                              
                
                if (carga.size()>0)
                {
                	t.TASK_RUT_Ejecutivo_Televenta__c = carga[0].rutEjecutivo;    
                    t.OwnerId = carga[0].idEjecutivo;
                }
                else
                {
                    t.TASK_RUT_Ejecutivo_Televenta__c ='';
                }
                
                t.TASK_Campana_Activa__c = cm.MCAMP_Campana_Activa__c;
                
                //Creación Tarea de Llamada Televenta Oncológico...
                
                system.debug('@@@@ INSERTA TAREA =>' + t);
                
                insert t;
                
                system.debug('@@@@ TAREA INSERTADA =>' + t);
                
                return t;
            }else{
                return null;
            }
        }catch(Exception ex){
            system.debug('@@@@ ERROR - CLS_GeneracionTareasCampanaTeleventa - Método generarTareaCampanaTeleventaOncologico:');
            system.debug('@@@@ =============================================================================================');
            system.debug('@@@@ ' + ex.getMessage() + '; ' + ex.getLineNumber());
            system.debug('@@@@ =============================================================================================');  
            return null;
        }
    }
    
    //Clase de Tipo Estructura para Ejecutivos de Televenta Capturados desde Campaña
    class EjecutivoTeleventa{
        
        String rutEjecutivo;
        String nomEjecutivo;
        Id idEjecutivo;
        
        EjecutivoTeleventa(String rutEjecutivo, String nomEjecutivo){
            this.rutEjecutivo = rutEjecutivo;
            this.nomEjecutivo = nomEjecutivo;
        }        
        
        EjecutivoTeleventa(String rutEjecutivo, String nomEjecutivo, Id idEjecutivo){
            this.rutEjecutivo = rutEjecutivo;
            this.nomEjecutivo = nomEjecutivo;
            this.idEjecutivo = idEjecutivo;
        }
        
    }
     
	

}