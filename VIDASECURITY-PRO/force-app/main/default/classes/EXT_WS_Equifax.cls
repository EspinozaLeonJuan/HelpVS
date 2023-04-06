//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)
//Methods Included: ConsultaPersona
// Primary Port Class Name: Equifax2Soap	
public class EXT_WS_Equifax {
	public class ConsultaPersona_element {
		public String rut;
		public String usuario;
		public String app;
		private String[] rut_type_info = new String[]{'rut','http://tempuri.org/','string','0','1','false'};
		private String[] usuario_type_info = new String[]{'usuario','http://tempuri.org/','string','0','1','false'};
		private String[] app_type_info = new String[]{'app','http://tempuri.org/','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'rut','usuario','app'};
	}
	public class ConsultaPersonaResponse_element {
		public EXT_WS_Axonaxis.DatosPersona ConsultaPersonaResult;
		private String[] ConsultaPersonaResult_type_info = new String[]{'ConsultaPersonaResult','http://tempuri.org/','DatosPersona','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://tempuri.org/','true','false'};
		private String[] field_order_type_info = new String[]{'ConsultaPersonaResult'};
	}
	public class Equifax2Soap {
		public String endpoint_x = 'http://servicios.vidasecurity.cl/Clientes/Equifax.asmx';
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x;
		private String[] ns_map_type_info = new String[]{'http://tempuri.org/','EXT_WS_Equifax','http://ws.axonaxis.cl/','EXT_WS_Axonaxis'};
		public EXT_WS_Axonaxis.DatosPersona ConsultaPersona(String rut,String usuario,String app) {
			EXT_WS_Equifax.ConsultaPersona_element request_x = new EXT_WS_Equifax.ConsultaPersona_element();
			EXT_WS_Equifax.ConsultaPersonaResponse_element response_x;
			request_x.rut = rut;
			request_x.usuario = usuario;
			request_x.app = app;
			Map<String, EXT_WS_Equifax.ConsultaPersonaResponse_element> response_map_x = new Map<String, EXT_WS_Equifax.ConsultaPersonaResponse_element>();
			response_map_x.put('response_x', response_x);
			WebServiceCallout.invoke(
				this,
				request_x,
				response_map_x,
				new String[]{endpoint_x,
				'http://tempuri.org/ConsultaPersona',
				'http://tempuri.org/',
				'ConsultaPersona',
				'http://tempuri.org/',
				'ConsultaPersonaResponse',
				'EXT_WS_Equifax.ConsultaPersonaResponse_element'}
			);
			response_x = response_map_x.get('response_x');
			return response_x.ConsultaPersonaResult;
		}
	}
}