public with sharing class IDCApi {

    //Variables for Development Environment
    // https://api-des.vidasecurity.cl:4000/vs-desarrollo
    public static Servicio_Externo__c service =  Servicio_Externo__c.getOrgDefaults();
    public static String BASEPATH = service == null || service.URL_Servicios_Vida_Security__c == null ? null : (service.URL_Servicios_Vida_Security__c + '/rv');
    
	static {
		if (BASEPATH == null) {
			if (Test.isRunningTest())
				BASEPATH = 'https://api-des.vidasecurity.cl:4000/vs-desarrollo/rv/Polizas';
            else
			    throw new IdcException('Debe establecer la URL de los servicios en la configuración personalizada de Servicios Externos.');
		}
	}
    public static System.HttpRequest getOfertaCreditoRequest(Integer linCod, String numPol, Integer rut) {
        System.debug('--- IDCApi.getOfertaCreditoRequest BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(String.format('/Clientes/Credito/{0}', new String[]{String.valueOf(rut)}));
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders();
        String body = null;

        System.HttpRequest httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);

        return httpRequest;
    }

    // public static IDCResponse getOfertaCredito(Integer linCod, String numPol, Integer rut) {
	// 	String httpMethod = 'GET';
	// 	String endpoint = getEndpoint(String.format('/Campaign/credito/{0}/{1}/{2}', new String[]{String.valueOf(linCod), numPol, String.valueOf(rut)}));
	// 	System.debug('endpoint: ' + endpoint);
    //     Map<String, String> headers = getHeaders();
    //     String body = null;
	// 	String response = null;
	// 	try { 
	// 	    response = HttpUtils.send(httpMethod, endpoint, body, headers);
	// 	} catch (Exception e) {
    //         System.debug(e);
	// 		throw new IdcException('Ocurrió un error al invocar el servicio IDC: ' + e.getTypeName() + ': ' + e.getMessage() + ', endpoint: ' + endpoint + '\nBody\n' + body);
	// 	}
    //     IDCResponse resp = (IDCResponse)JSON.deserialize(response, IDCResponse.class);

    //     return resp;        
    // }

    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();
		headerMap.put('Content-Type', 'application/json');
		headerMap.put('Accept', 'application/json');
		headerMap.put('x-ibm-client-id', '9e9bc552-9db3-4861-86f1-400528d44e2b');

        return headerMap;
    }  

    public static String getEndpoint(String serviceMethod){
        return BASEPATH + serviceMethod;
    }
}