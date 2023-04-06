public class Ws_EscritorioDigital_OR {
    
	public class Adjunto {
		public String Nombre;
		public String Codigo;
		public Boolean EsOpcional;
		public Boolean Causante;
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] EsOpcional_type_info = new String[]{'EsOpcional','http://escritoriodigital/ObtenerRequerimiento','boolean','1','1','false'};
		private String[] Causante_type_info = new String[]{'Causante','http://escritoriodigital/ObtenerRequerimiento','boolean','1','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Nombre','Codigo','EsOpcional','Causante'};
	}
    
	public class ArrayOfAdjunto {
		public Ws_EscritorioDigital_OR.Adjunto[] Adjunto;
		private String[] Adjunto_type_info = new String[]{'Adjunto','http://escritoriodigital/ObtenerRequerimiento','Adjunto','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Adjunto'};
	}
    
	public class ArrayOfAtributo {
		public Ws_EscritorioDigital_OR.Atributo[] Atributo;
		private String[] Atributo_type_info = new String[]{'Atributo','http://escritoriodigital/ObtenerRequerimiento','Atributo','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Atributo'};
	}
    
	public class ArrayOfBeneficiario {
		public Ws_EscritorioDigital_OR.Beneficiario[] Beneficiario;
		private String[] Beneficiario_type_info = new String[]{'Beneficiario','http://escritoriodigital/ObtenerRequerimiento','Beneficiario','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Beneficiario'};
	}
    
	public class ArrayOfCobertura {
		public Ws_EscritorioDigital_OR.Cobertura[] Cobertura;
		private String[] Cobertura_type_info = new String[]{'Cobertura','http://escritoriodigital/ObtenerRequerimiento','Cobertura','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Cobertura'};
	}
    
	public class ArrayOfFormulario {
		public Ws_EscritorioDigital_OR.Formulario[] Formulario;
		private String[] Formulario_type_info = new String[]{'Formulario','http://escritoriodigital/ObtenerRequerimiento','Formulario','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Formulario'};
	}
    
	public class ArrayOfIndice {
		public Ws_EscritorioDigital_OR.Indice[] Indice;
		private String[] Indice_type_info = new String[]{'Indice','http://escritoriodigital/ObtenerRequerimiento','Indice','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Indice'};
	}
    
	public class ArrayOfString {
		public String[] Perfil;
		private String[] Perfil_type_info = new String[]{'Perfil','http://escritoriodigital/ObtenerRequerimiento','string','0','-1','true'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Perfil'};
	}
    
	public class Asegurado {
		public String Rut;
		public String Nombres;
		public String ApellidoPaterno;
		public String ApellidoMaterno;
		public String Direccion;
		public String Telefono;
		public String Celular;
		public String FechaNacimiento;
		public String Sexo;
		public Ws_EscritorioDigital_OR.Region Region;
		public Ws_EscritorioDigital_OR.Ciudad Ciudad;
		public Ws_EscritorioDigital_OR.Comuna Comuna;
		private String[] Rut_type_info = new String[]{'Rut','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Nombres_type_info = new String[]{'Nombres','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoPaterno_type_info = new String[]{'ApellidoPaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoMaterno_type_info = new String[]{'ApellidoMaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Direccion_type_info = new String[]{'Direccion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Telefono_type_info = new String[]{'Telefono','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Celular_type_info = new String[]{'Celular','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Sexo_type_info = new String[]{'Sexo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Region_type_info = new String[]{'Region','http://escritoriodigital/ObtenerRequerimiento','Region','0','1','false'};
		private String[] Ciudad_type_info = new String[]{'Ciudad','http://escritoriodigital/ObtenerRequerimiento','Ciudad','0','1','false'};
		private String[] Comuna_type_info = new String[]{'Comuna','http://escritoriodigital/ObtenerRequerimiento','Comuna','0','1','false'};
		public Ws_EscritorioDigital_OR.Parentesco Parentesco;
		public Ws_EscritorioDigital_OR.EstadoCivil EstadoCivil;
		public String Email;
		private String[] Parentesco_type_info = new String[]{'Parentesco','http://escritoriodigital/ObtenerRequerimiento','Parentesco','0','1','false'};
		private String[] EstadoCivil_type_info = new String[]{'EstadoCivil','http://escritoriodigital/ObtenerRequerimiento','EstadoCivil','0','1','false'};
		private String[] Email_type_info = new String[]{'Email','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Nombres','ApellidoPaterno','ApellidoMaterno','Direccion','Telefono','Celular','FechaNacimiento','Sexo','Region','Ciudad','Comuna','Parentesco','EstadoCivil','Email'};
	}
    
	public class Atributo {
		public String Nombre;
		public String Valor;
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Nombre','Valor'};
	}
    
	public class Beneficiario {
		public String Rut;
		public String Nombres;
		public String ApellidoPaterno;
		public String ApellidoMaterno;
		public String Direccion;
		public String Telefono;
		public String Celular;
		public String FechaNacimiento;
		public String Sexo;
		public Ws_EscritorioDigital_OR.Region Region;
		public Ws_EscritorioDigital_OR.Ciudad Ciudad;
		public Ws_EscritorioDigital_OR.Comuna Comuna;
		private String[] Rut_type_info = new String[]{'Rut','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Nombres_type_info = new String[]{'Nombres','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoPaterno_type_info = new String[]{'ApellidoPaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoMaterno_type_info = new String[]{'ApellidoMaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Direccion_type_info = new String[]{'Direccion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Telefono_type_info = new String[]{'Telefono','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Celular_type_info = new String[]{'Celular','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Sexo_type_info = new String[]{'Sexo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Region_type_info = new String[]{'Region','http://escritoriodigital/ObtenerRequerimiento','Region','0','1','false'};
		private String[] Ciudad_type_info = new String[]{'Ciudad','http://escritoriodigital/ObtenerRequerimiento','Ciudad','0','1','false'};
		private String[] Comuna_type_info = new String[]{'Comuna','http://escritoriodigital/ObtenerRequerimiento','Comuna','0','1','false'};
		public Ws_EscritorioDigital_OR.Parentesco Parentesco;
		public String Email;
		public String Porcentaje;
		public String Prioridad;
		private String[] Parentesco_type_info = new String[]{'Parentesco','http://escritoriodigital/ObtenerRequerimiento','Parentesco','0','1','false'};
		private String[] Email_type_info = new String[]{'Email','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Porcentaje_type_info = new String[]{'Porcentaje','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Prioridad_type_info = new String[]{'Prioridad','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Nombres','ApellidoPaterno','ApellidoMaterno','Direccion','Telefono','Celular','FechaNacimiento','Sexo','Region','Ciudad','Comuna','Parentesco','Email','Porcentaje','Prioridad'};
	}
    
	public class Ciudad {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Cobertura {
		public String Nombre;
		public String Activa;
		public String CapitalAsegurado;
		public String Prima;
		public String AplicaIVA;
		public String Principal;
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Activa_type_info = new String[]{'Activa','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] CapitalAsegurado_type_info = new String[]{'CapitalAsegurado','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Prima_type_info = new String[]{'Prima','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] AplicaIVA_type_info = new String[]{'AplicaIVA','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Principal_type_info = new String[]{'Principal','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Nombre','Activa','CapitalAsegurado','Prima','AplicaIVA','Principal'};
	}
    
	public class Comuna {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Contratante {
		public String Rut;
		public String Nombres;
		public String ApellidoPaterno;
		public String ApellidoMaterno;
		public String Direccion;
		public String Telefono;
		public String Celular;
		public String FechaNacimiento;
		public String Sexo;
		public Ws_EscritorioDigital_OR.Region Region;
		public Ws_EscritorioDigital_OR.Ciudad Ciudad;
		public Ws_EscritorioDigital_OR.Comuna Comuna;
		private String[] Rut_type_info = new String[]{'Rut','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Nombres_type_info = new String[]{'Nombres','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoPaterno_type_info = new String[]{'ApellidoPaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoMaterno_type_info = new String[]{'ApellidoMaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Direccion_type_info = new String[]{'Direccion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Telefono_type_info = new String[]{'Telefono','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Celular_type_info = new String[]{'Celular','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Sexo_type_info = new String[]{'Sexo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Region_type_info = new String[]{'Region','http://escritoriodigital/ObtenerRequerimiento','Region','0','1','false'};
		private String[] Ciudad_type_info = new String[]{'Ciudad','http://escritoriodigital/ObtenerRequerimiento','Ciudad','0','1','false'};
		private String[] Comuna_type_info = new String[]{'Comuna','http://escritoriodigital/ObtenerRequerimiento','Comuna','0','1','false'};
		public String Email;
		private String[] Email_type_info = new String[]{'Email','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Nombres','ApellidoPaterno','ApellidoMaterno','Direccion','Telefono','Celular','FechaNacimiento','Sexo','Region','Ciudad','Comuna','Email'};
	}
    
	public class EstadoCivil {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Formulario {
		public String Nombre;
		public String Codigo;
		public Boolean RequiereFirma;
		public Boolean EsBinario;
		public String Binario;
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] RequiereFirma_type_info = new String[]{'RequiereFirma','http://escritoriodigital/ObtenerRequerimiento','boolean','1','1','false'};
		private String[] EsBinario_type_info = new String[]{'EsBinario','http://escritoriodigital/ObtenerRequerimiento','boolean','1','1','false'};
		private String[] Binario_type_info = new String[]{'Binario','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Nombre','Codigo','RequiereFirma','EsBinario','Binario'};
	}
    
	public class Indice {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class KeyValue {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Parentesco {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Persona {
		public String Rut;
		public String Nombres;
		public String ApellidoPaterno;
		public String ApellidoMaterno;
		public String Direccion;
		public String Telefono;
		public String Celular;
		public String FechaNacimiento;
		public String Sexo;
		public Ws_EscritorioDigital_OR.Region Region;
		public Ws_EscritorioDigital_OR.Ciudad Ciudad;
		public Ws_EscritorioDigital_OR.Comuna Comuna;
		private String[] Rut_type_info = new String[]{'Rut','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Nombres_type_info = new String[]{'Nombres','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoPaterno_type_info = new String[]{'ApellidoPaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] ApellidoMaterno_type_info = new String[]{'ApellidoMaterno','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Direccion_type_info = new String[]{'Direccion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Telefono_type_info = new String[]{'Telefono','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Celular_type_info = new String[]{'Celular','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] FechaNacimiento_type_info = new String[]{'FechaNacimiento','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Sexo_type_info = new String[]{'Sexo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Region_type_info = new String[]{'Region','http://escritoriodigital/ObtenerRequerimiento','Region','0','1','false'};
		private String[] Ciudad_type_info = new String[]{'Ciudad','http://escritoriodigital/ObtenerRequerimiento','Ciudad','0','1','false'};
		private String[] Comuna_type_info = new String[]{'Comuna','http://escritoriodigital/ObtenerRequerimiento','Comuna','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Nombres','ApellidoPaterno','ApellidoMaterno','Direccion','Telefono','Celular','FechaNacimiento','Sexo','Region','Ciudad','Comuna'};
	}
    
	public class Poliza {
		public Integer NumeroPoliza;
		public String PeriocidadPago;
		public String InicioVigencia;
		public String TerminoVigencia;
		public Ws_EscritorioDigital_OR.Producto Producto;
		private String[] NumeroPoliza_type_info = new String[]{'NumeroPoliza','http://escritoriodigital/ObtenerRequerimiento','int','1','1','false'};
		private String[] PeriocidadPago_type_info = new String[]{'PeriocidadPago','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] InicioVigencia_type_info = new String[]{'InicioVigencia','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] TerminoVigencia_type_info = new String[]{'TerminoVigencia','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Producto_type_info = new String[]{'Producto','http://escritoriodigital/ObtenerRequerimiento','Producto','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'NumeroPoliza','PeriocidadPago','InicioVigencia','TerminoVigencia','Producto'};
	}
    
	public class Producto {
		public String Nombre;
		public Ws_EscritorioDigital_OR.ArrayOfCobertura Coberturas;
		public Ws_EscritorioDigital_OR.ArrayOfAtributo Atributos;
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Coberturas_type_info = new String[]{'Coberturas','http://escritoriodigital/ObtenerRequerimiento','ArrayOfCobertura','0','1','false'};
		private String[] Atributos_type_info = new String[]{'Atributos','http://escritoriodigital/ObtenerRequerimiento','ArrayOfAtributo','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Nombre','Coberturas','Atributos'};
	}
    
	public class Region {
		public String Codigo;
		public String Valor;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Valor_type_info = new String[]{'Valor','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Valor'};
	}
    
	public class Requerimiento {
		public Integer IdRequerimiento;
		public String Nombre;
		public String CodigoTipo;
		public String Negocio;
		public String Archivador;
		public String UsuarioCreacion;
		public String FechaCreacion;
		public String Estado;
		public Ws_EscritorioDigital_OR.Asegurado Asegurado;
		public Ws_EscritorioDigital_OR.Contratante Contratante;
		public Ws_EscritorioDigital_OR.ArrayOfFormulario Formularios;
		public Ws_EscritorioDigital_OR.ArrayOfAdjunto Adjuntos;
		public Ws_EscritorioDigital_OR.ArrayOfIndice Indices;
		public Ws_EscritorioDigital_OR.ArrayOfBeneficiario Beneficiarios;
		public Ws_EscritorioDigital_OR.Poliza Poliza;
		private String[] IdRequerimiento_type_info = new String[]{'IdRequerimiento','http://escritoriodigital/ObtenerRequerimiento','int','1','1','false'};
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] CodigoTipo_type_info = new String[]{'CodigoTipo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Negocio_type_info = new String[]{'Negocio','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Archivador_type_info = new String[]{'Archivador','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] UsuarioCreacion_type_info = new String[]{'UsuarioCreacion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] FechaCreacion_type_info = new String[]{'FechaCreacion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Estado_type_info = new String[]{'Estado','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Asegurado_type_info = new String[]{'Asegurado','http://escritoriodigital/ObtenerRequerimiento','Asegurado','0','1','false'};
		private String[] Contratante_type_info = new String[]{'Contratante','http://escritoriodigital/ObtenerRequerimiento','Contratante','0','1','false'};
		private String[] Formularios_type_info = new String[]{'Formularios','http://escritoriodigital/ObtenerRequerimiento','ArrayOfFormulario','0','1','false'};
		private String[] Adjuntos_type_info = new String[]{'Adjuntos','http://escritoriodigital/ObtenerRequerimiento','ArrayOfAdjunto','0','1','false'};
		private String[] Indices_type_info = new String[]{'Indices','http://escritoriodigital/ObtenerRequerimiento','ArrayOfIndice','0','1','false'};
		private String[] Beneficiarios_type_info = new String[]{'Beneficiarios','http://escritoriodigital/ObtenerRequerimiento','ArrayOfBeneficiario','0','1','false'};
		private String[] Poliza_type_info = new String[]{'Poliza','http://escritoriodigital/ObtenerRequerimiento','Poliza','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'IdRequerimiento','Nombre','CodigoTipo','Negocio','Archivador','UsuarioCreacion','FechaCreacion','Estado','Asegurado','Contratante','Formularios','Adjuntos','Indices','Beneficiarios','Poliza'};
	}
    
	public class RespuestaObtenerRequerimiento {
		public Ws_EscritorioDigital_CR.Requerimiento Requerimiento;
		public Ws_EscritorioDigital_Principal.Resultado Resultado;
		public Ws_EscritorioDigital_OR.Usuario Usuario;
		private String[] Requerimiento_type_info = new String[]{'Requerimiento','http://escritoriodigital/ObtenerRequerimiento','Requerimiento','0','1','false'};
		private String[] Resultado_type_info = new String[]{'Resultado','http://escritoriodigital/ObtenerRequerimiento','Resultado','0','1','false'};
		private String[] Usuario_type_info = new String[]{'Usuario','http://escritoriodigital/ObtenerRequerimiento','Usuario','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Requerimiento','Resultado','Usuario'};
	}
    
	public class Resultado {
		public String Codigo;
		public String Mensaje;
		public String Excepcion;
		private String[] Codigo_type_info = new String[]{'Codigo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Mensaje_type_info = new String[]{'Mensaje','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Excepcion_type_info = new String[]{'Excepcion','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Codigo','Mensaje','Excepcion'};
	}
    
	public class Usuario {
		public String Rut;
		public String Correo;
		public String Alias;
		public String Nombre;
		public String Sucursal;
		public Ws_EscritorioDigital_OR.ArrayOfString Perfiles;
		private String[] Rut_type_info = new String[]{'Rut','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Correo_type_info = new String[]{'Correo','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Alias_type_info = new String[]{'Alias','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Nombre_type_info = new String[]{'Nombre','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Sucursal_type_info = new String[]{'Sucursal','http://escritoriodigital/ObtenerRequerimiento','string','0','1','false'};
		private String[] Perfiles_type_info = new String[]{'Perfiles','http://escritoriodigital/ObtenerRequerimiento','ArrayOfString','0','1','false'};
		private String[] apex_schema_type_info = new String[]{'http://escritoriodigital/ObtenerRequerimiento','true','false'};
		private String[] field_order_type_info = new String[]{'Rut','Correo','Alias','Nombre','Sucursal','Perfiles'};
	}
}