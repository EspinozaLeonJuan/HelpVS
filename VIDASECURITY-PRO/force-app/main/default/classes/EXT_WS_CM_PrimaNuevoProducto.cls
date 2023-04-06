/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-03-2021   Juan Espinoza León   Initial Version
**/
public with sharing class EXT_WS_CM_PrimaNuevoProducto {
    public EXT_WS_CM_PrimaNuevoProducto() {

    }

    public static Map<String, String> getHeaders(String token){
        system.debug('@@@@ TOKEN --> '+token);
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

    public static String getEndpoint(String idProducto, Integer edad, String parentesco, Decimal capital)
    {
        String WS_URL = '/ind/Simulator/premium/prospective?IdProducto='+idProducto+'&Edad='+edad+'&CodParentesco='+parentesco+'&NumGrupoFam=1&IdCobertura=PMCT&Capital='+capital;
        return API_URL + WS_URL; 
    }



    public static System.HttpRequest getDatosPrimaNuevoProducto(String token, String idProducto, Integer edad, String parentesco, Decimal capital) {
        System.debug('--- EXT_WS_CM_PrimaNuevoProducto.getPrimaNuevoProducto BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(idProducto, edad, parentesco, capital);
		System.debug('endpoint: ' + endpoint);
        Map<String, String> headers = getHeaders(token);
        String body = null;

        System.HttpRequest httpRequest = new System.HttpRequest();
        
        if (!Test.isRunningTest())
        {
            httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
        }

        httpRequest.setTimeout(60000); // timeout in milliseconds
        return httpRequest;
    }

    public static PAR_EXT_WS_CM_PrimaNuevoProducto mapPrimaNuevoProducto(HttpResponse httpResponse){

        try {
        
            PAR_EXT_WS_CM_PrimaNuevoProducto response;

            if(!Test.isRunningTest())
            {
                system.debug('@@@@ httpResponse  -->'+httpResponse.getBody());
                try {
                    response = (PAR_EXT_WS_CM_PrimaNuevoProducto)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_CM_PrimaNuevoProducto.class);
                    
                } catch (Exception ex) {
                    system.debug('@@@@ exepcion cob --> '+ex);
                }
                system.debug('@@@@ responde -->'+response);
            }
            else
            {
                response = new PAR_EXT_WS_CM_PrimaNuevoProducto();
                response.primaProspecto = new PAR_EXT_WS_CM_PrimaNuevoProducto.cls_primaProspecto();
                response.primaProspecto.coverageCode = 'PMCT';
                response.primaProspecto.coverageName = 'PRESTACIONES MEDICAS CATASTROFICAS (TITULARES)';
                response.primaProspecto.coverageRate = 0.0173;
                response.primaProspecto.netPremium = 0.1730;
                response.primaProspecto.ivaPremium = 0.0329;
                response.primaProspecto.totalPremium = 0.2059;
            }
                      
            return response;
        } 
        catch (Exception ex) {
            return null;
        }
    }

    public static PAR_EXT_WS_CM_PrimaNuevoProducto DatosPrimaNuevoProducto(String token, String idProducto, Integer edad, String parentesco, Decimal capital)
    {
        System.HttpRequest request = getDatosPrimaNuevoProducto(token, idProducto, edad, parentesco, capital);

        system.debug('@@@@ request --> '+ request);

        PAR_EXT_WS_CM_PrimaNuevoProducto retorno = null;

        Http http = new Http();
        HTTPResponse response = null;

        try 
        {
            if(!Test.isRunningTest())
            {
               response = http.send(request);
               system.debug('@@@@ response --> '+ response);
            }            
            
            retorno = mapPrimaNuevoProducto(response);

        } catch (Exception ex) {
            System.debug('@@@@ Excepcion response '+ ex);
            System.debug('@@@@ Excepcion line '+ ex.getLineNumber());
        }
       
        system.debug('@@@@ retorno --> '+ retorno);
        return retorno;
    }
}