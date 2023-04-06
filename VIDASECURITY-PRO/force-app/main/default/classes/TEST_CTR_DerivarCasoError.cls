/*******************************************************************************************
 *  NOMBRE                 : TEST_CTR_DerivarCasoError
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
public class TEST_CTR_DerivarCasoError {
    @istest static void LoadError_01() {
        Test.startTest();
        CTR_DerivarCasoError Con = new CTR_DerivarCasoError();        
        Con.Error = 'DERIVACION_NO_PERMITIDA';
        Con.LoadError();       
        Test.StopTest();
    } 


    @isTest static void cargaCasoSeleccionado_a() {
        Test.startTest();
        CTR_DerivarCasoError Con = new CTR_DerivarCasoError();
        Con.CargaCaso();
        Test.stopTest();
    }
}