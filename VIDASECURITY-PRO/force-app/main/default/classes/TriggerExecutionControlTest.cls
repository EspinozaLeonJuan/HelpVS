/**
* Globant
* @author           Javier Tibamoza
* @email: 			javier.armando@globant.com
* Project:          
* Description:      Test class for 'BootMakerDynamicJSON'.
*
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    10/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class TriggerExecutionControlTest {
    /**
	 * hasAlreadyDone
	 */
    static testMethod void testHasAlreadyDone(){
        String strTriggerAPIName = 'MessageOutboundTrigger';
        String strTriggerEvent = 'afterUpdate';
        TriggerExecutionControl.hasAlreadyDone(strTriggerAPIName, strTriggerEvent);
    }
    /**
	 * setAlreadyDone
	 */
    static testMethod void testSetAlreadyDone(){
        String strTriggerAPIName = 'MessageOutboundTrigger';
        String strTriggerEvent = 'afterUpdate';
        TriggerExecutionControl.setAlreadyDone(strTriggerAPIName, strTriggerEvent);
    }
    /**
	 * resetTriggerExecutionStatus
	 */
    static testMethod void testResetTriggerExecutionStatus(){
        String strTriggerAPIName = 'MessageOutboundTrigger';
        String strTriggerEvent = 'afterUpdate';
        TriggerExecutionControl.resetTriggerExecutionStatus(strTriggerAPIName, strTriggerEvent);
    }
    /**
	 * Account
	 */
    static testMethod void testSetInactiveObject(){
        String strApiObjectName = 'Account';
        TriggerExecutionControl.setInactiveObject(strApiObjectName);
        Boolean blActive = TriggerExecutionControl.isTriggerActive(strApiObjectName);
    }
}