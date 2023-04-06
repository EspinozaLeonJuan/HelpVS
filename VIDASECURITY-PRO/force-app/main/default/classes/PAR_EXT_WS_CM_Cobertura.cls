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

public class PAR_EXT_WS_CM_Cobertura{
	public cls_primaPoliza primaPoliza { get; set;}
	public class cls_primaPoliza {
		public String rut { get; set;}	//19203876-6
		public String product { get; set;}	//MD01972000B003
		public String flagPolicyHolder { get; set;}	//N
		public cls_coverages[] coverages { get; set;}
    }
    
	public class cls_coverages {
		public String codeCobert { get; set;}	//PMCN
		public String nameCobert { get; set;}	//PRESTACIONES MEDICAS CATASTROFICAS (NO TITULARES)
		//public String currency { get; set;}	//UF
		public Integer capital { get; set;}	//15000
		public Decimal premium { get; set;}	//0
		public Decimal extraPremium { get; set;}	//0
		public String extraPremiumType { get; set;}	//
		public String fecu { get; set;}	//0109
	}
	public static PAR_EXT_WS_CM_Cobertura parse(String json){
		return (PAR_EXT_WS_CM_Cobertura) System.JSON.deserialize(json, PAR_EXT_WS_CM_Cobertura.class);
	}

}