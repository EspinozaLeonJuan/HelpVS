/*******************************************************************************************
 *  NOMBRE                 : EXT_WS_EscritorioDigitalWebSvcTest
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
private class EXT_WS_EscritorioDigitalWebSvcTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital parentObject = new EXT_WS_EscritorioDigital();
		new EXT_WS_EscritorioDigital.CambiarEstadoRequerimiento_element();
		new EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element();
		new EXT_WS_EscritorioDigital.CrearRequerimiento_element();
		new EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element();
		new EXT_WS_EscritorioDigital.ObtenerPersistencia_element();
		new EXT_WS_EscritorioDigital.ObtenerPersistenciaDatos_element();
		new EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element();
		new EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element();
		new EXT_WS_EscritorioDigital.ObtenerRequerimiento_element();
		new EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element();
		new EXT_WS_EscritorioDigital.ObtenerRequerimientos_element();
		new EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element();
		new EXT_WS_EscritorioDigital.RespuestaCambiarEstadoRequerimiento();
		new EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia();
		new EXT_WS_EscritorioDigital.RespuestaObtenerPersistenciaDatos();
		new EXT_WS_EscritorioDigital.RespuestaValidarPersistencia();
		new EXT_WS_EscritorioDigital.Resultado();
		new EXT_WS_EscritorioDigital.Usuario();
		new EXT_WS_EscritorioDigital.ValidarPersistencia_element();
		new EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element();
		new EXT_WS_EscritorioDigital_CR.Requerimiento();
		new EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento();
		new EXT_WS_EscritorioDigital_CR.Resultado();
		new EXT_WS_EscritorioDigital_OR.Adjunto();
		new EXT_WS_EscritorioDigital_OR.ArrayOfAdjunto();
		new EXT_WS_EscritorioDigital_OR.ArrayOfAtributo();
		new EXT_WS_EscritorioDigital_OR.ArrayOfBeneficiario();
		new EXT_WS_EscritorioDigital_OR.ArrayOfCobertura();
		new EXT_WS_EscritorioDigital_OR.ArrayOfFormulario();
		new EXT_WS_EscritorioDigital_OR.ArrayOfIndice();
		new EXT_WS_EscritorioDigital_OR.ArrayOfString();
		new EXT_WS_EscritorioDigital_OR.Asegurado();
		new EXT_WS_EscritorioDigital_OR.Atributo();
		new EXT_WS_EscritorioDigital_OR.Beneficiario();
		new EXT_WS_EscritorioDigital_OR.Ciudad();
		new EXT_WS_EscritorioDigital_OR.Cobertura();
		new EXT_WS_EscritorioDigital_OR.Comuna();
		new EXT_WS_EscritorioDigital_OR.Contratante();
		new EXT_WS_EscritorioDigital_OR.EstadoCivil();
		new EXT_WS_EscritorioDigital_OR.Formulario();
		new EXT_WS_EscritorioDigital_OR.Indice();
		new EXT_WS_EscritorioDigital_OR.KeyValue();
		new EXT_WS_EscritorioDigital_OR.Parentesco();
		new EXT_WS_EscritorioDigital_OR.Persona();
		new EXT_WS_EscritorioDigital_OR.Poliza();
		new EXT_WS_EscritorioDigital_OR.Producto();
		new EXT_WS_EscritorioDigital_OR.Region();
		new EXT_WS_EscritorioDigital_OR.Requerimiento();
		new EXT_WS_EscritorioDigital_OR.RespuestaObtenerRequerimiento();
		new EXT_WS_EscritorioDigital_OR.Resultado();
		new EXT_WS_EscritorioDigital_OR.Usuario();
		new EXT_WS_EscritorioDigital_ORs.ArrayOfRequerimiento();
		new EXT_WS_EscritorioDigital_ORs.Requerimiento();
		new EXT_WS_EscritorioDigital_ORs.RespuestaObtenerRequerimientos();
		new EXT_WS_EscritorioDigital_ORs.Resultado();
	}
	@isTest static void coverCodeForCambiarEstadoRequerimiento(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.CambiarEstadoRequerimiento(null, null, null));
	}
	@isTest static void coverCodeForCrearRequerimiento(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.CrearRequerimiento(null, null, null, null, null, null));
	}
	@isTest static void coverCodeForObtenerPersistencia(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.ObtenerPersistencia(null, null, null, null, null));
	}
	@isTest static void coverCodeForObtenerPersistenciaDatos(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.ObtenerPersistenciaDatos(null, null, null, null, null));
	}
	@isTest static void coverCodeForObtenerRequerimiento(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.ObtenerRequerimiento(null, null, null, null));
	}
	@isTest static void coverCodeForObtenerRequerimientos(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.ObtenerRequerimientos(null, null, null, null, null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForValidarPersistencia(){
		Test.setMock(WebServiceMock.class, new EXT_WS_EscritorioDigitalMockImpl());
		EXT_WS_EscritorioDigital.EscritorioDigitalSoap testObject = new EXT_WS_EscritorioDigital.EscritorioDigitalSoap();
		System.assertEquals(null, testObject.ValidarPersistencia(null, null));
	}
}