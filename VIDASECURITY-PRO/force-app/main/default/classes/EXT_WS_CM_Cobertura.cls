/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-21-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   01-27-2021   Juan Espinoza León   Initial Version
**/
public with sharing class EXT_WS_CM_Cobertura {
    public EXT_WS_CM_Cobertura() {

    }

   // public String requestLabel { get; set;}


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

    public static String getEndpoint(String idPoliza, String rut, String dv)
    {
        String WS_URL = '/ind/PolicyServicing/Policy/'+idPoliza+'/insured/'+rut+'/'+dv+'/V/coverage';
        return API_URL + WS_URL;
    }

    public static System.HttpRequest getDatosCobertura(String token, String idPoliza, String rut, String dv) {
        System.debug('--- EXT_WS_CM_Cobertura.getDatosCobertura BEGIN');
        String httpMethod = 'GET';

		String endpoint = getEndpoint(idPoliza, rut, dv);
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

    public static PAR_EXT_WS_CM_Cobertura mapConsultaCobertura(HttpResponse httpResponse){

        try {

            PAR_EXT_WS_CM_Cobertura response;

            if(!Test.isRunningTest())
            {
                system.debug('@@@@ httpResponse  -->'+httpResponse.getBody());
                try {
                    response = (PAR_EXT_WS_CM_Cobertura)JSON.deserialize(httpResponse.getBody(), PAR_EXT_WS_CM_Cobertura.class);

                } catch (Exception ex) {
                    system.debug('@@@@ exepcion cob --> '+ex);
                }
                system.debug('@@@@ responde -->'+response);
            }
            else
            {
                response = new PAR_EXT_WS_CM_Cobertura();
                response.primaPoliza = new PAR_EXT_WS_CM_Cobertura.cls_primaPoliza();
                response.primaPoliza.coverages = new List<PAR_EXT_WS_CM_Cobertura.cls_coverages>();
                response.primaPoliza.Rut = '19203876-6';
                response.primaPoliza.Rut = 'MD01972000B003';
                response.primaPoliza.Rut = 'N';

                PAR_EXT_WS_CM_Cobertura.cls_coverages cov = new PAR_EXT_WS_CM_Cobertura.cls_coverages();

                cov.codeCobert = 'PMCN';
                cov.nameCobert = 'PRESTACIONES MEDICAS CATASTROFICAS (NO TITULARES)';
                cov.capital = 100;
                cov.premium = 0;
                cov.extraPremium = 0;
                cov.extraPremiumType = '';
                cov.fecu= '0109';
                response.primaPoliza.coverages.add(cov);

                cov = new PAR_EXT_WS_CM_Cobertura.cls_coverages();

                cov.codeCobert = 'FLEX';
                cov.nameCobert = 'PRESTACIONES MEDICAS FLEX (NO TITULARES)';
                cov.capital = 15000;
                cov.premium = 0;
                cov.extraPremium = 0;
                cov.extraPremiumType = '';
                cov.fecu= '0109';
                response.primaPoliza.coverages.add(cov);
            }

            return response;
        }
        catch (Exception ex) {
            return null;
        }
    }

    /*private Continuation getContinuation(System.HttpRequest request){
        System.debug('--- EXT_WS_CM_Cobertura.getContinuation BEGIN');
        ContinuationContext ctx = new ContinuationContext();
        ctx.continuation = new Continuation(60);
        ctx.continuation.continuationMethod = 'DatosCobertura';
        ctx.requestLabel = ctx.continuation.addHttpRequest(request);
        system.debug('@@@@ ctx --> '+ ctx);
        this.requestLabel = ctx.requestLabel;
        return ctx.continuation;
    }*/

    public static PAR_EXT_WS_CM_Cobertura DatosCobertura(String token, String idPoliza, String rut, String dv)
    {
        System.HttpRequest request = getDatosCobertura(token, idPoliza,rut, dv);

        system.debug('@@@@ request --> '+ request);

        PAR_EXT_WS_CM_Cobertura retorno = null;

        Http http = new Http();
        HTTPResponse response = null;

        try
        {
            if(!Test.isRunningTest())
            {
               response = http.send(request);
               system.debug('@@@@ response --> '+ response);
            }

            retorno = mapConsultaCobertura(response);

        } catch (Exception ex) {
            System.debug('@@@@ Excepcion response '+ ex);
            System.debug('@@@@ Excepcion line '+ ex.getLineNumber());
        }

        return retorno;
    }
}