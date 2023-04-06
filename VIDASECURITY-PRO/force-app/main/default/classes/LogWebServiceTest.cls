@isTest
private class LogWebServiceTest {

	static testMethod void logTest() {
		RestContext.response = new RestResponse();
		String message = EncodingUtil.base64Encode(Blob.valueOf('Este es el mensaje'));
		String stackTrace = EncodingUtil.base64Encode(Blob.valueOf('Este es un \n mensaje con" enters y comillas "')); 
		LogWebService.doPost(message, stackTrace);
		      
	}
}