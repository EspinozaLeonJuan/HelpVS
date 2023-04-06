/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-20-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_CS_Servicio_Liquidaciones_RRVV {
     //TOKEN

     //PARAMETROS QA
    //  private static String UrlWSToken = 'https://qa-sso.security.cl:8543/auth/realms/VS-Clients/protocol/openid-connect/token';
    //  private static String clientId = 'vs-site-client';
    //  private static String grant_type = 'password';
    //  private static String userName = '14239507-K';
    //  private static String password = 'vida2021';
    //  private static String reqBody = 'client_id='+clientId +'&grant_type='+grant_type +'&username='+userName+'&password='+password;
     //PARAMETROS QA

     //PARAMETROS DESARROLLO
    //  private static String UrlWSToken = 'https://des-sso.security.cl:8543/auth/realms/VS-Clients/protocol/openid-connect/token';
    //  private static String clientId = 'vs-web-salud';
    //  private static String grant_type = 'password';
    //  private static String userName = '17793573-5';
    //  private static String password = 'vida2020';
    //  private static String reqBody = 'grant_type='+grant_type +'&username='+userName+'&password='+password+'&client_id='+clientId;
     //PARAMETROS DESARROLLO


      //PARAMETROS PRODUCCION
      private static String UrlWSToken = 'https://sso.security.cl/auth/realms/VS-Clients/protocol/openid-connect/token';
      private static String clientId = 'vs-valuetech';
      private static String grant_type = 'client_credentials';
      private static String client_secret = 'a32d14c0-93ca-4f59-84fc-9e0955a5a30d';
      private static String reqBody = 'client_id='+clientId +'&grant_type='+grant_type +'&client_secret='+client_secret;
      //PARAMETROS PRODUCCION

      //TOKEN

      /*

       //PARAMETROS PRODUCCION

    //PARAMETROS PRODUCCION
      */

     public static String getToken(){

         String token;
         HttpRequest req = new HttpRequest();
         req.setMethod('POST');
         req.setHeader('Content-Type','application/x-www-form-urlencoded');
         req.setEndpoint(UrlWSToken);
         req.setBody(reqBody);

         Http http = new Http();

         try{
             HTTPResponse res = http.send(req);
             System.debug('Body ' + res.getBody());
             CLS_SSO_ResponseToken_VS r = CLS_SSO_ResponseToken_VS.parse(res.getBody());
             System.debug('Status ' + res.getStatus());
             System.debug('Status code ' + res.getStatusCode());
             token = r.access_token;

         }catch(Exception e){
             System.debug(e.getMessage());
             return 'ERROR';
         }

         return token;
     }

     //TOKEN


     //SERVICIO B64 LIQUIDACIONES
     //PARAMETROS QA
    //  private static String UrlWSLIQ = 'https://vs-as-sp-clientes-back-qa.azurewebsites.net/BffSitioPrivado/Document/Settlement/14239507K/';
    //  private static String ibm_clientId = '19b35572-efe2-415b-883a-7a4bee24fa2b';
    //  private static String grant_type_liq = 'password';
     //PARAMETROS QA


     //PARAMETROS DESARROLLO
    //  private static String UrlWSLIQ = 'https://vs-as-sp-clientes-back-des.azurewebsites.net/BffSitioPrivado/Document/Settlement/177935735/';
    //  private static String ibm_clientId = 'a19875d1-402b-4f27-9c6a-b908491ce81c';
     //private static String grant_type_liq = 'password';
     //PARAMETROS DESARROLLO


     //PARAMETROS PRODUCCION
     private static String UrlWSLIQ = 'https://vs-as-sp-clientes-back-prod.azurewebsites.net/BffSitioPrivado/Document/Settlement/14239507K/';
     private static String ibm_clientId = '25d6ebee-5d2c-4712-9c6a-70847b66ae06';
     private static String grant_type_liq = 'password';
     //PARAMETROS PRODUCCION
     //Rut/52271363/Month/202207


     //SERVICIO B64 LIQUIDACIONES


     public static String getLiquidacionPeriodo(String token, String rut, String periodo)
     {
         String url = UrlWSLIQ+ 'Rut/'+rut+'/Month/'+periodo+'?Password='+rut.substring(0, rut.length() - 1);
         system.debug('@@@@ url --> '+url);
         try
         {
             //String token = getToken();

             Http http = new Http();
             HttpRequest request = new HttpRequest();

             //QA
             request.setEndpoint(url);
             request.setMethod('GET');
             request.setHeader('Authorization', 'Bearer ' + token);
             request.setHeader('X-IBM-Client-Id', ibm_clientId);
            // request.setHeader('Content-Type', 'application/json');
             //QA
             HttpResponse response = http.send(request);

             system.debug('@@@@ response.getStatusCode() --> '+response.getStatusCode());
             if(response.getStatusCode() == 200){

                CLS_CS_ResponseLiquidacion r = CLS_CS_ResponseLiquidacion.parse(response.getBody());

                 System.debug('@@@@ B64 ' + r.base64);

                 return r.base64;
             }
             else{
                 System.debug('Error '+ response.getStatus());
             }
         }
         catch(Exception ex ){
             System.debug( '@@@@ getLiquidacionPeriodo ' + ex);
         }

         return '';
     }
}