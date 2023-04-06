/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-02-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-02-2020   Juan Espinoza Leon   Initial Version
**/
@IsTest
public with sharing class TEST_API_ContactCenter_CreaCaso {
    public TEST_API_ContactCenter_CreaCaso() {

    }
    @isTest static void doPost_Account()
    {
        Test.startTest();
        Factory.crearAccountSF();
        API_ContactCenter_CreaCaso.doPost( '888888888', '1234', '55555555','66666666', '', 1);
        Test.stopTest();
    }
    
    @isTest static void doPost_Lead()
    {
        Test.startTest();
        API_ContactCenter_CreaCaso.doPost('150455170', '1234', '55555555','66666666', '', 1);
        Test.stopTest();
    }

    @isTest static void doPost_Case()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        Case c = [SELECT Id, CaseNumber FROM Case WHERE Id =: caso.Id];
        system.debug('@@@@ caso --> '+ c);
        API_ContactCenter_CreaCaso.doPost('', '', '','66666666', c.CaseNumber, 3);
         API_ContactCenter_CreaCaso.doPost('', '', '','66666666','', 3);
         API_ContactCenter_CreaCaso.doPost('', '', '','', c.CaseNumber, 3);
        Test.stopTest();
    }

    @isTest static void doPost_Case_ChangeOwner()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        User usuario = Factory.buildUser();
        usuario.Anexo__c = '1234';
        usuario.Anexo_00__c = '0034';
        insert usuario;

        Case c = [SELECT Id, CaseNumber FROM Case WHERE Id =: caso.Id];
        system.debug('@@@@ caso --> '+ c);
        API_ContactCenter_CreaCaso.doPost('', '', '','1234', c.Id, 5);
        API_ContactCenter_CreaCaso.doPost('', '', '','0034', c.Id, 5);

        API_ContactCenter_CreaCaso.doPost('', '', '','', c.Id, 5);
        API_ContactCenter_CreaCaso.doPost('', '', '','0034', '', 5);
        
        Test.stopTest();
    }


    
    @isTest static void doPost_Error_01()
    {
        Test.startTest();
        Factory.crearAccountSF();
        API_ContactCenter_CreaCaso.doPost( '', '', '','', '', 1);
        Test.stopTest();
    }
    
      @isTest static void doPost_Error_02()
    {
        Test.startTest();
        Factory.crearAccountSF();
        API_ContactCenter_CreaCaso.doPost( '888888888', '1234', '55555555','66666666', '', null);
        Test.stopTest();
    }
    
    @isTest static void Genera_Caso_Atencion_Prospecto()
    {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        insert prospecto;
        Account account = new Account();
        account.Name = 'Name';
        account.Rut__c = '99999995';
        account.DV__c = '6';
        insert account;
        API_ContactCenter_CreaCaso.Genera_Caso_Atencion_Prospecto(prospecto.Id);
        Test.stopTest();
    }
    
    @isTest static void Retorna_Negocio()
    {
        Test.startTest();       
        Account account = new Account();
        account.Name = 'Name';
        account.Rut__c = '99999995';
        account.DV__c = '6';
        insert account;
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        insert poliza;
        API_ContactCenter_CreaCaso.Retorna_Negocio(account.Id);
        Test.stopTest();
    }
    
    @isTest static void Calcula_Prioridad()
    {
        Test.startTest();       
        Account account = new Account();
        account.Name = 'Name';
        account.Rut__c = '99999995';
        account.DV__c = '6';
        insert account;
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        insert poliza;
        API_ContactCenter_CreaCaso.Calcula_Prioridad(account.Id);
        Test.stopTest();
    }
    
    @isTest static void doPost_No_Utilizados()
    {
        Test.startTest();
        API_ContactCenter_CreaCaso.doPost('', '', '','', '', 2);
        API_ContactCenter_CreaCaso.doPost('', '', '','', '', 4);
        Test.stopTest();
    }

    
}