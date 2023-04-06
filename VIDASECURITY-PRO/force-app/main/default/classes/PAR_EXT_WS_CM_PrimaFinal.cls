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

public class PAR_EXT_WS_CM_PrimaFinal{
	public cls_primaPoliza primaPoliza {get; set;}
    
    public class cls_primaPoliza {
		public Double netPremium {get; set;}	//0.042
		public Double ivaPremium {get; set;}	//0.008
		public Double totalPrima {get; set;}	//0.05
	}
	public static PAR_EXT_WS_CM_PrimaFinal parse(String json){
		return (PAR_EXT_WS_CM_PrimaFinal) System.JSON.deserialize(json, PAR_EXT_WS_CM_PrimaFinal.class);
	}
}