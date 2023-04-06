@isTest
global class CLS_WSprodoncoMock implements WebServiceMock {

    public void doInvoke(
        
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType){
        	
            if (request instanceOf CLS_WSprodonco.FncValidaEsPreImpreso_element){
                CLS_WSprodonco.FncValidaEsPreImpresoResponse_element validacion = new CLS_WSprodonco.FncValidaEsPreImpresoResponse_element();
				//validacion.FncValidaEsPreImpresoResult = new String();
                response.put( 'response_x', validacion);
            }
            else if (request instanceOf CLS_WSprodonco.GetUltimoProducto_element){
                CLS_WSprodonco.GetUltimoProductoResponse_element producto = new CLS_WSprodonco.GetUltimoProductoResponse_element();
				producto.GetUltimoProductoResult = new CLS_WSprodonco.ArrayOfProductoOncologico();
                response.put( 'response_x', producto);
            }
            else if (request instanceOf CLS_WSprodonco.GetPolizasPacPat_element){
                CLS_WSprodonco.GetPolizasPacPatResponse_element polizas = new CLS_WSprodonco.GetPolizasPacPatResponse_element();
				polizas.GetPolizasPacPatResult = new CLS_WSprodonco.ArrayOfPoliza();
                response.put( 'response_x', polizas);
            }
            else if (request instanceOf CLS_WSprodonco.GetTarificacionOncoFechaNacimiento_element){
                CLS_WSprodonco.GetTarificacionOncoFechaNacimientoResponse_element tarificacion = new CLS_WSprodonco.GetTarificacionOncoFechaNacimientoResponse_element();
				tarificacion.GetTarificacionOncoFechaNacimientoResult = new CLS_WSprodonco.Tarificacion();
                response.put( 'response_x', tarificacion);
            }   
            else if (request instanceOf CLS_WSprodonco.GetIntermediario_element){
                CLS_WSprodonco.GetIntermediarioResponse_element intermediario = new CLS_WSprodonco.GetIntermediarioResponse_element();
				intermediario.GetIntermediarioResult = new CLS_WSprodonco.ArrayOfIntermediario();
                response.put( 'response_x', intermediario);
            }   
            else if (request instanceOf CLS_WSprodonco.GetTarificacionCoberturaFechaNac_element){
                CLS_WSprodonco.GetTarificacionCoberturaFechaNacResponse_element tarificacion = new CLS_WSprodonco.GetTarificacionCoberturaFechaNacResponse_element();
				tarificacion.GetTarificacionCoberturaFechaNacResult = new CLS_WSprodonco.Tarificacion();
                response.put( 'response_x', tarificacion);
            }      
            else if (request instanceOf CLS_WSprodonco.GetCodigoCobertura_element){
                CLS_WSprodonco.GetCodigoCoberturaResponse_element codigo = new CLS_WSprodonco.GetCodigoCoberturaResponse_element();
				codigo.GetCodigoCoberturaResult = new CLS_WSprodonco.ArrayOfCobertura();
                response.put( 'response_x', codigo);
            }    
            else if (request instanceOf CLS_WSprodonco.GetTarificacionEdad_element){
                CLS_WSprodonco.GetTarificacionEdadResponse_element tarificacion = new CLS_WSprodonco.GetTarificacionEdadResponse_element();
				tarificacion.GetTarificacionEdadResult = new CLS_WSprodonco.Tarificacion();
                response.put( 'response_x', tarificacion);
            }    
            else if (request instanceOf CLS_WSprodonco.GetTarificacionOncoEdad_element){
                CLS_WSprodonco.GetTarificacionOncoEdadResponse_element tarificacion = new CLS_WSprodonco.GetTarificacionOncoEdadResponse_element();
				tarificacion.GetTarificacionOncoEdadResult = new CLS_WSprodonco.Tarificacion();
                response.put( 'response_x', tarificacion);
            }    
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoSucursales_element){
                CLS_WSprodonco.ObtenerListadoSucursalesResponse_element sucursales = new CLS_WSprodonco.ObtenerListadoSucursalesResponse_element();
				sucursales.ObtenerListadoSucursalesResult = new CLS_WSprodonco.ArrayOfSucursal();
                response.put( 'response_x', sucursales);
            }    
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoTarjeta_element){
                CLS_WSprodonco.ObtenerListadoTarjetaResponse_element tarjetas = new CLS_WSprodonco.ObtenerListadoTarjetaResponse_element();
				tarjetas.ObtenerListadoTarjetaResult = new CLS_WSprodonco.ArrayOfTarjeta();
                response.put( 'response_x', tarjetas);
            }   
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoCiudad_element){
                CLS_WSprodonco.ObtenerListadoCiudadResponse_element ciudades = new CLS_WSprodonco.ObtenerListadoCiudadResponse_element();
				ciudades.ObtenerListadoCiudadResult = new CLS_WSprodonco.ArrayOfCiudad();
                response.put( 'response_x', ciudades);
            }    
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoBancos_element){
                CLS_WSprodonco.ObtenerListadoBancosResponse_element bancos = new CLS_WSprodonco.ObtenerListadoBancosResponse_element();
				bancos.ObtenerListadoBancosResult = new CLS_WSprodonco.ArrayOfBanco();
                response.put( 'response_x', bancos);
            }   
            else if (request instanceOf CLS_WSprodonco.ObtenerFolio_element){
                CLS_WSprodonco.ObtenerFolioResponse_element folio = new CLS_WSprodonco.ObtenerFolioResponse_element();
				folio.ObtenerFolioResult = new CLS_WSprodonco.Folio();
                response.put( 'response_x', folio);
            }     
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoRegion_element){
                CLS_WSprodonco.ObtenerListadoRegionResponse_element regiones = new CLS_WSprodonco.ObtenerListadoRegionResponse_element();
				regiones.ObtenerListadoRegionResult = new CLS_WSprodonco.ArrayOfRegion();
                response.put( 'response_x', regiones);
            }    
            else if(request instanceOf CLS_WSprodonco.ObtenerListadoComuna_element){
                CLS_WSprodonco.ObtenerListadoComunaResponse_element comunas = new CLS_WSprodonco.ObtenerListadoComunaResponse_element();
                comunas.ObtenerListadoComunaResult = new CLS_WSprodonco.ArrayOfComuna();
                response.put( 'response_x', comunas);
            }            
            else if (request instanceOf CLS_WSprodonco.ObtenerListadoFormaPago_element){
                CLS_WSprodonco.ObtenerListadoFormaPagoResponse_element formapago = new CLS_WSprodonco.ObtenerListadoFormaPagoResponse_element();
				formapago.ObtenerListadoFormaPagoResult = new CLS_WSprodonco.ArrayOfFormaPago();
                response.put( 'response_x', formapago);
            }   
            else if (request instanceOf CLS_WSprodonco.ObtenerListaPeriodicidadPago_element){
                CLS_WSprodonco.ObtenerListaPeriodicidadPagoResponse_element pago = new CLS_WSprodonco.ObtenerListaPeriodicidadPagoResponse_element();
				pago.ObtenerListaPeriodicidadPagoResult = new CLS_WSprodonco.ArrayOfPeriodicidadPago();
                response.put( 'response_x', pago);
            }    
            else if (request instanceOf CLS_WSprodonco.ObtenerRelacionFamiliar_element){
                CLS_WSprodonco.ObtenerRelacionFamiliarResponse_element Relacion = new CLS_WSprodonco.ObtenerRelacionFamiliarResponse_element();
				Relacion.ObtenerRelacionFamiliarResult = new CLS_WSprodonco.ArrayOfRelacionFamiliar();
                response.put( 'response_x', Relacion);
            }
            else if (request instanceOf CLS_WSprodonco.PrcObtenerCapital_element){
                CLS_WSprodonco.PrcObtenerCapitalResponse_element capital = new CLS_WSprodonco.PrcObtenerCapitalResponse_element();
				capital.PrcObtenerCapitalResult = new CLS_WSprodonco.Capital();
                response.put( 'response_x', capital);
            }
            else if (request instanceOf CLS_WSprodonco.PrcObtenerCapitalParentesco_element){
                CLS_WSprodonco.PrcObtenerCapitalParentescoResponse_element capital = new CLS_WSprodonco.PrcObtenerCapitalParentescoResponse_element();
				capital.PrcObtenerCapitalParentescoResult = new CLS_WSprodonco.CapitalUFPS();
                response.put( 'response_x', capital);
            }   
            else if (request instanceOf CLS_WSprodonco.ValidaAseguradoOnco_element){
                CLS_WSprodonco.ValidaAseguradoOncoResponse_element validacion = new CLS_WSprodonco.ValidaAseguradoOncoResponse_element();
				//validacion.ValidaAseguradoOncoResult = new String();
                response.put( 'response_x', validacion);
            }   
            else if (request instanceOf CLS_WSprodonco.ValidacionUsuarioPorFecNac_element){
                CLS_WSprodonco.ValidacionUsuarioPorFecNacResponse_element validacion = new CLS_WSprodonco.ValidacionUsuarioPorFecNacResponse_element();
				validacion.ValidacionUsuarioPorFecNacResult = new CLS_WSprodonco.UsuarioValido();
                response.put( 'response_x', validacion);
            }    
            else if (request instanceOf CLS_WSprodonco.ValidaCliente_element){
                CLS_WSprodonco.ValidaClienteResponse_element validacion = new CLS_WSprodonco.ValidaClienteResponse_element();
				//validacion.ValidaClienteResult = new Integer();
                response.put( 'response_x', validacion);
            }       
            else if (request instanceOf CLS_WSprodonco.ValidacionUsuarioPorEdad_element){
                CLS_WSprodonco.ValidacionUsuarioPorEdadResponse_element validacion = new CLS_WSprodonco.ValidacionUsuarioPorEdadResponse_element();
				validacion.ValidacionUsuarioPorEdadResult = new CLS_WSprodonco.UsuarioValido();
                response.put( 'response_x', validacion);
            }
            else  if (request instanceOf CLS_WSprodoncoOper.RegistraDatosProspecto_element){
                CLS_WSprodoncoOper.RegistraDatosProspectoResponse_element producto = new CLS_WSprodoncoOper.RegistraDatosProspectoResponse_element();
				response.put( 'response_x', producto);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraPersona_element){
                CLS_WSprodoncoOper.RegistraPersonaResponse_element persona = new CLS_WSprodoncoOper.RegistraPersonaResponse_element();
				response.put( 'response_x', persona);
            }            
            else if (request instanceOf CLS_WSprodoncoOper.ActualizaDatosPropuesta_element){
                CLS_WSprodoncoOper.ActualizaDatosPropuestaResponse_element propuesta = new CLS_WSprodoncoOper.ActualizaDatosPropuestaResponse_element();
				response.put( 'response_x', propuesta);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraFormaPago_element){
                CLS_WSprodoncoOper.RegistraFormaPagoResponse_element formapago = new CLS_WSprodoncoOper.RegistraFormaPagoResponse_element();
				response.put( 'response_x', formapago);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraCoberturaAsegurado_element){
                CLS_WSprodoncoOper.RegistraCoberturaAseguradoResponse_element cobertura = new CLS_WSprodoncoOper.RegistraCoberturaAseguradoResponse_element();
				response.put( 'response_x', cobertura);
            }
			else if (request instanceOf CLS_WSprodoncoOper.RegistrarContratantePropuesta_element){
                CLS_WSprodoncoOper.RegistrarContratantePropuestaResponse_element contratante = new CLS_WSprodoncoOper.RegistrarContratantePropuestaResponse_element();
				response.put( 'response_x', contratante);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraPropuesta_element){
                CLS_WSprodoncoOper.RegistraPropuestaResponse_element propuesta = new CLS_WSprodoncoOper.RegistraPropuestaResponse_element();
				response.put( 'response_x', propuesta);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraIntermediario_element){
                CLS_WSprodoncoOper.RegistraIntermediarioResponse_element intermediario = new CLS_WSprodoncoOper.RegistraIntermediarioResponse_element();
				response.put( 'response_x', intermediario);
            }
            else if (request instanceOf CLS_WSprodoncoOper.ObtenerDatosProspecto_element){
                CLS_WSprodoncoOper.ObtenerDatosProspectoResponse_element prospecto = new CLS_WSprodoncoOper.ObtenerDatosProspectoResponse_element();
				prospecto.ObtenerDatosProspectoResult = new CLS_WSprodoncoOper.DatosProspecto();
                response.put( 'response_x', prospecto);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistraNumeroGrabacion_element){
                CLS_WSprodoncoOper.RegistraNumeroGrabacionResponse_element numero = new CLS_WSprodoncoOper.RegistraNumeroGrabacionResponse_element();
				response.put( 'response_x', numero);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistrarAseguradoPropuesta_element){
                CLS_WSprodoncoOper.RegistrarAseguradoPropuestaResponse_element asegurado = new CLS_WSprodoncoOper.RegistrarAseguradoPropuestaResponse_element();
				response.put( 'response_x', asegurado);
            }
            else if (request instanceOf CLS_WSprodoncoOper.RegistrarBeneficiario_element){
                CLS_WSprodoncoOper.RegistrarBeneficiarioResponse_element beneficiario = new CLS_WSprodoncoOper.RegistrarBeneficiarioResponse_element();
				response.put( 'response_x', beneficiario);
            }
            else  if(request instanceOf CLS_WSprodoncoEquifax.ConsultaPersona_element){
                CLS_WSprodoncoEquifax.ConsultaPersonaResponse_element consulta = new CLS_WSprodoncoEquifax.ConsultaPersonaResponse_element();
                consulta.ConsultaPersonaResult = new wsAxonaxisCl.DatosPersona();
                response.put( 'response_x', consulta);
                 }
                
                
                
                
                
                
            
        }
    
}