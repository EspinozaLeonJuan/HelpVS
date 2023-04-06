@isTest
global class CLS_WSprodoncoOperMock implements WebServiceMock {

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
        	
   
            if (request instanceOf CLS_WSprodoncoOper.RegistraDatosProspecto_element){
                CLS_WSprodoncoOper.RegistraDatosProspectoResponse_element producto = new CLS_WSprodoncoOper.RegistraDatosProspectoResponse_element();
				response.put( 'response_x', producto);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraPersona_element){
                CLS_WSprodoncoOper.RegistraPersonaResponse_element persona = new CLS_WSprodoncoOper.RegistraPersonaResponse_element();
				response.put( 'response_x', persona);
            }            
            else if (request instanceOf CLS_WSprodoncoOper.ActualizaDatosPropuesta_element){
                CLS_WSprodoncoOper.ActualizaDatosPropuestaResponse_element propuesta = new CLS_WSprodoncoOper.ActualizaDatosPropuestaResponse_element();
				response.put( 'response_x', propuesta);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraFormaPago_element){
                CLS_WSprodoncoOper.RegistraFormaPagoResponse_element formapago = new CLS_WSprodoncoOper.RegistraFormaPagoResponse_element();
				response.put( 'response_x', formapago);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraCoberturaAsegurado_element){
                CLS_WSprodoncoOper.RegistraCoberturaAseguradoResponse_element cobertura = new CLS_WSprodoncoOper.RegistraCoberturaAseguradoResponse_element();
				response.put( 'response_x', cobertura);
            }
			else if (request instanceOf CLS_WSprodoncoOper.RegistrarContratantePropuesta_element){
                CLS_WSprodoncoOper.RegistrarContratantePropuestaResponse_element contratante = new CLS_WSprodoncoOper.RegistrarContratantePropuestaResponse_element();
				response.put( 'response_x', contratante);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraPropuesta_element){
                CLS_WSprodoncoOper.RegistraPropuestaResponse_element propuesta = new CLS_WSprodoncoOper.RegistraPropuestaResponse_element();
				response.put( 'response_x', propuesta);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraIntermediario_element){
                CLS_WSprodoncoOper.RegistraIntermediarioResponse_element intermediario = new CLS_WSprodoncoOper.RegistraIntermediarioResponse_element();
				response.put( 'response_x', intermediario);
            }
            else if (request instanceOf CLS_WSprodoncoOper.ObtenerDatosProspecto_element){
                CLS_WSprodoncoOper.ObtenerDatosProspectoResponse_element prospecto = new CLS_WSprodoncoOper.ObtenerDatosProspectoResponse_element();
				prospecto.ObtenerDatosProspectoResult = new CLS_WSprodoncoOper.DatosProspecto();
                response.put( 'response_x', prospecto);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraNumeroGrabacion_element){
                CLS_WSprodoncoOper.RegistraNumeroGrabacionResponse_element numero = new CLS_WSprodoncoOper.RegistraNumeroGrabacionResponse_element();
				response.put( 'response_x', numero);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistrarAseguradoPropuesta_element){
                CLS_WSprodoncoOper.RegistrarAseguradoPropuestaResponse_element asegurado = new CLS_WSprodoncoOper.RegistrarAseguradoPropuestaResponse_element();
				response.put( 'response_x', asegurado);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistrarBeneficiario_element){
                CLS_WSprodoncoOper.RegistrarBeneficiarioResponse_element beneficiario = new CLS_WSprodoncoOper.RegistrarBeneficiarioResponse_element();
				response.put( 'response_x', beneficiario);
            }
    
        }
    
}