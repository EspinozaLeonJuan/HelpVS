public without sharing class ACSELCalloutService {

	public class ASCELCalloutException extends Exception {}

	@testVisible
	public static final String MSG_INTERNAL_ERROR = 'Ha ocurrido un error interno del servidor. Codigo HTTP 500.';
	@testVisible
	public static final String MSG_OTHER_STATUS = 'El servicio retorno un codigo HTTP no documentado. Codigo HTTP: ';

	private static final String PUT_METHOD = 'PUT';
	private static final String ACSEL_CALLOUT = 'ACSELCalloutService';
	//private static final String ENDPOINT = 'https://190.98.205.156:4000/vs-desarrollo/ind/Cliente/Ejecutivo/';
	private static final String PREFERRED_CONTENT_TYPE = 'application/json';
	//private static final String X_IBM_CLIENT_ID = 'bf017252-7c67-4632-bb62-11f892ac6017';

	/* PRODUCCION */
	private static final String ENDPOINT = 'https://api.vidasecurity.cl/vs/ind/Cliente/Ejecutivo/';
	private static final String X_IBM_CLIENT_ID = '9e9bc552-9db3-4861-86f1-400528d44e2b';
	

	public static List<ACSELAsignacionResponse> asignaEjecutivos(List<ACSELAsignacion> asignaciones){
		HttpRequest req = new HttpRequest();
		req.setMethod(PUT_METHOD);
		req.setEndpoint(ENDPOINT);
		req.setHeader('Content-Type', PREFERRED_CONTENT_TYPE);
		req.setHeader('Accept', PREFERRED_CONTENT_TYPE);
		req.setHeader('x-ibm-client-id', X_IBM_CLIENT_ID);
		req.setTimeout(120000);
		req.setBody(Json.serialize(asignaciones));
		HttpResponse response = new Http().send(req);
		Integer codeResponse = response.getStatusCode();

		if (codeResponse == 500)
			throw new ASCELCalloutException(MSG_INTERNAL_ERROR);
		// if (codeResponse == 207) {
			// De acuerdo con lo planteado en reunión, cuando el servicio devuelve un 207 no se hace nada.
		// }
		if (codeResponse != 200 && codeResponse != 207)
			throw new ASCELCalloutException(MSG_OTHER_STATUS + codeResponse);
		String body = response.getBody();
		return ACSELAsignacionResponse.parse(body);
	}



}