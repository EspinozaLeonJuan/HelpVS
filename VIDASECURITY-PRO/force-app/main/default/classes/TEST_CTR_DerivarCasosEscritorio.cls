/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_DerivarCasosEscritorio
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
@istest
public class TEST_CTR_DerivarCasosEscritorio {
    @isTest static void LoadError_01() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'PENDIENTE_DOCUMENTOS_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_02() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'REQUERIMIENTO_NO_CARGADO_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_03() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'VALUETECH_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_04() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'CAMBIO_ESTADO_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_05() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_06() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_07() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'DERIVACION_NO_PERMITIDA';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_08() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.Error = 'EXCEPCION';
        Con.LoadError();       
        Test.StopTest();
    } 
    

    @isTest static void ToDerivar() {
        Test.startTest();
                      
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();        
        Con.IDCASO = '5000H00000x7H2W';
        Con.ToDerivar();

        Test.stopTest();
    } 

      @isTest static void ToCase() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        
        Test.stopTest();
    } 


    @isTest static void eliminarRequerimiento() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.eliminarRequerimiento();
        
        Test.stopTest();
    } 

     @isTest static void ToEscritorioDigital() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToEscritorioDigital();
        
        Test.stopTest();
    } 

    @isTest static void CargaCasoPendiente() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();
        
        Con.CargaCasoPendiente();
        Test.StopTest();
    } 

    @isTest static void CargaCasoError() {
        Test.startTest();
        CTR_DerivarCasosEscritorio Con = new CTR_DerivarCasosEscritorio();
        
        Con.CargaCasoError();
        Test.StopTest();
    }
}