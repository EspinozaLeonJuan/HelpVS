/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-04-2022
 * @last modified by  : Juan Espinoza León
**/
public class EBV_GetPolizas {

    public class rutInput {
    	@InvocableVariable(required=true)
    	public String rut;
    }
    public class polizasOutput {
        @InvocableVariable(required=false)
        public Integer poliza;
    }
    @InvocableMethod(label='Get Polizas servicio')
    public static List<polizasOutput> getPoliza(List<rutInput> ruts){
        List<polizasOutput> polizaOutPut = new List<polizasOutput>();

        polizasOutput policee = new polizasOutput();

        Set<String> rutNumbers = new Set<String>();
        String rutp;

        for(rutInput OrderInput :ruts){
            rutNumbers.add(OrderInput.rut);
            rutp = OrderInput.rut;
        }

        System.debug('test1'+rutp);

		//Cleaning '-' and '.'
        String cleanRUT = rutp
            .replace('.','')
            .replace('-','');

		String run = cleanRUT.substring(0, cleanRUT.length()-1);

        System.debug('run'+run);
        try{
            String token = EBV_GetAccessToken.getToken();
        	Http http = new Http();
       		HttpRequest request = new HttpRequest();
        /*	request.setEndpoint('https://api-qa.vidasecurity.cl:7000/vs-qa/col/PolicyServicing/Policy/insuranceCo/99301000/byInsured?InsuredRut='+run+'&Page=1&Offset=10');//QA VALUES
            request.setMethod('GET');//QA VALUES
            request.setHeader('Authorization', 'Bearer ' + token);//QA VALUES
            request.setHeader('X-IBM-Client-Id', '4cfa2b2a-20a8-4c20-acb9-03b060ce4481');//QA VALUES
*/
            request.setEndpoint('https://api.vidasecurity.cl/vs/col/PolicyServicing/Policy/insuranceCo/99301000/byInsured?InsuredRut='+run+'&Page=1&Offset=10');
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + token);
            request.setHeader('X-IBM-Client-Id', '9e9bc552-9db3-4861-86f1-400528d44e2b');
            request.setHeader('LR_USUARIO', '12721330-5');
            request.setHeader('Sistema', 'Clientes');
            request.setHeader('LR_CODINTER', '00000000');
            request.setHeader('Content-Type', 'application/json');

        	HttpResponse response = http.send(request);

            //List of policies registered in BHP
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


            System.debug('Response CODE: ' + response.getStatusCode() );

        	if(response.getStatusCode() == 200){
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody() );
                List<Object> objectNames = (List<Object>)result.get('policies');

                boolean existe = false;

                Map<String, Object> numpol = null;
                Integer pol = 0;

                for (Object obj : objectNames)
                {
                    numpol = (Map<String, Object>)obj;
                    pol = (Integer)numpol.get('policyNumber');
                    System.debug('NUMERO DE POLIZA: ' + pol);
                    existe = listpolice.contains(pol);
                    if (existe)
                    {
                        break;
                    }
                }

                //Validando que la poliza exista en la lista de polizas de BHP
                if (existe) {
                    System.debug('La poliza SÍ existe en la lista ' + pol);
                    policee.poliza = pol;
            	    polizaOutPut.add(policee);
                }
                else
                {
                    System.debug('La poliza no existe');
                    policee.poliza = 0;
                    polizaOutPut.add(policee);
                }
        	}
            else
            {
            	System.debug('Error'+ response.getStatus());
        	}
        }
        catch(Exception ex ){
            System.debug( 'EBV_GetPolizas ' + ex);
        }
        return polizaOutPut;
    }
}