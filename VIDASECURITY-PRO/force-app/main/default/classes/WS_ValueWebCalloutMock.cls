@isTest
global class WS_ValueWebCalloutMock implements WebServiceMock{
	 global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
          /*if (request instanceOf WS_ValueWeb.AgregarDocumentoResponse_element) {
                   response.put('response_x', new WS_ValueWeb.AgregarDocumentoResponse_element());
          }*/
          WS_ValueWeb.AgregarDocumentoResponse_element r = new WS_ValueWeb.AgregarDocumentoResponse_element();
          r.AgregarDocumentoResult = new WS_ValueWeb.AgregarDocumentoReturn();
          r.AgregarDocumentoResult.Code = 0;
               
          response.put('response_x', r);
               
               
               
   }
}