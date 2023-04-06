/**
 * @File Name          : PAR_UR_BandejaCasos.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Juan Espinoza León
 * @Last Modified On   : 08-30-2021
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
public class PAR_UR_BandejaCasos{
	
    public cls_Filtro Filtro {get; set; }
    
    public cls_Grilla Grilla {get; set; }
			
	public cls_Acciones Acciones {get; set; }

	public cls_Botonera Botonera {get; set; }
            
	public class cls_Filtro {
		public boolean FechaDerivacion {get; set; }
		public boolean HoraDerivacion {get; set; }
        public boolean EstadoCaso {get; set; }
		public boolean Negocio {get; set; }
		public boolean Categoria {get; set; }
		public boolean Solicitud {get; set; }
		public boolean NumeroCaso {get; set; }
		public boolean RUTCaso {get; set; }
		public boolean ClienteNoCliente {get; set; }
		public boolean Poliza {get; set; }
		public boolean Propuesta {get; set; }
		public boolean Origen {get; set; }
		public boolean SubEstadoACSEL {get; set; } 	
		public boolean FiltroBeneficios {get; set; } 	
	}
	
	public  class cls_Grilla {
        public boolean EstadoCaso {get; set; }
        public boolean NumeroCaso {get; set; }
		public boolean Propuesta {get; set; }
		public boolean Poliza {get; set; }
        public boolean RUTCaso {get; set; }
        public boolean ClienteNoCliente {get; set; }        
		public boolean Nombre {get; set; }
		public boolean Negocio {get; set; }
		public boolean Categoria {get; set; }
		public boolean Solicitud {get; set; }
		public boolean FechaCreacion {get; set; }
		public boolean FechaDerivacion {get; set; }
		public boolean FechaAsignacion {get; set; }
		public boolean FechaCierre {get; set; }
		public boolean Agente {get; set; }
		public boolean Ejecutivo {get; set; }
		public boolean Responsable {get; set; }
		public boolean Origen {get; set; }
		public boolean SubEstadoACSEL {get; set; }
		public boolean MontoRescate {get; set; }
	}

	public  class cls_Acciones {
        public boolean ResponsableMultiple {get; set; }
		public boolean CierreMultiple {get; set; }
	}

	public  class cls_Botonera {
        public boolean CasosUR {get; set; }
		public boolean CasosUREnRevision {get; set; }
		public boolean CasosURHistorico {get; set; }
	}

	public static PAR_UR_BandejaCasos parse(String json){
		return (PAR_UR_BandejaCasos) System.JSON.deserialize(json, PAR_UR_BandejaCasos.class);
	}


    /*@isTest static  void testParse() {
		String json=		''+
		'{'+
		'   "Caso" : { "EscritorioDigital": false, "EnvioCorreo": false, "AdjuntosValuetech": true, "Adjuntos": true},'+
		'    "Filtro": { "FechaDerivacion"  : true,'+ "HoraDerivacion"  : true,'+
		'    "EstadoCaso" : false,'+
		'"Negocio"  : false,'+
		'"Categoria"  : false,'+
		'"Solicitud"  : false,'+
		'"NumeroCaso" : false,'+
		'"RutCaso" : false,'+
		'"Cliente"  : false,'+
		'"Poliza"  : false,'+
		'"Propuesta"  : false,'+
		'"Origen"  : false,'+
		'"EstadoAcsel"  : false},'+
		'"Grilla" :'+
		'{'+
		'"Propuesta" : false,'+
		'"Poliza" : false,'+
		'"RUT" : false,'+
		'"Nombre" : false,'+
		'"Negocio" : false,'+
		'"Categoria" : false,'+
		'"Solicitud" : false,'+
		'"FechaCreacion" : false,'+
		'"FechaDerivacion" : false,'+
		'"FechaAsignacion" : false,'+
		'"FechaCierre" : false,'+
		'"Agente" : false,'+
		'"Ejecutivo" : false,'+
		'"Responsable" : false,'+
		'"Origen" : false,'+
		'"EstadoACSEL" : false}'+
		'  '+
		''+
        '}';
        
        system.debug('@@@@ JSON --> '+json);
        PAR_UR_BandejaCasos obj = parse(json);
        
        system.debug('@@@@ obj --> '+obj);

		System.assert(obj != null);
	}*/
}