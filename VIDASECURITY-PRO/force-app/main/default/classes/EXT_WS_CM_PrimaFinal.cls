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
public with sharing class EXT_WS_CM_PrimaFinal {
    public EXT_WS_CM_PrimaFinal() {

    }


    public String requestLabel { get; set;}
  

    public static Map<String, String> getHeaders(String token){
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');

        headerMap.put('Accept', 'application/json');
        headerMap.put('x-ibm-client-id', servicio.ClientId_Api_VS_SaludProtegida__c);
        headerMap.put('Authorization', 'Bearer '+token);

        return headerMap;
    }  

    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();
    
     //Variables for Development Environment
    public static String API_URL = servicio.URL_Api_Vida_Security__c; 

    public static String getEndpoint(String idPoliza, String rut, String dv, String idCobertura)
    {
        String WS_URL = '/ind/Simulator/exclusion/premium';

        return API_URL + WS_URL + '?IdPoliza='+idPoliza+'&Rut='+rut+'&Dv='+dv+'&TipoId=V&IdProducto=&IdCobertura='+idCobertura;
    }

    public static System.HttpRequest getDatosPoliza(String token, String idPoliza, String rut, String dv, String idCobertura) {
        System.debug('--- EXT_WS_CM_PrimaFinal.getDatosPoliza BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(idPoliza, rut, dv, idCobertura);
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders(token);
        String body = null;
        System.debug('headers: ' + headers);
        
        System.HttpRequest httpRequest = new System.HttpRequest();
        
        if (!Test.isRunningTest())
        {
            httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
        }

        httpRequest.setTimeout(60000); // timeout in milliseconds
        return httpRequest;
    }

    public static PAR_EXT_WS_CM_PrimaFinal mapConsultaPoliza(HttpResponse httpResponse){

        try {
        
            PAR_EXT_WS_CM_PrimaFinal response;

            if(!Test.isRunningTest())
            {
                response = (PAR_EXT_WS_CM_PrimaFinal)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_CM_PrimaFinal.class);
                system.debug('@@@@ responde -->'+response);
            }
                     
            return response;
        } 
        catch (Exception ex) {
            return null;
        }
    }

 /*   private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- EXT_WS_CM_PrimaFinal.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(60);
        ctx.continuation.continuationMethod = 'DatosExclusion';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);
        system.debug('@@@@ ctx --> '+ ctx);
        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }*/

    public static PAR_EXT_WS_CM_PrimaFinal DatosPoliza(String token, String idPoliza, String rut, String dv, String idCobertura)
    {
        System.HttpRequest request = getDatosPoliza(token, idPoliza,rut, dv, idCobertura);
        PAR_EXT_WS_CM_PrimaFinal retorno = null;

        system.debug('@@@@ request --> '+ request);

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