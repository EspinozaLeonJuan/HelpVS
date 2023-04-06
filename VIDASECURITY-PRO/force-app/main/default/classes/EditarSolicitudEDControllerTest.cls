@isTest public class EditarSolicitudEDControllerTest {
  
    @isTest static void cargaDatosUsuario() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	 
        SC.CargaDatosUsuario();
        Test.stopTest();
    } 
    
    @istest static void constructor() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        ApexPages.StandardController stdHR = new ApexPages.StandardController(solicitud);
        EditarSolicitudEDController SC = new EditarSolicitudEDController(stdHR);
        Test.StopTest();
    }
    
    @isTest static void cancelarSolicitud() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	 
        SC.cancelarSolicitud();
        Test.stopTest();
    }  
    
    @istest static void getListaSolicitudes() {   
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController();     
        List<SelectOption> lista = SC.getListaSolicitudes();
        System.assert(lista.size() == 9);	     
        Test.stopTest();
    }
    
    @istest static void getListaSolicitantes() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController();
        SC.CodigoSolicitud = 'SOL0001';
        List<SelectOption> lista = SC.getListaSolicitantes();
        System.assert(lista.size() == 4);	   
        Test.stopTest();
    }
    
    @isTest static void obtenerPersistencia() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	 
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';         
        SC.obtienePersistencia();
        Test.stopTest();
    } 
    
    @isTest static void anulaRequerimientoActual() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 
        SC.RutUsuario = '15045517-0';
        SC.Persistencia = 12345;
        SC.Solicitud = new Solicitud__c();
        SC.Solicitud.IdRequerimiento__c = 69; 
        SC.AnulaRequerimientoActual();     
        Test.stopTest();
    }
    
    @isTest static void consultaEstadoRequerimiento() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 
        SC.RutUsuario = '15045517-0';
        SC.Persistencia = 12345;
        SC.Solicitud = new Solicitud__c();       
        SC.ConsultaEstadoRequerimiento(); 
        Test.stopTest();
    } 
    
    @isTest static void creaRequerimiento()  {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController();        
        SC.RutUsuario = '15045517-0';
        SC.Persistencia = 12345;
        SC.TipoRequerimiento =  'RRVVTIPO0001';
        SC.Solicitud = new Solicitud__c();       
        SC.Solicitud.RUT_Titular__c = '15045517-0'; 
        SC.CrearRequerimiento();     
        Test.stopTest();
    }
 
    @isTest static void actualizaSolicitud() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';  
        SC.Persistencia = 12345;        
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;
            
        SC.CodigoSolicitud = 'SOL0001';
        SC.TipoRequerimiento =  'RRVVTIPO0001';
        SC.IdRequerimiento = 690;
        
        SC.ActualizaSolicitud();
        
        Test.stopTest();
    } 
    
    
    @isTest static void actualizarSolicitud_ok() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';  
        SC.Persistencia = 12345; 
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;
        
        SC.IdRequerimiento = 690;
        SC.AnulaRequerimiento = 'ok';
        SC.actualizarSolicitud();
        Test.stopTest();
    } 
  
    @isTest static void actualizarSolicitud_error() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';  
        SC.Persistencia = 12345;        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;
        
        SC.IdRequerimiento = 690;
        SC.AnulaRequerimiento = 'error';    
        SC.actualizarSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void actualizarSolicitud_errorPersistencia() {
        Test.startTest();
        EditarSolicitudEDController SC = new EditarSolicitudEDController(); 	
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';  
        SC.Persistencia = 0;        
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;
        
        SC.IdRequerimiento = 690;
        SC.AnulaRequerimiento = 'error';
        SC.actualizarSolicitud();
        Test.stopTest();
    } 
}