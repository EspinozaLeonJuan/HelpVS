/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 04-09-2022
 * @last modified by  : Juan Espinoza León
**/

@IsTest
public with sharing class TEST_CLS_CM_BandejaTareas_Televenta {


    @Istest
    static void changeOwnerTasks()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        campaign.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospectos Campañas - Ventas Oncológico'].Id;
        campaign.Name = 'Campañana Oncologico Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta - Oncológico';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;
        insert campaign;

        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Not Started';
        tarea.Priority = 'Media';
        tarea.OwnerId = UserInfo.getUserId();
        tarea.TASK_Campana__c = campaign.Id;
        tarea.Last_Assigned_Owner__c = UserInfo.getUserId();

        insert tarea;
        List<String> ids = new List<String>();
        ids.add(tarea.Id);
        Test.startTest();
		CLS_CM_BandejaTareas_Televenta.changeOwnerTasks(ids,UserInfo.getUserId());
        Test.stopTest();
    }


    @IsTest
    static void get_pickList_with_dependency_Test_01()
    {
        Test.startTest();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_CM_BandejaTareas_Televenta.get_pickList_SubEstado('En Curso');
        Test.stopTest();
    }


    @Istest
    static void changeStatusTasks()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Not Started';
        tarea.Priority = 'Media';
        tarea.OwnerId = UserInfo.getUserId();
        tarea.Last_Assigned_Owner__c = UserInfo.getUserId();

        insert tarea;

        List<String> ids = new List<String>();
        ids.add(tarea.Id);
        Test.startTest();
		CLS_CM_BandejaTareas_Televenta.changeStatusTasks(ids, 'En Curso', 'Volver a llamar');
        Test.stopTest();
    }

    @IsTest
    static void get_pickList_CampagnasTeleventa_Test_01()
    {
        String RecordTypeId  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Televenta Oncológico').getRecordTypeId();

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
        cmp.RecordTypeId = RecordTypeId;
        cmp.IsActive = true;
        cmp.Status = 'En curso';
        cmp.EndDate = Date.today().addDays(-1);
        cmp.Type = 'Salud Protegida';
        insert cmp;

        Test.startTest();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_CM_BandejaTareas_Televenta.get_pickList_CampagnasTeleventa();
        Test.stopTest();
    }

    @IsTest
    static void getTasksForIds_Test_01()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Not Started';
        tarea.Priority = 'Media';
        tarea.OwnerId = UserInfo.getUserId();
        tarea.Last_Assigned_Owner__c = UserInfo.getUserId();

        insert tarea;

        List<String> ids = new List<String>();
        ids.add(tarea.Id);

        Test.startTest();
        CLS_CM_BandejaTareas_Televenta.getTasksForIds(ids);
        Test.stopTest();
    }


    @IsTest
    static void getTasks_Filter_Test_01()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Televenta Oncológico'].Id;
        campaign.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Prospectos Campañas - Ventas Oncológico'].Id;
        campaign.Name = 'Campañana Oncologico Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta - Oncológico';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;
        insert campaign;

        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Not Started';
        tarea.Priority = 'Media';
        tarea.OwnerId = UserInfo.getUserId();
        tarea.Last_Assigned_Owner__c = UserInfo.getUserId();
        tarea.TASK_Campana__c = campaign.Id;
        tarea.IsReminderSet = true;
        tarea.ReminderDateTime = Date.today();

        insert tarea;
        
        tarea.Subject= 'Realizar Llamada';
        update tarea;

        List<String> ids = new List<String>();
        ids.add(tarea.Id);

        Test.startTest();
        CLS_CM_BandejaTareas_Televenta.getTasks_Filter('Ventas Oncológico', '','1-9','Abierta','','Juan Espinoza León', 'Pepito', Date.today(), Date.today(), Date.today());
        CLS_CM_BandejaTareas_Televenta.getTasks_Filter('Ventas Oncológico', '','','','','', '', null, null, null);

        CLS_CM_BandejaTareas_Televenta.getTasks_Filter_Owner('Ventas Oncológico', UserInfo.getUserId(), '','1-9','Abierta','', 'Pepito', Date.today(), Date.today(), Date.today());
        CLS_CM_BandejaTareas_Televenta.getTasks_Filter_Owner('Ventas Oncológico', UserInfo.getUserId(), '','','','','', null, null, null);
		CLS_CM_BandejaTareas_Televenta.getTasks_Remembers_Owner('Ventas Oncológico', UserInfo.getUserId());		
       // (String CampaignId, String RutCliente, String Estado, String SubEstado, String AsignadoA, String NombreCliente) {
       // 
       CLS_CM_BandejaTareas_Televenta.getTasks_Filter('Tarea Televentas Links', '','1-9','Abierta','','Juan Espinoza León', 'Pepito', Date.today(), Date.today(), Date.today());
        CLS_CM_BandejaTareas_Televenta.getTasks_Filter('Tarea Televentas Links', '','','','','', '', null, null, null);

        CLS_CM_BandejaTareas_Televenta.getTasks_Filter_Owner('Tarea Televentas Links', UserInfo.getUserId(), '','1-9','Abierta','', 'Pepito', Date.today(), Date.today(), Date.today());
        CLS_CM_BandejaTareas_Televenta.getTasks_Filter_Owner('Tarea Televentas Links', UserInfo.getUserId(), '','','','','', null, null, null);
		CLS_CM_BandejaTareas_Televenta.getTasks_Remembers_Owner('Tarea Televentas Links', UserInfo.getUserId());		
       
        Test.stopTest();
    }
}