/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-21-2021   Juan Espinoza León   Initial Version
**/
public with sharing class EXT_WS_CC_RealizaLLamada {
    
    public String requestLabel { get; set;}
    public String response {get;set;}

    public EXT_WS_CC_RealizaLLamada() {
 
    }

    public static String WS_URL = '/com/CallCenter/Call';
    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();
    
    //Variables for Development Environment 
    // https://api-des.vidasecurity.cl:4000/vs-desarrollo
    public static String API_URL =  servicio.URL_Api_Vida_Security__c;
  
    public static String ENDPOINT = '';

	private static final String PREFERRED_CONTENT_TYPE = 'application/json';

	static {
        if (String.IsBlank(API_URL))
        {
            if (Test.isRunningTest())            
                ENDPOINT = 'https://api-des.vidasecurity.cl:4000/vs-desarrollo/com/CallCenter/Call';
            else
			    throw new IdcException('Debe establecer la URL en la sección Parámetros Vida.');
        }
        else {
            ENDPOINT = API_URL + WS_URL;
        }
    }

    public static OBJ_WS_CC_RealizaLlamada RealizaLlamada(PAR_EXT_WS_RealizaLlamada llamada){
        OBJ_WS_CC_RealizaLlamada salida = new OBJ_WS_CC_RealizaLlamada();

		HttpRequest request = new HttpRequest();
		request.setMethod('POST');
		request.setEndpoint(ENDPOINT);
        
        request.setHeader('Content-Type', PREFERRED_CONTENT_TYPE);
		request.setHeader('Accept', PREFERRED_CONTENT_TYPE);
		request.setHeader('x-ibm-client-id', servicio.ClientId_Api_VS_ContactCenter__c);
        request.setTimeout(120000);
        
        Map<String, Object> obj = new Map<String, Object>();
        obj.put('Id',  llamada.Id);
        obj.put('From', llamada.Desde);
        obj.put('To', llamada.Hasta);
        obj.put('Rut', llamada.Rut);
		obj.put('User', llamada.Usuario);
        String json = Json.serialize(obj);

        system.debug('@@@@ json --> '+ json);
		request.setBody(json);
        HttpResponse response;
        if (!Test.isRunningTest())
        {
            response = new Http().send(request);
            system.debug('@@@@ response --> '+ response);
        }
        else {
            response = new HttpResponse();
            response.setBody('');
            response.setStatus('202');
            response.setStatusCode(202);
        }

        system.debug('@@@@ response.getBody() --> '+ response.getBody());
        system.debug('@@@@ response.getStatus() --> '+ response.getStatus());
        system.debug('@@@@ response.getStatusCode() --> '+ response.getStatusCode());

        salida.StatusCode = response.getStatusCode();
        salida.Status = response.getStatus();
        salida.Body = response.getBody();

        return salida;
    }
    

    public static System.HttpRequest postCall(PAR_EXT_WS_RealizaLlamada llamada){
        Integer linCod = 1;

        System.HttpRequest request = EXT_API_CC_RealizarLlamada.postCall(llamada);

        return request;
    }

    /*
    //CONTINUATION METHODS
	public static Object RealizaLlamada_Async(PAR_EXT_WS_RealizaLlamada llamada){
		System.debug('CallCenter.Call - BEGIN');
		String httpMethod = 'POST';
        Map<String, String> headers = getHeaders();
        
        Map<String, Object> obj = new Map<String, Object>();
        obj.put('Id',  llamada.Id);
        obj.put('From', llamada.Desde);
        obj.put('To', llamada.Hasta);
        obj.put('Rut', llamada.Rut);

        String body = Json.serialize(obj);

        System.HttpRequest httpRequest = HttpUtils.getHttpRequest(httpMethod, ENDPOINT, body, headers);
       

		ContinuationContext ctx = new ContinuationContext();
		ctx.continuation = new Continuation(40);
	    ctx.continuation.continuationMethod = 'renderResponse';
		ctx.requestLabel = ctx.continuation.addHttpRequest(httpRequest);
        //requestLabel
         
        requestLabel = ctx.addHttpRequest(httpRequest);
        return ctx;
      
       // Continuation con = new Continuation(60);
       // // Set callback method
        //con.continuationMethod='renderResponse';
        //// Create callout request
        //HttpRequest req = new HttpRequest();
        //req.setMethod('GET');
        //req.setEndpoint(ENDPOINT);
        //returnedContinuationId = con.addHttpRequest(req);
        //return con;

    }


    public Object renderResponse() {
      // Get the response by using the unique label
      HttpResponse httpRes = Continuation.getResponse(requestLabel);
      // Set the result variable that is displayed on the Visualforce page
      response = httpRes.getBody();
      // Return null to re-render the original Visualforce page
      system.debug('@@@@ response --> ' + response);
      return null;
    }

    
    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();

        headerMap.put('Content-Type', PREFERRED_CONTENT_TYPE);
		headerMap.put('Accept', PREFERRED_CONTENT_TYPE);
		headerMap.put('x-ibm-client-id', X_IBM_CLIENT_ID);

        return headerMap;
    }  */

}