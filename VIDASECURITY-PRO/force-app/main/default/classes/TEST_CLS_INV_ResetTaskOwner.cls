/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-31-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public with sharing class TEST_CLS_INV_ResetTaskOwner {

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

        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

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
        tarea.OwnerId = u1.Id;
        tarea.Last_Assigned_Owner__c = u2.Id;
        tarea.IsReminderSet = true;
        tarea.ReminderDateTime = Datetime.newInstance(2008, 2, 5, 8, 30, 12);

        insert tarea;

        List<String> Ids = new List<String>();
		Ids.add(tarea.Id);

        CLS_INV_ResetTaskOwner.ActualizaDatos(Ids);

        Test.stopTest();
    }
}