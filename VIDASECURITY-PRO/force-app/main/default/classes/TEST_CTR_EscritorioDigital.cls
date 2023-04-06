/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_EscritorioDigital
 *  TIPO				   : APEX TEST CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 *  2.0     - 2019/02/07 - J.ESPINOZA       - Actualización Clase
 * *****************************************************************************************/
@istest
public class TEST_CTR_EscritorioDigital {    
    @istest static void creaRequerimiento_Ok() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Persistencia = 1;
        Con.IdRequerimiento = 10;
        
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_a() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = -2;
        Con.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        Con.RespuestaPersistencia.IdPersistencia = 1234;        
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_b() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();        
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        Con.RespuestaPersistencia.IdPersistencia = 1234;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorPersistencia_c() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                 
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.Persistencia = 0;
        Con.crearRequerimiento();
        Test.StopTest();
    }
    
    @istest static void creaRequerimiento_ErrorRequerimiento() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
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
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta);         
        Con.ToCase();
        Test.stopTest();
    }


    @isTest static void LoadError() {
        Test.startTest();       
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = new Case();
        Con.Caso.Id = '5000n000005PnoFAAS';
        Con.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_EXCEPCION';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_USUARIO_INVALIDO';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA';         
        Con.loadError();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO';            
        Con.loadError();
        
        Test.stopTest();
    } 
    
     @isTest static void VerRequerimiento_Error() {
        Test.startTest();
 		Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                                  
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
        Con.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        Con.RespuestaPersistencia.IdPersistencia = 1234;
        Con.verRequerimiento();
        Test.stopTest();
    } 
    
    @isTest static void eliminarRequerimiento()
    {
        Test.startTest();
 		Factory.crearAccountAnonimo();         
        Account cuenta = Factory.cuenta.buildInsert();                                  
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = FactoryEscritorio.buildCaso('Solicitudes', cuenta); 
        Con.eliminarRequerimiento();
        Test.stopTest();
    }

    @isTest static void CargaCaso() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = new Case();       
        Con.CargaCaso();
        Test.stopTest();
    }

    @isTest static void cargaVerCaso() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.cargaVerCaso();
        Test.stopTest();
    }
    
    @isTest static void CargaCaso2() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.Caso = new Case();  
        Con.CargaCaso();
        Test.stopTest();
    }

    @isTest static void cargaVerCaso2() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.cargaVerCaso();
        Test.stopTest();
    }
    
     @isTest static void listaSolicitantes() {
        Test.startTest();
        CTR_EscritorioDigital Con = new CTR_EscritorioDigital();
        Con.getListaSolicitantes();
        Test.stopTest();
    }   
}