/**
* VASS
* @author           Javier Tibamoza Cubillos
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
global class TriggerExecutionControl {
    // Variable to avoid the trigger execution loop
	public static set<string> setExecutedTriggers = new set<string>();
    public static set<string> setInactiveObjects = new set<string>();
	/** 
     * @description: Indicates if trigger has been fired once in the same thread
    */
	public static boolean hasAlreadyDone( String strTriggerAPIName, String strTriggerEvent ){ 
		return ( !setExecutedTriggers.isEmpty() ? setExecutedTriggers.contains( strTriggerAPIName + strTriggerEvent ) : false );
	}
    /** 
     * @description: Sets that trigger has been fired
    */
	public static void setAlreadyDone( String strTriggerAPIName, String strTriggerEvent ){
		setExecutedTriggers.add( strTriggerAPIName + strTriggerEvent );
	}
    /** 
     * @description: Indicates that trigger has not ran yet (optional)
    */
	public static void resetTriggerExecutionStatus( String strTriggerAPIName, String strTriggerEvent ){
		setExecutedTriggers.remove( strTriggerAPIName + strTriggerEvent );
	}
    /** 
     * @description: 
    */
    public static boolean isTriggerActive( String strApiObjectName ) {
		return ( setInactiveObjects.contains(strApiObjectName) ? false : true );
	}
    /** 
     * @description: Method used to incative a trigger for a specific Sobject
    */
	public static void setInactiveObject(String strApiObjectName){
		setInactiveObjects.add( strApiObjectName );
	}
}