/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 10-04-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-03-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class PAR_EXT_WS_ConsultaPersona {

   // public PAR_EXT_WS_ConsultaPersona() {

    //}

	public class Nombre {
		public String FuenteNombre { get; set; }
		public String Nombres { get; set; }
		public String ApellidoPaterno { get; set; }
		public String ApellidoMaterno { get; set; }
	}

	public class FechaNacimiento {
		public String FuenteFechaNacimiento { get; set; }
		public String FechaNacimiento { get; set; }
	}

	public Integer Codigo { get; set; }
	public String Descripcion { get; set; }
	public Persona Persona { get; set; }

	public class Edad {
		public String FuenteEdad { get; set; }
		public Integer Edad { get; set; }
	}

	public class Persona {
		public String RUT { get; set; }
		public Nombre Nombre { get; set; }
		public Actividad Actividad { get; set; }
		public FechaNacimiento FechaNacimiento { get; set; }
		public Edad Edad { get; set; }
		public FechaDefuncion FechaDefuncion { get; set; }
		public Sexo Sexo { get; set; }
		public Nacionalidad Nacionalidad { get; set; }
		public EstadoCivil EstadoCivil { get; set; }
		public Domicilio Domicilio { get; set; }
	}

	public class Nacionalidad {
		public String FuenteNacionalidad { get; set; }
		public String Nacionalidad { get; set; }
	}

	public class Actividad {
		public String FuenteActividad { get; set; }
		public String Actividad { get; set; }
	}

	public class EstadoCivil {
		public String FuenteEstadoCivil { get; set; }
		public String EstadoCivil { get; set; }
		public String FechaMatrimonio { get; set; }
	}

	public class Domicilio {
		public String FuenteDomicilio { get; set; }
		public String Calle { get; set; }
		public String Comuna { get; set; }
		public String Ciudad { get; set; }
		public String Region { get; set; }
	}

	public class Sexo {
		public String FuenteSexo { get; set; }
		public String Sexo { get; set; }
	}

	public class FechaDefuncion {
		public String FuenteFechaDefuncion { get; set; }
		public String FechaDefuncion { get; set; }
	}

	
	public static PAR_EXT_WS_ConsultaPersona parse(String json) {
		return (PAR_EXT_WS_ConsultaPersona) System.JSON.deserialize(json, PAR_EXT_WS_ConsultaPersona.class);
	}
}