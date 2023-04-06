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
public class EXT_WS_OncologicoMockImpl implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		System.debug(LoggingLevel.INFO, 'EXT_WS_OncologicoMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf EXT_WS_Oncologico.EliminaPropuesta_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.EliminaPropuestaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ExistePropuesta_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ExistePropuestaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.FncValidaEsPreImpreso_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.FncValidaEsPreImpresoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetCodigoCobertura_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetCodigoCoberturaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetIntermediario_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetIntermediarioResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetPolizaDatos_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetPolizaDatosResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetPolizasPacPat_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetPolizasPacPatResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetTarificacionCoberturaFechaNac_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetTarificacionCoberturaFechaNacResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetTarificacionEdad_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetTarificacionEdadResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetTarificacionOncoEdad_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetTarificacionOncoEdadResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetTarificacionOncoFechaNacimiento_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetTarificacionOncoFechaNacimientoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.GetUltimoProducto_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.GetUltimoProductoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtenerCoberturasCapital_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtenerCoberturasCapitalResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtenerDatosPropuesta_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtenerDatosPropuestaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerFolio_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerFolioResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoBancos_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoBancosResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoCiudad_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoCiudadResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoComuna_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoComunaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoFormaPago_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoFormaPagoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoRegion_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoRegionResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoSucursales_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoSucursalesResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListadoTarjeta_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListadoTarjetaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerListaPeriodicidadPago_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerListaPeriodicidadPagoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ObtenerRelacionFamiliar_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ObtenerRelacionFamiliarResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneAsegurados_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneAseguradosResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneBeneficiarios_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneBeneficiariosResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneContratante_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneContratanteResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneFormaPago_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneFormaPagoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneIntermediarios_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneIntermediariosResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtienePropuesta_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtienePropuestaResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.obtieneURLValueWeb_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.obtieneURLValueWebResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.PrcObtenerCapital_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.PrcObtenerCapitalResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.PrcObtenerCapitalParentesco_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.PrcObtenerCapitalParentescoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ValidaAseguradoOnco_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ValidaAseguradoOncoResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ValidacionUsuarioPorEdad_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ValidacionUsuarioPorEdadResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ValidacionUsuarioPorFecNac_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ValidacionUsuarioPorFecNacResponse_element());
		}
		else if(request instanceOf EXT_WS_Oncologico.ValidaCliente_element) {
			response.put( 'response_x', new EXT_WS_Oncologico.ValidaClienteResponse_element());
		}
	}
}