@istest
public class TEST_EXT_WS_CM_PrimaNuevoProducto {

    @isTest static void getDatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';        
        EXT_WS_CM_PrimaNuevoProducto.getDatosPrimaNuevoProducto(token, 'MD017400001001', 35, '0001', 10000);
        Test.stopTest();
    }
    
     @isTest static void mapConsultaPoliza_Test01()
    {
        Test.startTest();
        EXT_WS_CM_PrimaNuevoProducto.mapPrimaNuevoProducto(null);
        Test.stopTest();
    }
    
    @isTest static void DatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_PrimaNuevoProducto.DatosPrimaNuevoProducto(token, 'MD017400001001', 35, '0001', 10000);
        Test.stopTest();
    }
}