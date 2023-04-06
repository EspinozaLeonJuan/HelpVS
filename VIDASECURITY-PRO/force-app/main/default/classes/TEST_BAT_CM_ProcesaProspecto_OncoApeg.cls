@istest
public class TEST_BAT_CM_ProcesaProspecto_OncoApeg {

      @IsTest static void execute_text()
    {      
        Test.startTest();    
        
       // String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Salud Protegida'].Id;

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
       // cmp.RecordTypeId = RecordTypeId;
        cmp.EndDate = Date.today().addDays(-1);
        insert cmp;
        
        Lead lead = new Lead(); 
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '0';
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
        lead.Email = 'a@ibm.com';
        insert lead;
 
        CampaignMember cm = new CampaignMember();
        cm.LeadId = lead.Id; 
        cm.CampaignId = cmp.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;
           
         BAT_CM_ProcesaProspecto_OncoApeg  batch = new BAT_CM_ProcesaProspecto_OncoApeg (cmp.Id);
        Id batchId = Database.executeBatch(batch);
            
        test.stopTest();
    }
}