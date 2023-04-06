@isTest
private class ACSELCalloutServiceTest {

	static {

	}

	@testSetup
	static void init(){

	}

	@isTest
	static void dado_HTTPCODE200_cuando_SeAsignaEjecutivos_debe_RetornarResultados() {
		// dado
		String responseBody = ACSELAsignacionResponse.getExample();
		SingleHttpResponseMock responseMock =
									new SingleHttpResponseMock(200, 'Complete', responseBody, null);
		// cuando
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, responseMock);
		List<ACSELAsignacion> asignaciones = ACSELAsignacion.parse(ACSELAsignacion.getExample());
		List<ACSELAsignacionResponse> resultados = ACSELCalloutService.asignaEjecutivos(asignaciones);
		Test.stopTest();
		// debe
		System.assertNotEquals(null, responseMock.getRequest());
		System.assertEquals(2, resultados.size());
	}

	@isTest
	static void dado_HTTPCODE207_cuando_SeAsignaEjecutivos_debe_RetornarResultadosParciales() {
		// dado
		String responseBody = ACSELAsignacionResponse.getExample();
		SingleHttpResponseMock responseMock =
									new SingleHttpResponseMock(207, 'MultiStatus', responseBody, null);
		String errorMessage = '';
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, responseMock);
		List<ACSELAsignacion> asignaciones = ACSELAsignacion.parse(ACSELAsignacion.getExample());
		List<ACSELAsignacionResponse> resultados = ACSELCalloutService.asignaEjecutivos(asignaciones);
		Test.stopTest();
		System.assertNotEquals(null, responseMock.getRequest());
		System.assertEquals(2, resultados.size());
	}

	@isTest
	static void dado_HTTPCODE500_cuando_SeAsignaEjecutivos_debe_RetornarError() {
		// dado
		String responseBody = ACSELAsignacionResponse.getExample();
		SingleHttpResponseMock responseMock =
									new SingleHttpResponseMock(500, 'Internal Error', responseBody, null);
		String errorMessage = '';
		try {
			Test.startTest();
			Test.setMock(HttpCalloutMock.class, responseMock);
			List<ACSELAsignacion> asignaciones = ACSELAsignacion.parse(ACSELAsignacion.getExample());
			List<ACSELAsignacionResponse> resultados = ACSELCalloutService.asignaEjecutivos(asignaciones);
			Test.stopTest();
		} catch (ACSELCalloutService.ASCELCalloutException ex) {
			errorMessage = ex.getMessage();
		}
		System.assertNotEquals(null, errorMessage, 'Debe lanzar el error: ' + ACSELCalloutService.MSG_INTERNAL_ERROR);
	}

	@isTest
	static void dado_NOT_HTTPCODE_200_500_207_cuando_SeAsignaEjecutivos_debe_RetornarError() {
		// dado
		String responseBody = ACSELAsignacionResponse.getExample();
		SingleHttpResponseMock responseMock =
									new SingleHttpResponseMock(300, 'Other Status Cde', responseBody, null);
		String errorMessage = '';
		try {
			Test.startTest();
			Test.setMock(HttpCalloutMock.class, responseMock);
			List<ACSELAsignacion> asignaciones = ACSELAsignacion.parse(ACSELAsignacion.getExample());
			List<ACSELAsignacionResponse> resultados = ACSELCalloutService.asignaEjecutivos(asignaciones);
			Test.stopTest();
		} catch (ACSELCalloutService.ASCELCalloutException ex) {
			errorMessage = ex.getMessage();
		}
		System.assert(errorMessage.contains(ACSELCalloutService.MSG_OTHER_STATUS), 'Debe lanzar el error: ' + ACSELCalloutService.MSG_OTHER_STATUS);
	}

}