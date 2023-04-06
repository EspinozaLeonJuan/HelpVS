/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_COL_Gestion_Reembolso_Whastapp {

    //TOKEN
    //PARAMETROS PRODUCCION
    private static String UrlWS = 'https://sso.security.cl/auth/realms/VS-Clients/protocol/openid-connect/token';
    private static String clientId = 'vs-valuetech';
    private static String grant_type = 'client_credentials';
    private static String client_secret = 'a32d14c0-93ca-4f59-84fc-9e0955a5a30d';
    private static String reqBody = 'client_id='+clientId +'&grant_type='+grant_type +'&client_secret='+client_secret;
    //PARAMETROS PRODUCCION

    //PARAMETROS QA
    // private static String UrlWS = 'https://qa-sso.security.cl:8543/auth/realms/VS-Clients/protocol/openid-connect/token';
    // private static String clientId = 'vs-venta-web';
    // private static String grant_type = 'password';
    // private static String userName = '17119809-7';
    // private static String password = 'vida2021';
    // private static String reqBody = 'client_id='+clientId +'&grant_type='+grant_type +'&username='+userName+'&password='+password;
    //PARAMETROS QA

    //TOKEN

    public static String getToken(){

        String token;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setEndpoint(UrlWS);
		req.setBody(reqBody);

		Http http = new Http();

        try{
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            CLS_COL_Response_Token_VS r = CLS_COL_Response_Token_VS.parse(res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());
            token = r.access_token;

        }catch(Exception e){
            System.debug(e.getMessage());
            return 'ERROR';
        }

        return token;
    }

    private static List<Integer> getPolizas_BHP()
    {
        List<Integer> listpolice = new List<Integer>();
        listpolice.add(282042);
        listpolice.add(282043);
        listpolice.add(282044);
        listpolice.add(282045);
        listpolice.add(282053);
        listpolice.add(282054);
        listpolice.add(282758);
        listpolice.add(282761);
        listpolice.add(282908);
        listpolice.add(282963);
        listpolice.add(282965);
        listpolice.add(283198);
        listpolice.add(283199);
        listpolice.add(283200);
        listpolice.add(281610);
        listpolice.add(281827);
        listpolice.add(282349);
        listpolice.add(282350);
        listpolice.add(283197);
        listpolice.add(283058);
        listpolice.add(281593);
        //Test police
        listpolice.add(281947);
        listpolice.add(282658);
        listpolice.add(283189);

        return listpolice;
    }

    public static Integer getPoliza(String rut){

        List<Integer> polizas_BHP = getPolizas_BHP();

        Integer police = 0;

        try{

            String cleanRUT = rut
            .replace('.','')
            .replace('-','');

            String run = cleanRUT.substring(0, cleanRUT.length()-1);

            String token = getToken();

        	Http http = new Http();
       		HttpRequest request = new HttpRequest();

            //PRODUCCION
            request.setEndpoint('https://api.vidasecurity.cl/vs/col/PolicyServicing/Policy/insuranceCo/99301000/byInsured?InsuredRut='+run+'&Page=1&Offset=10');
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + token);
            request.setHeader('X-IBM-Client-Id', '9e9bc552-9db3-4861-86f1-400528d44e2b');
            request.setHeader('LR_USUARIO', '12721330-5');
            request.setHeader('Sistema', 'Clientes');
            request.setHeader('LR_CODINTER', '00000000');
            request.setHeader('Content-Type', 'application/json');
            //PRODUCCION

            //QA
            // request.setEndpoint('https://api-qa.vidasecurity.cl:7000/vs-qa/col/PolicyServicing/Policy/insuranceCo/99301000/byInsured?InsuredRut='+run+'&Page=1&Offset=10');//QA VALUES
            // request.setMethod('GET');//QA VALUES
            // request.setHeader('Authorization', 'Bearer ' + token);//QA VALUES
            // request.setHeader('X-IBM-Client-Id', '4cfa2b2a-20a8-4c20-acb9-03b060ce4481');//QA VALUES
            //QA

        	HttpResponse response = http.send(request);

        	if(response.getStatusCode() == 200){
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody() );
                List<Object> objectNames = (List<Object>)result.get('policies');
				List<String> fieldNames = new List<String>();

                boolean existe = false;

                Map<String, Object> numpol = null;

                for (Object obj : objectNames)
                {
                    numpol = (Map<String, Object>)obj;
                    police = (Integer)numpol.get('policyNumber');
                    System.debug('NUMERO DE POLIZA: ' + police);
                    existe = polizas_BHP.contains(police);
                    if (existe)
                    {
                        break;
                    }
                }

                if (existe) {
                    System.debug('La poliza SÍ existe en la lista ' + police);
                } else {
                    System.debug('La poliza no existe');
                }
        	}
            else{
            	System.debug('Error'+ response.getStatus());
        	}
        }
        catch(Exception ex ){
            System.debug( '@@@@ CLS_COL_Gestion_Reembolso_Whastapp ' + ex);
            police = 0;
        }

        return police;
    }


    public class DatosReembolso
    {
        public String Remesa { get; set;}

        public String Denuncio { get; set;}
    }

    public static DatosReembolso getDatosRemesa(String idMessage)
    {
        DatosReembolso retorno = null;

        MessagingSession ms = [SELECT Id, Tipo_de_Gasto_Reembolso__c, Valor_Tipo_de_Gasto_Reembolso__c, RUT_Titular_Reembolso__c, Poliza_Titular_Reembolso__c, RUT_Dependiente_Reembolso__c, Nombre_Titular_Reembolso__c, Nombre_Dependiente_Reembolso__c, Etapa_Reembolso__c, Apellido_Dependiente_Reembolso__c, Apellido_Titular_Reembolso__c, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c
                FROM MessagingSession WHERE Id =: idMessage];

        String police = ms.Poliza_Titular_Reembolso__c;
        String rutTitular = ms.RUT_Titular_Reembolso__c.split('-')[0];
        Integer numOp = Integer.valueOf(ms.Valor_Tipo_de_Gasto_Reembolso__c);

        try
        {
            String token = getToken();
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('claimDate', Datetime.now().format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\''));
            gen.writeNumberField('clasification', numOp);
            gen.writeStringField('origin', 'WHATSAPP');
            gen.writeEndObject();
            String jsonData = gen.getAsString();
            System.debug('jsonData---> ' + jsonData);

            HttpRequest req = new HttpRequest();

            req.setMethod('POST');

            //QA
            // req.setHeader('accept', 'application/json');
            // req.setHeader('Content-Type', 'application/json; charset=utf-8');
            // req.setHeader('Authorization', 'Bearer ' + token);
            // req.setHeader('X-IBM-Client-Id', '4cfa2b2a-20a8-4c20-acb9-03b060ce4481');
            // req.setEndpoint('https://api-qa.vidasecurity.cl:7000/vs-qa/col/Claims/consignment/insuranceCo/99301000/policy/'+ police +'?InsuredRut='+ rutTitular +'&BeneficiaryRut='+ rutTitular);
            //QA

            //PRODUCCION
            req.setHeader('accept', 'application/json');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('X-IBM-Client-Id', '9e9bc552-9db3-4861-86f1-400528d44e2b');
            req.setEndpoint('https://api.vidasecurity.cl/vs/col/Claims/consignment/insuranceCo/99301000/policy/'+String.valueof(police)+'?InsuredRut='+rutTitular+'&BeneficiaryRut='+rutTitular);
            //PRODUCCION

            req.setBody(jsonData);

            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('Body ' + res.getBody());
            System.debug('Status ' + res.getStatus());
			System.debug('Status code ' + res.getStatusCode());

            if(res.getStatusCode() == 200){
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                Map<String, Object> remeDeta = (Map<String, Object>) result.get('consignment');

                Object numReq = (Object) remeDeta.get('folio');

                String numRemes = (String) remeDeta.get('id');

                system.debug('NUMERO DE REMESA = ' + numRemes);
                system.debug('NUMERO DE SOLICITUD = ' + numReq);

                String cleanNumReq = String.valueof(numReq)
                    .replace('(','')
                    .replace(')','');

                retorno = new DatosReembolso();
                retorno.Remesa =  numRemes;
                retorno.Denuncio = cleanNumReq;

        	}else{
            	System.debug('Error'+ res.getStatus());
        	}

        }
        catch(Exception e)
        {
            system.debug('@@@@ EX --> '+e.getMessage());
        }

        return retorno;
    }




 }