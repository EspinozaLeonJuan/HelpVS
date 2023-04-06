/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 12-01-2020
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   12-01-2020   Juan Espinoza León   Initial Version
**/
@istest
public class TEST_CTR_TV_GestionCarga {
    public TEST_CTR_TV_GestionCarga() {

    }

    @istest
    public static void getCampagnasOnco()
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
        
        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        
        gcarga.campaigns = [SELECT Id, Name FROM Campaign WHERE IsActive = true AND Status = 'En Curso' ORDER BY CreatedDate DESC];
        gcarga.getCampagnasOnco();      
        Test.stopTest();
    }

    @istest
    public static void importCSVFile_1()
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

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;

        String x = 'RUT__c,DV,POLIZAMANDATORIA,TELEFONO1,TELEFONO2,TELEFONO3,TELEFONO4,TELEFONO5,TELEFONO6,TELEFONO7,TELEFONO8,EMAILTEST'+'\n'+
        '16903814,7,,947338647,,,,,,,,juespinoza@security.cl'+'\n'+
        '15045517,0,,947338647,,,,,,,,juespinoza@security.cl';
        gcarga.csvFileBody = Blob.valueOf(x);
        
        gcarga.importCSVFile();      
        Test.stopTest();
    }
    
    @istest
    public static void importCSVFile_2()
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

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;

        String x = 'RUT__c,DV,POLIZAMANDATORIA,TELEFONO1,TELEFONO2,TELEFONO3,TELEFONO4,TELEFONO5,TELEFONO6,TELEFONO7,TELEFONO8,EMAILTEST,CORREOENVIADO';
        gcarga.csvFileBody = Blob.valueOf(x);
        
        gcarga.importCSVFile();      
        Test.stopTest();
    }
    
    @istest
    public static void importCSVFile_3()
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

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;

       // String x = 'l';
        gcarga.csvFileBody = null;//Blob.valueOf(x);
        
        gcarga.importCSVFile();      
        Test.stopTest();
    }
    
 	@istest
    public static void CreateNewUpload()
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
        campaign.CAMP_Producto__c = '19';
        insert campaign;

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;

        gcarga.CreateNewUpload();      
        Test.stopTest();
    }
   
    @istest(SeeAllData = true)
    public static void ProcessUpload_1()
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
        campaign.CAMP_Producto__c = '66';
        insert campaign;

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;
		String x = 'RUT__c,DV,POLIZAMANDATORIA,TELEFONO1,TELEFONO2,TELEFONO3,TELEFONO4,TELEFONO5,TELEFONO6,TELEFONO7,TELEFONO8,EMAILTEST,CORREOENVIADO'+'\n'+
        '16903814,7,,947338647,,,,,,,,juespinoza@security.cl,TRUE'+'\n'+
        '15045517,0,,947338647,,,,,,,,juespinoza@security.cl,TRUE';
        gcarga.csvFileBody = Blob.valueOf(x);
        
        gcarga.importCSVFile();    
        gcarga.ProcessUpload();      
        Test.stopTest();
    }

    @istest
    public static void ProcessUpload_2()
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
        campaign.CAMP_Producto__c = '19';
        insert campaign;

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;
		String x = 'RUT__c,DV,POLIZAMANDATORIA,TELEFONO1,TELEFONO2,TELEFONO3,TELEFONO4,TELEFONO5,TELEFONO6,TELEFONO7,TELEFONO8,EMAILTEST,CORREOENVIADO'+'\n'+
        '16903814,7,,947338647,,,,,,,,juespinoza@security.cl,TRUE'+'\n'+
        '15045517,0,,947338647,,,,,,,,juespinoza@security.cl,TRUE';
        gcarga.csvFileBody = Blob.valueOf(x);
        
        gcarga.importCSVFile();    
        gcarga.ProcessUpload();      
        Test.stopTest();
    }
    
    @istest
    public static void ProcessUpload_3()
    {
        Test.startTest();
        
        Account cuenta_1 = new Account();
        cuenta_1.FirstName = 'A';
        cuenta_1.LastName = 'B';
        cuenta_1.Rut__c = '1';
        cuenta_1.DV__c = '9';
        insert cuenta_1;
        
        Poliza__c poliza_1 = new Poliza__c();
        poliza_1.Cuenta__c = cuenta_1.Id;
        poliza_1.Name = '1';
        insert poliza_1;
        
        Account cuenta_2 = new Account();
        cuenta_2.FirstName = 'A';
        cuenta_2.LastName = 'B';
        cuenta_2.Rut__c = '2';
        cuenta_2.DV__c = '7';
        insert cuenta_2;
        
        Poliza__c poliza_2 = new Poliza__c();
        poliza_2.Cuenta__c = cuenta_2.Id;
        poliza_2.Name = '2';
        insert poliza_2;        

        Campaign campaign = new Campaign();
        campaign.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Salud Protegida'].Id;
        campaign.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Miembros Salud Protegida'].Id;
        campaign.Name = 'Campañana Salud Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Salud Protegida';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;  
        campaign.CAMP_Producto__c = '19';
        insert campaign;

        CTR_TV_GestionCarga gcarga = new CTR_TV_GestionCarga(); 
        gcarga.CampaignId = campaign.Id;
		String x ='RUT_PROSPECTO,DV_PROSPECTO,NOMBRE_PROSPECTO,APELLIDO_PROSPECTO,RUT_CONTRATANTE_ORIGINAL,DV_CONTRATANTE_ORIGINAL,POLIZA_CONTRATANTE_ORIGINAL,PLAN_COBERTURA,TELEFONO,EMAIL,FECHA_NACIMIENTO_PROSPECTO,FECHA_INICIO_VIGENCIA_PROSPECTO,COD_NUEVO_PRODUCTO'+'\n'+
'125084781,1,JUAN,LUCAY TORRES,1,9,1,SALUD PROTEGIDA 15000,2280885,juespinoza@security.cl,16/04/1995,01/05/2021,MD017400002001'+'\n'+
'17597236,6,ALEJANDRO,ALZERRECA RABAGLIATI,2,7,2,SALUD PROTEGIDA 15000,22425231,juespinoza@security.cl,04/04/1990,01/05/2021,MD017400002001';
        gcarga.csvFileBody = Blob.valueOf(x);
        
        gcarga.importCSVFile();    
        gcarga.ProcessUpload();              
       
        Test.stopTest();
    }
    
     @istest
    public static void ToHistory()
    {
        Test.startTest();
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.ToHistory();
        Test.stopTest();
    }


    @istest
    public static void CancelGestion()
    {
        Test.startTest();

        Carga_Televenta__c carga = new Carga_Televenta__c();
        insert carga;

        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.Carga = [SELECT Id FROM Carga_Televenta__c WHERE Id =: carga.Id];
        dcarga.CancelGestion();
        Test.stopTest();
    }


    @istest
    public static void ArchivoProcesadoOk()
    {
        Test.startTest();

        Carga_Televenta__c carga = new Carga_Televenta__c();
        insert carga;

        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.IdCarga = carga.Id;
        dcarga.ArchivoProcesadoOk();
        Test.stopTest();
    }

    @istest
    public static void CancelUpload()
    {
        Test.startTest();
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.CancelUpload();
        Test.stopTest();
    }
    
    @istest
    public static void IniciaCargaResultado_1()
    {
        Test.startTest();
          Account cuenta_1 = new Account();
        cuenta_1.FirstName = 'A';
        cuenta_1.LastName = 'B';
        cuenta_1.Rut__c = '1';
        cuenta_1.DV__c = '9';
        insert cuenta_1;
        
        Poliza__c poliza_1 = new Poliza__c();
        poliza_1.Cuenta__c = cuenta_1.Id;
        poliza_1.Name = '1';
        insert poliza_1;
        
        Account cuenta_2 = new Account();
        cuenta_2.FirstName = 'A';
        cuenta_2.LastName = 'B';
        cuenta_2.Rut__c = '2';
        cuenta_2.DV__c = '7';
        insert cuenta_2;
        
        Poliza__c poliza_2 = new Poliza__c();
        poliza_2.Cuenta__c = cuenta_2.Id;
        poliza_2.Name = '2';
        insert poliza_2;      
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
        campaign.CAMP_Producto__c = '66';
        insert campaign;
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'PROCESADA';
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'APEG';
        carga.Tipo__c = 'Televenta - Oncológico';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.AccountId__c = cuenta_1.Id;
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.AccountId__c = cuenta_2.Id;
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;

        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
            dcarga.map_cuentas = new Map<Id, Account> ();
        dcarga.map_cuentas.put(cuenta_1.Id, cuenta_1);
        dcarga.map_cuentas.put(cuenta_2.Id, cuenta_2);
        dcarga.TipoCampagna = 'APEG';
        ApexPages.currentPage().getParameters().put('id', carga.Id);     
        ApexPages.currentPage().getParameters().put('page', 'OK');  
        dcarga.Carga = carga;
        dcarga.IniciaCargaResultado();
        dcarga.GenerateCampaignMember();
        Test.stopTest();
    }
      @istest
    public static void IniciaCargaResultado_2()
    {
        Test.startTest();
          Account cuenta_1 = new Account();
        cuenta_1.FirstName = 'A';
        cuenta_1.LastName = 'B';
        cuenta_1.Rut__c = '1';
        cuenta_1.DV__c = '9';
        insert cuenta_1;
        
        Poliza__c poliza_1 = new Poliza__c();
        poliza_1.Cuenta__c = cuenta_1.Id;
        poliza_1.Name = '1';
        insert poliza_1;
        
        Account cuenta_2 = new Account();
        cuenta_2.FirstName = 'A';
        cuenta_2.LastName = 'B';
        cuenta_2.Rut__c = '2';
        cuenta_2.DV__c = '7';
        insert cuenta_2;
        
        Poliza__c poliza_2 = new Poliza__c();
        poliza_2.Cuenta__c = cuenta_2.Id;
        poliza_2.Name = '2';
        insert poliza_2;       
        
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
        campaign.CAMP_Producto__c = '66';
        insert campaign;
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'PROCESADA';
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'ONCO';
        carga.Tipo__c = 'Televenta - APEG';
        insert carga;
        
         Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.AccountId__c = cuenta_1.Id;
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.AccountId__c = cuenta_2.Id;
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '2';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;

        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
         dcarga.map_cuentas = new Map<Id, Account> ();
        dcarga.map_cuentas.put(cuenta_1.Id, cuenta_1);
        dcarga.map_cuentas.put(cuenta_2.Id, cuenta_2);
        //dcarga.TipoCampagna = 'ONCO';
        ApexPages.currentPage().getParameters().put('id', carga.Id); 
        ApexPages.currentPage().getParameters().put('page', 'ERROR');
        //dcarga.Carga = carga;
        dcarga.IniciaCargaResultado();
        dcarga.GenerateCampaignMember();
        Test.stopTest();
    }
    
     @istest
    public static void IniciaCargaResultado_3()
    {
        Test.startTest();
          Account cuenta_1 = new Account();
        cuenta_1.FirstName = 'A';
        cuenta_1.LastName = 'B';
        cuenta_1.Rut__c = '1';
        cuenta_1.DV__c = '9';
        insert cuenta_1;
        
        Poliza__c poliza_1 = new Poliza__c();
        poliza_1.Cuenta__c = cuenta_1.Id;
        poliza_1.Name = '1';
        insert poliza_1;
        
        Account cuenta_2 = new Account();
        cuenta_2.FirstName = 'A';
        cuenta_2.LastName = 'B';
        cuenta_2.Rut__c = '2';
        cuenta_2.DV__c = '7';
        insert cuenta_2;
        
        Poliza__c poliza_2 = new Poliza__c();
        poliza_2.Cuenta__c = cuenta_2.Id;
        poliza_2.Name = '2';
        insert poliza_2;       
        
        Campaign campaign = new Campaign();
        campaign.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Campaña - Salud Protegida'].Id;
        campaign.CampaignMemberRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Miembros Salud Protegida'].Id;
        campaign.Name = 'Campañana Salud Protegid Test';
        campaign.Status = 'En Curso';
        campaign.IsActive = true;
        campaign.CAMPA_Ejecutar_JOB_Procesar_Prospectos__c = false;
        campaign.Type = 'Salud Protegida';
        campaign.CAMPA_Ejecutivo_Televenta__c = '9869387-4;9919804-4';
        campaign.Description = 'Test';
        campaign.CAMPA_Script_Televenta__c = 'Test';
        campaign.StartDate = Date.today();
        campaign.EndDate = Date.today() + 1;  
        campaign.CAMP_Producto__c = '66';
        insert campaign;
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'PROCESADA';
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'ONCO';
        carga.Tipo__c = 'Salud Protegida';
        insert carga;
        
         Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.AccountId__c = cuenta_1.Id;
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        registro1.FECHA_NACIMIENTO_PROSPECTO__c = '20/05/2000';
        registro1.FECHA_INICIO_VIGENCIA_PROSPECTO__c = '01/06/2021';        
        registro1.CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c = 'MD017400002001';        
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.AccountId__c = cuenta_2.Id;
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '2';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        registro2.FECHA_NACIMIENTO_PROSPECTO__c = '20/05/2000';
        registro2.FECHA_INICIO_VIGENCIA_PROSPECTO__c = '01/06/2021';
        registro2.CODIGO_WS_PRIMA_NUEVO_PRODUCTO__c = 'MD017400002001';
        insert registro2;

        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
         dcarga.map_cuentas = new Map<Id, Account> ();
        dcarga.map_cuentas.put(cuenta_1.Id, cuenta_1);
        dcarga.map_cuentas.put(cuenta_2.Id, cuenta_2);
        //dcarga.TipoCampagna = 'ONCO';
        ApexPages.currentPage().getParameters().put('id', carga.Id); 
        ApexPages.currentPage().getParameters().put('page', 'ERROR');
        //dcarga.Carga = carga;
        dcarga.IniciaCargaResultado();
        dcarga.GenerateCampaignMember();
        Test.stopTest();
    }
    
    @istest
    public static void RegistrosValidos()
    {
        Test.startTest();
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.IdCarga = '1';
        dcarga.RegistrosValidos();
        Test.stopTest();
    }

    @istest
    public static void RegistrosInvalidos()
    {
        Test.startTest();
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.IdCarga = '1';
        dcarga.RegistrosInvalidos();
        Test.stopTest();        
    }
