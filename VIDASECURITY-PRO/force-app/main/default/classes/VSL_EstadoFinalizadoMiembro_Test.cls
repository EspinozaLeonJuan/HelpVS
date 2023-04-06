@isTest
public class VSL_EstadoFinalizadoMiembro_Test {
    @isTest
    public static void EstadoFinalizadoMiembroProcess(){
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        List<Lead> updateLeads = new List<Lead>();
        
        Lead lead = new Lead(Lastname= 'newLead', Company='Company2', PROSP_Carga_RUT__c='33333333', RecordTypeId = LinkRecordType, Status='Abierto');  
        insert lead;
        
        Campaign cmp = New Campaign(Name='Campagin Test Lead', 
                                    Status='En Curso', Type='Televenta-Links',
                                    CAMP_Producto__c= '19',
                                    CAMPA_Ejecutivo_Televenta__c='14904286-5;15535357-0;9919804-4',
                                    CurrencyIsoCode='CLP',
                                    IsActive=true,
                                   Origen_de_Base__c='Bases Normales');
        insert cmp;
        
        CampaignMember cm = new CampaignMember(campaignId=cmp.Id, leadId=lead.Id);
        insert cm;
        
        List<Lead> leads = [select id, Status from Lead where id = : lead.id];
        lead.Status = 'Habilitado';
        updateLeads.add(lead);
        
        update updateLeads;
    }
}