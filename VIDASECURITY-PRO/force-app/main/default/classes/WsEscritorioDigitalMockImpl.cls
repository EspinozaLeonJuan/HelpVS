@isTest
public class WsEscritorioDigitalMockImpl implements WebServiceMock {
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
            if(request instanceOf WsEscritorioDigital.ValidarPersistencia_element) {
                WsEscritorioDigital.ValidarPersistenciaResponse_element persistencia = new WsEscritorioDigital.ValidarPersistenciaResponse_element();
                persistencia.ValidarPersistenciaResult = new WsEscritorioDigital.RespuestaValidarPersistencia();
                response.put( 'response_x', persistencia);
            }
            else if(request instanceOf WsEscritorioDigital.ObtenerPersistencia_element) {
                WsEscritorioDigital.ObtenerPersistenciaResponse_element persistencia = new WsEscritorioDigital.ObtenerPersistenciaResponse_element();
                response.put( 'response_x', persistencia);
            }
            else if(request instanceOf WsEscritorioDigital.ObtenerRequerimiento_element) {
                WsEscritorioDigital.ObtenerRequerimientoResponse_element respuesta = new WsEscritorioDigital.ObtenerRequerimientoResponse_element();
                response.put( 'response_x', respuesta);
            }
            else if(request instanceOf WsEscritorioDigital.ObtenerRequerimientos_element) {
                WsEscritorioDigital.ObtenerRequerimientosResponse_element respuesta= new WsEscritorioDigital.ObtenerRequerimientosResponse_element();
                response.put( 'response_x', respuesta);
            }
            else if(request instanceOf WsEscritorioDigital.CambiarEstadoRequerimiento_element) {
                WsEscritorioDigital.CambiarEstadoRequerimientoResponse_element respuesta = new WsEscritorioDigital.CambiarEstadoRequerimientoResponse_element();
                response.put( 'response_x', respuesta);
            }
            else if(request instanceOf WsEscritorioDigital.CrearRequerimiento_element) {
                WsEscritorioDigital.CrearRequerimientoResponse_element respuesta= new WsEscritorioDigital.CrearRequerimientoResponse_element();
                response.put( 'response_x', respuesta);
            }   
        }
}