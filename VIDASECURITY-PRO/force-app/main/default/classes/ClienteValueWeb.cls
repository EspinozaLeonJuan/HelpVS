public class ClienteValueWeb {
    public static WS_ValueWeb.AgregarDocumentoReturn AgregarDocumento(String token, String idTransaccion, String content, String xmlIndex, String extension) {
        WS_ValueWeb.SIDWIntegrationSoap cliente = new WS_ValueWeb.SIDWIntegrationSoap();
        cliente.endpoint_x = 'http://www.valueweb.cl/vwnetx_wsVidaSecurity_SegIndividuales/SIDWIntegration.asmx';        
        WS_ValueWeb.AgregarDocumentoReturn retorno = cliente.AgregarDocumento(token, idTransaccion, content, xmlIndex, extension);        
        return retorno;
    }
}