@isTest
private class SalesforceTPSoapTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap parentObject = new SalesforceTPSoap();
		new SalesforceTPSoap.Anulo_element();
		new SalesforceTPSoap.AnuloResponse_element();
		new SalesforceTPSoap.ArrayOfMotivo();
		new SalesforceTPSoap.ArrayOfMotivoFinTurno();
		new SalesforceTPSoap.ArrayOfPausa();
		new SalesforceTPSoap.ArrayOfSerie();
		new SalesforceTPSoap.CambiaEscritorio_element();
		new SalesforceTPSoap.CambiaEscritorioResponse_element();
		new SalesforceTPSoap.CambiaRecordatorio_element();
		new SalesforceTPSoap.CambiaRecordatorioResponse_element();
		new SalesforceTPSoap.CambiaRutAtencionVigente_element();
		new SalesforceTPSoap.CambiaRutAtencionVigenteResponse_element();
		new SalesforceTPSoap.DerivoTurno_element();
		new SalesforceTPSoap.DerivoTurnoResponse_element();
		new SalesforceTPSoap.Err(); 
		//new SalesforceTPSoap.ExtensionDataObject();
		new SalesforceTPSoap.FinTurno_element();
		new SalesforceTPSoap.FinTurnoResponse_element();
		new SalesforceTPSoap.GetEdoBase_element();
		new SalesforceTPSoap.GetEdoBaseResponse_element();
		new SalesforceTPSoap.GetEdoSesion_element();
		new SalesforceTPSoap.GetEdoSesionResponse_element();
		new SalesforceTPSoap.GetMotivos_element();
		new SalesforceTPSoap.GetMotivosResponse_element();
		new SalesforceTPSoap.GetPausas_element();
		new SalesforceTPSoap.GetPausasResponse_element();
		new SalesforceTPSoap.GetRecordatorio_element();
		new SalesforceTPSoap.GetRecordatorioResponse_element();
		new SalesforceTPSoap.GetSeries_element();
		new SalesforceTPSoap.GetSeriesResponse_element();
		new SalesforceTPSoap.Login_element();
		new SalesforceTPSoap.LoginResponse_element();
		new SalesforceTPSoap.Logoff_element();
		new SalesforceTPSoap.LogoffResponse_element();
		new SalesforceTPSoap.Motivo();
		new SalesforceTPSoap.MotivoFinTurno();
		new SalesforceTPSoap.Oficina();
		new SalesforceTPSoap.Pausa();
		new SalesforceTPSoap.PidoTurno_element();
		new SalesforceTPSoap.PidoTurnoResponse_element();
		new SalesforceTPSoap.ProcesoTurno_element();
		new SalesforceTPSoap.ProcesoTurnoResponse_element();
		new SalesforceTPSoap.ReLlamo_element();
		new SalesforceTPSoap.ReLlamoResponse_element();
		new SalesforceTPSoap.ResultadoGetEdoBase();
		new SalesforceTPSoap.ResultadoGetEdoSesion();
		new SalesforceTPSoap.ResultadoGetMotivos();
		new SalesforceTPSoap.ResultadoGetPausas();
		new SalesforceTPSoap.ResultadoGetSeries();
		new SalesforceTPSoap.ResultadoLogIn();
		new SalesforceTPSoap.Serie();
		new SalesforceTPSoap.SetPausa_element();
		new SalesforceTPSoap.SetPausaResponse_element();
		new SalesforceTPSoap.Urgencia_element();
		new SalesforceTPSoap.UrgenciaResponse_element();
	}
	@isTest static void coverCodeForAnulo(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.Anulo(null, null, null));
	}
	@isTest static void coverCodeForCambiaEscritorio(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		testObject.CambiaEscritorio(null, null);
	}
	@isTest static void coverCodeForCambiaRecordatorio(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		testObject.CambiaRecordatorio(null, null);
	}
	@isTest static void coverCodeForCambiaRutAtencionVigente(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		testObject.CambiaRutAtencionVigente(null, null, null, null, null);
	}
	@isTest static void coverCodeForDerivoTurno(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.DerivoTurno(null, null, null));
	}
	@isTest static void coverCodeForFinTurno(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.FinTurno(null, null, null, null));
	}
	@isTest static void coverCodeForGetEdoBase(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetEdoBase(null, null));
	}
	@isTest static void coverCodeForGetEdoSesion(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetEdoSesion(null, null, null));
	}
	@isTest static void coverCodeForGetMotivos(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetMotivos(null, null));
	}
	@isTest static void coverCodeForGetPausas(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetPausas(null, null));
	}
	@isTest static void coverCodeForGetRecordatorio(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetRecordatorio(null));
	}
	@isTest static void coverCodeForGetSeries(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.GetSeries(null, null));
	}
	@isTest static void coverCodeForLogin(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.Login(null, null, null, null, null));
	}
	@isTest static void coverCodeForLogoff(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.Logoff(null, null, null));
	}
	@isTest static void coverCodeForPidoTurno(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.PidoTurno(null, null));
	}
	@isTest static void coverCodeForProcesoTurno(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.ProcesoTurno(null, null, null));
	}
	@isTest static void coverCodeForReLlamo(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.ReLlamo(null, null, null));
	}
	@isTest static void coverCodeForSetPausa(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.SetPausa(null, null, null, null));
	}
	@isTest static void coverCodeForUrgencia(){
		Test.setMock(WebServiceMock.class, new SalesforceTPSoapMockImpl());
		SalesforceTPSoap.WsSFTotalpackSoap testObject = new SalesforceTPSoap.WsSFTotalpackSoap();
		System.assertEquals(null, testObject.Urgencia(null, null, null, null, null));
	}
}