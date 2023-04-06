public class CompromisoPagoAPI extends BaseAPI {
	
	public static void throwError(Boolean condition, String message) {
		if (condition)
			throw new CobranzaException(message);

	} 
	
	public static IngresarCompromisoPagoResponse[] enviarCompromiso(IngresarCompromisoPagoRequest[] requests){
		System.debug('CompromisoPagoAPI.enviarCompromiso - BEGIN');
		String httpMethod = 'POST';
		String endpoint = getEndpoint('/Pagos/compromiso');
		Map<String, String> headers = getHeaders();
		String body = JSON.serialize(requests);
		String response = null;
		try {
			response = HttpUtils.send(httpMethod, endpoint, body, headers);
		} catch (HttpException e) {
			//Integer statusCode = e.statusCode;
			response = e.responseBody;
		}
		throwError(response == null, 'No se obtuvo respuesta del servicio');
		
		System.debug(response);
		Object responseObj = IngresarCompromisoPagoResponse.parse(response);
		throwError(responseObj == null, 'No se obtuvo respuesta al parsear el servicio');
		
		if (responseObj instanceof IngresarCompromisoPagoResponse) {
			IngresarCompromisoPagoResponse compromisoResponse = (IngresarCompromisoPagoResponse)responseObj;
			if (compromisoResponse.isSuccess())
			return new IngresarCompromisoPagoResponse[] {compromisoResponse};
			throw new CobranzaException(compromisoResponse);
		}
		
		throwError(!(responseObj instanceof IngresarCompromisoPagoResponse[]), 'responseObj no es un arreglo de respuestas');
		return (IngresarCompromisoPagoResponse[])responseObj;
			}	

	
	//CONTINUATION METHODS
	public static ContinuationContext initContinuationEnviarCompromiso(IngresarCompromisoPagoRequest[] requests, String continuationMethod){
		System.debug('CompromisoPagoAPI.initContinuationEnviarCompromiso - BEGIN');
		String httpMethod = 'POST';
		String endpoint = getEndpoint('/Pagos/compromiso');
		Map<String, String> headers = getHeaders();
		String body = JSON.serialize(requests);
    system.debug('@@@ body JSON : ' + body);
		System.HttpRequest httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
    system.debug('@@@ httpRequest : ' + httpRequest);
		ContinuationContext ctx = new ContinuationContext();
    system.debug('@@@ ctx : ' + ctx);
		ctx.continuation = new Continuation(40);
	    ctx.continuation.continuationMethod = continuationMethod;
		ctx.requestLabel = ctx.continuation.addHttpRequest(httpRequest);
    system.debug('@@@ ctx 2 : ' + ctx);
		return ctx;
	}
}