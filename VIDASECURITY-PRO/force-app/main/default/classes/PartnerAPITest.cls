@isTest
private class PartnerAPITest {

	static testMethod void loginTest() {
		String responseXML = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"><soapenv:Body><ns:loginResponse xmlns:ns="urn:partner.soap.sforce.com"><ns:result><ns:sessionId>ABC</ns:sessionId><ns:serverUrl>http://login.salesforce.com</ns:serverUrl><ns:organizationId>00D2154dda445</ns:organizationId><ns:sessionSecondsValid>12</ns:sessionSecondsValid></ns:result></ns:loginResponse></soapenv:Body></soapenv:Envelope>';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseXML));
		String username = 'foo@bar.cl';
		String password = '123abc';
		String token = 'LKKJHd12dj112553fEwxCqS';
				Test.startTest();
		Session session = PartnerAPI.login(username, password, token);
		Test.stopTest();
		System.assertEquals('ABC', session.sessionId, 'Session Id nos parsed');
		System.assertEquals('http://login.salesforce.com', session.serverURL, 'Server URL not parsed');
			}
}