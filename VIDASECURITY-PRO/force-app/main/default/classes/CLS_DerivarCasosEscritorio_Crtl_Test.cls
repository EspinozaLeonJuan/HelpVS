@istest
public class CLS_DerivarCasosEscritorio_Crtl_Test {
     @isTest static void LoadError_01() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'PENDIENTE_DOCUMENTOS_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_02() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'REQUERIMIENTO_NO_CARGADO_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_03() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'VALUETECH_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_04() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'CAMBIO_ESTADO_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_05() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_06() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_07() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'DERIVACION_NO_PERMITIDA';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_08() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.Error = 'EXCEPCION';
        Con.LoadError();       
        Test.StopTest();
    } 
    

    @isTest static void ToDerivar() {
        Test.startTest();
                      
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();        
        Con.IDCASO = '5000H00000x7H2W';
        Con.ToDerivar();

        Test.stopTest();
    } 

      @isTest static void ToCase() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        
        Test.stopTest();
    } 


    @isTest static void eliminarRequerimiento() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.eliminarRequerimiento();
        
        Test.stopTest();
    } 

     @isTest static void ToEscritorioDigital() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToEscritorioDigital();
        
        Test.stopTest();
    } 

    @isTest static void CargaCasoPendiente() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();
        
        Con.CargaCasoPendiente();
        Test.StopTest();
    } 

    @isTest static void CargaCasoError() {
        Test.startTest();
        CLS_DerivarCasosEscritorio_Controlador Con = new CLS_DerivarCasosEscritorio_Controlador();
        
        Con.CargaCasoError();
        Test.StopTest();
    }
}