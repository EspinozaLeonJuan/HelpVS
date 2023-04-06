/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_EscritorioDigitalError
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
public class TEST_CTR_EscritorioDigitalError {
    @istest static void LoadError_01() {
        Test.startTest();
        CTR_EscritorioDigitalError Con = new CTR_EscritorioDigitalError();        
      
        Con.Error = 'RUT_CLIENTE_NO_CORRESPONDE';
        Con.LoadAlerta();  
        Con.Error = 'RUT_CLIENTE_SIN_BENEFICIARIOS';
        Con.LoadAlerta();  
        Con.Error = 'POLIZA_OBSOLETA';
        Con.LoadAlerta(); 
        Con.Error = 'POLIZA_NO_INGRESADA';
        Con.LoadAlerta(); 
        Con.Error = 'CLIENTE_SIN_POLIZAS_ACTIVAS';
        Con.LoadAlerta();  
        Con.Error = 'POLIZA_NO_CORRESPONDE';
        Con.LoadAlerta();  
        Con.Error = 'CREA_REQUERIMIENTO_EXCEPCION';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_EXCEPCION_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_INVALIDO_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_EXCEPCION';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_INVALIDO';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA';
        Con.LoadAlerta(); 
        Con.Error = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO';
        Con.LoadAlerta(); 
        Con.Error = 'REQUERIMIENTO_NO_SOPORTADO';
        Con.LoadAlerta(); 
        Con.Error = 'REQUERIMIENTO_NO_APV';
        Con.LoadAlerta(); 
        Con.Error = 'REQUERIMIENTO_MAX_3';
        Con.LoadAlerta(); 
        Con.Error = 'REQUERIMIENTO_MI_SEGURO';
        Con.LoadAlerta(); 
        Test.StopTest();
    }         
    
    
    @isTest static void CargaCaso() {
        Test.startTest();
        CTR_EscritorioDigitalError Con = new CTR_EscritorioDigitalError();
        Con.CargaCaso();
        Test.stopTest();
    }
    
    @isTest static void ToCase() {
        Test.startTest();
        CTR_EscritorioDigitalError Con = new CTR_EscritorioDigitalError();
        Con.Caso = new Case();
        Con.Caso.Id = '5000n000005PnoFAAS';
        Con.ToCase();
        Test.stopTest();
    }
    
}