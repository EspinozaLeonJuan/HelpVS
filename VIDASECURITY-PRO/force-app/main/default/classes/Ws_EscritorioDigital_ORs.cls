public class Ws_EscritorioDigital_ORs {
	public class ArrayOfRequerimiento {
		public Ws_EscritorioDigital_CR.Requerimiento[] Requerimiento;
		private String[] Requerimiento_type_info = new String[]{'Requerimiento','http://escritoriodigital/ObtenerRequerimientos','Requerimiento','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimientos','true','false'};
		private String[] field_order_type_info = new String[]{'Requerimiento'};
	}
    
	public class Requerimiento {
		public Integer IdRequerimiento;
		public String Nombre;
		public String RutCliente;
		public String CodigoTipo;
		public String UsuarioCreacion;
		public String FechaCreacion;
		public String FechaActualizacion;
		public String Estado;
		public Integer Poliza;
		public String UsuarioActualizacion;
		private String[] IdRequerimiento_type_info = new String[]{'IdRequerimiento','http://escritoriodigital/ObtenerRequerimientos','int','1','1','false'};
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] RutCliente_type_info = new String[]{'RutCliente','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] CodigoTipo_type_info = new String[]{'CodigoTipo','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] UsuarioCreacion_type_info = new String[]{'UsuarioCreacion','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] FechaCreacion_type_info = new String[]{'FechaCreacion','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] FechaActualizacion_type_info = new String[]{'FechaActualizacion','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] Estado_type_info = new String[]{'Estado','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] Poliza_type_info = new String[]{'Poliza','http://escritoriodigital/ObtenerRequerimientos','int','1','1','false'};
		private String[] UsuarioActualizacion_type_info = new String[]{'UsuarioActualizacion','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimientos','true','false'};
		private String[] field_order_type_info = new String[]{'IdRequerimiento','Nombre','RutCliente','CodigoTipo','UsuarioCreacion','FechaCreacion','FechaActualizacion','Estado','Poliza','UsuarioActualizacion'};
	}
    
	public class RespuestaObtenerRequerimientos {
		public Ws_EscritorioDigital_ORs.ArrayOfRequerimiento Requerimientos;
		public Ws_EscritorioDigital_Principal.Resultado Resultado;
		private String[] Requerimientos_type_info = new String[]{'Requerimientos','http://escritoriodigital/ObtenerRequerimientos','ArrayOfRequerimiento','0','1','false'};
		private String[] Resultado_type_info = new String[]{'Resultado','http://escritoriodigital/ObtenerRequerimientos','Resultado','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimientos','true','false'};
		private String[] field_order_type_info = new String[]{'Requerimientos','Resultado'};
	}
    
	public class Resultado {
		public String Codigo;
		public String Mensaje;
		public String Excepcion;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] Excepcion_type_info = new String[]{'Excepcion','http://escritoriodigital/ObtenerRequerimientos','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimientos','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Mensaje','Excepcion'};
	}
}