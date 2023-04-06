trigger VSL_EstadoFinalizadoMiembro_Prospecto on Lead (after update) {
    if(Trigger.isUpdate){
        if(Trigger.isAfter){
            String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id; 
            List<CampaignMember> updateCampaignMember = new List<CampaignMember>();
            List<Lead> leads = [select id, status, (select id, status from campaignmembers ) from lead 
                                where id IN: trigger.new];
            for(Lead lead : leads){
                if(lead.Status == 'Habilitado'){
                    for(CampaignMember cm : lead.campaignmembers){
                        cm.Status = 'Finalizado';
                        updateCampaignMember.add(cm);
                    }  
                }   
            }
            update updateCampaignMember;
        }
    }
}