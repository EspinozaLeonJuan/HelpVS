/*******************************************************************************************
 *  NOMBRE                 : VSL_LinkCampaignMemberStatus
 *  TIPO                   : APEX TRIGGER
 *  REQUERIMIENTO          : PROYECTO LINKS - TELEVENTA LINKS
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE    - OBSERVACIONES
 *  1.0     - 20/06/2020 - JP. HERNANDEZ  - Creación de nuevo estado para campañas Links
 * *****************************************************************************************/
trigger VSL_LinkCampaignMemberStatus on Campaign (after insert) {

    if(Trigger.isAfter){

        if(Trigger.isInsert){
            try{

                List<CampaignMemberStatus> ecm = new List<CampaignMemberStatus>();

                String campaignId = [SELECT id FROM RecordType WHERE Name='Campaña - Links'].id;
                System.debug('CampaignId'+campaignId);

                for (Campaign cmp : Trigger.new) {
                    if (cmp.RecordTypeId != null) {
                        if (cmp.RecordTypeId.equals(campaignId)) {
                            CampaignMemberStatus statusFinalizado = new CampaignMemberStatus();
                            statusFinalizado.CampaignId = cmp.id;
                            statusFinalizado.Label = 'Finalizado'; 
                            ecm.add(statusFinalizado);
                            System.debug('done'+statusFinalizado);
                        }
                    }                   
                }

                insert ecm;
            }
            catch(Exception ex){
                    
                system.debug('@@@@@ ERROR -> ' + ex);
                
            } 
        }
    }

}