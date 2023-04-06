public with sharing class EBV_GetpoliceRespConst {
     public static Integer getRemi(String rut){
        Integer police;
        String rutInp = rut; 
         try{
            
            String token = EBV_GetAccessToken.getToken();
       
        	Http http = new Http();
       		HttpRequest request = new HttpRequest();
            
        	request.setEndpoint('https://api.vidasecurity.cl/vs/col/PolicyServicing/Policy/insuranceCo/99301000/byInsured?InsuredRut='+rutInp+'&Page=1&Offset=10');
        	request.setMethod('GET');
        	request.setHeader('Authorization', 'Bearer ' + token);
            request.setHeader('X-IBM-Client-Id', '9e9bc552-9db3-4861-86f1-400528d44e2b');
            request.setHeader('LR_USUARIO', '12721330-5');
            request.setHeader('Sistema', 'Clientes'); 
            request.setHeader('LR_CODINTER', '00000000');
            request.setHeader('Content-Type', 'application/json');
        	HttpResponse response = http.send(request);
             
              //Lista del polizas registradas en BHP
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
            //polizas de prueba
            listpolice.add(281947);
            listpolice.add(282658);
            listpolice.add(283189);
            
            
        	if(response.getStatusCode() == 200){ 
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody() );
                List<Object> objectNames = (List<Object>)result.get('policies');
				List<String> fieldNames = new List<String>();
                
                Map<String, Object> numpol = (Map<String, Object>)objectNames[0];
                
                police = (Integer)numpol.get('policyNumber');
      			System.debug('NUMERO DE POLIZA: ' + police);
                
                //Validando que la poliza exista en la lista de polizas de BHP
                boolean existe = listpolice.contains(police);
                if (existe) {
                    System.debug('La poliza SÍ existe en la lista ' + police);
                } else {
                    System.debug('La poliza no existe');
                }
                
        	}else{
            	System.debug('Error'+ response.getStatus());
        	}
        }
        catch(Exception ex ){
            System.debug( 'EBV_GetPolizas ' + ex);
        }
        
        return police;

    }

}