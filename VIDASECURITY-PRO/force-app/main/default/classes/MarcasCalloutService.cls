public without sharing class MarcasCalloutService {

	public class MarcasCalloutException extends Exception {}

	@testVisible
	public static final String MSG_INTERNAL_ERROR = 'Ha ocurrido un error interno del servidor. Codigo HTTP 500.';
	@testVisible
	public static final String MSG_OTHER_STATUS = 'El servicio retorno un codigo HTTP no documentado. Codigo HTTP: ';

	private static final String PUT_METHOD = 'PUT';
	private static final String MARCAS_CALLOUT = 'MarcasCalloutService';
	private static final String PREFERRED_CONTENT_TYPE = 'application/json';

	public static List<MarcaResponse> modificarMarcas(List<MarcaRequest> marcas){
		HttpRequest req = new HttpRequest();
		req.setMethod(PUT_METHOD);
		req.setEndpoint('"callout:' + MARCAS_CALLOUT + '"');
		req.setHeader('Content-Type', PREFERRED_CONTENT_TYPE);
		req.setHeader('Accept', PREFERRED_CONTENT_TYPE);
		req.setBody(Json.serialize(marcas));
		HttpResponse response = new Http().send(req);
		Integer codeResponse = response.getStatusCode();
		if (codeResponse == 500)
			throw new MarcasCalloutException(MSG_INTERNAL_ERROR);
		if (codeResponse == 207) {
			// ¿Enviar un correo de las asignaciones incorrectas para que se puedan corregir a mano?
		}
		if (codeResponse != 200 && codeResponse != 207)
			throw new MarcasCalloutException(MSG_OTHER_STATUS + codeResponse);
		String body = response.getBody();
		return MarcaResponse.parse(body);
	}

}