/*******************************************************************************************
 *  NOMBRE                 : TRG_ModificarPropuesta
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - PRODUCTO ONCOLÓGICO
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Trigger
 *  1.1     - 26/09/2018 - H.NORAMBUENA     - Se actualiza estado de Cerrado a Completada en tarea anterior
 * *****************************************************************************************/
trigger TRG_ModificarPropuesta on Opportunity (after insert, after update, after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){

        }
        if(Trigger.isUpdate){
            try{
                Opportunity op = Trigger.new[0];
                
                // Validacón estado op
                if( op.StageName == 'Venta - Rechaza Calidad' ){
                    
                    if( op.OPOR_ID_Campa_a_SF__c != '' ){

                        Contratante__c con = [SELECT Id, CONTRA_Dv__c, CONTRA_Rut__c, CONTRA_Propuesta__c FROM Contratante__c WHERE CONTRA_Propuesta__c =: op.Id];
                        System.debug('@@@@ CONTRATANTE => ' + con);                        
                        
                        List<CampaignMember> LST_CM = new List<CampaignMember>();
                        LST_CM = [SELECT Id, CampaignId, LeadId, ContactId, Status, RecordTypeId, Name, FirstName, LastName, 
                                        LeadSource, MCAMP_Fecha_Fin_Campana__c, Type, MCAMP_Carga_RUT__c, 
                                        MCAMP_Carga_Dv__c, MCAMP_Script_Televenta__c, MCAMP_Campana_Activa__c, MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c
                                  FROM CampaignMember
                                  WHERE CampaignId =: op.OPOR_ID_Campa_a_SF__c];
                        System.debug('@@@@ LISTA MIEMBROS => ' + LST_CM);

                        
                        if( LST_CM.size() > 0 && con.Id != null ){
                            
                            CampaignMember idMC = null;                            
                            for(CampaignMember cm : LST_CM){
                                if(cm.MCAMP_Carga_RUT__c == String.valueOf(con.CONTRA_Rut__c)){
                                    idMC = cm;
                                    break;
                                }
                            }
                            
                            // Generación Id Único Tarea
                            String IdUnicoTarea = idMC.CampaignId;
                            IdUnicoTarea = IdUnicoTarea + idMC.Id;
                            String idTareaMC = idMC.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c;
                            //idTareaMC = idTareaMC.substring(0, 14);
                            IdUnicoTarea = IdUnicoTarea + idTareaMC;
                            
                            System.debug('@@@@ Id Tarea Generado => ' + IdUnicoTarea);
                            
                            if(idMC != null){
                                // Bucar tarea antigua abierta...y copiar...
                                Task tareaAntigua = new Task();
                                List<Task> oTarea = [SELECT Id, RecordTypeId, WhoId, WhatId, Subject, ActivityDate, 
                                                     Status, Priority, OwnerId, IsClosed, TASK_Agregar_Comentario_Tarea__c, 
                                                     TASK_Campana_Activa__c, TASK_Campana__c, TASK_Fecha_de_Reprogramaci_n__c, 
                                                     TASK_ID_Campana__c, TASK_ID_Miembro_Campana__c, 
                                                     TASK_No_quiere_ser_contactado_Televenta__c, TASK_RUT_Ejecutivo_Televenta__c, 
                                                     TASK_Sub_Estado__c, TASK_Id_Unico_Actividad__c
                                                     FROM Task 
                                                     WHERE TASK_Id_Unico_Actividad__c =: IdUnicoTarea AND Status = 'Completada'];
                                
                                system.debug('@@@@ LISTA TAREAS ANTIGUAS => ' + oTarea);
                                
                                if( oTarea.size() > 0 ){
                                    tareaAntigua = oTarea[0];
                                    oTarea[0].Status = 'Cerrada';
                                    oTarea[0].TASK_Sub_Estado__c = null;
                                    System.debug('@@@@ TAREA ANTIGUA => ' + oTarea[0]);
                                    Update oTarea;                                
                                }
                                
                                // Proceso generación nueva tarea asociada a campaña...
                                CLS_GeneracionTareasCampanaTeleventa clsTa = new CLS_GeneracionTareasCampanaTeleventa();
                                Task nTarea = clsTa.generarTareaCampanaTeleventaOncologico(idMC);                                
                                //Task nTarea = new Task();
                                if(nTarea.Id != null){
                                    nTarea.OwnerId = tareaAntigua.OwnerId;
                                    nTarea.Status = 'Diferida';
                                    nTarea.TASK_Sub_Estado__c = op.OPOR_Motivo_de_Rechazo_o_Perdida__c;
                                    nTarea.TASK_Id_Unico_Actividad__c = idMC.CampaignId;
                                    nTarea.TASK_Id_Unico_Actividad__c = nTarea.TASK_Id_Unico_Actividad__c + idMC.Id;
                                    idMC.MCAMP_ID_Tarea_Llamada_Venta_Prod_Onco__c = nTarea.Id;
                                    Update idMC;                                    
                                    Update nTarea;

                                    System.debug('@@@@ TAREA GENERADA => ' + nTarea);
                                }else{
                                    op.addError('Imposible generar tarea nueva de llamada....');
                                } 
                                    
                                
                            }
                            
                        }
                    }       
                }
                if( op.StageName == 'Venta - Aprobada' && op.OPOR_WS_Actualiza_Datos_Prospecto__c == false ){

                    //Recuperación RUT Usuario que esta ejecutando la modificación propuesta en SF
                    string usuario = [select
                                      Id,
                                      Name,
                                      RUT_Usuario__c
                                      from 
                                      User
                                      where
                                      Id =: UserInfo.getUserId()].RUT_Usuario__c;
                    
                    //Llamada a WS Onco
                    CLS_LlamadaWSonco.actualizarPropuestaOnco(usuario, op.Id); 
                    
                    CLS_ActualizaPantalla rPg = new CLS_ActualizaPantalla();
                    rPg.actualizaPropuesta(op.Id); 
  
                }
                
            }catch(Exception ex){
                system.debug('@@@@@ ERROR - TRG_ModificarPropuesta - AFTER UPDATE => ' + ex + ', LÍNEA => ' + ex.getLineNumber());  
            }            
        }
        if(Trigger.isDelete){
            try{
                system.debug('@@@@@ ID OPP A ELIMINAR => ' + Trigger.old[0].Id );
                            
                /*Opportunity o = [SELECT Id,
                                        OPOR_N_Propuesta__c
                                 FROM Opportunity
                                 WHERE Id =: Trigger.old[0].Id];
                
                system.debug('@@@@ PROPUESTA ELIMINADA => ' + o);
                */
                
                List<Asegurado__c> LASE = new List<Asegurado__c>();
                List<Beneficiario2__c> LBEN = new List<Beneficiario2__c>();
                List<Intermediario__c> LINT = new List<Intermediario__c>();
                List<Cobertura2__c> LCOB = new List<Cobertura2__c>();
                List<Contratante__c> LCOT = new List<Contratante__c>();
                List<Persona__c> LPER = new List<Persona__c>();             
                
                LCOT = [SELECT Id FROM Contratante__c WHERE CONTRA_Propuesta__c =: Trigger.old[0].Id];
                LBEN = [SELECT Id FROM Beneficiario2__c WHERE BEN_Propuesta__c =: Trigger.old[0].Id];
                LCOB = [SELECT Id FROM Cobertura2__c WHERE COB_Propuesta__c =: Trigger.old[0].Id];
                LASE = [SELECT Id FROM Asegurado__c WHERE ASEG_Propuesta__c =: Trigger.old[0].Id];                
                LINT = [SELECT Id FROM Intermediario__c WHERE INTER_Propuesta__c =: Trigger.old[0].Id];              
                LPER = [SELECT Id FROM Persona__c WHERE PERSO_N_Propuesta__c =: Trigger.old[0].OPOR_N_Propuesta__c];
                
                delete LCOT;
                delete LBEN;
                delete LCOB;
                delete LASE;
                delete LINT;
                delete LPER;                
                
            }catch(system.Exception ex){
                system.debug('@@@@ ERROR ELIMINAR OPP => ' + ex.getMessage());
            }
        }
    }else{
        /*
        if(Trigger.isInsert){
            
        }
        if(Trigger.isUpdate){
            
        }
        if(Trigger.isDelete){
            
        }        
*/
    }
    
}