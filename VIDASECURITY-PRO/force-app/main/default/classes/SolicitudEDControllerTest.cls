@isTest
public class SolicitudEDControllerTest {
    @isTest static void generaMensaje() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController();
        SC.Operacion = 'ERRORELIMINAR';
        SC.Mensaje = 'tester';      
        SC.GeneraMensaje();
        Test.StopTest();
    }
    
    @isTest static void cargaMensaje() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	  
        SC.CargaParametrosMensaje();
        Test.StopTest();
    }
    
    @isTest static void verRequerimiento() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	 
        SC.RutUsuario = '15045517-0';
        SC.UserOS = 'GRP_SECURITY\\SALESFORCE';
        SC.Ip = '10.240.45.250';         
        SC.verRequerimiento();
        Test.StopTest();
    }  
    
    @isTest static void volverCaso() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	 
        SC.VolverCaso();
        Test.StopTest();
    }  
    
    @isTest static void cargaDatosUsuario() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	 
        SC.CargaDatosUsuario();
        Test.StopTest();
    } 
    
    @isTest static void creaSolicitud() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	 
        SC.Solicitud = new Solicitud__c();
        Test.StopTest();
    }  
    
    @isTest static void creaIdCaso() {
        Test.StartTest();       
        SolicitudEDController SC = new SolicitudEDController(); 	 
        SC.casoId =  Id.valueOf('5000q000000UTnxAAG'); 
        Test.StopTest();
    }  
    
    @istest static void constructor() {
        Test.StartTest();       
        Solicitud__c Solicitud = new Solicitud__c();
        Solicitud.Id = Id.valueOf('a0P0q000000v1Q7EAI'); 
        Solicitud.Caso__c = Id.valueOf('5000q000000UTnxAAG');
        Solicitud.Codigo_Solicitud__c = 'SOL_0001';
        Solicitud.IdRequerimiento__c = 69;
        Solicitud.Nombre_Titular__c = 'Juan Espinoza';
        Solicitud.RUT_Titular__c = '15045517-0';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(Solicitud);
        SolicitudEDController SC = new SolicitudEDController(stdHR);
        Test.StopTest();
    }
}