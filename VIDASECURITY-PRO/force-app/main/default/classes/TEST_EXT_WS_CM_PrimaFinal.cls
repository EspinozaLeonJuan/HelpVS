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
public class TEST_EXT_WS_CM_PrimaFinal {

    @isTest static void getDatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_PrimaFinal.getDatosPoliza(token,  '5564436','19203876', '6', '0429');
        Test.stopTest();
    }
    
     @isTest static void mapConsultaPoliza_Test01()
    {
        Test.startTest();
        EXT_WS_CM_PrimaFinal.mapConsultaPoliza(null);
        Test.stopTest();
    }
    
    @isTest static void DatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_PrimaFinal.DatosPoliza(token, '5564436','19203876', '6', '0429');
        Test.stopTest();
    }

}