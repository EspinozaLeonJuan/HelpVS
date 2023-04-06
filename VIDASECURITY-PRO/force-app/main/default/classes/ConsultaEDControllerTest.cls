@isTest public class ConsultaEDControllerTest {
    @isTest static void cargaDatosUsuario() {
        ConsultaEDController SC = new ConsultaEDController(); 	 
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
      
        ApexPages.StandardController stdHR = new ApexPages.StandardController(Solicitud);
        ConsultaEDController SC = new ConsultaEDController(stdHR);
        Test.StopTest();
    }

    @isTest static void toCaso() {
        ConsultaEDController SC = new ConsultaEDController(); 
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);        
        insert caso;
        
        Solicitud__c solicitud = FactoryEscritorio.buildSolicitud(caso);
        insert solicitud;
        
        SC.Solicitud = solicitud;
                
        SC.toCaso();
    }       
}