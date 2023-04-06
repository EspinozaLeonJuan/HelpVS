/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-01-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@isTest
private class EXT_WS_AccessWebSvcTest {
	 
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access parentObject = new EXT_WS_Access();
		new EXT_WS_Access.AccessInfo();
		new EXT_WS_Access.AppInfo();
		new EXT_WS_Access.ArrayOfDatoAplicacion();
		new EXT_WS_Access.ArrayOfDatoRol();
		new EXT_WS_Access.ArrayOfMenu();
		new EXT_WS_Access.DatoAcceso();
		new EXT_WS_Access.DatoAplicacion();
		new EXT_WS_Access.DatoRol();
		new EXT_WS_Access.ExtensionDataObject();
		new EXT_WS_Access.Login_element();
		new EXT_WS_Access.LoginResponse_element();
		new EXT_WS_Access.LoginRut_element();
		new EXT_WS_Access.LoginRutResponse_element();
		new EXT_WS_Access.MantienePersistencia_element();
		new EXT_WS_Access.MantienePersistenciaResponse_element();
		new EXT_WS_Access.Menu();
		new EXT_WS_Access.ObtenerMenu_element();
		new EXT_WS_Access.ObtenerMenuResponse_element();
		new EXT_WS_Access.ObtenerOpcion_element();
		new EXT_WS_Access.ObtenerOpcionResponse_element();
		new EXT_WS_Access.SimularUsuario_element();
		new EXT_WS_Access.SimularUsuarioResponse_element();
		new EXT_WS_Access.UserInfo();
		new EXT_WS_Access.ValidaAcceso_element();
		new EXT_WS_Access.ValidaAccesoResponse_element();
		new EXT_WS_Access.WebInfo();
	}
	@isTest static void coverCodeForLogin(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.Login(null));
	}
	@isTest static void coverCodeForLoginRut(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.LoginRut(null));
	}
	@isTest static void coverCodeForMantienePersistencia(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.MantienePersistencia(null));
	}
	@isTest static void coverCodeForObtenerMenu(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.ObtenerMenu(null));
	}
	@isTest static void coverCodeForObtenerOpcion(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.ObtenerOpcion(null));
	}
	@isTest static void coverCodeForSimularUsuario(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.SimularUsuario(null, null));
	}
	@isTest static void coverCodeForValidaAcceso(){
		Test.setMock(WebServiceMock.class, new EXT_WS_AccessMockImpl());
		EXT_WS_Access.WsAccessSoap testObject = new EXT_WS_Access.WsAccessSoap();
		System.assertEquals(null, testObject.ValidaAcceso(null));
	}
}