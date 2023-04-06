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

public class PAR_EXT_WS_CM_Exclusiones{
	public cls_sobrePrima sobrePrima;
	
	public class cls_sobrePrima {
		public String ensuredRut {get; set;}	//19203876-6
		public String product {get; set;}	//MD01972000B003
		public String coverageCode {get; set;}	//PMCN
		public String coverageName {get; set;}	//PRESTACIONES MEDICAS CATASTROFICAS (NO TITULARES)
		public cls_recaDctoExcl[] recaDctoExcl {get; set;}
	}

	public class cls_recaDctoExcl {
		public String actionType {get; set;}	//E
		public String porcentajeMilaje {get; set;}	//
		public Integer extraPremiumFactor {get; set;}	//0
		public Integer extraPremiumAmount {get; set;}	//0
		public String cause {get; set;}	//Cirugía para Miopía gastos asociados, secuelas y complicaciones
	}
    
	public static PAR_EXT_WS_CM_Exclusiones parse(String json){
		return (PAR_EXT_WS_CM_Exclusiones) System.JSON.deserialize(json, PAR_EXT_WS_CM_Exclusiones.class);
	}
}