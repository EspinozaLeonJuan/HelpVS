/*******************************************************************************************
 *  NOMBRE                 : TEST_CLS_EscritorioDigital_Internal
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
public class TEST_CLS_EscritorioDigital_Internal {
    @isTest static void Solicitud_01() { 
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        String Valida =  CLS_EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);
        System.debug('@@ED@@ CLS_EscritorioDigital_Internal.Etiqueta -> '+ Valida); 
        //System.assert(Valida == 'ED - Solicitud pensión sobrevivencia');  
        Test.stopTest();
    }
    
    @isTest static void Solicitantes_01()
    {
        Test.startTest();
        String DetalleSolicitud = 'Solicitud Pensión Sobrevivencia';
        
        List<SelectOption> lista =  CLS_EscritorioDigital_Internal.getListaSolicitantes(DetalleSolicitud);
        
       
        Test.stopTest();
    }
    
    @isTest static void Solicitante_01()
    {
        Test.startTest();
        String Tipo = 'RRVVTIPO0005';
        
        String value =  CLS_EscritorioDigital_Internal.Solicitante(Tipo);
        
       
        Test.stopTest();
    }
  
    @istest static void CargaDatosUsuario()
    {
        Test.startTest();
        String Id = [SELECT ID FROM USER LIMIT 1].Id;

        CLS_EscritorioDigital_Internal.CargaDatosUsuario(Id);
        Test.stopTest();
    }
}