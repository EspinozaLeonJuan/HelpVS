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
public class PAR_EXT_WS_CM_PrimaPoliza
{
	public Double netPremium {get; set;}	//2.7592
	public Double ivaPremium {get; set;}	//0.1804
    public Double totalPrima {get; set;}	//2.9396
    
	public static PAR_EXT_WS_CM_PrimaPoliza parse(String json){
		return (PAR_EXT_WS_CM_PrimaPoliza) System.JSON.deserialize(json, PAR_EXT_WS_CM_PrimaPoliza.class);
	}
}