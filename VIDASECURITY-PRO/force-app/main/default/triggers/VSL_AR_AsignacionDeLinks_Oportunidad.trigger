trigger VSL_AR_AsignacionDeLinks_Oportunidad on Opportunity (before update) {
    
    if(trigger.isUpdate){
        if(trigger.isBefore){
            //=================== Inicio de proceso de asignacion Links =================<  
            
            Opportunity currentOpp = trigger.new[0];
            
            if(currentOpp.StageName == 'Asignación' && currentOpp.Agente_de_Venta__c == null && currentOpp.Ejecutivo_Post_Venta__c == null ){
                
                String LinkRecordType = [select Id from RecordType where name = 'Venta - Link' limit 1].Id;
                
                if(currentOpp.RecordTypeId != null){
                    if(currentOpp.RecordTypeId.equals(LinkRecordType)){
                        List<Contact> contact = null;   
                        List<Region__c> region = null;
                        if(currentOpp.Tipo_Link__c == 'Bases Normales' && currentOpp.Tipo_Link__c != null){
                            if(currentOpp.Region1__c != null){
                                if(currentOpp.Region1__c == '002'){
                                    if(currentOpp.Renta__c > 1000000){
                                        region = [select id, Name from region__c where REGI_C_digo__c =: currentOpp.Region1__c];
                                        contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Jefe Comercial' limit 1];
                                        if(contact.size() > 0 && contact != null){
                                            currentOpp.Agente_de_Venta__c = contact[0].Id;
                                        }else{
                                            contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Gerente Regional' limit 1];
                                            if(contact.size() > 0){
                                                currentOpp.Agente_de_Venta__c = contact[0].Id;
                                            }else{
                                                trigger.new[0].addError('No existe un Jefe Comercial o Gerente Regional activo para asignar para ' + region[0].Name + '.'); 
                                            }
                                        }
                                    }else{
                                        currentOpp.StageName = 'Cerrada Perdida Link';
                                    }
                                }else{
                                    if(currentOpp.Region1__c == '008' || currentOpp.Region1__c == '009' || currentOpp.Region1__c == '010'){
                                        if(currentOpp.Renta__c > 800000){
                                            region = [select id, Name from region__c where REGI_C_digo__c =: currentOpp.Region1__c];
                                            contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Jefe Comercial' limit 1];
                                            if(contact.size() > 0 && contact != null){
                                                currentOpp.Agente_de_Venta__c = contact[0].Id;
                                            }else{
                                                contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Gerente Regional' limit 1];
                                                if(contact.size() > 0){
                                                    currentOpp.Agente_de_Venta__c = contact[0].Id;
                                                }else{
                                                    trigger.new[0].addError('No existe un Jefe Comercial o Gerente Regional activo para asignar para ' + region[0].Name + '.'); 
                                                }
                                            }
                                        }else{
                                            currentOpp.StageName = 'Cerrada Perdida Link';
                                        }
                                    }else{
                                        if(currentOpp.Region1__c == '013'){
                                            if(currentOpp.Renta__c < 800000){
                                                region = [select id, Name from region__c where REGI_C_digo__c =: currentOpp.Region1__c];
                                                contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Supervisor PF' limit 1];
                                                if(contact.size() > 0){
                                                    currentOpp.Agente_de_Venta__c = contact[0].Id;
                                                }else{
                                                    trigger.new[0].addError('No existe un Supervisor PF activo para asignar para ' + region[0].Name + '.'); 
                                                }
                                            }
                                        }else{
                                            region = [select id, Name from region__c where REGI_C_digo__c =: currentOpp.Region1__c];
                                            contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Jefe Comercial' limit 1];
                                            if(contact.size() > 0 && contact != null){
                                                currentOpp.Agente_de_Venta__c = contact[0].Id;
                                            }else{
                                                contact = [select Id from Contact where Region__c =: region[0].Id and Activo__c = true and Tipo_Cargo__c = 'Gerente Regional' limit 1];   
                                                if(contact.size() > 0){
                                                    currentOpp.Agente_de_Venta__c = contact[0].Id;
                                                }else{
                                                    trigger.new[0].addError('No existe un Jefe Comercial o Gerente Regional activo para asignar para ' + region[0].Name + '.'); 
                                                }
                                            } 
                                        } 
                                    }   
                                }
                            }
                        }     
                    }
                    //=================== fin de proceso de asignacion Links =================<
                }
            }
        }
    }
}