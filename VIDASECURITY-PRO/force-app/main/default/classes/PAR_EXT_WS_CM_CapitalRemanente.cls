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
public class PAR_EXT_WS_CM_CapitalRemanente{
    
   	public Decimal principalAmount {get; set;}	
    public Decimal remainingAmount {get; set;}	
    
	public static PAR_EXT_WS_CM_CapitalRemanente parse(String json){
		return (PAR_EXT_WS_CM_CapitalRemanente) System.JSON.deserialize(json, PAR_EXT_WS_CM_CapitalRemanente.class);
	}

}