@isTest
public class EBV_GetTokenValueTech_Test {
    @isTest
	public static void getTokenTest() {

		String response;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GetTokenValueTechMock());
		response = EBV_GetTokenValueTech.getToken();
		Test.stopTest();
		System.assert(response != 'ERROR', 'This service call should return a string containing a token.');
    }
}