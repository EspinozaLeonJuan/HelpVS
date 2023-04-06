/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   02-08-2021   Juan Espinoza León   Initial Version
**/
public with sharing class EXT_WS_CM_CallSSO {
    public EXT_WS_CM_CallSSO() {

    }

  //  public String requestLabel { get; set;}

    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/x-www-form-urlencoded');
        headerMap.put('Content-Length', '0');
       
        return headerMap;
    }  

    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();
    
     //Variables for Development Environment
    public static String API_URL = servicio.URL_SSO_Api_Vida_Security__c;// 

    public static String getEndpoint()
    {
        return API_URL;
    }

    public static System.HttpRequest getDatosAuth() {
        System.debug('--- EXT_WS_CM_CallSSO.getDatosPoliza BEGIN');
        String httpMethod = 'POST';

		String endpoint = getEndpoint();
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders();
        System.debug('headers: ' + headers);


        System.HttpRequest httpRequest = new System.HttpRequest();
        
        if (!Test.isRunningTest())
        {
            httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, '', headers);
        }
        
        httpRequest.setBody('grant_type=client_credentials&client_id=api&client_secret='+servicio.Client_Secret_SSO_Api_Vida_Security__c);

        System.debug('httpRequest: ' + httpRequest.getBody());
        httpRequest.setTimeout(60000); // timeout in milliseconds
        return httpRequest;
    }

    public static PAR_EXT_WS_CM_CallSSO mapConsultaAuth(HttpResponse httpResponse){

        try {
        
            PAR_EXT_WS_CM_CallSSO response;

            if(!Test.isRunningTest())
            {
                system.debug('@@@@ httpResponse -->'+ httpResponse.getBody());
                response = (PAR_EXT_WS_CM_CallSSO)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_CM_CallSSO.class);
                system.debug('@@@@ responde -->'+response);
            }
            else
            {
                response = new PAR_EXT_WS_CM_CallSSO();
            }
            
            return response;
        } 
        catch (Exception ex) {
            return null;
        }
    }

    /*private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- EXT_WS_CM_CallSSO.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(60);
        ctx.continuation.continuationMethod = 'DatosAuth';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);
        system.debug('@@@@ ctx --> '+ ctx);
        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }*/

    public static PAR_EXT_WS_CM_CallSSO DatosAuth()
    {
        System.HttpRequest request = getDatosAuth();

        system.debug('@@@@ request --> '+ request);

        PAR_EXT_WS_CM_CallSSO retorno = null;

        Http http = new Http();
        HTTPResponse response = null;

        try 
        {
            if(!Test.isRunningTest())
            {
               response = http.send(request);
               system.debug('@@@@ response --> '+ response);
            }            
            
            retorno = mapConsultaAuth(response);
            system.debug('@@@@ TOKEN '+ retorno.access_token);
            system.debug('@@@@ TOKEN.size '+ retorno.access_token.length());       

        } catch (Exception ex) {
            System.debug('@@@@ Excepcion response '+ ex);
            System.debug('@@@@ Excepcion line '+ ex.getLineNumber());
        }

      
        return retorno;
    }
}