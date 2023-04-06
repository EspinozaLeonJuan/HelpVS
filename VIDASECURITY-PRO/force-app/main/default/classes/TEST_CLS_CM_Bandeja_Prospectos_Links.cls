/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-04-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_CM_Bandeja_Prospectos_Links {

    @Istest
    static void changeOwnerLeads()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];

        String RecordTypeId_Campaign  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Links').getRecordTypeId();
        String RecordTypeId_CampaignMember  = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Prospectos Campañas - Ventas Links').getRecordTypeId();

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = RecordTypeId_Campaign;
        campaign.CampaignMemberRecordTypeId = RecordTypeId_CampaignMember;
        campaign.Name = 'Campañana  Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta-Links';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;
        insert campaign;

        String RecordTypeId_Lead  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();

        Lead lead = new Lead();
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '9';
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
        lead.Status = 'Abierto';
        lead.Sub_Estado__c = 'No Contactado';
        lead.RecordTypeId = RecordTypeId_Lead;
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
        insert lead;

        List<CampaignMember> testCampMemb1 = new List<CampaignMember>();
        testCampMemb1.add(new CampaignMember(LeadId =lead.Id , CampaignId = campaign.Id, Status = 'Sent'));
        insert testCampMemb1;


        List<String> ids = new List<String>();
        ids.add(lead.Id);

        Test.startTest();
		CLS_CM_Bandeja_Prospectos_Links.changeOwnerLeads(ids, UserInfo.getUserId());
        CLS_CM_Bandeja_Prospectos_Links.changeStatusLeads(ids, 'Abierto', '' );
        CLS_CM_Bandeja_Prospectos_Links.cierreAdministrativoLeads(ids);
        Test.stopTest();
    }

    @IsTest
    static void get_pickList_with_dependency_Test_01()
    {
        Test.startTest();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_CM_Bandeja_Prospectos_Links.get_pickList_SubEstado('En Curso');
        Test.stopTest();
    }

     @IsTest
    static void get_pickList_CampagnasLinks_Test_01()
    {
        String RecordTypeId_Campaign  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Links').getRecordTypeId();
        String RecordTypeId_CampaignMember  = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Prospectos Campañas - Ventas Links').getRecordTypeId();

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = RecordTypeId_Campaign;
        campaign.CampaignMemberRecordTypeId = RecordTypeId_CampaignMember;
        campaign.Name = 'Campañana  Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta-Links';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;
        insert campaign;

        Test.startTest();
        List<CLS_UTL_Lightning.customValueWrapper> dependentPicklistValuesMap = CLS_CM_Bandeja_Prospectos_Links.get_pickList_CampagnasLinks();
        Test.stopTest();
    }

    @IsTest
    static void getLeads_Filter_Test()
    {
        String RecordTypeId_Campaign  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Links').getRecordTypeId();
        String RecordTypeId_CampaignMember  = Schema.SObjectType.CampaignMember.getRecordTypeInfosByName().get('Prospectos Campañas - Ventas Links').getRecordTypeId();

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = RecordTypeId_Campaign;
        campaign.CampaignMemberRecordTypeId = RecordTypeId_CampaignMember;
        campaign.Name = 'Campañana  Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Televenta-Links';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;
        insert campaign;

        String RecordTypeId_Lead  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();

        Lead lead = new Lead();
        lead.PROSP_Carga_RUT__C = '1';
        lead.DV__C = '9';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today();
        lead.FirstName = 'A';
        lead.Fecha_Entrevista__c = Date.Today();
        lead.Reprogramacion__c = Datetime.now();
        lead.LastName = 'B';
        lead.Status = 'Abierto';
        lead.Sub_Estado__c = 'No Contactado';
        lead.RecordTypeId = RecordTypeId_Lead;
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
        insert lead;

        List<CampaignMember> testCampMemb1 = new List<CampaignMember>();
        testCampMemb1.add(new CampaignMember(LeadId =lead.Id , CampaignId = campaign.Id, Status = 'Sent'));
        insert testCampMemb1;

        List<String> Ids = new List<String>();
        Ids.add(lead.Id);

        Test.startTest();
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter('','1-9','Abierto','','Juan Espinoza León', 'Pepito', Date.today(), Date.today(), Date.today(), Date.today(), 'Bases Normales', 'Bases Normales', 'Bases Normales');
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter('','','','','', '', null, null, null, null, null, null, null);
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter_Owner(UserInfo.getUserId(), '','1-9','Abierta','', 'Pepito', Date.today(), Date.today(), Date.today(), Date.today(), 'Bases Normales', 'Bases Normales', 'Bases Normales');
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter(campaign.Id,'','','','', '', null, null, null, null, null, null, null);
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter_Owner(UserInfo.getUserId(), campaign.Id,'1-9','Abierta','', 'Pepito', Date.today(), Date.today(), Date.today(), Date.today(), 'Bases Normales', 'Bases Normales', 'Bases Normales');
        CLS_CM_Bandeja_Prospectos_Links.getLeads_Filter_Owner(UserInfo.getUserId(), '','','','','', null, null, null, null, null, null, null);
		CLS_CM_Bandeja_Prospectos_Links.getLeads_CallRemembers_Owner(UserInfo.getUserId());
        CLS_CM_Bandeja_Prospectos_Links.getLeadForIds(Ids);
		Test.stopTest();
    }

      @IsTest
    static void getTasks_Filter_Test_01()
    {
        AccountGeneration accountGen = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '30323528', '0', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','30323528').save();

        Account account = (Account)accountGen.get();

        Contact con = [SELECT Id FROM Contact WHERE Rut_contacto__c = '30323528' limit 1];


        Task tarea = new Task();

        String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Tarea Televentas Links').getRecordTypeId();
        tarea.RecordTypeId = Task_RecordTypeId;
        tarea.Subject = 'Realizar Llamada';
        tarea.WhatId = account.Id;
        tarea.WhoId = con.Id;
        tarea.Status = 'Abierta';
        tarea.Priority = 'Media';
        tarea.OwnerId = UserInfo.getUserId();
        tarea.Last_Assigned_Owner__c = UserInfo.getUserId();
        tarea.IsReminderSet = true;
        tarea.ReminderDateTime = Date.today();

        insert tarea;

        tarea.Subject= 'Realizar Llamada';
        update tarea;

        List<String> ids = new List<String>();
        ids.add(tarea.Id);

        Test.startTest();
		CLS_CM_Bandeja_Prospectos_Links.getLeads_CallTask_Remembers_Owner(UserInfo.getUserId());
        Test.stopTest();
    }




}