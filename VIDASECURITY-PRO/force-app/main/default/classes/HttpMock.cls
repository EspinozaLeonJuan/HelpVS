@isTest
public class HttpMock implements HttpCalloutMock {
  protected Integer code;
  protected String status;
  protected String bodyAsString;
  protected Blob bodyAsBlob;
  protected Map<String, String> responseHeaders;
  private HTTPRequest request;

  public HttpMock(Integer code, String status, String bodyAsString, Blob bodyAsBlob,
   Map<String, String> responseHeaders) {
    this.code = code;
    this.status = status;
    this.bodyAsString = bodyAsString;
    this.bodyAsBlob = bodyAsBlob;
    this.responseHeaders = responseHeaders;
    //comments
    
  }

  public HttpMock(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
		this(code, status, null, body, responseHeaders);
  }

  public HttpMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
		this(code, status, body, null, responseHeaders);
  }

  public HttpMock(Integer code, String status, String body) {
		this(code, status, body, null, null);
  }


  public HttpMock(String body) {
		this(200, 'OK', body, null, null);
  }

  public HTTPResponse respond(HTTPRequest req) {
    this.request = req;
    HttpResponse resp = new HttpResponse();
    resp.setStatusCode(code);
    resp.setStatus(status);
    if (bodyAsBlob != null) {
      resp.setBodyAsBlob(bodyAsBlob);
      } else {
        resp.setBody(bodyAsString);
      }

      if (responseHeaders != null) {
       for (String key : responseHeaders.keySet()) {
        resp.setHeader(key, responseHeaders.get(key));
      }
    }
    return resp;
  }

  public HttpRequest getRequest() {
    return this.request;
  }
}