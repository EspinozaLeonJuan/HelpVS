/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-01-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@isTest
public class EXT_WS_AccessMockImpl implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) { 
       
		System.debug(LoggingLevel.INFO, 'EXT_WS_AccessMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf EXT_WS_Access.Login_element) {
			response.put( 'response_x', new EXT_WS_Access.LoginResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.LoginRut_element) {
			response.put( 'response_x', new EXT_WS_Access.LoginRutResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.MantienePersistencia_element) {
			response.put( 'response_x', new EXT_WS_Access.MantienePersistenciaResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.ObtenerMenu_element) {
			response.put( 'response_x', new EXT_WS_Access.ObtenerMenuResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.ObtenerOpcion_element) {
			response.put( 'response_x', new EXT_WS_Access.ObtenerOpcionResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.SimularUsuario_element) {
			response.put( 'response_x', new EXT_WS_Access.SimularUsuarioResponse_element());
		}
		else if(request instanceOf EXT_WS_Access.ValidaAcceso_element) {
			response.put( 'response_x', new EXT_WS_Access.ValidaAccesoResponse_element());
		}
	}
}