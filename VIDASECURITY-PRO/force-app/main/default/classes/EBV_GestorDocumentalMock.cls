@isTest
public class EBV_GestorDocumentalMock implements HttpCalloutMock{
    
    public HTTPResponse respond(HttpRequest req){
        HTTPResponse res = new HTTPResponse();

        res.setHeader('Content-Type', 'application/json');
        String body ='{'+
		'    \"Exito\": true,'+
		'    \"Mensaje\": null,'+
		'    \"IdSolicitud\": 124'+
		'}';
        res.setBody(body);
        res.setStatusCode(200);
        return res;


    } 

}