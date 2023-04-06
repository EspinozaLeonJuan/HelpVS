@istest
public class TEST_CTR_TV_HistorialCargas {

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
        
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.getListarCampagnas();      
        Test.stopTest();
    } 
    
    @istest
    public static void getListarEstados()
    {
        Test.startTest();       
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.getListarEstados();      
        Test.stopTest();
    } 
    
    @istest
    public static void ListadoCargas()
    {
        Test.startTest();       
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.ListadoCargas();      
        Test.stopTest();
    } 
    
     @istest
    public static void NuevaCargaDatos()
    {
        Test.startTest();       
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.NuevaCargaDatos();      
        Test.stopTest();
    } 
    
     @istest
    public static void ToDetalleCarga()
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
        
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
         
        ApexPages.currentPage().getParameters().put('id', carga.Id); 
        ApexPages.currentPage().getParameters().put('Estado', 'CREADA');
        gcarga.ToDetalleCarga();  
        
        ApexPages.currentPage().getParameters().put('Estado', 'EN PROCESO');
        gcarga.ToDetalleCarga(); 
        
        ApexPages.currentPage().getParameters().put('Estado', 'COMPLETADA');
        gcarga.ToDetalleCarga(); 
        
        ApexPages.currentPage().getParameters().put('Estado', 'CANCELADA');
        gcarga.ToDetalleCarga(); 
        
        Test.stopTest();
    } 
    
     @istest
    public static void search()
    {
        Test.startTest();       
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.FechaInicio = Date.today().addMonths(-1);//1 mes
        gcarga.FechaTermino = Date.today();
        gcarga.search();      
        Test.stopTest();
    } 
    
     @istest
    public static void cleanSearch()
    {
        Test.startTest();       
        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.cleanSearch();      
        Test.stopTest();
    } 
    
    @istest
    public static void getctvlist_1()
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
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'ONCO';
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
        registro2.ErrorCarga__c = false;
        insert registro2;

        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.FechaInicio = Date.today().addMonths(-1);//1 mes
        gcarga.FechaTermino = Date.today();
        gcarga.getctvlist();      
        Test.stopTest();
    } 
    
    @istest
    public static void getctvlist_2()
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
        
        Carga_Televenta__c carga = new Carga_Televenta__c();
        carga.Campagna__c = campaign.Id;
        carga.Tipo_Campagna__c = 'ONCO';
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
        registro2.ErrorCarga__c = false;
        insert registro2;

        CTR_TV_HistorialCargas gcarga = new CTR_TV_HistorialCargas(); 
        gcarga.FechaInicio = Date.today().addMonths(-1);//1 mes
        gcarga.FechaTermino = Date.today();
        gcarga.CampagnaId = campaign.Id;
        gcarga.getctvlist();      
        Test.stopTest();
    } 
    
        
     @istest public static void FirstPage()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.FirstPage();
         Test.stopTest();
     }
 
     @istest public static void previous()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.previous();
         Test.stopTest();        
     }
 

     @istest public static void next()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.next();
         Test.stopTest();
     }
 
     @istest public static void LastPage()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.LastPage();
         Test.stopTest();
     }
 
 
     @istest public static void getprev()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getprev();
         Test.stopTest();
     }
     
     @istest public static void getnxt()
     {
         Test.startTest();
         CTR_TV_HistorialCargas dt = new CTR_TV_HistorialCargas();
         dt.totalrecs = 100;
         dt.Page = 2;
         dt.getnxt();
         Test.stopTest();
     }
    
    
    
    
        
        
    
    
    
    
}