@isTest 
private class VSL_LinkCampaignMemberStatusTest {
    public VSL_LinkCampaignMemberStatusTest() {

    }

    @isTest static void linkCampaignMemberStatus(){

        String recordTypeCmp = [SELECT id FROM RecordType WHERE Name='Campaña - Links'].id;

        Campaign cmp = new Campaign(
            Name='Campaña Test',
            RecordTypeId= recordTypeCmp,
            CurrencyIsoCode = 'CLP',
            Status = 'Planificada'
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(cmp, false);
        System.assertEquals(result.isSuccess(), true);
        Test.stopTest();
    }

}