@isTest
public class CLS_WSprodoncoEquifaxMockImpl implements WebServiceMock {

    public void doInvoke(
        
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType){
        	
            if(request instanceOf CLS_WSprodoncoEquifax.ConsultaPersona_element){
                CLS_WSprodoncoEquifax.ConsultaPersonaResponse_element consulta = new CLS_WSprodoncoEquifax.ConsultaPersonaResponse_element();
                consulta.ConsultaPersonaResult = new wsAxonaxisCl.DatosPersona();
                response.put( 'response_x', consulta);
                 }
            
        }
    
}