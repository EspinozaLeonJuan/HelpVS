@IsTest
public with sharing class TEST_CLS_INV_Case_DerivacionAutomatica {
    @isTest static void inic()
    {
        Test.startTest();
        
        Account cuenta = Factory.cuenta.buildInsert();     
        Case caso = Factory.buildCasoSF('Solicitudes', cuenta);
        caso.Derivacion_Automatica__c = true;
        insert caso;

        List<String> Ids = new List<String>();
        Ids.add(caso.Id);

        CLS_INV_Case_DerivacionAutomatica.Execute(Ids);
        Test.stopTest();
    }
}