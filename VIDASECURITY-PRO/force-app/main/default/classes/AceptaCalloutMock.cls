@isTest
global class AceptaCalloutMock implements HttpCalloutMock{
  global HttpResponse respond(HTTPRequest req){
    HttpResponse res = new HttpResponse();
    res.setStatus('OK');
    res.setStatusCode(200);
    res.setBody('{"status": 200,"message": "Success","session_id": "6vszf5ci740d4d223c314d2bb3ca5b202cba19c2","result": {"code": "CA80000002D22FCPR2", "file_preview": "https://google.com"}}');
    return res;
  }
}