/**
 * @File Name          : PAR_UR_CASO.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 6/19/2020, 1:10:22 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/10/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public with sharing class PAR_UR_CASO {
    
    public cls_Eventos Eventos {get; set; }
    
    public class cls_Eventos {
		public boolean EscritorioDigital {get; set; } //
		public boolean EnvioCorreo {get; set; }
		public boolean AdjuntosValuetech {get; set; } //
		public boolean Adjuntos {get; set; } //
		public boolean Comentarios {get; set; }
		public boolean TareasUR {get; set; } //   ojo opcion televenta
		public boolean EnProceso { get; set; }
		public boolean RetornoEjecutiva {get; set; }  
		public boolean Rechazar {get; set; }
		public boolean Cerrar {get; set; }
		public boolean ReasignarResponsable {get; set; } 

		public boolean ActualizaACSEL {get; set; } //

		public boolean Contacto {get; set; } 
		public boolean Propuesta {get; set; } 
		public boolean Asunto {get; set; } 
		public boolean FechaCreacion {get; set; } 
		public boolean Ejecutivo {get; set; } 

		public boolean Canal {get; set; } 

		public boolean FechaCierre {get; set; } 

		public boolean Agente {get; set; } 
		

		public boolean MontoRescate {get; set; }

		public boolean SubEstadoACSEL {get; set; }
	}
	
	public static PAR_UR_Caso parse(String json){
		return (PAR_UR_Caso) System.JSON.deserialize(json, PAR_UR_Caso.class);
	}
/*

static testMethod void testParse() {
		String json=		'{'+
		'	"Eventos" : '+
		'	{ '+
		'		"EscritorioDigital": false, '+
		'		"EnvioCorreo": false, '+
		'		"AdjuntosValuetech": true, '+
		'		"Adjuntos": true, '+
		'		"Comentarios" : true,'+
		'		"TareasUR" : true,'+
		'		"EnProceso" : false, +
		'		"RetornoEjecutiva" : false, +
		'		"Rechazar" : true, '+
		'		"Cerrar" : true, '+
		'       "ActualizaACSEL" : true, '+
		'		"ReasignarResponsable" : true,'+
		'		"Contacto" : true,'+
		'		"Propuesta" : true,'+
		'		"Asunto" : true,'+
		'		"FechaCreacion" : true,'+
		'		"Ejecutivo" : true,'+
		'		"Canal" : true,'+
		'		"FechaCierre" : true,'+
		'		"Agente" : true,'+
		'		"MontoRescate"  : true,'+
		'		"SubEstadoACSEL"  : true'+
		'	}'+
		'}';
		aa obj = parse(json);
		System.assert(obj != null);
	}
	
	*/

	/*
	   "MontoRescate" : N/V/E,'+
	   "SubEstadoACSEL" : N/V/E,'+	
	*/
}