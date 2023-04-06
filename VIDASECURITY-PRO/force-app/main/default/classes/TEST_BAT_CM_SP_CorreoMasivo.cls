@istest
public class TEST_BAT_CM_SP_CorreoMasivo {

     @IsTest 
    static void go() {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.RUT__c = '1-0';
        prospecto.Email = 'juan@ibm.com';
        insert prospecto;
        
        BAT_CM_SP_CorreoMasivo  batch = new BAT_CM_SP_CorreoMasivo (prospecto.Id);
        Id batchId = Database.executeBatch(batch);
       Test.stopTest(); 
    }
    
}