@isTest
private class ClienteValueWebTest {
    @isTest static void testCallout() {
        Test.setMock(WebServiceMock.class, new WS_ValueWebCalloutMock());
        String token = '4eb909cfa5eb57a094a873c136fc01eb';
		String idTransaccion = 'fd8d956b-1e8f-4895-a548-b6b2d331dbf7';
		String content = '';
		String xmlIndex = '<IndexList><Index Value="VIDA SECURITY" Label="Empresa" /><Index Value="POLIZA" Label="Tipo de Documento" /><Index Value="1-9" Label="RUT Asegurado" /><Index Value="Juanito Perez" Label="Nombre Contratante" /><Index Value="false" Label="EnviaAcsel" /></IndexList>';
		String extension = 'pdf';
        
        WS_ValueWeb.AgregarDocumentoReturn result = ClienteValueWeb.AgregarDocumento(token, idTransaccion, content, xmlIndex, extension);
        
        System.assertEquals(0, result.Code);
    }
}