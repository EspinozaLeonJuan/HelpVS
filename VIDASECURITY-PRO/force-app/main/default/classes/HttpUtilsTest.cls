@isTest
private class HttpUtilsTest {
	

	static testMethod void getTest() {
		String responseBody = 'ABC';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		Test.startTest();
		Blob b = HttpUtils.get('http://foo.bar.cl');
		Test.stopTest();
		String response = b.toString();
		System.assertEquals('ABC', response);
       	}

	static testMethod void sendDOMTest() {
		String responseBody = '<?xml version="1.0" encoding="UTF-8"?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Dont forget me this weekend</body></note>';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		String method = 'POST';
		String endpoint = 'http://localhost';
		Dom.Document body = new Dom.Document();
		Map<String, String> headerMap = new Map<String, String>();
		Test.startTest();
		Dom.Document response = HttpUtils.send(method,  endpoint, body, headerMap);
		Test.stopTest();
		
		System.assertNotEquals(null, response);
       	}
       	
       	static testMethod void httpException() {
       		try {
       			throw new HttpException(200, 'Test');
       		} catch (Exception e) {
       			
       		
       	}
	}

	static testMethod void sendStringTest() {
		String responseBody = '<?xml version="1.0" encoding="UTF-8"?><note><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Dont forget me this weekend</body></note>';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		String method = 'POST';
		String endpoint = 'http://localhost';
		String body = '';
		Map<String, String> headerMap = new Map<String, String>();
		Test.startTest();
		String response = HttpUtils.send(method,  endpoint, body, headerMap);
		Test.stopTest();
		
		System.assertNotEquals(null, response);
       	}
       	
       	
}