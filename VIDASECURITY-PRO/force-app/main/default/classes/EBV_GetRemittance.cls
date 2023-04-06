/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 06-29-2022
 * @last modified by  : Juan Espinoza León
**/
public class EBV_GetRemittance {

    public class Input{
        @InvocableVariable(required = True)
        public String rut;
        @InvocableVariable(required=false)
        public String numPolice;
         @InvocableVariable(required=false)
        public String idMessaging;
        @InvocableVariable(required=false)
        public String tipoGasto;
    }
    public class remittanceOutput{
        @InvocableVariable(required = True)
        public String remitt;
        @InvocableVariable(required=false)
        public String numR;
    }

   	@InvocableMethod(label='Get Remittance')
    public static List<remittanceOutput> getReme(List<Input>values){

        List<remittanceOutput>Output = new List<remittanceOutput>();

        remittanceOutput remes = new remittanceOutput();

        Set<String> policiesNumber = new Set<String>();
        Set<String> rutNumbers = new Set<String>();
        String rutp;
        String idMess;
        String opcion;
        Integer numOp;

        for(Input rutInput :values){
            rutNumbers.add(rutInput.rut);
            System.debug('Aqui rut ' + rutInput.idMessaging);
            rutp = rutInput.rut;
            idMess= rutInput.idMessaging;
            opcion = rutInput.tipoGasto;
        }

        try
        {
            String cleanRUT = rutp
            .replace('.','')
            .replace('-','');

            String run = cleanRUT.substring(0, cleanRUT.length()-1);

            system.debug('opcion de gasto = ' + opcion);

            if (opcion == 'Ambulatorio (consulta, exámenes, medicamentos, ópticos)'){
                numOp = 1;
            }else{
                numOp = 2;
            }

            system.debug('numero de opcion= ' + numOp);

            Integer police = EBV_GetpoliceRespConst.getRemi(run);

            String token = EBV_GetAccessToken.getToken();
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
            // req.setHeader('Content-Type', 'application/json');
            req.setHeader('accept', 'application/json');
            req.setHeader('Content-Type', 'application/json; charset=utf-8');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('X-IBM-Client-Id', '9e9bc552-9db3-4861-86f1-400528d44e2b');

            req.setEndpoint('https://api.vidasecurity.cl/vs/col/Claims/consignment/insuranceCo/99301000/policy/'+String.valueof(police)+'?InsuredRut='+run+'&BeneficiaryRut='+run);
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

                //assigning variable to field in salesforce
                //
                MessagingSession remeSess = [Select id, Vass_Remesa__c from MessagingSession where id =: idMess ];
                remeSess.Vass_Remesa__c = numRemes != null ? String.valueOf(numRemes) : null;
                update remeSess;

                //Cleaning '()' from the answer
                //
                String cleanNumReq = String.valueof(numReq)
                    .replace('(','')
                    .replace(')','');

                //loading list with data
                //
                remes.remitt = numRemes;
                remes.numR = cleanNumReq;
            	Output.add(remes);

        	}else{
            	System.debug('Error'+ res.getStatus());
        	}

        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return Output;
    }
}