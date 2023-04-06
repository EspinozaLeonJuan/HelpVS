global class StandardHttpCalloutMock implements HttpCalloutMock {
	
	public String body {get; set;}
	
	global StandardHttpCalloutMock(String body) {
		this.body = body;
	} 

	global HTTPResponse respond(HTTPRequest req) {
		HttpResponse res = new HttpResponse();
		res.setBody(body);
		res.setStatusCode(200);
		return res;
	}
}