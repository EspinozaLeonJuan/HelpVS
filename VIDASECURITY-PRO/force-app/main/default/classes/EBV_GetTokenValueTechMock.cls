@isTest
public class EBV_GetTokenValueTechMock implements HttpCalloutMock{
    public HTTPResponse respond(HttpRequest req){
        HTTPResponse res = new HTTPResponse();

        res.setHeader('Content-Type', 'application/json');
        String body ='{'+'"\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFkbWluIiwibmJmIjoxNjQ5OTAyOTM2LCJleHAiOjE2NDk5MDQ3MzYsImlhdCI6MTY0OTkwMjkzNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo0OTIyMCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDkyMjAifQ.n_KyOv3_iSvji9CSoNk8xJ66V8M_TZ3mOD8arpoKw-E\""'+
     '}';
        res.setBody(body);
        res.setStatusCode(200);
        return res;


    } 

}