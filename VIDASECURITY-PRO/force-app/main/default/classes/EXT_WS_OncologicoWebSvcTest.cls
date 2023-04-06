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
private class EXT_WS_OncologicoWebSvcTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico parentObject = new EXT_WS_Oncologico();
		new EXT_WS_Oncologico.ArrayOfAseguradoPropuesta();
		new EXT_WS_Oncologico.ArrayOfBanco();
		new EXT_WS_Oncologico.ArrayOfBeneficiarioPropuesta();
		new EXT_WS_Oncologico.ArrayOfCiudad();
		new EXT_WS_Oncologico.ArrayOfCobertura();
		new EXT_WS_Oncologico.ArrayOfComuna();
		new EXT_WS_Oncologico.ArrayOfFormaPago();
		new EXT_WS_Oncologico.ArrayOfIntermediario();
		new EXT_WS_Oncologico.ArrayOfIntermediarioPropuesta();
		new EXT_WS_Oncologico.ArrayOfPeriodicidadPago();
		new EXT_WS_Oncologico.ArrayOfPoliza();
		new EXT_WS_Oncologico.ArrayOfProductoOncologico();
		new EXT_WS_Oncologico.ArrayOfRegion();
		new EXT_WS_Oncologico.ArrayOfRelacionFamiliar();
		new EXT_WS_Oncologico.ArrayOfSucursal();
		new EXT_WS_Oncologico.ArrayOfTarjeta();
		new EXT_WS_Oncologico.AseguradoPropuesta();
		new EXT_WS_Oncologico.Banco();
		new EXT_WS_Oncologico.BeneficiarioPropuesta();
		new EXT_WS_Oncologico.Capital();
		new EXT_WS_Oncologico.CapitalUFPS();
		new EXT_WS_Oncologico.Ciudad();
		new EXT_WS_Oncologico.Cobertura();
		new EXT_WS_Oncologico.Comuna();
		new EXT_WS_Oncologico.ContratantePropuesta();
		new EXT_WS_Oncologico.EliminaPropuesta_element();
		new EXT_WS_Oncologico.EliminaPropuestaResponse_element();
		new EXT_WS_Oncologico.ExistePropuesta_element();
		new EXT_WS_Oncologico.ExistePropuestaResponse_element();
		new EXT_WS_Oncologico.FncValidaEsPreImpreso_element();
		new EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element();
		new EXT_WS_Oncologico.Folio();
		new EXT_WS_Oncologico.FormaPago();
		new EXT_WS_Oncologico.FormaPagoPropuesta();
		new EXT_WS_Oncologico.GetCodigoCobertura_element();
		new EXT_WS_Oncologico.GetCodigoCoberturaResponse_element();
		new EXT_WS_Oncologico.GetIntermediario_element();
		new EXT_WS_Oncologico.GetIntermediarioResponse_element();
		new EXT_WS_Oncologico.GetPolizaDatos_element();
		new EXT_WS_Oncologico.GetPolizaDatosResponse_element();
		new EXT_WS_Oncologico.GetPolizasPacPat_element();
		new EXT_WS_Oncologico.GetPolizasPacPatResponse_element();
		new EXT_WS_Oncologico.GetTarificacionCoberturaFechaNac_element();
		new EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element();
		new EXT_WS_Oncologico.GetTarificacionEdad_element();
		new EXT_WS_Oncologico.GetTarificacionEdadResponse_element();
		new EXT_WS_Oncologico.GetTarificacionOncoEdad_element();
		new EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element();
		new EXT_WS_Oncologico.GetTarificacionOncoFechaNacimiento_element();
		new EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element();
		new EXT_WS_Oncologico.GetUltimoProducto_element();
		new EXT_WS_Oncologico.GetUltimoProductoResponse_element();
		new EXT_WS_Oncologico.Intermediario();
		new EXT_WS_Oncologico.IntermediarioPropuesta();
		new EXT_WS_Oncologico.obtenerCoberturasCapital_element();
		new EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element();
		new EXT_WS_Oncologico.obtenerDatosPropuesta_element();
		new EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element();
		new EXT_WS_Oncologico.ObtenerFolio_element();
		new EXT_WS_Oncologico.ObtenerFolioResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoBancos_element();
		new EXT_WS_Oncologico.ObtenerListadoBancosResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoCiudad_element();
		new EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoComuna_element();
		new EXT_WS_Oncologico.ObtenerListadoComunaResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoFormaPago_element();
		new EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoRegion_element();
		new EXT_WS_Oncologico.ObtenerListadoRegionResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoSucursales_element();
		new EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element();
		new EXT_WS_Oncologico.ObtenerListadoTarjeta_element();
		new EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element();
		new EXT_WS_Oncologico.ObtenerListaPeriodicidadPago_element();
		new EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element();
		new EXT_WS_Oncologico.ObtenerRelacionFamiliar_element();
		new EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element();
		new EXT_WS_Oncologico.obtieneAsegurados_element();
		new EXT_WS_Oncologico.obtieneAseguradosResponse_element();
		new EXT_WS_Oncologico.obtieneBeneficiarios_element();
		new EXT_WS_Oncologico.obtieneBeneficiariosResponse_element();
		new EXT_WS_Oncologico.obtieneContratante_element();
		new EXT_WS_Oncologico.obtieneContratanteResponse_element();
		new EXT_WS_Oncologico.obtieneFormaPago_element();
		new EXT_WS_Oncologico.obtieneFormaPagoResponse_element();
		new EXT_WS_Oncologico.obtieneIntermediarios_element();
		new EXT_WS_Oncologico.obtieneIntermediariosResponse_element();
		new EXT_WS_Oncologico.obtienePropuesta_element();
		new EXT_WS_Oncologico.obtienePropuestaResponse_element();
		new EXT_WS_Oncologico.obtieneURLValueWeb_element();
		new EXT_WS_Oncologico.obtieneURLValueWebResponse_element();
		new EXT_WS_Oncologico.PeriodicidadPago();
		new EXT_WS_Oncologico.Poliza();
		new EXT_WS_Oncologico.PrcObtenerCapital_element();
		new EXT_WS_Oncologico.PrcObtenerCapitalParentesco_element();
		new EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element();
		new EXT_WS_Oncologico.PrcObtenerCapitalResponse_element();
		new EXT_WS_Oncologico.ProductoOncologico();
		new EXT_WS_Oncologico.Propuesta();
		new EXT_WS_Oncologico.Region();
		new EXT_WS_Oncologico.RelacionFamiliar();
		new EXT_WS_Oncologico.Respuesta();
		new EXT_WS_Oncologico.Sucursal();
		new EXT_WS_Oncologico.Tarificacion();
		new EXT_WS_Oncologico.Tarjeta();
		new EXT_WS_Oncologico.UsuarioValido();
		new EXT_WS_Oncologico.ValidaAseguradoOnco_element();
		new EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element();
		new EXT_WS_Oncologico.ValidacionUsuarioPorEdad_element();
		new EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element();
		new EXT_WS_Oncologico.ValidacionUsuarioPorFecNac_element();
		new EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element();
		new EXT_WS_Oncologico.ValidaCliente_element();
		new EXT_WS_Oncologico.ValidaClienteResponse_element();
	}
	@isTest static void coverCodeForEliminaPropuesta(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.EliminaPropuesta(null, null, null, null));
	}
	@isTest static void coverCodeForExistePropuesta(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ExistePropuesta(null, null, null, null));
	}
	@isTest static void coverCodeForFncValidaEsPreImpreso(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.FncValidaEsPreImpreso(null, null, null, null, null));
	}
	@isTest static void coverCodeForGetCodigoCobertura(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetCodigoCobertura(null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForGetIntermediario(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetIntermediario(null, null));
	}
	@isTest static void coverCodeForGetPolizaDatos(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetPolizaDatos(null, null));
	}
	@isTest static void coverCodeForGetPolizasPacPat(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetPolizasPacPat(null, null, null));
	}
	@isTest static void coverCodeForGetTarificacionCoberturaFechaNac(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetTarificacionCoberturaFechaNac(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForGetTarificacionEdad(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetTarificacionEdad(null, null, null, null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForGetTarificacionOncoEdad(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetTarificacionOncoEdad(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForGetTarificacionOncoFechaNacimiento(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetTarificacionOncoFechaNacimiento(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForGetUltimoProducto(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.GetUltimoProducto(null, null, null));
	}
	@isTest static void coverCodeForobtenerCoberturasCapital(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtenerCoberturasCapital(null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForobtenerDatosPropuesta(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtenerDatosPropuesta(null, null, null, null));
	}
	@isTest static void coverCodeForObtenerFolio(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerFolio(null, null, null, null, null));
	}
	@isTest static void coverCodeForObtenerListadoBancos(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoBancos(null));
	}
	@isTest static void coverCodeForObtenerListadoCiudad(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoCiudad(null, null));
	}
	@isTest static void coverCodeForObtenerListadoComuna(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoComuna(null, null));
	}
	@isTest static void coverCodeForObtenerListadoFormaPago(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoFormaPago(null, null, null, null, null));
	}
	@isTest static void coverCodeForObtenerListadoRegion(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoRegion(null));
	}
	@isTest static void coverCodeForObtenerListadoSucursales(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoSucursales(null));
	}
	@isTest static void coverCodeForObtenerListadoTarjeta(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListadoTarjeta(null));
	}
	@isTest static void coverCodeForObtenerListaPeriodicidadPago(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerListaPeriodicidadPago(null));
	}
	@isTest static void coverCodeForObtenerRelacionFamiliar(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ObtenerRelacionFamiliar(null, null, null, null, null));
	}
	@isTest static void coverCodeForobtieneAsegurados(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneAsegurados(null, null, null));
	}
	@isTest static void coverCodeForobtieneBeneficiarios(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneBeneficiarios(null, null, null));
	}
	@isTest static void coverCodeForobtieneContratante(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneContratante(null, null, null));
	}
	@isTest static void coverCodeForobtieneFormaPago(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneFormaPago(null, null, null));
	}
	@isTest static void coverCodeForobtieneIntermediarios(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneIntermediarios(null, null, null));
	}
	@isTest static void coverCodeForobtienePropuesta(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtienePropuesta(null, null, null));
	}
	@isTest static void coverCodeForobtieneURLValueWeb(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.obtieneURLValueWeb(null, null, null, null));
	}
	@isTest static void coverCodeForPrcObtenerCapital(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.PrcObtenerCapital(null, null, null, null, null, null));
	}
	@isTest static void coverCodeForPrcObtenerCapitalParentesco(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.PrcObtenerCapitalParentesco(null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForValidaAseguradoOnco(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ValidaAseguradoOnco(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForValidacionUsuarioPorEdad(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ValidacionUsuarioPorEdad(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForValidacionUsuarioPorFecNac(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ValidacionUsuarioPorFecNac(null, null, null, null, null, null, null, null));
	}
	@isTest static void coverCodeForValidaCliente(){
		Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
		EXT_WS_Oncologico.WsProductoOncologicoSoap testObject = new EXT_WS_Oncologico.WsProductoOncologicoSoap();
		System.assertEquals(null, testObject.ValidaCliente(null, null, null));
	}
}