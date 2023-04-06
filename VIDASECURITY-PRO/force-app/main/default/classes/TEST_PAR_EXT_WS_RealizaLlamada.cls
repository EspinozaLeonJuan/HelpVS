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
@IsTest
public with sharing class TEST_PAR_EXT_WS_RealizaLlamada {
    public TEST_PAR_EXT_WS_RealizaLlamada() {

    }

    @isTest static void test()
    {
        Test.startTest();
        PAR_EXT_WS_RealizaLlamada param = new PAR_EXT_WS_RealizaLlamada();
        param.Id = 'asdsadsa';
        param.Desde = '1111111';
        param.Hasta = '222222';
        param.Rut = '15045517-0';
        param.Usuario = 'jespinoza';
        Test.stopTest();
    }
}