@isTest
public class VSL_AR_AsignacionEjecutivo_PropectoTest {
    @isTest
    public static void procesoAsignacion(){
        
        String someUser = [Select Id from User limit 1].Id;
        
        String bulkUser = [Select Id from group where type ='Queue' and name='Link Bulk' limit 1].Id;

        Campaign cmp = New Campaign(Name='Campagin Test Lead', 
                                    Status='En Curso', Type='Televenta-Links',
                                    CAMP_Producto__c= '19',
                                    CAMPA_Ejecutivo_Televenta__c='14904286-5;15535357-0;9919804-4',
                                    CurrencyIsoCode='CLP',
                                    IsActive=true,
                                   Origen_de_Base__c='Bases Normales');
        insert cmp;       
        
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        
        List<Lead> newLeads = new List<Lead>();
        
        for(Integer i = 0; i < 10; i++){
            newLeads.add(new Lead(FirstName='Name'+ i , lastname='test' + i,  PROSP_Carga_RUT__c= '912'+ i,
                                  RecordTypeId=LinkRecordType, Perfil_asignacion__c='Agente', OwnerId = bulkUser , Ejecutivo_PostVenta__c=someUser));
        }
        
        Test.startTest();
   
        insert newLeads;
        
        List<CampaignMember> cm = new List<CampaignMember>();
        
        for(Lead item : newLeads){
            cm.add(New CampaignMember(campaignId=cmp.Id, leadId=item.Id));
        }
        
        insert cm;
        
        Test.stopTest();
        
    }
}