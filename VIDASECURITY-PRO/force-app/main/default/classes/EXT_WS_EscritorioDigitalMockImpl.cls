/*******************************************************************************************
 *  NOMBRE                 : EXT_WS_EscritorioDigitalMockImpl
 *  TIPO				   : APEX TEST CLASS 
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
@isTest
public class EXT_WS_EscritorioDigitalMockImpl implements WebServiceMock {
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
       
		System.debug(LoggingLevel.INFO, 'EXT_WS_EscritorioDigitalMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf EXT_WS_EscritorioDigital.CambiarEstadoRequerimiento_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.CrearRequerimiento_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.ObtenerPersistencia_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.ObtenerPersistenciaDatos_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.ObtenerRequerimiento_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.ObtenerRequerimientos_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element());
		}
		else if(request instanceOf EXT_WS_EscritorioDigital.ValidarPersistencia_element) {
			response.put( 'response_x', new EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element());
		}
	}
}