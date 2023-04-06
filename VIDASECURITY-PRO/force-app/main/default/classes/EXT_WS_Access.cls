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
public class EXT_WS_Access {
	private static final String s_ns0 = 'http://Security.cl/';
	public class AccessInfo {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public EXT_WS_Access.UserInfo UserInfo;
		public EXT_WS_Access.AppInfo AppInfo;
		public EXT_WS_Access.WebInfo WebInfo;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] UserInfo_type_info = new String[]{'UserInfo',s_ns0,'UserInfo','0','1','false'};
		private transient String[] AppInfo_type_info = new String[]{'AppInfo',s_ns0,'AppInfo','0','1','false'};
		private transient String[] WebInfo_type_info = new String[]{'WebInfo',s_ns0,'WebInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','UserInfo','AppInfo','WebInfo'};
	}
	public class AppInfo {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public String Cup;
		public Double Option;
		public String RolName; 
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] Cup_type_info = new String[]{'Cup',s_ns0,'string','0','1','false'};
		private transient String[] Option_type_info = new String[]{'Option',s_ns0,'double','1','1','false'};
		private transient String[] RolName_type_info = new String[]{'RolName',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','Cup','Option','RolName'};
	}
	public class ArrayOfDatoAplicacion {
		public EXT_WS_Access.DatoAplicacion[] DatoAplicacion;
		private transient String[] DatoAplicacion_type_info = new String[]{'DatoAplicacion',s_ns0,'DatoAplicacion','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'DatoAplicacion'};
	}
	public class ArrayOfDatoRol {
		public EXT_WS_Access.DatoRol[] DatoRol;
		private transient String[] DatoRol_type_info = new String[]{'DatoRol',s_ns0,'DatoRol','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'DatoRol'};
	}
	public class ArrayOfMenu {
		public EXT_WS_Access.Menu[] Menu;
		private transient String[] Menu_type_info = new String[]{'Menu',s_ns0,'Menu','0','-1','true'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'Menu'};
	}
	public class DatoAcceso {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public Boolean AccesoValido;
		public String Mensaje;
		public Boolean Bloqueado;
		public Boolean RecienBloqueado;
		public Integer IdPersistencia;
		public String NombreUsuario;
		public Double Rut;
		public String Dv;
		public String Nombres;
		public String Apellidos;
		public String Correo;
		public EXT_WS_Access.ArrayOfDatoAplicacion ListadoAplicaciones;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] AccesoValido_type_info = new String[]{'AccesoValido',s_ns0,'boolean','1','1','false'};
		private transient String[] Mensaje_type_info = new String[]{'Mensaje',s_ns0,'string','0','1','false'};
		private transient String[] Bloqueado_type_info = new String[]{'Bloqueado',s_ns0,'boolean','1','1','false'};
		private transient String[] RecienBloqueado_type_info = new String[]{'RecienBloqueado',s_ns0,'boolean','1','1','false'};
		private transient String[] IdPersistencia_type_info = new String[]{'IdPersistencia',s_ns0,'int','1','1','false'};
		private transient String[] NombreUsuario_type_info = new String[]{'NombreUsuario',s_ns0,'string','0','1','false'};
		private transient String[] Rut_type_info = new String[]{'Rut',s_ns0,'double','1','1','false'};
		private transient String[] Dv_type_info = new String[]{'Dv',s_ns0,'string','0','1','false'};
		private transient String[] Nombres_type_info = new String[]{'Nombres',s_ns0,'string','0','1','false'};
		private transient String[] Apellidos_type_info = new String[]{'Apellidos',s_ns0,'string','0','1','false'};
		private transient String[] Correo_type_info = new String[]{'Correo',s_ns0,'string','0','1','false'};
		private transient String[] ListadoAplicaciones_type_info = new String[]{'ListadoAplicaciones',s_ns0,'ArrayOfDatoAplicacion','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','AccesoValido','Mensaje','Bloqueado','RecienBloqueado','IdPersistencia','NombreUsuario','Rut','Dv','Nombres','Apellidos','Correo','ListadoAplicaciones'};
	}
	public class DatoAplicacion {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public String Cup;
		public EXT_WS_Access.ArrayOfDatoRol ListadoRoles;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] Cup_type_info = new String[]{'Cup',s_ns0,'string','0','1','false'};
		private transient String[] ListadoRoles_type_info = new String[]{'ListadoRoles',s_ns0,'ArrayOfDatoRol','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','Cup','ListadoRoles'};
	}
	public class DatoRol {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public String Cup;
		public String Codigo;
		public String Descripcion;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] Cup_type_info = new String[]{'Cup',s_ns0,'string','0','1','false'};
		private transient String[] Codigo_type_info = new String[]{'Codigo',s_ns0,'string','0','1','false'};
		private transient String[] Descripcion_type_info = new String[]{'Descripcion',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','Cup','Codigo','Descripcion'};
	}
	public class ExtensionDataObject {
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{};
	}
	public class Login_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class LoginResponse_element {
		public EXT_WS_Access.DatoAcceso LoginResult;
		private transient String[] LoginResult_type_info = new String[]{'LoginResult',s_ns0,'DatoAcceso','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'LoginResult'};
	}
	public class LoginRut_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class LoginRutResponse_element {
		public EXT_WS_Access.DatoAcceso LoginRutResult;
		private transient String[] LoginRutResult_type_info = new String[]{'LoginRutResult',s_ns0,'DatoAcceso','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'LoginRutResult'};
	}
	public class MantienePersistencia_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class MantienePersistenciaResponse_element {
		public Boolean MantienePersistenciaResult;
		private transient String[] MantienePersistenciaResult_type_info = new String[]{'MantienePersistenciaResult',s_ns0,'boolean','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'MantienePersistenciaResult'};
	}
	public class Menu {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public Double Id;
		public String Name;
		public String Description;
		public String Path;
		public Double Order;
		public Boolean Encryption;
		public Boolean Intranet;
		public Boolean Internet;
		public EXT_WS_Access.ArrayOfMenu ListaMenu;
		public Boolean Withpath;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] Id_type_info = new String[]{'Id',s_ns0,'double','1','1','false'};
		private transient String[] Name_type_info = new String[]{'Name',s_ns0,'string','0','1','false'};
		private transient String[] Description_type_info = new String[]{'Description',s_ns0,'string','0','1','false'};
		private transient String[] Path_type_info = new String[]{'Path',s_ns0,'string','0','1','false'};
		private transient String[] Order_type_info = new String[]{'Order',s_ns0,'double','1','1','false'};
		private transient String[] Encryption_type_info = new String[]{'Encryption',s_ns0,'boolean','1','1','false'};
		private transient String[] Intranet_type_info = new String[]{'Intranet',s_ns0,'boolean','1','1','false'};
		private transient String[] Internet_type_info = new String[]{'Internet',s_ns0,'boolean','1','1','false'};
		private transient String[] ListaMenu_type_info = new String[]{'ListaMenu',s_ns0,'ArrayOfMenu','0','1','false'};
		private transient String[] Withpath_type_info = new String[]{'Withpath',s_ns0,'boolean','1','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','Id','Name','Description','Path','Order','Encryption','Intranet','Internet','ListaMenu','Withpath'};
	}
	public class ObtenerMenu_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class ObtenerMenuResponse_element {
		public EXT_WS_Access.ArrayOfMenu ObtenerMenuResult;
		private transient String[] ObtenerMenuResult_type_info = new String[]{'ObtenerMenuResult',s_ns0,'ArrayOfMenu','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerMenuResult'};
	}
	public class ObtenerOpcion_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class ObtenerOpcionResponse_element {
		public String ObtenerOpcionResult;
		private transient String[] ObtenerOpcionResult_type_info = new String[]{'ObtenerOpcionResult',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ObtenerOpcionResult'};
	}
	public class SimularUsuario_element {
		public EXT_WS_Access.AccessInfo informacion;
		public String rutsimular;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] rutsimular_type_info = new String[]{'rutsimular',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion','rutsimular'};
	}
	public class SimularUsuarioResponse_element {
		public EXT_WS_Access.DatoAcceso SimularUsuarioResult;
		private transient String[] SimularUsuarioResult_type_info = new String[]{'SimularUsuarioResult',s_ns0,'DatoAcceso','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'SimularUsuarioResult'};
	}
	public class UserInfo {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public String UserName;
		public Double Rut;
		public String Dv;
		public String Password;
		public Double PersistCode;
		public String Ip;
		public String UserOS;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] UserName_type_info = new String[]{'UserName',s_ns0,'string','0','1','false'};
		private transient String[] Rut_type_info = new String[]{'Rut',s_ns0,'double','1','1','false'};
		private transient String[] Dv_type_info = new String[]{'Dv',s_ns0,'string','0','1','false'};
		private transient String[] Password_type_info = new String[]{'Password',s_ns0,'string','0','1','false'};
		private transient String[] PersistCode_type_info = new String[]{'PersistCode',s_ns0,'double','1','1','false'};
		private transient String[] Ip_type_info = new String[]{'Ip',s_ns0,'string','0','1','false'};
		private transient String[] UserOS_type_info = new String[]{'UserOS',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','UserName','Rut','Dv','Password','PersistCode','Ip','UserOS'};
	}
	public class ValidaAcceso_element {
		public EXT_WS_Access.AccessInfo informacion;
		private transient String[] informacion_type_info = new String[]{'informacion',s_ns0,'AccessInfo','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'informacion'};
	}
	public class ValidaAccesoResponse_element {
		public EXT_WS_Access.DatoAcceso ValidaAccesoResult;
		private transient String[] ValidaAccesoResult_type_info = new String[]{'ValidaAccesoResult',s_ns0,'DatoAcceso','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ValidaAccesoResult'};
	}
	public class WebInfo {
		public EXT_WS_Access.ExtensionDataObject ExtensionData;
		public String SessionId;
		public String Method;
		public String Environment;
		public String Parameters;
		public String Url;
		public String UrlReferrer;
		public String Browser;
		public String Os;
		public Double GeoLatitude;
		public Double GeoLongitude;
		public Boolean IsMobile;
		public String InfoMovile;
		private transient String[] ExtensionData_type_info = new String[]{'ExtensionData',s_ns0,'ExtensionDataObject','0','1','false'};
		private transient String[] SessionId_type_info = new String[]{'SessionId',s_ns0,'string','0','1','false'};
		private transient String[] Method_type_info = new String[]{'Method',s_ns0,'string','0','1','false'};
		private transient String[] Environment_type_info = new String[]{'Environment',s_ns0,'string','0','1','false'};
		private transient String[] Parameters_type_info = new String[]{'Parameters',s_ns0,'string','0','1','false'};
		private transient String[] Url_type_info = new String[]{'Url',s_ns0,'string','0','1','false'};
		private transient String[] UrlReferrer_type_info = new String[]{'UrlReferrer',s_ns0,'string','0','1','false'};
		private transient String[] Browser_type_info = new String[]{'Browser',s_ns0,'string','0','1','false'};
		private transient String[] Os_type_info = new String[]{'Os',s_ns0,'string','0','1','false'};
		private transient String[] GeoLatitude_type_info = new String[]{'GeoLatitude',s_ns0,'double','1','1','false'};
		private transient String[] GeoLongitude_type_info = new String[]{'GeoLongitude',s_ns0,'double','1','1','false'};
		private transient String[] IsMobile_type_info = new String[]{'IsMobile',s_ns0,'boolean','1','1','false'};
		private transient String[] InfoMovile_type_info = new String[]{'InfoMovile',s_ns0,'string','0','1','false'};
		private transient String[] apex_schema_type_info = new String[]{s_ns0,'true','false'};
		private transient String[] field_order_type_info = new String[]{'ExtensionData','SessionId','Method','Environment','Parameters','Url','UrlReferrer','Browser','Os','GeoLatitude','GeoLongitude','IsMobile','InfoMovile'};
	}
	public class WsAccessSoap {
		public String endpoint_x = '';//'http://webservices2.vidasecurity.cl/WsAccess.asmx';
		public Map<String,String> inputHttpHeaders_x;
		public Map<String,String> outputHttpHeaders_x;
		public String clientCertName_x;
		public String clientCert_x;
		public String clientCertPasswd_x;
		public Integer timeout_x;
		private transient String[] ns_map_type_info = new String[]{'http://Security.cl/','EXT_WS_Access'};
		public EXT_WS_Access.DatoAcceso Login(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.Login_element request_x = new EXT_WS_Access.Login_element();
			EXT_WS_Access.LoginResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.LoginResponse_element> response_map_x = new Map<String, EXT_WS_Access.LoginResponse_element>();
			response_map_x.put('response_x', response_x);


			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/Login', // The SOAP action.
				s_ns0, // The request namespace.
				'Login', // The request name.
				s_ns0, // The response namespace.
				'LoginResponse', //  The response name.
				'EXT_WS_Access.LoginResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.LoginResult;
		}
		public EXT_WS_Access.DatoAcceso LoginRut(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.LoginRut_element request_x = new EXT_WS_Access.LoginRut_element();
			EXT_WS_Access.LoginRutResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.LoginRutResponse_element> response_map_x = new Map<String, EXT_WS_Access.LoginRutResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/LoginRut', // The SOAP action.
				s_ns0, // The request namespace.
				'LoginRut', // The request name.
				s_ns0, // The response namespace.
				'LoginRutResponse', //  The response name.
				'EXT_WS_Access.LoginRutResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.LoginRutResult;
		}
		public Boolean MantienePersistencia(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.MantienePersistencia_element request_x = new EXT_WS_Access.MantienePersistencia_element();
			EXT_WS_Access.MantienePersistenciaResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.MantienePersistenciaResponse_element> response_map_x = new Map<String, EXT_WS_Access.MantienePersistenciaResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/MantienePersistencia', // The SOAP action.
				s_ns0, // The request namespace.
				'MantienePersistencia', // The request name.
				s_ns0, // The response namespace.
				'MantienePersistenciaResponse', //  The response name.
				'EXT_WS_Access.MantienePersistenciaResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.MantienePersistenciaResult;
		}
		public EXT_WS_Access.ArrayOfMenu ObtenerMenu(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.ObtenerMenu_element request_x = new EXT_WS_Access.ObtenerMenu_element();
			EXT_WS_Access.ObtenerMenuResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.ObtenerMenuResponse_element> response_map_x = new Map<String, EXT_WS_Access.ObtenerMenuResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/ObtenerMenu', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerMenu', // The request name.
				s_ns0, // The response namespace.
				'ObtenerMenuResponse', //  The response name.
				'EXT_WS_Access.ObtenerMenuResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerMenuResult;
		}
		public String ObtenerOpcion(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.ObtenerOpcion_element request_x = new EXT_WS_Access.ObtenerOpcion_element();
			EXT_WS_Access.ObtenerOpcionResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.ObtenerOpcionResponse_element> response_map_x = new Map<String, EXT_WS_Access.ObtenerOpcionResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}
			
			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/ObtenerOpcion', // The SOAP action.
				s_ns0, // The request namespace.
				'ObtenerOpcion', // The request name.
				s_ns0, // The response namespace.
				'ObtenerOpcionResponse', //  The response name.
				'EXT_WS_Access.ObtenerOpcionResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ObtenerOpcionResult;
		}
		public EXT_WS_Access.DatoAcceso SimularUsuario(EXT_WS_Access.AccessInfo informacion,String rutsimular) {
			EXT_WS_Access.SimularUsuario_element request_x = new EXT_WS_Access.SimularUsuario_element();
			EXT_WS_Access.SimularUsuarioResponse_element response_x;
			request_x.informacion = informacion;
			request_x.rutsimular = rutsimular;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.SimularUsuarioResponse_element> response_map_x = new Map<String, EXT_WS_Access.SimularUsuarioResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/SimularUsuario', // The SOAP action.
				s_ns0, // The request namespace.
				'SimularUsuario', // The request name.
				s_ns0, // The response namespace.
				'SimularUsuarioResponse', //  The response name.
				'EXT_WS_Access.SimularUsuarioResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.SimularUsuarioResult;
		}
		public EXT_WS_Access.DatoAcceso ValidaAcceso(EXT_WS_Access.AccessInfo informacion) {
			EXT_WS_Access.ValidaAcceso_element request_x = new EXT_WS_Access.ValidaAcceso_element();
			EXT_WS_Access.ValidaAccesoResponse_element response_x;
			request_x.informacion = informacion;
		    // A map of key-value pairs that represent the response that the external service sends after receiving the request. In each pair, the key is a response identifier. The value is the response object, which is an instance of a type that is created as part of the auto-generated stub class.
			Map<String, EXT_WS_Access.ValidaAccesoResponse_element> response_map_x = new Map<String, EXT_WS_Access.ValidaAccesoResponse_element>();
			response_map_x.put('response_x', response_x);

			if (!Test.isRunningTest())
			{
				endpoint_x = CLS_OBJ_Parameter.GetValue('EXT_WSACCESS_ENDPOINT');
			}

			WebServiceCallout.invoke(
				this, // stub - An instance of the Apex class that is auto-generated from a WSDL (the stub class).
				request_x, // request - The request to the external service. The request is an instance of a type that is created as part of the auto-generated stub class.
				response_map_x, // response
				new String[]{endpoint_x, //  the URL of the external web service
				'http://Security.cl/ValidaAcceso', // The SOAP action.
				s_ns0, // The request namespace.
				'ValidaAcceso', // The request name.
				s_ns0, // The response namespace.
				'ValidaAccesoResponse', //  The response name.
				'EXT_WS_Access.ValidaAccesoResponse_element'} // The response type.
			);
			response_x = response_map_x.get('response_x');
			return response_x.ValidaAccesoResult;
		}
	}
}