@isTest
public class EliminarSolicitudEDControllerTest {
    @isTest static void cargaDatosUsuario() {
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	 
        SC.CargaDatosUsuario();
    } 
     
    @istest static void constructor()  {
        Test.StartTest();     
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        ApexPages.StandardController stdHR = new ApexPages.StandardController(solicitud);
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(stdHR);
        Test.StopTest();
    }
    
    @isTest static void obtenerPersistencia() {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	 
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';         
        SC.obtienePersistencia();
        Test.stopTest();
    } 
    
    @isTest static void anulaRequerimientoActual()  {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 
        SC.RutUsuario = '15045517-0';
        SC.Persistencia = 12345;
        SC.Solicitud = new Solicitud__c();
        SC.Solicitud.IdRequerimiento__c = 69; 
        SC.AnulaRequerimientoActual();     
        Test.stopTest();
    }
   
    @isTest static void eliminarSolicitud_ok() {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	
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
        SC.EstadoActual  = 'NUEVO';
        SC.AnulaRequerimiento = 'ok';      
        SC.eliminarSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void eliminarSolicitud_error_1() {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	
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
        SC.EstadoActual  = 'NUEVO';      
        SC.AnulaRequerimiento = 'error';
        SC.eliminarSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void eliminarSolicitud_error_2() {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	
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
        SC.EstadoActual  = 'NUEVO';
        SC.AnulaRequerimiento = 'error';      
        SC.eliminarSolicitud();
        Test.stopTest();
    } 
    
    @isTest static void eliminarSolicitud_error_3() {
        Test.startTest();
        EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';  
        SC.Persistencia = 90;        
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;      
        SC.EstadoActual  = 'INGRESADO';
        SC.AnulaRequerimiento = 'error';     
        SC.eliminarSolicitud();
        Test.stopTest();
    } 
    
     @isTest static void toBack() {
         EliminarSolicitudEDController SC = new EliminarSolicitudEDController(); 	
       
        SC.toBack();
    }  
}