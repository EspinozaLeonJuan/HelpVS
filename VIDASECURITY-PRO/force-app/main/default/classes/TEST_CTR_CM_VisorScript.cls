/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-01-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@istest
public with sharing class TEST_CTR_CM_VisorScript {
    public TEST_CTR_CM_VisorScript() {

    }


    @isTest static void iniciaVisorScript()
    {
        Test.startTest();

        Account account = Factory.crearAccountSF();

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Cuenta__c = account.Id;
        insert prospecto;

        CTR_CM_VisorScript Con = new CTR_CM_VisorScript();
        ApexPages.currentPage().getParameters().put('Id', prospecto.Id);
        Con.iniciaVisorScript();
        test.stopTest();
    }
}