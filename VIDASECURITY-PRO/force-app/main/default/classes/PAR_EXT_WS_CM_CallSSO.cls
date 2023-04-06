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
public class PAR_EXT_WS_CM_CallSSO{
	public String access_token {get; set;}	
	public Integer expires_in {get; set;}	
	public Integer refresh_expires_in {get; set;}
	public String refresh_token {get; set;}	
	public String token_type {get; set;}
	//public Integer not-before-policy;	//0
	public String session_state {get; set;}	
	public String scope {get; set;}	//Sites-Clients
    
	public static PAR_EXT_WS_CM_CallSSO parse(String json){
		return (PAR_EXT_WS_CM_CallSSO) System.JSON.deserialize(json, PAR_EXT_WS_CM_CallSSO.class);
	}
   
}