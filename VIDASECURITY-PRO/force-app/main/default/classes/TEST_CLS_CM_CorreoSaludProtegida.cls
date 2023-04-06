@istest
public class TEST_CLS_CM_CorreoSaludProtegida {

     @IsTest 
    static void go() {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.RUT__c = '1-0';
        insert prospecto;
        
        CLS_CM_CorreoSaludProtegida.enviarEmail(prospecto.Id);
       	Test.stopTest(); 
    }
    
}