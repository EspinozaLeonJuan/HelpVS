/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
@IsTest
public class TEST_CTR_CS_Derivacion_Escritorio {
    public TEST_CTR_CS_Derivacion_Escritorio() {

    }
    
    @isTest static void LoadError_01() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'PENDIENTE_DOCUMENTOS_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_02() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'REQUERIMIENTO_NO_CARGADO_VALUETECH';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_03() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'VALUETECH_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_04() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'CAMBIO_ESTADO_ERROR';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_05() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

    @isTest static void LoadError_06() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'RUT_USUARIO_NO_REGISTRADO';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_07() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'DERIVACION_NO_PERMITIDA';
        Con.LoadError();       
        Test.StopTest();
    } 

     @isTest static void LoadError_08() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();        
        Con.Error = 'EXCEPCION';
        Con.LoadError();       
        Test.StopTest();
    } 
    

    @isTest static void ToDerivar() {
        Test.startTest();
                      
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();      
        Account cuenta = Factory.crearAccountAnonimo();         
        Factory.cuenta.buildInsert();  
        Case caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        insert caso;
        Con.IDCASO = caso.Id;
        Con.ToDerivar();
        Test.stopTest();
    } 

      @isTest static void ToCase() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        
        Test.stopTest();
    } 


    @isTest static void eliminarRequerimiento() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.eliminarRequerimiento();
        
        Test.stopTest();
    } 

     @isTest static void ToEscritorioDigital() {
        Test.startTest();

        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();  
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();           
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToEscritorioDigital();
        
        Test.stopTest();
    } 

    @isTest static void CargaCasoPendiente() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();
        
        Con.CargaCasoPendiente();
        Test.StopTest();
    } 

    @isTest static void CargaCasoError() {
        Test.startTest();
        CTR_CS_Derivacion_Escritorio Con = new CTR_CS_Derivacion_Escritorio();
        
        Con.CargaCasoError();
        Test.StopTest();
    }
}