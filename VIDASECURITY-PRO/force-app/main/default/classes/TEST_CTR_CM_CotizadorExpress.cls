/**
 * @description       :
 * @author            : Juan Espinoza Leon
 * @group             :
 * @last modified on  : 07-09-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@istest
public class TEST_CTR_CM_CotizadorExpress {
    public TEST_CTR_CM_CotizadorExpress() {

    }

    @isTest static void getListadoRegiones()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoRegiones();
        test.stopTest();
    }

    @isTest static void getListadoCiudades()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoCiudades();
        test.stopTest();
    }

    @isTest static void getListadoComunas()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoComunas();
        test.stopTest();
    }

    @isTest static void SeleccionRegion()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionRegion();
        test.stopTest();
    }

    @isTest static void SeleccionCiudad()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionCiudad();
        test.stopTest();
    }

    @isTest static void SeleccionComuna()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionComuna();
        test.stopTest();
    }

    @isTest static void loadInicio_Test_01()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

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

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Cuenta__c = account.Id;
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;


		Task tarea = new Task();
        tarea.TASK_ID_Miembro_Campana__c = cm.Id;
        tarea.TASK_RUT_Ejecutivo_Televenta__c = '12345678-0';
        insert tarea;


        ApexPages.currentPage().getParameters().put('TaskId', tarea.Id);

        Con.loadInicio();
        test.stopTest();
    }

     @isTest static void loadInicio_Test_02()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Cierre Administrativo';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

    @isTest static void loadInicio_Test_03()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Contratante No Contactado';
       // lead.Sub_Estado__c = 'No Contesta, inubicable';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

     @isTest static void loadInicio_Test_04()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Contratante Contactado';
        //lead.Sub_Estado__c = 'Molesto con la compañìa';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

     @isTest static void loadInicio_Test_05()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Contratante Contactado';
        //lead.Sub_Estado__c = 'Molesto con la compañìa';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

	@isTest static void loadInicio_Test_06()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Asegurado No Contactado';
       // lead.Sub_Estado__c = 'No Contesta, inubicable';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

    @isTest static void loadInicio_Test_07()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Asegurado Contactado';
       // lead.Sub_Estado__c = 'No le interesa';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

      /* @isTest static void loadInicio_Test_08()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = 'Contratante Original';
        lead.Status = 'Contrata';
        lead.Actualizacion_Datos_Poliza__c = !lead.Actualizacion_Datos_Poliza__c;
        //lead.Sub_Estado__c = 'Contratante de póliza original';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }*/

      @isTest static void loadInicio_Test_09()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();


        Lead lead = new Lead();
        lead.FirstName = 'Name';
        lead.LastName = 'LastName';
        lead.Contratante_Salud_Protegida__c = '';
        insert lead;

        ApexPages.currentPage().getParameters().put('LeadId', lead.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.loadInicio();
        test.stopTest();
    }

   @isTest static void iniciaCotizadorExpress_1()
    {
        Test.startTest();

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

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Cuenta__c = account.Id;
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;


		Task tarea = new Task();
        tarea.WhatId = account.Id;
        tarea.TASK_ID_Miembro_Campana__c = cm.Id;
        tarea.TASK_RUT_Ejecutivo_Televenta__c = '12345678-0';
        insert tarea;

        ApexPages.currentPage().getParameters().put('TaskId', tarea.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
        cotizador.CampaignId__c = campaign.Id;
        cotizador.TaskId__c = tarea.Id;
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);

		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.Cotizador = cotizador;
        Con.TipoCampagna  ='Televenta - Oncológico';
        Con.iniciaCotizadorExpress();

        test.stopTest();
    }

     @isTest static void iniciaCotizadorExpress_2()
    {
        Test.startTest();

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

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Cuenta__c = account.Id;
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;

        ApexPages.currentPage().getParameters().put('LeadId', prospecto.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
        cotizador.CampaignId__c = campaign.Id;
        cotizador.LeadId__c = prospecto.Id;
        cotizador.CampaingMemberId__c = cm.Id;
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.Cotizador = cotizador;
        Con.iniciaCotizadorExpress();

        test.stopTest();
    }

    @isTest static void iniciaCotizadorExpress_3()
    {
        Test.startTest();

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

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;

        ApexPages.currentPage().getParameters().put('LeadId', prospecto.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
        cotizador.CampaignId__c = campaign.Id;
        cotizador.LeadId__c = prospecto.Id;
        cotizador.CampaingMemberId__c = cm.Id;
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.Cotizador = cotizador;
        Con.iniciaCotizadorExpress();

        test.stopTest();
    }

      @isTest static void iniciaCotizadorExpress_4()
    {
        Test.startTest();

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

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Tercero';

        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;

        ApexPages.currentPage().getParameters().put('LeadId', prospecto.Id);

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
        cotizador.CampaignId__c = campaign.Id;
		cotizador.RUT_Tercero__c = '1-9';
        cotizador.LeadId__c = prospecto.Id;
        cotizador.CampaingMemberId__c = cm.Id;
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.Cotizador = cotizador;
        Con.iniciaCotizadorExpress();

        test.stopTest();
    }

     @isTest static void loadCotizadorExpress_01()
    {
        Test.startTest();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
    	cotizador.RUT_Tercero__c = '1-9';
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Tipo_Campagna__c = 'Televenta - Oncológico';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.CotizadorId = cotizador.Id;
        Con.loadCotizadorExpress();

        test.stopTest();

    }

      @isTest static void loadCotizadorExpress_02()
    {
        Test.startTest();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Tipo_Producto__c = '19';
    	cotizador.RUT_Tercero__c = '1-9';
        cotizador.Relacion_Titular__c = '001';
        cotizador.WS_Valor_CLP__c = '0';
        cotizador.WS_Valor_UF__c = '0';
        cotizador.WS_Valida_Fecha_Nacimiento__c = 'S';
		cotizador.Asegurable__c = 'S';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1992, 2, 25);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.CotizadorId = cotizador.Id;
        Con.TipoCampagna = 'Televenta - Oncológico';
        Con.loadCotizadorExpress();

        test.stopTest();

    }
    @isTest public  static void  generaContratanteProspecto_01()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
       // cmp.RecordTypeId = RecordTypeId;
        cmp.EndDate = Date.today().addDays(-1);
        insert cmp;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

         CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = cmp.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;
        Con.generaContratanteProspecto(prospecto.Id);
        test.stopTest();
    }

    @isTest public  static void  generaContratanteProspecto_02()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.TipoCampagna = 'Salud Protegida';
        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
       // cmp.RecordTypeId = RecordTypeId;
        cmp.EndDate = Date.today().addDays(-1);
        insert cmp;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

         CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = cmp.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;
        Con.generaContratanteProspecto(prospecto.Id);
        test.stopTest();
    }

     @isTest static void getListadoTelefonos()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;
        String[] telefonos = new String[2];
        telefonos[0] = '12345';
        telefonos[1] = '67890';
        Con.Cotizador.Lista_Telefonos__c = Con.generaTelefonosCliente(telefonos);
        Con.getListadoTelefonos();
        test.stopTest();
    }

    @isTest static void getListadoCelulares()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;
        String[] telefonos = new String[2];
        telefonos[0] = '12345';
        telefonos[1] = '67890';
        Con.Cotizador.Lista_Telefonos__c = Con.generaTelefonosCliente(telefonos);
        Con.getListadoCelulares();
        test.stopTest();
    }

    @isTest static void getListadoEstadoCivil()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.getListadoEstadoCivil();
        test.stopTest();
    }

    @isTest static void SeleccionCelular()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionCelular();
        test.stopTest();
    }

    @isTest static void SeleccionTelefono()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionTelefono();
        test.stopTest();
    }

    @isTest static void SeleccionEstadoCivil()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionEstadoCivil();
        test.stopTest();
    }


    @isTest static void ConsultaAsegurado_1()
    {
        Test.startTest();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        ApexPages.currentPage().getParameters().put('idAsegurado', '1');
        ApexPages.currentPage().getParameters().put('parentesco', 'HIJO');
      	ApexPages.currentPage().getParameters().put('fechaNacimiento', '22-09-2000');
        ApexPages.currentPage().getParameters().put('IdSalesforce', cotizador.Id);
        ApexPages.currentPage().getParameters().put('fechaNacimientoInt', '20092020');

        Con.ConsultaAsegurado();
        test.stopTest();
    }

     @isTest static void ConsultaAsegurado_2()
    {
        Test.startTest();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        ApexPages.currentPage().getParameters().put('idAsegurado', '1');
        ApexPages.currentPage().getParameters().put('parentesco', 'HIJO');
        ApexPages.currentPage().getParameters().put('fechaNacimiento', '22-09-2000');
        ApexPages.currentPage().getParameters().put('IdSalesforce', 'X');
        ApexPages.currentPage().getParameters().put('fechaNacimientoInt', '20092020');

        Con.ConsultaAsegurado();
        test.stopTest();
    }

    @isTest static void EliminaAsegurado()
    {
        Test.startTest();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;

        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.Cotizador = cotizador;
        ApexPages.currentPage().getParameters().put('IdSalesforce1', cotizador.Id);
        Con.EliminaAsegurado();
        test.stopTest();
    }


    @isTest static void ActualizaPregunta()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        ApexPages.currentPage().getParameters().put('IdSalesforce2', cotizador.Id);
        ApexPages.currentPage().getParameters().put('Pregunta', '1');
        ApexPages.currentPage().getParameters().put('Respuesta', 'SI');
        Con.ActualizaPregunta();

        ApexPages.currentPage().getParameters().put('Pregunta', '1');
        Con.ActualizaPregunta();
        ApexPages.currentPage().getParameters().put('Pregunta', '2');
        Con.ActualizaPregunta();
        ApexPages.currentPage().getParameters().put('Pregunta', '3');
        Con.ActualizaPregunta();
        ApexPages.currentPage().getParameters().put('Pregunta', '4');
        Con.ActualizaPregunta();
        ApexPages.currentPage().getParameters().put('Pregunta', '5');
        Con.ActualizaPregunta();
        test.stopTest();
    }

    @isTest static void PasoPredigitador()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Task task = new Task();
        insert task;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.TaskId__c =  task.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.PasoPredigitador();
        test.stopTest();
    }

     @istest static  void Actualiza_Contratante_Email_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
        cotizador.Actualiza_Contratante_Email();
        Test.stopTest();
   }

   @istest static  void Actualiza_Contratante_Telefono_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
        cotizador.Actualiza_Contratante_Telefono();
        Test.stopTest();
   }

    @istest static  void Actualiza_Tercero_Nombre_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
        cotizador.Actualiza_Tercero_Nombre();
        Test.stopTest();
   }

   @istest static  void Actualiza_Tercero_Email_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
        cotizador.Actualiza_Tercero_Email();
        Test.stopTest();
   }

   @istest static  void Actualiza_Tercero_Telefono_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
  		cotizador.Actualiza_Tercero_Telefono();
        Test.stopTest();
   }

   @istest static  void Actualiza_Email_Asegurado_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cot;
        cotizador.Cotizador = cot;
     	cotizador.Actualiza_Email_Asegurado();
        Test.stopTest();
   }

   @istest static  void Actualiza_Telefono_Asegurado_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.Lista_Telefonos__c = '["4566","3434"]';
		insert cot;
        cotizador.Cotizador = cot;
    	cotizador.Actualiza_Telefono_Asegurado();
        Test.stopTest();
   }


   @istest static  void Actualiza_Celular_Asegurado_Test01()
   {
   		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.Lista_Telefonos__c = '["4566","3434"]';
		insert cot;
        cotizador.Cotizador = cot;
    	cotizador.Actualiza_Celular_Asegurado();
        Test.stopTest();
   }


    @istest static  void Actualiza_Tercero_Rut_Test01()
   {
   		Test.startTest();

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

        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Contratante_Salud_Protegida__c = 'Asegurado Titular';
        prospecto.Email_Contratante_Cotizador__c = 'juanespinozaleon@ibm.com';
        insert prospecto;

        CampaignMember cm = new CampaignMember();
        cm.LeadId = prospecto.Id;
        cm.CampaignId = campaign.Id;
        cm.MCAMP_Actualizar_Nuevo_Cliente__c = true;
        cm.MCAMP_Tipo_Producto__c = '19';
        insert cm;


        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cot.LeadId__c = prospecto.Id;
		insert cot;
        cotizador.Cotizador = cot;
        cotizador.Actualiza_Tercero_RUT();
        Test.stopTest();
   }


	@istest static  void ErrorCotizador_Test01()
	{
		Test.startTest();
        CTR_CM_CotizadorExpress cotizador = new CTR_CM_CotizadorExpress();
        Cotizador_Express__c cot = new Cotizador_Express__c();
        cot.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
		insert cot;
        cotizador.Cotizador = cot;
	    cotizador.ErrorCotizador();
        Test.stopTest();
	}

     @isTest static void ReiniciarCotizacion_Task()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Task task = new Task();
        insert task;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.TaskId__c =  task.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ReiniciarCotizacion();
        test.stopTest();
    }


     @isTest static void ActualizaDireccion()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Task task = new Task();
        insert task;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.TaskId__c =  task.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ActualizaDireccion();
        test.stopTest();
    }

    @isTest static void ConsultaFechaCambio()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Task task = new Task();
        insert task;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.TaskId__c =  task.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ConsultaFechaCambio();
        test.stopTest();
    }

     @isTest static void ActualizaPasoPredigitador()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Task task = new Task();
        insert task;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.TaskId__c =  task.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ActualizaPasoPredigitador();
        test.stopTest();
    }

    @isTest static void getListadoCiudades_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoCiudades_Contratante();
        test.stopTest();
    }

    @isTest static void getListadoComunas_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoComunas_Contratante();
        test.stopTest();
    }

    @isTest static void SeleccionRegion_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionRegion_Contratante();
        test.stopTest();
    }

    @isTest static void SeleccionCiudad_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionCiudad_Contratante();
        test.stopTest();
    }

    @isTest static void SeleccionComuna_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionComuna_Contratante();
        test.stopTest();
    }

 /*   @isTest static void ActualizaDireccion_Contratante()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.AccountId__c = account.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ActualizaDireccion_Contratante();
        test.stopTest();
    }*/

    @isTest static void getListadoCiudades_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoCiudades_Tercero();
        test.stopTest();
    }

    @isTest static void getListadoComunas_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();
        Con.getListadoComunas_Tercero();
        test.stopTest();
    }

    @isTest static void SeleccionRegion_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionRegion_Tercero();
        test.stopTest();
    }

    @isTest static void SeleccionCiudad_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionCiudad_Tercero();
        test.stopTest();
    }

    @isTest static void SeleccionComuna_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
		insert cotizador;
        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.SeleccionComuna_Tercero();
        test.stopTest();
    }

    @isTest static void ActualizaDireccion_Tercero()
    {
        Test.startTest();
        CTR_CM_CotizadorExpress Con = new CTR_CM_CotizadorExpress();

        Account account = new Account();
        account.Name = 'Name';
        insert account;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.Cuenta__c = account.Id;
        prospecto.Contratante_Salud_Protegida__c = 'Contratante Original';
        insert prospecto;

        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.TipoCotizacion__c  = 'T';
        cotizador.LeadId__c =  prospecto.Id;
		insert cotizador;

        Con.Cotizador = cotizador;
        Con.CotizadorId = cotizador.Id;

        Con.ActualizaDireccion_Tercero();
        test.stopTest();
    }
  }