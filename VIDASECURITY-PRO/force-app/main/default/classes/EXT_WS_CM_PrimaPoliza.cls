/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   01-27-2021   Juan Espinoza León   Initial Version
**/
public with sharing class EXT_WS_CM_PrimaPoliza {
    public EXT_WS_CM_PrimaPoliza() {

    }

    //public String requestLabel { get; set;}
  
    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();

    public static Map<String, String> getHeaders(String token){
        Map<String, String> headerMap = new Map<String, String>();
      
        headerMap.put('Content-Type', 'application/json');
        headerMap.put('Accept', 'application/json');
        headerMap.put('x-ibm-client-id', servicio.ClientId_Api_VS_SaludProtegida__c);
        headerMap.put('Authorization', 'Bearer '+token);
      
        return headerMap;
    }  

     //Variables for Development Environment
    public static String API_URL = servicio.URL_Api_Vida_Security__c;
    
    public static String getEndpoint(String idPoliza)
    {
        String WS_URL = '/ind/PolicyServicing/Policy/'+IdPoliza+'/premium';

        return API_URL  + WS_URL;
    }

    public static System.HttpRequest getDatosPoliza(String token, String idPoliza) {
        System.debug('--- EXT_WS_CM_PrimaPoliza.getDatosPoliza BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(idPoliza);
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders(token);
        System.debug('headers: ' + headers);
        String body = null;

        System.HttpRequest httpRequest = new HttpRequest();

        if (!Test.isRunningTest())
        {
            httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
        }

        httpRequest.setTimeout(60000); // timeout in milliseconds
        return httpRequest;
    }

    public static PAR_EXT_WS_CM_PrimaPoliza mapConsultaPoliza(HttpResponse httpResponse){

        try {
        
            PAR_EXT_WS_CM_PrimaPoliza response;

            if(!Test.isRunningTest())
            {
                response = (PAR_EXT_WS_CM_PrimaPoliza)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_CM_PrimaPoliza.class);
                system.debug('@@@@ responde -->'+response);
            }
                        
            return response;
        } 
        catch (Exception ex) {
            return null;
        }
    }

    /*private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- EXT_WS_CM_Exclusiones.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(60);
        ctx.continuation.continuationMethod = 'DatosPoliza';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);
        system.debug('@@@@ ctx --> '+ ctx);
        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }*/

    public static PAR_EXT_WS_CM_PrimaPoliza DatosPoliza(String token,String idPoliza)
    {
        System.HttpRequest request = getDatosPoliza(token, idPoliza);

        system.debug('@@@@ request --> '+ request);

        PAR_EXT_WS_CM_PrimaPoliza retorno = null;

        Http http = new Http();
        HTTPResponse response = null;

        try 
        {
            if(!Test.isRunningTest())
            {
               response = http.send(request);
               system.debug('@@@@ response --> '+ response);
            }            
            
            retorno = mapConsultaPoliza(response);

        } catch (Exception ex) {
            System.debug('@@@@ Excepcion response '+ ex);
            System.debug('@@@@ Excepcion line '+ ex.getLineNumber());
        }
       
        return retorno;
    }
}