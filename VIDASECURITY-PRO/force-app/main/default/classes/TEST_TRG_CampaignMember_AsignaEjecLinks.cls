@IsTest
private class TEST_TRG_CampaignMember_AsignaEjecLinks {
    public TEST_TRG_CampaignMember_AsignaEjecLinks() {

    }

    @isTest
    public static void procesoAsignacion(){

        String someUser = [SELECT Id FROM User LIMIT 1].Id;

        String bulkUser = [SELECT Id FROM group WHERE type ='Queue' AND name='Link Bulk' LIMIT 1].Id;

        Campaign cmp = New Campaign(Name='Campagin Test Lead',
                                    Status='En Curso', Type='Televenta-Links',
                                    CAMP_Producto__c= '19',
                                    CAMPA_Ejecutivo_Televenta__c='14904286-5;15535357-0;9919804-4',
                                    CurrencyIsoCode='CLP',
                                    IsActive=true,
                                   Origen_de_Base__c='Bases Normales');
        insert cmp;

        String LinkRecordType = [SELECT Id FROM RecordType WHERE name = 'Prospecto Links'].Id;

        List<Lead> newLeads = new List<Lead>();

        for(Integer i = 0; i < 10; i++){
            newLeads.add(new Lead(
                            FirstName = 'Name'+ i,
                            Lastname = 'test' + i,
                            PROSP_Carga_RUT__c = '912'+ i,
                            Tipo_Base__c = 'Bases Normales',
                            RecordTypeId = LinkRecordType,
                            Tipo_Link__c = 'Bases Normales',
                            Nombre_Base__c = 'Bases Normales',
                            Perfil_asignacion__c = 'Agente',
                            OwnerId = bulkUser,
                            Ejecutivo_PostVenta__c = someUser));
        }

        Test.startTest();

        insert newLeads;

        List<CampaignMember> cm = new List<CampaignMember>();

        for(Lead item : newLeads){
            cm.add(New CampaignMember(
                                campaignId=cmp.Id,
                                leadId=item.Id
                                )
                );
        }

        insert cm;

        Test.stopTest();

    }
}