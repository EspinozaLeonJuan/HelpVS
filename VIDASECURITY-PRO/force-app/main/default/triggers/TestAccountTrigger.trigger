/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:		
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    23/11/2021     Javier Tibamoza JATC 	       Class Updated
***********************************************************************************************************************/
trigger TestAccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	Map<String,Switch_new_functions__mdt> mSwitch = UtilityClass.getSwitchNewFunctions();
    if( !UtilityClass.validateSwitchNewFunctions('newTriggerFactory', mSwitch ) ) {
		new TriggerHandler()
			.bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TestAccountHandler())
			.bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.TriggerInterface[] {
				new TestAsyncHandler()
			})
			.manage();    
	}
}