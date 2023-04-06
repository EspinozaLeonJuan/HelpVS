/*******************************************************************************************
 *  NOMBRE                 : TRG_GestionarEstadosMiembrosCampanaTeleventa
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO TELEVENTA - PRODUCTO ONCOLÓGICO
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 16/04/2018 - H.NORAMBUENA     - Creación Trigger
 * 
 * *****************************************************************************************/
trigger TRG_GestionarEstadosMiembrosCampanaTeleventa on Campaign (before insert, before update, before delete, 
                                                     			  after insert, after update, after delete) {

    if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            
            try{
                
                Campaign c = Trigger.new[0];
                 system.debug('@@@@@ CAMPANA => ' + c );
                
                String RecordTypeVenta='';
                
                RecordTypeVenta=[select id from RecordType where name='Campaña - Televenta Oncológico'].id;
                if (RecordTypeVenta==null)
                {
                    RecordTypeVenta='';
                }
                
                // Al ser creada una nueva campaña de Tipo Venta Oncológico, automáticamente se crean los Estados para miembros
                // de campaña según Tareas de llamadas para mantener acorde los datos....
                // En produccion es 0120H000001QUFTQA4
                if(c.RecordTypeId == RecordTypeVenta ){
                    system.debug('@@@@@ AFTER INSERT IF 1 => ' + c );
                	List<CampaignMemberStatus> ecm = new List<CampaignMemberStatus>();
                    ecm = [SELECT 
                          			Id,
                           			CampaignId,
                           			Label,
                           			SortOrder,
                           			IsDefault,
                           			HasResponded
                           FROM
                          			CampaignMemberStatus
                           WHERE
                          			CampaignId =: c.Id];
                    
                    system.debug('@@@@@ AFTER INSERT LISTA ESTADOS  => ' + ecm.size() ); 
                    if(ecm.size() > 0){
                        for(CampaignMemberStatus s : ecm){
                            system.debug('@@@@@ ESTADO => ' + s.Id );
                            system.debug('@@@@@ ESTADO => ' + s.CampaignId );
                            system.debug('@@@@@ ESTADO => ' + s.Label );
                            system.debug('@@@@@ ESTADO => ' + s.SortOrder );
                            system.debug('@@@@@ ESTADO => ' + s.IsDefault );
                            system.debug('@@@@@ ESTADO => ' + s.HasResponded );
                            if(s.IsDefault == true){
                                s.Label = 'Abierta';
                                s.SortOrder = 1;
                            }
                            if(s.HasResponded == true){
                                s.Label = 'En Curso';
                                s.SortOrder = 2;
                            }
                        }
                        // Nuevo estado
                        CampaignMemberStatus cmsCompletada = new CampaignMemberStatus();
                        cmsCompletada.CampaignId = c.Id;
                        cmsCompletada.Label = 'Completada';
                        cmsCompletada.SortOrder = 3;
                        cmsCompletada.HasResponded = true;
                        ecm.add(cmsCompletada);
                        
                        // Nuevo estado
                        CampaignMemberStatus cmsDiferida = new CampaignMemberStatus();
                        cmsDiferida.CampaignId = c.Id;
                        cmsDiferida.Label = 'Diferida';
                        cmsDiferida.SortOrder = 4;
                        cmsDiferida.HasResponded = true;
                        ecm.add(cmsDiferida);                        
                        upsert ecm;
                    }
                    
                }                  
                
            }catch(Exception ex){
                
                system.debug('@@@@@ ERROR - TRG_GestionarEstadosMiembrosCampanaTeleventa - AFTER INSERT => ' + ex);
                
            }
            
        }
        if(Trigger.isUpdate){
            
            try{
                
                Campaign c = Trigger.new[0];
                
                String RecordTypeVenta='';
                
                RecordTypeVenta=[select id from RecordType where name='Campaña - Televenta Oncológico'].id;
                if (RecordTypeVenta==null)
                {
                    RecordTypeVenta='';
                }
                
                system.debug('@@@@ AFTER UPDATE ACTIVACION CAMPAÑA => ' + c);
                
				//Procesamiento de MC para campañas televenta oncologico planificadas...
				//|| c.RecordTypeId == '0120H000001QUFTQA4'
                if((c.RecordTypeId == RecordTypeVenta ) && c.Status == 'En Curso' && c.IsActive == true ){
                    
                    List<CampaignMember> LST_mc = new List<CampaignMember>();
                    LST_mc = [SELECT Id From CampaignMember WHERE CampaignId =: c.Id];
                    If(LST_mc.size() > 0){
                        List<Campaign> LST_Campana = new List<Campaign>();
                        LST_Campana.add(c);
                        CLS_CorrerJOBMcCampOnco.procesarMCCampOnco(LST_Campana);
                        //c.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
                    }else{
                        system.debug('@@@@ SIN MC Asociados....');
                    }
                    
                }                  
                
            }catch(Exception ex){
                
                system.debug('@@@@@ ERROR - TRG_GestionarEstadosMiembrosCampanaTeleventa - AFTER INSERT => ' + ex);
                
            }            
            
        }
        if(Trigger.isDelete){
            
        }
        
    }else{
        
        if(Trigger.isInsert){
            
        }
        if(Trigger.isUpdate){
            
        }
        if(Trigger.isDelete){
            
        }
        
    }
    
}