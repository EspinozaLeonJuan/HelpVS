@isTest
private class AsignaContactoAMiembroDeCampanaTest {
    
    static {
        TriggerHandler.enable(AsignaContactoAMiembroDeCampanaHandler.class);
    }
  
    
    static testMethod void asignaContactoTest() {
        Test.startTest();
        
        Factory.crearAccountAnonimo();
        Account cAnonimo = [select id from Account where Rut__c = '99999998' limit 1];
        
        Contact contacto = Factory.buildContact(cAnonimo);
        contacto.Rut_contacto__c = '11111111';
        contacto.DV_contacto__c = '1';
        insert contacto;
        
        Campaign campaign = new Campaign();
        campaign.Name = 'Campaña prueba';
        insert campaign;
        
        CampaignMember member = new CampaignMember();
        member.CampaignId = campaign.Id;
        member.Numero_de_Poliza__c = '1234';
        member.ContactId = contacto.Id;
        
        insert member;
        Test.stopTest(); 
    }   
}