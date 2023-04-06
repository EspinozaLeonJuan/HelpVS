public class HttpUtils {
	
	private static final Credencial__c credencial = Credencial__c.getOrgDefaults();
		
	private static final String username = credencial == null ? null : credencial.Username__c;
	private static final String password = credencial == null ? null : credencial.Password__c;
	private static final String token = credencial == null ? null : credencial.Token__c;
	
	public static Blob get(String endpoint) {
		String sessionId = UserInfo.getSessionId();
		if (sessionId == null) {
			Session session = PartnerAPI.login(username, password, token);
			sessionId = session.sessionId;
		}
		Map<String, String> headerMap = new Map<String, String> {
			'Authorization' => 'Bearer ' + sessionId
		};
		return send('GET', endpoint, (Blob)null, headerMap);
	}
				
	public static HttpRequest getHttpRequest(String method, String endpoint, Map<String, String> headerMap) {
		HttpRequest req = new HttpRequest();
		req.setMethod(method);
		req.setEndpoint(endpoint);
		if (headerMap != null) {
			for (String key : headerMap.keySet()) {
				String value = headerMap.get(key);
				req.setHeader(key, value);
			}
		}
		return req;				
	}

	public static HttpRequest getHttpRequest(String method, String endpoint, Blob body, Map<String, String> headerMap) {
		HttpRequest req = getHttpRequest(method,endpoint,headerMap);
		if (body != null) req.setBodyAsBlob(body);
		return req;				
	}

	public static HttpRequest getHttpRequest(String method, String endpoint, String body, Map<String, String> headerMap) {
		HttpRequest req = getHttpRequest(method,endpoint,headerMap);
		// System.debug('\nREQUEST BODY:\n' + body);
		if (body != null) req.setBody(body);
		return req;				
	}

	public static HttpRequest getHttpRequest(String method, String endpoint, Dom.Document body, Map<String, String> headerMap) {
			HttpRequest req = getHttpRequest(method,endpoint,headerMap);
		if (body != null)
			req.setBodyDocument(body);
		return req;				
	}

	public static Blob send(String method, String endpoint, Blob body, Map<String, String> headerMap) {
		HttpRequest req = getHttpRequest(method, endpoint, body, headerMap);
		
		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() == 302) {
			String location = res.getHeader('Location');
			if (String.isNotBlank(location))
				return send(method, location, body, headerMap);
		}
		Blob response = res.getBodyAsBlob();
		System.assertEquals(200, res.getStatusCode());
		return response;
	}
	
	
	public static Dom.Document send(String method, String endpoint, Dom.Document body, Map<String, String> headerMap) {
		HttpRequest req = getHttpRequest(method, endpoint, body, headerMap);
		
		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() == 302) {
			String location = res.getHeader('Location');
			if (String.isNotBlank(location))
				return send(method, location, body, headerMap);
		}
		Dom.Document response = res.getBodyDocument();
		//System.assertEquals(200, res.getStatusCode());
		return response;
	}

	public static String send(String method, String endpoint, String body, Map<String, String> headerMap) {
		HttpRequest req = getHttpRequest(method, endpoint, body, headerMap);
		if (body != null)
			req.setBody(body);
		
		Http http = new Http();
		HttpResponse res = http.send(req);
		if (res.getStatusCode() == 302) {
			String location = res.getHeader('Location');
			if (String.isNotBlank(location))
				return send(method, location, body, headerMap);
		}
		String response = res.getBody();
	  System.debug('\nRESPONSE BODY:\n' + response);
		System.debug('\nSTATUS CODE: ' + res.getStatusCode());
		if (res.getStatusCode() != 200){
			throw new HttpException(res.getStatusCode(),res.getBody());
		}
			
		return response;
	}

	
}