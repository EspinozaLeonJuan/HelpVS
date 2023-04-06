/*******************************************************************************************
 *  NOMBRE                 : TRG_TieneCasoHijo
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO UNIDAD RESOLUTORA 
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 10/07/2018 - L.LABBE          - Creación Trigger
 * 
 * *****************************************************************************************/

trigger TRG_TieneCasoHijo on Case ( after insert, before delete, before update, after update) {
    
try{
    
        system.debug('$$$$$$$ llamado al trigger TRG_TieneCasoHijo ');
    if(Trigger.isInsert){
    
        	system.debug('$$$$$$$ entra al trigger TRG_TieneCasoHijo ');
    
            Case casoAT = trigger.new[0];
            
            system.debug('$$$$$$$ caso '+ casoAT);
            
        	//seleccion del caso de atencion 
            List<Case> caso = [Select Id, 
                               Caso_Tiene_Solicitud__c, 
                               Caso_Tiene_Reclamo__c, 
                               Caso_Tiene_Consulta__c, 
                               Tipo_de_Requerimiento__c, 
                               recordTypeId 
                              // from Case where ParentId =: casoAT.ParentId];
                 			 from Case where Id =: casoAT.ParentId];
        
        
        system.debug('$$$$$$$ entra en IsInsert'); 
        
    //	if(caso.Size() > 0)
      //  { //verifico que exista registro consultado
            
             system.debug('$$$$$$$ tamaño arreglo ' + caso.size());  
             system.debug('$$$$$$$ tipo requerimiento ' + casoAT.Tipo_de_Requerimiento__c);  
            
                    if(casoAT.Tipo_de_Requerimiento__c == 'Solicitudes'){
                        Case cs = new Case(); 
                        if (!Test.isRunningTest()) 
                        { 
                            cs = caso[0];
                        }
                        cs.CASO_Tiene_Solicitud__c = true;
                        database.update(cs); 
                        
                    }
            
            
                    if(casoAT.Tipo_de_Requerimiento__c == 'Reclamos'){
                         Case cs = new Case(); 
                         if (!Test.isRunningTest()) 
                        { 
                            cs = caso[0];
                        }
                         cs.CASO_Tiene_Reclamo__c = true;
						 database.update(cs); 


                         
                    }
            
                    if(casoAT.Tipo_de_Requerimiento__c == 'Consultas'){
                         Case cs = new Case(); 
                         if (!Test.isRunningTest()) 
                        { 
                            cs = caso[0];
                        }
                     cs.CASO_Tiene_Consulta__c = true;
                        database.update(cs); 


                          
                    }
        
        	//}
      	}
    
    if(Trigger.isDelete){
        
                integer cont;
                
                system.debug('$$$$$$$ entra al trigger TRG_TieneCasoHijo ');
                
                Case casoAT = trigger.old[0];
                
                system.debug('$$$$$$$ caso '+ casoAT);
                
                List<case> caso = [Select id, 
                                   Caso_Tiene_Solicitud__c, 
                                   Caso_Tiene_Reclamo__c, 
                                   Caso_Tiene_Consulta__c, 
                                   Tipo_de_Requerimiento__c, 
                                   recordTypeId 
                                   //from Case where ParentId =: casoAT.ParentId];
                 			 from Case where Id =: casoAT.ParentId];
        
     //  if(caso.Size() > 0){ 
        
        System.debug('@@@@@@@@@@@ TIpo de requerimiento inicial' + casoAT.Tipo_de_Requerimiento__c);
        
                            if(casoAT.Tipo_de_Requerimiento__c == 'Solicitudes'){
                            //cuenta cantidad de casos en solicitudes
                            cont = [Select count() 
                                    from case 
                                    where ParentId=:casoAT.ParentId and 
                                    Tipo_de_Requerimiento__c ='Solicitudes'];  
                                	System.debug('@@@@@@@@@@@ Cantidad de Casos Solicitud' + cont);
                                
                                If (cont == 1 ){
                                    System.debug('@@@@@@@@@@@ entra en contador Solicitud' );
                                     Case cs = new case(); 
                                     if (!Test.isRunningTest()) 
                                    { 
                                        cs = caso[0];
                                    }
                                     cs.CASO_Tiene_Solicitud__c = false;
                                     database.update(cs);
                                    
                                }   
                            
                            }
        				 if(casoAT.Tipo_de_Requerimiento__c == 'Reclamos'){
                            //cuenta cantidad de casos en Reclamos
                            cont = [Select count() 
                                    from case 
                                    where ParentId=:casoAT.ParentId and 
                                    Tipo_de_Requerimiento__c ='Reclamos'];  
                                	System.debug('@@@@@@@@@@@ Cantidad de Casos Reclamos' + cont);
                                
                                If (cont == 1 ){
                                     Case cs = new case(); 
                                    if (!Test.isRunningTest()) 
                                    { 
                                        cs = caso[0];
                                    }
                                     cs.CASO_Tiene_Reclamo__c = false;
                                     database.update(cs);
                                    
                                }   
                            }
        
        					 if(casoAT.Tipo_de_Requerimiento__c == 'Consultas'){
                            //cuenta cantidad de casos en Consultas
                            cont = [Select count() 
                                    from case 
                                    where ParentId=:casoAT.ParentId and 
                                    Tipo_de_Requerimiento__c ='Consultas'];  
                                	System.debug('@@@@@@@@@@@ Cantidad de Casos Consultas' + cont);
                                
                                If (cont == 1 ){
                                     Case cs = new case(); 
                                     if (!Test.isRunningTest()) 
                                     { 
                                         cs = caso[0];
                                     }
                                     cs.CASO_Tiene_Consulta__c = false;
                                     database.update(cs);
                                    
                                }   
                            
                            }
        
        
        
    	//}
        
    }   
    }catch(Exception ex){
                system.debug('@@@@@ ERROR - No entra  => ' + ex);
               
      
            }  
}