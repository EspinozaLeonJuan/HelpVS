@istest
public class TEST_BAT_CC_ActualizaProspecto {

     @IsTest 
    static void go() {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.RUT__c = '15045517-0';
        insert prospecto;
        
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        Contact_Center_Log__c log = new Contact_Center_Log__c();
        log.EsCliente__c = false;
        log.LeadId__c = prospecto.Id;
        log.IdSalesforce__c = caso.Id;
        log.RUT__c = '150455170';
        insert log;
        
        BAT_CC_ActualizaProspecto  batch = new BAT_CC_ActualizaProspecto (log.Id);
        Id batchId = Database.executeBatch(batch);
       Test.stopTest(); 
    }
    
}