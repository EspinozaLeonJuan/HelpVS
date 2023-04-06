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
public class TEST_EXT_WS_CM_CallSSO {
    @isTest static void getDatosAuth_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_CallSSO.getDatosAuth();
        Test.stopTest();
    }
    
     @isTest static void mapConsultaAuth_Test01()
    {
        Test.startTest();
        EXT_WS_CM_CallSSO.mapConsultaAuth(null);
        Test.stopTest();
    }
    
    @isTest static void DatosAuth_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_CallSSO.DatosAuth();
        Test.stopTest();
    }
}