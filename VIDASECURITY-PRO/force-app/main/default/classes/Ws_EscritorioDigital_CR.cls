public class Ws_EscritorioDigital_CR {
	
    public class Requerimiento {
		public Integer IdRequerimiento;
		private String[] IdRequerimiento_type_info = new String[]{'IdRequerimiento','http://escritoriodigital/CrearRequerimiento','int','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/CrearRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'IdRequerimiento'};
	}
    
	public class RespuestaCrearRequerimiento {
		public Ws_EscritorioDigital_CR.Requerimiento Requerimiento;
		public Ws_EscritorioDigital_Principal.Resultado Resultado;
		private String[] Requerimiento_type_info = new String[]{'Requerimiento','http://escritoriodigital/CrearRequerimiento','Requerimiento','0','1','false'};
		private String[] Resultado_type_info = new String[]{'Resultado','http://escritoriodigital/CrearRequerimiento','Resultado','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/CrearRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Requerimiento','Resultado'};
	}
    
	public class Resultado {
		public String Codigo;
		public String Mensaje;
		public String Excepcion;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/CrearRequerimiento','string','0','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://escritoriodigital/CrearRequerimiento','string','0','1','false'};
		private String[] Excepcion_type_info = new String[]{'Excepcion','http://escritoriodigital/CrearRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/CrearRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Mensaje','Excepcion'};
	}
}