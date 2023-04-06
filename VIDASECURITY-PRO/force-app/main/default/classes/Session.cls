global class Session {
	

	private static final String NS_SOAP = 'http://schemas.xmlsoap.org/soap/envelope/';
	private static final String NS_SF = 'urn:partner.soap.sforce.com';
	
	public enum SessionEnvironment {SANDBOX, PRODUCTION, DEVELOPER}
	public SessionEnvironment environment;
	public String username;
	public String password;
	public String token;
		
	public String sessionId;
	public String serverURL;
	public String organizationId;
	public Integer sessionSecondsValid;
	public Datetime lastLoginDate;
	
	public Session(SessionEnvironment environment, String username, String password, String token) {
		this.environment = environment;
		this.username = username;
		this.password = password;
		this.token = token;
	}
	
	
	public class LoginException extends Exception {}

	public void login() {
		String xml = '<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/"><Header/><Body><login xmlns="urn:partner.soap.sforce.com"><username>' + username + '</username><password>' + password + token + '</password></login></Body></Envelope>';
		Dom.Document requestBody = new Dom.Document();
		requestBody.load(xml);
		Map<String, String> headerMap = new Map<String, String> {
			'Content-Type' => 'text/xml;charset=UTF-8',
			'SOAPAction' => '""'
		};
		String subdomain = 'www';
		if (this.environment == SessionEnvironment.SANDBOX)
			subdomain = 'test';
		String endpoint = 'https://' + subdomain + '.salesforce.com/services/Soap/u/29.0';
		Dom.Document response = HTTPUtils.send('POST', endpoint, requestBody, headerMap);
		parseSession(response);
	}
	
	private void parseSession(Dom.Document responseDocument) {
		Dom.Xmlnode rootElm = responseDocument.getRootElement(); // soapenv:Envelope
		Dom.Xmlnode bodyElm = rootElm.getChildElement('Body', NS_SOAP); // soapenv:Body
		
		Dom.Xmlnode faultElm = bodyElm.getChildElement('Fault', NS_SOAP); // soapenv:Fault
		Dom.Xmlnode faultStringElm = faultElm == null ? null : faultElm.getChildElement('faultstring', null); // faultstring
		if (faultStringElm != null)          
			throw new LoginException(faultStringElm.getText());
		Dom.Xmlnode loginResponseElm = bodyElm.getChildElement('loginResponse', NS_SF); // loginResponse
		Dom.Xmlnode resultElm = loginResponseElm.getChildElement('result', NS_SF); // result

		Dom.Xmlnode sessionIdElm = resultElm.getChildElement('sessionId', NS_SF); // sessionId
		Dom.XmlNode serverUrlElm = resultElm.getChildElement('serverUrl', NS_SF); // serverURL
		Dom.XmlNode organizationIdElm = resultElm.getChildElement('organizationId', NS_SF);
		Dom.XmlNode sessionSecondsValidElm = resultElm.getChildElement('sessionSecondsValid', NS_SF);
		
		this.sessionId = sessionIdElm.getText();
		this.serverURL = serverUrlElm.getText();
		this.organizationId = organizationIdElm == null ? null : organizationIdElm.getText();
		String sessionSecondsValid = sessionSecondsValidElm == null ? null : sessionSecondsValidElm.getText();
		this.sessionSecondsValid = sessionSecondsValid == null ? 0 : Integer.valueOf(sessionSecondsValid);
		this.lastLoginDate = Datetime.now();
	}
}