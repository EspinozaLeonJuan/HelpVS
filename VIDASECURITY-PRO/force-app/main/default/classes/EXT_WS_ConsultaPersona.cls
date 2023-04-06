/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-29-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-03-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class EXT_WS_ConsultaPersona {

    public String requestLabel { get; set;}
  

    public static Map<String, String> getHeaders(){
        Map<String, String> headerMap = new Map<String, String>();
		headerMap.put('Content-Type', 'application/json');
		headerMap.put('Accept', 'application/json');
        headerMap.put('x-ibm-client-id', servicio.ClientId_Api_VS_ConsultaPersona__c);

        return headerMap;
    }    

    public static String WS_URL = '/com/Personas/Directorio/';

    public static Servicios_Vida_Security__c servicio =  Servicios_Vida_Security__c.getOrgDefaults();
    //Variables for Development Environment 
    // https://api-des.vidasecurity.cl:4000/vs-desarrollo
    public static String API_URL =  servicio.URL_Api_Vida_Security__c;
  
    public static String BASEPATH = '';

	static {
        if (String.IsBlank(API_URL))
        {
            if (Test.isRunningTest())            
            {
                BASEPATH = 'https://api-des.vidasecurity.cl:4000/vs-desarrollo/com/Personas/Directorio/';
            }
        }
        else {
            BASEPATH = API_URL + WS_URL;
        }
    }
    
    public static String getEndpoint(String rut){
        return BASEPATH + rut;
    }

    public static System.HttpRequest getDatosPersona(String rut) {
        System.debug('--- EXT_WS_ConsultaPersona.getDatosPersona BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(rut);
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders();
        String body = null;

        System.HttpRequest httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
  
        return httpRequest;
    }

    public static OBJ_WS_ConsultaPersona mapConsultaPersona(HttpResponse httpResponse){

        try {
        
            PAR_EXT_WS_ConsultaPersona response;

            if(!Test.isRunningTest())
            {
                response = (PAR_EXT_WS_ConsultaPersona)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_ConsultaPersona.class);
                system.debug('@@@@ responde -->'+response);
            }
            else
            {
                response = new PAR_EXT_WS_ConsultaPersona();
                response.Persona = new PAR_EXT_WS_ConsultaPersona.Persona();
                response.Persona.Nombre = new PAR_EXT_WS_ConsultaPersona.Nombre();
                response.Persona.Nombre.ApellidoPaterno = 'Espinoza';
                response.Persona.Nombre.ApellidoMaterno = 'Leon';
                response.Persona.Nombre.Nombres = 'Juan';      
                response.Persona.FechaNacimiento = new PAR_EXT_WS_ConsultaPersona.FechaNacimiento();
                response.Persona.FechaNacimiento.FechaNacimiento = '1982-04-11';
            }
            
            OBJ_WS_ConsultaPersona persona = new OBJ_WS_ConsultaPersona();
            persona.Nombres = response.Persona.Nombre.Nombres; 
            persona.Apellido_Paterno = response.Persona.Nombre.ApellidoPaterno; 
            persona.Apellido_Materno = response.Persona.Nombre.ApellidoMaterno; 
            persona.Fecha_Nacimiento = response.Persona.FechaNacimiento.FechaNacimiento;

            return persona;
        } 
        catch (Exception ex) {
            return null;
        }
        
    }

    private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- EXT_WS_ConsultaPersona.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(60);
        ctx.continuation.continuationMethod = 'DatosPersona';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);
        system.debug('@@@@ ctx --> '+ ctx);
        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }

    public static OBJ_WS_ConsultaPersona DatosPersona(String rut)
    {
        System.HttpRequest request = getDatosPersona(rut);

        system.debug('@@@@ request --> '+ request);

        Http http = new Http();
        HTTPResponse response = null;
        
        if(!Test.isRunningTest())
        {
           response = http.send(request);
           system.debug('@@@@ response --> '+ response);
        }
        
        OBJ_WS_ConsultaPersona persona = null;

        persona = mapConsultaPersona(response);
       
        return persona;
    }

}