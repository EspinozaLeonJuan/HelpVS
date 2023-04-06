/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   05-28-2021   Juan Espinoza León   Initial Version
**/
public class PAR_EXT_WS_CM_PrimaNuevoProducto{
	public cls_primaProspecto primaProspecto {get; set;}
	
	public class cls_primaProspecto {
		public String coverageCode {get; set;}	//PMCT
		public String coverageName {get; set;}	//PRESTACIONES MEDICAS CATASTROFICAS (TITULARES)
		public Double coverageRate {get; set;}	//0.0173
		public Double netPremium {get; set;}	//0.173
		public Double ivaPremium {get; set;}	//0.0329
		public Double totalPremium {get; set;}	//0.2059
	}
	public static PAR_EXT_WS_CM_PrimaNuevoProducto parse(String json){
		return (PAR_EXT_WS_CM_PrimaNuevoProducto) System.JSON.deserialize(json, PAR_EXT_WS_CM_PrimaNuevoProducto.class);
	}
}