/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-13-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public with sharing class TEST_CLS_CS_Servicio_Liquidaciones_RRVV {
    @isTest
	public static void getTokenTest() {

		String response;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_SSO_ResponseToken_VS());
		response = CLS_CS_Servicio_Liquidaciones_RRVV.getToken();
		Test.stopTest();
		System.assert(response != 'ERROR', 'This service call should return a string containing a token.');
    }

    @isTest
	public static void getPolizaTest() {

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_CS_Servicio_Liquidaciones_RRVV());
        Test.setMock(HttpCalloutMock.class, new MOCK_CLS_SSO_ResponseToken_VS());
        
        String token = CLS_CS_Servicio_Liquidaciones_RRVV.getToken();
		String response = CLS_CS_Servicio_Liquidaciones_RRVV.getLiquidacionPeriodo(token, '5267896K', '202203');

        Test.stopTest();
    }
}