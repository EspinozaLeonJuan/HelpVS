/*******************************************************************************************
 *  NOMBRE                 : EXT_WS_EscritorioDigital
 *  TIPO				   : APEX CLASS 
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class EXT_WS_EscritorioDigital {
	public class CambiarEstadoRequerimiento_element {
		public Integer idrequerimiento;
		public String estado;
		public String rutusuario;
		private String[] idrequerimiento_type_info = new String[]{'idrequerimiento','http://tempuri.org/','int','1','1','false'};
		private String[] estado_type_info = new String[]{'estado','http://tempuri.org/','string','0','1','false'};
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'idrequerimiento','estado','rutusuario'};
	}
	public class CambiarEstadoRequerimientoResponse_element {
		public EXT_WS_EscritorioDigital.RespuestaCambiarEstadoRequerimiento CambiarEstadoRequerimientoResult;
		private String[] CambiarEstadoRequerimientoResult_type_info = new String[]{'CambiarEstadoRequerimientoResult','http://tempuri.org/','RespuestaCambiarEstadoRequerimiento','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'CambiarEstadoRequerimientoResult'};
	}
	public class CrearRequerimiento_element {
		public Integer idpersistencia;
		public String rutcliente;
		public Integer poliza;
		public String tiporequerimiento;
		public String rutusuario;
		public String usuario;
		private String[] idpersistencia_type_info = new String[]{'idpersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] rutcliente_type_info = new String[]{'rutcliente','http://tempuri.org/','string','0','1','false'};
		private String[] poliza_type_info = new String[]{'poliza','http://tempuri.org/','int','1','1','false'};
		private String[] tiporequerimiento_type_info = new String[]{'tiporequerimiento','http://tempuri.org/','string','0','1','false'};
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'idpersistencia','rutcliente','poliza','tiporequerimiento','rutusuario','usuario'};
	}
	public class CrearRequerimientoResponse_element {
		public EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento CrearRequerimientoResult;
		private String[] CrearRequerimientoResult_type_info = new String[]{'CrearRequerimientoResult','http://tempuri.org/','RespuestaCrearRequerimiento','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'CrearRequerimientoResult'};
	}
	public class EscritorioDigitalSoap {
		public String endpoint_x = 'http://servicios.vidasecurity.cl/clientes/escritoriodigital.asmx';
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x;
		private String[] ns_map_type_info = new String[]{'http://tempuri.org/','EXT_WS_EscritorioDigital','http://escritoriodigital/CrearRequerimiento','EXT_WS_EscritorioDigital_CR','http://escritoriodigital/ObtenerRequerimiento','EXT_WS_EscritorioDigital_OR','http://escritoriodigital/ObtenerRequerimientos','EXT_WS_EscritorioDigital_ORs'};

		public EXT_WS_EscritorioDigital.RespuestaCambiarEstadoRequerimiento CambiarEstadoRequerimiento(Integer idrequerimiento,String estado,String rutusuario) {
			EXT_WS_EscritorioDigital.CambiarEstadoRequerimiento_element request_x = new EXT_WS_EscritorioDigital.CambiarEstadoRequerimiento_element();
			EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element response_x;
			request_x.idrequerimiento = idrequerimiento;
			request_x.estado = estado;
			request_x.rutusuario = rutusuario;
			Map<String, EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/CambiarEstadoRequerimiento',
				'http://tempuri.org/',
				'CambiarEstadoRequerimiento',
				'http://tempuri.org/',
				'CambiarEstadoRequerimientoResponse',
				'EXT_WS_EscritorioDigital.CambiarEstadoRequerimientoResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.CambiarEstadoRequerimientoResult;
		}

		public EXT_WS_EscritorioDigital_CR.RespuestaCrearRequerimiento CrearRequerimiento(Integer idpersistencia,String rutcliente,Integer poliza,String tiporequerimiento,String rutusuario,String usuario) {
			EXT_WS_EscritorioDigital.CrearRequerimiento_element request_x = new EXT_WS_EscritorioDigital.CrearRequerimiento_element();
			EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element response_x;
			request_x.idpersistencia = idpersistencia;
			request_x.rutcliente = rutcliente;
			request_x.poliza = poliza;
			request_x.tiporequerimiento = tiporequerimiento;
			request_x.rutusuario = rutusuario;
			request_x.usuario = usuario;
			Map<String, EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/CrearRequerimiento',
				'http://tempuri.org/',
				'CrearRequerimiento',
				'http://tempuri.org/',
				'CrearRequerimientoResponse',
				'EXT_WS_EscritorioDigital.CrearRequerimientoResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.CrearRequerimientoResult;
		}

		public EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia ObtenerPersistencia(String rutusuario,String usuario,String password,String ip,String useros) {
			EXT_WS_EscritorioDigital.ObtenerPersistencia_element request_x = new EXT_WS_EscritorioDigital.ObtenerPersistencia_element();
			EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element response_x;
			request_x.rutusuario = rutusuario;
			request_x.usuario = usuario;
			request_x.password = password;
			request_x.ip = ip;
			request_x.useros = useros;
			Map<String, EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ObtenerPersistencia',
				'http://tempuri.org/',
				'ObtenerPersistencia',
				'http://tempuri.org/',
				'ObtenerPersistenciaResponse',
				'EXT_WS_EscritorioDigital.ObtenerPersistenciaResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerPersistenciaResult;
		}

		public EXT_WS_EscritorioDigital.RespuestaObtenerPersistenciaDatos ObtenerPersistenciaDatos(String rutusuario,String usuario,String password,String ip,String useros) {
			EXT_WS_EscritorioDigital.ObtenerPersistenciaDatos_element request_x = new EXT_WS_EscritorioDigital.ObtenerPersistenciaDatos_element();
			EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element response_x;
			request_x.rutusuario = rutusuario;
			request_x.usuario = usuario;
			request_x.password = password;
			request_x.ip = ip;
			request_x.useros = useros;
			Map<String, EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ObtenerPersistenciaDatos',
				'http://tempuri.org/',
				'ObtenerPersistenciaDatos',
				'http://tempuri.org/',
				'ObtenerPersistenciaDatosResponse',
				'EXT_WS_EscritorioDigital.ObtenerPersistenciaDatosResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerPersistenciaDatosResult;
		}

		public EXT_WS_EscritorioDigital_OR.RespuestaObtenerRequerimiento ObtenerRequerimiento(Integer idpersistencia,Integer idrequerimiento,String rutusuario,String usuario) {
			EXT_WS_EscritorioDigital.ObtenerRequerimiento_element request_x = new EXT_WS_EscritorioDigital.ObtenerRequerimiento_element();
			EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element response_x;
			request_x.idpersistencia = idpersistencia;
			request_x.idrequerimiento = idrequerimiento;
			request_x.rutusuario = rutusuario;
			request_x.usuario = usuario;
			Map<String, EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ObtenerRequerimiento',
				'http://tempuri.org/',
				'ObtenerRequerimiento',
				'http://tempuri.org/',
				'ObtenerRequerimientoResponse',
				'EXT_WS_EscritorioDigital.ObtenerRequerimientoResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerRequerimientoResult;
		}

		public EXT_WS_EscritorioDigital_ORs.RespuestaObtenerRequerimientos ObtenerRequerimientos(Integer idpersistencia,Integer idrequerimiento,String rutcliente,String codigofamilia,DateTime fecha,String estado,String sistema,Integer poliza,Integer filainicial,Integer largopagina,String rutusuario,String usuario) {
			EXT_WS_EscritorioDigital.ObtenerRequerimientos_element request_x = new EXT_WS_EscritorioDigital.ObtenerRequerimientos_element();
			EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element response_x;
			request_x.idpersistencia = idpersistencia;
			request_x.idrequerimiento = idrequerimiento;
			request_x.rutcliente = rutcliente;
			request_x.codigofamilia = codigofamilia;
			request_x.fecha = fecha;
			request_x.estado = estado;
			request_x.sistema = sistema;
			request_x.poliza = poliza;
			request_x.filainicial = filainicial;
			request_x.largopagina = largopagina;
			request_x.rutusuario = rutusuario;
			request_x.usuario = usuario;
			Map<String, EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ObtenerRequerimientos',
				'http://tempuri.org/',
				'ObtenerRequerimientos',
				'http://tempuri.org/',
				'ObtenerRequerimientosResponse',
				'EXT_WS_EscritorioDigital.ObtenerRequerimientosResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerRequerimientosResult;
		}

		public EXT_WS_EscritorioDigital.RespuestaValidarPersistencia ValidarPersistencia(String rutusuario,Integer idpersistencia) {
			EXT_WS_EscritorioDigital.ValidarPersistencia_element request_x = new EXT_WS_EscritorioDigital.ValidarPersistencia_element();
			EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element response_x;
			request_x.rutusuario = rutusuario;
			request_x.idpersistencia = idpersistencia;
			Map<String, EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element> response_map_x = new Map<String, EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ValidarPersistencia',
				'http://tempuri.org/',
				'ValidarPersistencia',
				'http://tempuri.org/',
				'ValidarPersistenciaResponse',
				'EXT_WS_EscritorioDigital.ValidarPersistenciaResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidarPersistenciaResult;
		}
	}
	public class ObtenerPersistencia_element {
		public String rutusuario;
		public String usuario;
		public String password;
		public String ip;
		public String useros;
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] password_type_info = new String[]{'password','http://tempuri.org/','string','0','1','false'};
		private String[] ip_type_info = new String[]{'ip','http://tempuri.org/','string','0','1','false'};
		private String[] useros_type_info = new String[]{'useros','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'rutusuario','usuario','password','ip','useros'};
	}
	public class ObtenerPersistenciaDatos_element {
		public String rutusuario;
		public String usuario;
		public String password;
		public String ip;
		public String useros;
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] password_type_info = new String[]{'password','http://tempuri.org/','string','0','1','false'};
		private String[] ip_type_info = new String[]{'ip','http://tempuri.org/','string','0','1','false'};
		private String[] useros_type_info = new String[]{'useros','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'rutusuario','usuario','password','ip','useros'};
	}
	public class ObtenerPersistenciaDatosResponse_element {
		public EXT_WS_EscritorioDigital.RespuestaObtenerPersistenciaDatos ObtenerPersistenciaDatosResult;
		private String[] ObtenerPersistenciaDatosResult_type_info = new String[]{'ObtenerPersistenciaDatosResult','http://tempuri.org/','RespuestaObtenerPersistenciaDatos','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ObtenerPersistenciaDatosResult'};
	}
	public class ObtenerPersistenciaResponse_element {
		public EXT_WS_EscritorioDigital.RespuestaObtenerPersistencia ObtenerPersistenciaResult;
		private String[] ObtenerPersistenciaResult_type_info = new String[]{'ObtenerPersistenciaResult','http://tempuri.org/','RespuestaObtenerPersistencia','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ObtenerPersistenciaResult'};
	}
	public class ObtenerRequerimiento_element {
		public Integer idpersistencia;
		public Integer idrequerimiento;
		public String rutusuario;
		public String usuario;
		private String[] idpersistencia_type_info = new String[]{'idpersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] idrequerimiento_type_info = new String[]{'idrequerimiento','http://tempuri.org/','int','1','1','false'};
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'idpersistencia','idrequerimiento','rutusuario','usuario'};
	}
	public class ObtenerRequerimientoResponse_element {
		public EXT_WS_EscritorioDigital_OR.RespuestaObtenerRequerimiento ObtenerRequerimientoResult;
		private String[] ObtenerRequerimientoResult_type_info = new String[]{'ObtenerRequerimientoResult','http://tempuri.org/','RespuestaObtenerRequerimiento','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ObtenerRequerimientoResult'};
	}
	public class ObtenerRequerimientos_element {
		public Integer idpersistencia;
		public Integer idrequerimiento;
		public String rutcliente;
		public String codigofamilia;
		public DateTime fecha;
		public String estado;
		public String sistema;
		public Integer poliza;
		public Integer filainicial;
		public Integer largopagina;
		public String rutusuario;
		public String usuario;
		private String[] idpersistencia_type_info = new String[]{'idpersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] idrequerimiento_type_info = new String[]{'idrequerimiento','http://tempuri.org/','int','1','1','true'};
		private String[] rutcliente_type_info = new String[]{'rutcliente','http://tempuri.org/','string','0','1','false'};
		private String[] codigofamilia_type_info = new String[]{'codigofamilia','http://tempuri.org/','string','0','1','false'};
		private String[] fecha_type_info = new String[]{'fecha','http://tempuri.org/','dateTime','1','1','true'};
		private String[] estado_type_info = new String[]{'estado','http://tempuri.org/','string','0','1','false'};
		private String[] sistema_type_info = new String[]{'sistema','http://tempuri.org/','string','0','1','false'};
		private String[] poliza_type_info = new String[]{'poliza','http://tempuri.org/','int','1','1','true'};
		private String[] filainicial_type_info = new String[]{'filainicial','http://tempuri.org/','int','1','1','true'};
		private String[] largopagina_type_info = new String[]{'largopagina','http://tempuri.org/','int','1','1','true'};
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'idpersistencia','idrequerimiento','rutcliente','codigofamilia','fecha','estado','sistema','poliza','filainicial','largopagina','rutusuario','usuario'};
	}
	public class ObtenerRequerimientosResponse_element {
		public EXT_WS_EscritorioDigital_ORs.RespuestaObtenerRequerimientos ObtenerRequerimientosResult;
		private String[] ObtenerRequerimientosResult_type_info = new String[]{'ObtenerRequerimientosResult','http://tempuri.org/','RespuestaObtenerRequerimientos','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ObtenerRequerimientosResult'};
	}
	public class RespuestaCambiarEstadoRequerimiento {
		public EXT_WS_EscritorioDigital.Resultado Resultado;
		private String[] Resultado_type_info = new String[]{'Resultado','http://tempuri.org/','Resultado','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'Resultado'};
	}
	public class RespuestaObtenerPersistencia {
		public Integer IdPersistencia;
		public EXT_WS_EscritorioDigital.Resultado Resultado;
		private String[] IdPersistencia_type_info = new String[]{'IdPersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] Resultado_type_info = new String[]{'Resultado','http://tempuri.org/','Resultado','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'IdPersistencia','Resultado'};
	}
	public class RespuestaObtenerPersistenciaDatos {
		public Integer IdPersistencia;
		public EXT_WS_EscritorioDigital.Resultado Resultado;
		public EXT_WS_EscritorioDigital.Usuario Usuario;
		private String[] IdPersistencia_type_info = new String[]{'IdPersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] Resultado_type_info = new String[]{'Resultado','http://tempuri.org/','Resultado','0','1','false'};
		private String[] Usuario_type_info = new String[]{'Usuario','http://tempuri.org/','Usuario','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'IdPersistencia','Resultado','Usuario'};
	}
	public class RespuestaValidarPersistencia {
		public EXT_WS_EscritorioDigital.Resultado Resultado;
		private String[] Resultado_type_info = new String[]{'Resultado','http://tempuri.org/','Resultado','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'Resultado'};
	}
	public class Resultado {
		public String Codigo;
		public String Mensaje;
		public String Excepcion;
		private String[] Codigo_type_info = new String[]{'Codigo','http://tempuri.org/','string','0','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://tempuri.org/','string','0','1','false'};
		private String[] Excepcion_type_info = new String[]{'Excepcion','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Mensaje','Excepcion'};
	}
	public class Usuario {
		public String Rut;
		public String Correo;
		public String NombreUsuario;
		public String Nombres;
		public String Apellidos;
		private String[] Rut_type_info = new String[]{'Rut','http://tempuri.org/','string','0','1','false'};
		private String[] Correo_type_info = new String[]{'Correo','http://tempuri.org/','string','0','1','false'};
		private String[] NombreUsuario_type_info = new String[]{'NombreUsuario','http://tempuri.org/','string','0','1','false'};
		private String[] Nombres_type_info = new String[]{'Nombres','http://tempuri.org/','string','0','1','false'};
		private String[] Apellidos_type_info = new String[]{'Apellidos','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Correo','NombreUsuario','Nombres','Apellidos'};
	}
	public class ValidarPersistencia_element {
		public String rutusuario;
		public Integer idpersistencia;
		private String[] rutusuario_type_info = new String[]{'rutusuario','http://tempuri.org/','string','0','1','false'};
		private String[] idpersistencia_type_info = new String[]{'idpersistencia','http://tempuri.org/','int','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'rutusuario','idpersistencia'};
	}
	public class ValidarPersistenciaResponse_element {
		public EXT_WS_EscritorioDigital.RespuestaValidarPersistencia ValidarPersistenciaResult;
		private String[] ValidarPersistenciaResult_type_info = new String[]{'ValidarPersistenciaResult','http://tempuri.org/','RespuestaValidarPersistencia','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ValidarPersistenciaResult'};
	}
}