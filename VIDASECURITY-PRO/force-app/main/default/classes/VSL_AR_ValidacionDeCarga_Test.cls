@isTest
public class VSL_AR_ValidacionDeCarga_Test {
    
    @isTest
    public static void leadProcess(){
        
        
        String LinkRecordType = [select Id from RecordType where name = 'Prospecto Links'].Id;
        String CampaignRecordType = [select Id from RecordType where name = 'Miembros de campaña'].Id;
        
        // ======= validacion no existe cliente y tiene campaña activa =====================
        try{
            
            Lead newLead3 = new Lead(Lastname= 'newLead3', Company='Company2', PROSP_Carga_RUT__c='33333333', RecordTypeId = LinkRecordType);
            insert newLead3;        
            Campaign newCampaign = new Campaign(Name='Campaign', RecordTypeId=CampaignRecordType);
            insert newCampaign;           
            CampaignMember cmRelation1 = new CampaignMember(CampaignId=newCampaign.Id, LeadId=newLead3.Id);
            insert cmRelation1;           
            Lead newLead_3 = new Lead(Lastname= 'newLead_3', Company='Company3', PROSP_Carga_RUT__c='33333333', RecordTypeId = LinkRecordType);
            insert newLead_3;
            
        }catch(Exception e){
            
            System.debug('Exception1 : ' + e.getMessage());  
            
        }      
        //===================================================================================
        
        // ======= validacion existe cliente y tiene pòliza =================================
        try{
            
            Account newAccount = new Account(Name='Account1', Rut__c='11111111');
            insert newAccount;
            Poliza__c poliza1 = new Poliza__c(Name='Poliza1', Cuenta__c = newAccount.Id);
            insert poliza1;  
            Lead newLead_1 = new Lead(Lastname= 'newLead1_1', Company='Company1', PROSP_Carga_RUT__c='11111111', RecordTypeId = LinkRecordType, Perfil_asignacion__c= 'Ejecutivo Post Venta');
            insert newLead_1; 
            
        }catch(Exception e){
            
            System.debug('Exception2 : ' + e.getMessage());
            
        }
        
        //==================================================================================
        
        // ======= validacion existe cliente y tiene entrevista en el último año ===========
        
        try{
            
            Account newAccount2 = new Account(Name='Account2', Rut__c='22222222');
            insert newAccount2;
            Opportunity newOpportunity2 = new Opportunity(Name='newOpportunityAccount2', AccountId=newAccount2.Id, CloseDate=date.newinstance(2020,4,20),                                              StageName='Prospecting');
            insert newOpportunity2;   
            Lead newLead_2 = new Lead(Lastname= 'newLead1_1', Company='Company1', PROSP_Carga_RUT__c='22222222', RecordTypeId = LinkRecordType,  Perfil_asignacion__c= 'Ejecutivo Post Venta');
            insert newLead_2;
            
        }catch(Exception e){
            
            System.debug('Exception3 : ' + e.getMessage());
            
        }
        //==================================================================================
        
    }
    
}