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
public class TEST_EXT_WS_CM_CapitalRemanente {
    @isTest static void getDatosCapital_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_CapitalRemanente.getDatosCapital(token,'12149099','18219435', '2', '4025');
        Test.stopTest();
    }
    
     @isTest static void mapConsultaCapital_Test01()
    {
        Test.startTest();
        EXT_WS_CM_CapitalRemanente.mapConsultaCapital(null);
        Test.stopTest();
    }
    
    @isTest static void DatosCapital_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_CapitalRemanente.DatosCapital(token,'12149099','18219435', '2', '4025');
        Test.stopTest();
    }
}