/*
    @istest
    public static void getData_DOK()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = false;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga(); 
        dcarga.IdCarga = carga.Id;
        dcarga.getData_OK();
        Test.stopTest();        
    }

    @istest
    public static void getData_DError()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = true;
        insert registro2;
        
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.IdCarga = carga.Id;
        dcarga.getData_Error();
        Test.stopTest();       
    }
    
      @istest
    public static void getData()
    {
        Test.startTest();
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = true;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = true;
        insert registro2;
        
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();
        dcarga.IdCarga = carga.Id;
        dcarga.getData();
        Test.stopTest();       
    }
*/
    @istest
    public static void InicioError()
    {
        Test.startTest();  
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();      
        dcarga.InicioError();
        Test.stopTest();
    }

    @istest
    public static void AceptarError()
    { 
        Test.startTest();  
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();      
        dcarga.AceptarError();
        Test.stopTest();
    }

    @istest
    public static void IniciaEnProceso()
    {
        Test.startTest();  
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Estado__c = 'CANCELADA';
        insert carga;
        
        Registro_Carga_Televenta__c registro1 = new Registro_Carga_Televenta__c();
        registro1.CORREOENVIADO__c = 'true';
        registro1.EMAILTEST__c = 'juespinoza@security.cl';
        registro1.POLIZA_MANDATORIA__c = '1234';
        registro1.RUT__c = '15045517';
        registro1.DV__c = '0';
        registro1.TELEFONO_1__c = '+56947338647';
        registro1.TELEFONO_2__c = '';
        registro1.TELEFONO_3__c = '';
        registro1.TELEFONO_4__c = '';
        registro1.TELEFONO_5__c = '';        
        registro1.TELEFONO_6__c = '';
        registro1.TELEFONO_7__c = '';
        registro1.TELEFONO_8__c = '';
        registro1.Carga_Televenta__c = carga.Id;
        registro1.ErrorCarga__c = false;
        insert registro1;


        Registro_Carga_Televenta__c registro2 = new Registro_Carga_Televenta__c();
        registro2.CORREOENVIADO__c = 'true';
        registro2.EMAILTEST__c = 'juespinoza@security.cl';
        registro2.POLIZA_MANDATORIA__c = '1234';
        registro2.RUT__c = '15045517';
        registro2.DV__c = '0';
        registro2.TELEFONO_1__c = '+56947338647';
        registro2.TELEFONO_2__c = '';
        registro2.TELEFONO_3__c = '';
        registro2.TELEFONO_4__c = '';
        registro2.TELEFONO_5__c = '';        
        registro2.TELEFONO_6__c = '';
        registro2.TELEFONO_7__c = '';
        registro2.TELEFONO_8__c = '';
        registro2.Carga_Televenta__c = carga.Id;
        registro2.ErrorCarga__c = false;
        insert registro2;
        
        CTR_TV_GestionCarga dcarga = new CTR_TV_GestionCarga();     
        ApexPages.currentPage().getParameters().put('id', carga.Id); 
        ApexPages.currentPage().getParameters().put('Reprocesar', 'true');
        dcarga.IniciaEnProceso();
        Test.stopTest();
    }    
    
     @istest public static void FirstPage()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.FirstPage();
         Test.stopTest();
     }
 
     @istest public static void previous()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.previous();
         Test.stopTest();        
     }
 

     @istest public static void next()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.next();
         Test.stopTest();
     }
 
     @istest public static void LastPage()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.LastPage();
         Test.stopTest();
     }
 
 
     @istest public static void getprev()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getprev();
         Test.stopTest();
     }
     
     @istest public static void getnxt()
     {
         Test.startTest();
         CTR_TV_GestionCarga dt = new CTR_TV_GestionCarga();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getnxt();
         Test.stopTest();
     }
}