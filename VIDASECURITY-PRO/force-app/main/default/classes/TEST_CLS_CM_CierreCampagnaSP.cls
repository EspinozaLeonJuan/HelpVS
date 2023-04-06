/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-19-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@istest
public class TEST_CLS_CM_CierreCampagnaSP {

    public static String CRON_EXP = '0 0 0 24 6 ? 2022';
    
      @IsTest(SeeAllData=true)  static void execute_text()
    {      
          
        TriggerHandler.disable();

        String RecordTypeId  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Salud Protegida').getRecordTypeId();

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
        cmp.RecordTypeId = RecordTypeId;
        cmp.IsActive = true;
        cmp.Status = 'En curso';
        cmp.EndDate = Date.today().addDays(-1);
        cmp.Type = 'Salud Protegida';
        insert cmp;
        
        String RecordTypeId_Lead  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();
        
        Lead lead = new Lead(); 
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '9';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today(); 
        lead.FirstName = 'A';
        lead.LastName = 'B';	
        lead.Sub_Estado__c = 'Llamar Contratante';
        lead.RecordTypeId = RecordTypeId_Lead;
        insert lead;
        
        String Task_RecordTypeId_Task_Links  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();
        
        Task task = new Task();
        task.RecordTypeId = Task_RecordTypeId_Task_Links;
        task.WhoId = lead.Id;
        task.Subject = 'Realizar LLamdada';
        task.Status = 'Abierta';
        insert task;
        
        
        List<CampaignMember> testCampMemb1 = new List<CampaignMember>();
        testCampMemb1.add(new CampaignMember(LeadId =lead.Id , CampaignId = cmp.Id, Status = 'Sent'));
        insert testCampMemb1;

        Test.startTest();    
        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP, 
        new CLS_CM_CierreCampagnaSP());  
       
        test.stopTest();
        
        TriggerHandler.enable();
    }
}