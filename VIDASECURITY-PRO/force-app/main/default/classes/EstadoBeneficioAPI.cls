public class EstadoBeneficioAPI extends BaseAPI {
	
	public static EstadoBeneficioResponse actualizarBeneficio(EstadoBeneficioRequest request, String status) {
		String httpMethod = 'POST';
		String endpoint = getEndpoint('/Trassa/'+status);
		Map<String, String> headers = getHeaders();
		String body = JSON.serialize(request);
	
    system.debug('@@@ request : ' + request);
		String response = null;
		try { 
      system.debug('@@@ send endpoint : ' + endpoint);
      system.debug('@@@ send headers : ' + headers);
      system.debug('@@@ send body : ' + body);
		response = HttpUtils.send(httpMethod, endpoint, body, headers);
      system.debug('@@@ response : ' + response);
		} catch (Exception e) {
			throw new CobranzaException('Ocurrió un error al invocar el servicio de actualización de beneficios: ' + e.getTypeName() + ': ' + e.getMessage() + ', endpoint: ' + endpoint + '\nBody\n' + body);
		}
		Object responseObj = EstadoBeneficioResponse.parse(response);
		if (responseObj instanceof EstadoBeneficioResponse)
			return (EstadoBeneficioResponse)responseObj;
        throw new CobranzaException('No fue posible realizar el ' + status + ' los beneficios para la filial especificada.' + request);
    }
    
	public static EstadoBeneficioResponse bloquearBeneficio(EstadoBeneficioRequest request) {
		return actualizarBeneficio(request, 'bloqueo');
	}

	public static EstadoBeneficioResponse desbloquearBeneficio(EstadoBeneficioRequest request) {
		return actualizarBeneficio(request, 'desbloqueo');
    }


	//CONTINUATION METHODS
	public static ContinuationContext initContinuationactualizarBeneficio(EstadoBeneficioRequest request, String continuationMethod, String status) {
        String httpMethod = 'POST';
		String endpoint = getEndpoint('/Trassa/'+status);
		Map<String, String> headers = getHeaders();
		String body = JSON.serialize(request);

		System.HttpRequest httpRequest = HttpUtils.getHttpRequest(httpMethod, endpoint, body, headers);
		//String response = HttpUtils.send(httpMethod, endpoint, body, headers);

	    ContinuationContext ctx = new ContinuationContext();
		ctx.continuation = new Continuation(40);
	    ctx.continuation.continuationMethod = continuationMethod;
		ctx.requestLabel = ctx.continuation.addHttpRequest(httpRequest);

		return ctx;
    }
    
	public static ContinuationContext initContinuationBloquearBeneficio(EstadoBeneficioRequest request, String continuationMethod) {
		return initContinuationactualizarBeneficio(request, continuationMethod, 'bloqueo');
	}

	public static ContinuationContext initContinuationDesbloquearBeneficio(EstadoBeneficioRequest request, String continuationMethod) {
		return initContinuationactualizarBeneficio(request, continuationMethod, 'desbloqueo');
    }
}