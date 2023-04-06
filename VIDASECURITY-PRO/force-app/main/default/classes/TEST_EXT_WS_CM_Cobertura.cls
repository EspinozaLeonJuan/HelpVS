/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 03-11-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-11-2021   Juan Espinoza León   Initial Version
**/
@istest
public class TEST_EXT_WS_CM_Cobertura {
    @isTest static void getDatosCobertura_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_Cobertura.getDatosCobertura(token, '5564436', '19203876', '6' );
        Test.stopTest();
    }
    
     @isTest static void mapConsultaCobertura_Test01()
    {
        Test.startTest();
        EXT_WS_CM_Cobertura.mapConsultaCobertura(null);
        Test.stopTest();
    }
    
    @isTest static void DatosCobertura_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_Cobertura.DatosCobertura(token, '5564436', '19203876', '6' );
        Test.stopTest();
    }
}