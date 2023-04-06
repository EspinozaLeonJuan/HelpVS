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
public class TEST_EXT_WS_CM_PrimaPoliza {

    @isTest static void getDatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_PrimaPoliza.getDatosPoliza(token, '12149099');
        Test.stopTest();
    }
    
     @isTest static void mapConsultaPoliza_Test01()
    {
        Test.startTest();
        EXT_WS_CM_PrimaPoliza.mapConsultaPoliza(null);
        Test.stopTest();
    }
    
    @isTest static void DatosPoliza_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_PrimaPoliza.DatosPoliza(token, '12149099');
        Test.stopTest();
    }
}