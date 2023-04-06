trigger CampaignMemberTrigger on CampaignMember (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
 new TriggerHandler().bind(TriggerHandler.BEFORE_INSERT_UPDATE, new AsignaContactoAMiembroDeCampanaHandler()).manage();   
}