@isTest
public class NuevaSolicitudEDControllerTest {
    @isTest static void cargaDatosUsuario() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.CargaDatosUsuario();
        Test.StopTest();
    } 
    
    @istest static void getListaSolicitudes() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController();
        List<SelectOption> lista = NSC.getListaSolicitudes();
        System.assert(lista.size() == 9);	   
        Test.StopTest();
    }
    
    @istest static void getListaSolicitantes() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController();
        NSC.CodigoSolicitud = 'SOL0001';
        List<SelectOption> lista = NSC.getListaSolicitantes();
        System.assert(lista.size() == 4);	
        Test.StopTest();
    }
    
    @isTest static void cancelarSolicitud() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.cancelarSolicitud();
        Test.StopTest();
    }  
    
    @istest static void guardaSolicitud() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController();
      
        NSC.CodigoSolicitud = 'SOL0001';
        NSC.TipoRequerimiento = 'RRVVTIPO0002';
        NSC.IdRequerimiento = 690;
        
        NSC.Solicitud = new Solicitud__c();
        NSC.RUTTitular = 'Nombre';
        NSC.NombreTitular = '88888888-8';
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;       
        
        NSC.casoId = caso.Id;      
        NSC.Solicitud.Caso__c = NSC.casoId;  
        NSC.guardaSolicitud();    
        Test.stopTest();
    }
    
    @isTest static void obtienePersistencia() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.RutUsuario = '15045517-0';
        NSC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        NSC.Ip = '10.240.45.250';         
        NSC.obtienePersistencia();
        Test.StopTest();
    }  
    
    @isTest static void crearSolicitud() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.crearSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void toBack() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.toBack();
        Test.stopTest();
    } 
    
    @isTest static void toView() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 	 
        NSC.Solicitud = new Solicitud__c();	
        NSC.toView();
        Test.stopTest();
    } 
    
    @istest static void nuevoRequerimientoED() {
        Test.startTest();
        NuevaSolicitudEDController NSC = new NuevaSolicitudEDController(); 
        NSC.Persistencia = 123;      
        NSC.RutUsuario = '15045517-0';
        NSC.TipoRequerimiento = 'RRVVTIPO0002';     
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso; 
        
        NSC.Solicitud = new Solicitud__c();	
        NSC.casoId = caso.Id;
        NSC.Solicitud.RUT_Titular__c =  '88888888-8';
        NSC.nuevoRequerimientoED();
        Test.stopTest();
    }
    
    @istest static void constructor() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso; 
        
        Solicitud__c Solicitud = new Solicitud__c();      
        Solicitud.Caso__c = caso.Id;     
        ApexPages.StandardController stdHR = new ApexPages.StandardController(Solicitud);      
        NuevaSolicitudEDController SC = new NuevaSolicitudEDController(stdHR);      
        Test.StopTest();
    }   
}