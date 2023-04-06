/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-30-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public with sharing class TEST_TRG_Task_ChangeStatus_NotStarted {
    public TEST_TRG_Task_ChangeStatus_NotStarted() {

    }

    @isTest(SeeAllData=true)
    static void Execute()
    {

        Profile p = [SELECT Id FROM Profile LIMIT 1];

        User u1 = new User(Alias = 'standa_1', Email='saplingstandard_1_user@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, RUT_Usuario__c = '1',
        TimeZoneSidKey='America/Los_Angeles', UserName='saplingstandar_1_duser@testorg.com');

        insert u1;

        User u2 = new User(Alias = 'standa_2', Email='saplingstandar_2_duser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id, RUT_Usuario__c = '2',
        TimeZoneSidKey='America/Los_Angeles', UserName='saplingstandard_2_user@testorg.com');


        insert u2;

        User u3 = new User(Alias = 'standa_3', Email='saplingstandard_3_user@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id , RUT_Usuario__c = '3',
        TimeZoneSidKey='America/Los_Angeles', UserName='saplingstandard_3_user@testorg.com');

        insert u3;

        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();
        // Account account  = new Account();
        // account.FirstName = 'Name';
        // account.LastName = 'LastName';
        // account.OwnerId = u3.Id;
        // account.Rut_contacto__pc = '123321';
        // account.DV_contacto__pc = '0';
        // account.Rut__c = '123321';
        // account.DV__c = '0';
        // insert account;

       /* Contact con = new Contact();
        // con.AccountId = account.Id;
        con.LastName = 'FN';
        con.FirstName = 'LN';
        //con.RUT__c = '15045517';
        con.DV_contacto__c = '1';
        con.Rut_contacto__c = '11111111';
        con.OwnerId = u1.Id;
        insert con;*/

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        Test.startTest();

        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Not Started';
        tarea.Priority = 'Media';
        tarea.OwnerId = u2.Id;
        tarea.Last_Assigned_Owner__c = u2.Id;

        insert tarea;

        Task queryTask = [SELECT Id,RecordTypeId, Subject, WhatId, WhoId,Status, Priority, OwnerId, Last_Assigned_Owner__c FROM Task WHERE Id =: tarea.Id];
        system.debug('@@@@ queryTask '+queryTask);

        account.OwnerId = u3.Id;
        update account;

        queryTask = [SELECT Id,RecordTypeId, Subject, WhatId, WhoId,Status, Priority, OwnerId, Last_Assigned_Owner__c FROM Task WHERE Id =: tarea.Id];
        system.debug('@@@@ queryTask 2 '+ queryTask);

        Test.stopTest();
    }
}