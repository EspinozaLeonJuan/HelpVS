@isTest
public class CNuevaSolicitudEDControllerTest {
    @isTest static void cargaDatosUsuario() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 	 
        NSC.CargaDatosUsuario();
        Test.StopTest();
    } 
    
    @istest static void getListaSolicitudes() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController();
        List<SelectOption> lista = NSC.getListaSolicitudes();
        System.assert(lista.size() == 9);	   
        Test.StopTest();
    }
    
    @istest static void getListaSolicitantes() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController();
        NSC.CodigoSolicitud = 'SOL0001';
        List<SelectOption> lista = NSC.getListaSolicitantes();
        System.assert(lista.size() == 4);	
        Test.StopTest();
    }
    
    @isTest static void cancelarSolicitud() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        NSC.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
      
        NSC.cancelarSolicitud();
        Test.StopTest();
    }  
    
    @istest static void guardaSolicitud() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController();
      
        NSC.CodigoSolicitud = 'SOL0001';
        NSC.TipoRequerimiento = 'RRVVTIPO0002';
        NSC.IdRequerimiento = 690;
                
        NSC.RUTTitular = 'Nombre';
        NSC.NombreTitular = '88888888-8';
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;       
        NSC.Caso = caso;
        
        NSC.guardaSolicitud();    
        Test.stopTest();
    }
    
    @isTest static void obtienePersistencia() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 	 
        NSC.RutUsuario = '15045517-0';
        NSC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        NSC.Ip = '10.240.45.250';         
        NSC.obtienePersistencia();
        Test.StopTest();
    }  
    
    @isTest static void crearSolicitud() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 	 
        NSC.crearSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void toBack() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        NSC.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        
        NSC.toBack();
        Test.stopTest();
    } 
    
    @isTest static void toView() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 	 
        NSC.Solicitud = new Solicitud__c();	
        NSC.toView();
        Test.stopTest();
    } 
    
    @istest static void nuevoRequerimientoED() {
        Test.startTest();
        CNuevaSolicitudEDController NSC = new CNuevaSolicitudEDController(); 
        NSC.Persistencia = 123;      
        NSC.RutUsuario = '15045517-0';
        NSC.TipoRequerimiento = 'RRVVTIPO0002';     
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso; 
        
        NSC.Solicitud = new Solicitud__c();	
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
       
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);      
        CNuevaSolicitudEDController SC = new CNuevaSolicitudEDController(stdHR);      
        Test.StopTest();
    }   
}