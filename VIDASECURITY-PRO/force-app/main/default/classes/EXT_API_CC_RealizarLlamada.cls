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
public with sharing class EXT_API_CC_RealizarLlamada {
    public EXT_API_CC_RealizarLlamada() {

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

    public static System.HttpRequest postCall(PAR_EXT_WS_RealizaLlamada llamada) {
        System.debug('--- EXT_API_CC_RealizarLlamada.postCall BEGIN');
        String httpMethod = 'POST';

        Map<String, Object> obj = new Map<String, Object>();
        obj.put('Id',  llamada.Id);
        obj.put('From', llamada.Desde);
        obj.put('To', llamada.Hasta);
        obj.put('Rut', llamada.Rut);
        obj.put('User', llamada.Usuario);

        System.debug('@@@@ obj --> '+ obj);
//obj.put('User', 'agente01');
        String body = Json.serialize(obj);
        Map<String, String> headers = getHeaders();

        System.debug('@@@@ httpMethod --> '+ httpMethod);
        System.debug('@@@@ ENDPOINT --> '+ ENDPOINT);
        System.debug('@@@@ body --> '+ body);
        System.debug('@@@@ headers --> '+ headers);
        
        System.HttpRequest httpRequest;
        if (!Test.isRunningTest())
        {
            httpRequest = HttpUtils.getHttpRequest(httpMethod, ENDPOINT, body, headers);
        }
        else {
            httpRequest = new System.HttpRequest();
        }

        System.debug('@@@@ httpRequest --> '+ httpRequest);
        return httpRequest;
    }

    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();

        headerMap.put('Content-Type', PREFERRED_CONTENT_TYPE);
		headerMap.put('Accept', PREFERRED_CONTENT_TYPE);
		headerMap.put('x-ibm-client-id', servicio.ClientId_Api_VS_ContactCenter__c);

        return headerMap;
    }  
 
}