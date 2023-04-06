public abstract class BaseAPI {
    
    //Variables for Development Environment
    // https://api-des.vidasecurity.cl:4000/vs-desarrollo
    public static Servicio_Externo__c service =  Servicio_Externo__c.getOrgDefaults();
    public static String BASEPATH = service == null || service.URL_Servicios_Vida_Security__c == null ? null : (service.URL_Servicios_Vida_Security__c + '/col/Polizas');
    
    static {
        if (BASEPATH == null) {
            if (Test.isRunningTest())
                BASEPATH = 'https://api-des.vidasecurity.cl:4000/vs-desarrollo/col/Polizas';
            else
                throw new CobranzaException('Debe establecer la URL de los servicios en la configuración personalizada de Servicios Externos.');
        }
    }
    
    public static String CLIENTID = '9e9bc552-9db3-4861-86f1-400528d44e2b';


    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();
        headerMap.put('Content-Type', 'application/json');
        headerMap.put('Accept', 'application/json');
        headerMap.put('x-ibm-client-id', CLIENTID);

        return headerMap;
    }  

    public static String getEndpoint(String serviceMethod){
        return BASEPATH + serviceMethod;
    }
}