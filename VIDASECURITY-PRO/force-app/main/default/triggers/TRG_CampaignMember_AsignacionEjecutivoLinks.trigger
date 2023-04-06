trigger TRG_CampaignMember_AsignacionEjecutivoLinks on CampaignMember (before insert) {
if(trigger.isInsert){
        if(trigger.isBefore){
            //======================== Inicio proceso asignar ejecutivos ========================================

            List<String> idLeads = new List<String>();
            List<String> idCampaigns = new List<String>();
            for(CampaignMember item : trigger.new){
                if (item.WEB_UPLOAD__c == true)
                {
                    return;
                }

                idLeads.add(item.LeadId);
                if(!idCampaigns.contains(item.CampaignId)){
                    idCampaigns.add(item.CampaignId);
                }
            }

            Map<String, String> rutSelectedPerCampaign = new Map<String,String>();

            List<String> rutET = new List<String>();

            String idUsuarioBulk = [SELECT Id FROM Group WHERE type ='Queue' AND name='Link Bulk' LIMIT 1].Id;

            Map<Id, Lead> leadToAssign  = new Map<Id, Lead>([SELECT Id, OwnerId, Tipo_Base__c FROM Lead WHERE Id IN : idLeads AND OwnerId = : idUsuarioBulk]);

            List<Campaign> ETCampaign = [SELECT id, Origen_de_Base__c, CAMPA_Ejecutivo_Televenta__c FROM Campaign WHERE Id IN : idCampaigns and Type =: 'Televenta-Links'];

            if (ETCampaign.isEmpty()) return;
            for(Campaign itemCampaign : ETCampaign){
                if(!String.isEmpty(itemCampaign.CAMPA_Ejecutivo_Televenta__c) & itemCampaign.CAMPA_Ejecutivo_Televenta__c!=null){
                    String[] EJfieldList = itemCampaign.CAMPA_Ejecutivo_Televenta__c.split(';');
                    for(String pickListitem : EJfieldList){
                        rutSelectedPerCampaign.put(pickListitem, itemCampaign.id);
                        if(!rutET.contains(pickListitem)){
                            rutET.add(pickListitem);
                        }
                    }
                }
            }

            if(rutET.size() > 0){
                List<User> userET = [SELECT id, RUT_Usuario__c FROM User WHERE RUT_Usuario__c IN: rutET];

                List<Lead> leadToUpdate = new List<Lead>();

                for(Campaign campaignItem : ETCampaign){
                    List<User> ETToAssign = new List<User>();
                    for(String ETitem : rutSelectedPerCampaign.keySet()){
                        if(campaignItem.Id.equals(rutSelectedPerCampaign.get(ETitem))){
                            for(User getSelectedUser : userET){
                                if(getSelectedUser.RUT_Usuario__c.equals(ETitem)){
                                    ETToAssign.add(getSelectedUser);
                                    break;
                                }
                            }
                        }
                    }

                    Integer countET = 0;
                    for(CampaignMember currentCamMem : trigger.new){
                        if(campaignItem.Id.equals(currentCamMem.CampaignId) && leadToAssign.get(currentCamMem.LeadId) != null){
                            Lead getLead = leadToAssign.get(currentCamMem.LeadId);
                            getLead.OwnerId = ETToAssign[countET].Id;
                            //JP: se asigna origen de base a los Leads

                            if (String.isBlank(getLead.Tipo_Base__c))
                            {
                                getLead.Tipo_Base__c = ETCampaign[0].Origen_de_Base__c;
                            }

                            //Se agregan para ser actualizados
                            leadToUpdate.add(getLead);
                            if(countET == ETToAssign.size() - 1){
                                countEt = 0;
                            }else{
                                countEt++;
                            }
                        }

                    }
                }

                if(leadToUpdate.size() > 0){
                    update leadToUpdate;
                }
            }
            else
            {
                //colección para asignar origenes
                List<Lead> leadAssignOrigen   = [SELECT Id, Tipo_Base__c FROM Lead WHERE Id IN : idLeads];

                //se obtienen los leads asociados a los miembros de campaña entrantes del trigger, se les actualiza
                //el campo tipo_base__c para que sea coherente con el dato de la campaña asignada.

                if (leadAssignOrigen.isEmpty()) return;
                for(Lead leadOrigin : leadAssignOrigen){
                    if (String.isBlank(leadOrigin.Tipo_Base__c))
                    {
                        leadOrigin.Tipo_Base__c  = ETCampaign[0].Origen_de_Base__c;
                    }
                }

                system.debug(leadAssignOrigen);

                if(leadAssignOrigen.size() > 0){
                    update leadAssignOrigen;
                }
            }

            //========================== Fin proceso asignar ejecutivos =========================================
        }

    }
}