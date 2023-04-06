@isTest
public class EscritorioDigital_Controller_Test {
    @isTest static void cargaDatosUsuario() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        
        Con.CargaDatosUsuario();
        Test.StopTest();
    } 
    
   @istest static void getListaSolicitantes() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Con.DetalleSolicitud = 'Solicitud garantía estatal';
        List<SelectOption> lista = Con.getListaSolicitantes();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_Ok() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Con.Persistencia = 1;
        Con.IdRequerimiento = 10;
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        /*Con.RutUsuario = '15045517-0';
Con.UserOS = 'GRP_SECURITY\\SALESFORCE';
Con.Ip = '10.240.45.250'; */
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_a() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = -2;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_b() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = -1;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_c() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                 
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = 0;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorRequerimiento() {
        Test.startTest();
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = 1;
        Con.IdRequerimiento = 0;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @isTest static void ToCase() {
        Test.startTest();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller();    
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        Test.stopTest();
    } 
    
    @istest static void constructor_a() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = '36';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
     @istest static void constructor_b() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = '36';
         caso.CASO_Poliza_Asoc__c = '12345';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
     @istest static void constructor_c() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = null;
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    @istest static void constructor_d() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatales';
        caso.Id_Requerimiento_EscritorioDigital__c = '69';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    @istest static void constructor_e() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = '';
        caso.Id_Requerimiento_EscritorioDigital__c = '';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    @istest static void constructor_f() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso('Consultas', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Consultas';        
        caso.Detalle_Solicitud__c = '';
        caso.Id_Requerimiento_EscritorioDigital__c = '';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    @istest static void constructor_g() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso_sinDetalle('Solicitudes', cuenta);     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = '36';
         caso.CASO_Poliza_Asoc__c = '12345';
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    @istest static void constructor_h() {
        Test.StartTest();       
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Case caso = FactoryEscritorio.buildCaso_sinCuenta('Solicitudes');     
        caso.Tipo_de_Requerimiento__c = 'Solicitudes';        
        caso.Detalle_Solicitud__c = 'Solicitud garantía estatal';
        caso.Id_Requerimiento_EscritorioDigital__c = '36';
        caso.CASO_Poliza_Asoc__c = '12345';        
        ApexPages.StandardController stdHR = new ApexPages.StandardController(caso);            
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(stdHR);      
        Test.StopTest();
    }
    
    
    
     @isTest static void VerRequerimiento_Error() {
        Test.startTest();
 		Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                                  
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(); 
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.verRequerimiento();
        Test.stopTest();
    } 
    
    @isTest static void eliminarRequerimiento()
    {
        Test.startTest();
 		Factory.crearAccountAnonimo();         
       // Account cuenta = Factory.cuenta.buildInsert();                                  
        EscritorioDigital_Controller Con = new EscritorioDigital_Controller(); 
      //   Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.eliminarRequerimiento();
        Test.stopTest();
    }
    
}