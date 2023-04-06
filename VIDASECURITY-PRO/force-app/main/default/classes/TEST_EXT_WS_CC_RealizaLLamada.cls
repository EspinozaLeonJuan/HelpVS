/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   04-29-2021   Juan Espinoza León   Initial Version
**/
@IsTest(SeeAllData=true) 
public with sharing class TEST_EXT_WS_CC_RealizaLLamada {
    public TEST_EXT_WS_CC_RealizaLLamada() {
 
    }

    @isTest static void postCall()
    {
        Test.startTest();
        PAR_EXT_WS_RealizaLlamada param = new PAR_EXT_WS_RealizaLlamada();
        param.Id = 'asdsadsa';
        param.Desde = '1111111';
        param.Hasta = '222222';
        param.Rut = '15045517-0';
        param.Usuario = 'jespinoza';
        EXT_WS_CC_RealizaLLamada.postCall(param);
        Test.stopTest();
    }
    
     @isTest static void RealizaLlamada()
    {
        Test.startTest();
        PAR_EXT_WS_RealizaLlamada param = new PAR_EXT_WS_RealizaLlamada();
        param.Id = 'asdsadsa';
        param.Desde = '1111111';
        param.Hasta = '222222';
        param.Rut = '15045517-0';
        param.Usuario = 'jespinoza';
        EXT_WS_CC_RealizaLLamada.RealizaLlamada(param);
        Test.stopTest();
    }
    

}