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
public class TEST_EXT_WS_CM_Exclusiones {
    @isTest static void getDatosExclusion_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_Exclusiones.getDatosExclusion(token, '5564436', '19203876', '6');
        Test.stopTest();
    }
    
     @isTest static void mapConsultaExclusion_Test01()
    {
        Test.startTest();
        EXT_WS_CM_Exclusiones.mapConsultaExclusion(null);
        Test.stopTest();
    }
    
    @isTest static void DatosExclusion_Test01()
    {
        Test.startTest();
        String token = '';
        EXT_WS_CM_Exclusiones.DatosExclusion(token, '5564436', '19203876', '6');
        Test.stopTest();
    }
}