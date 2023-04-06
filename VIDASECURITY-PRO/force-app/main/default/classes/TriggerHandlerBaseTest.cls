/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          Integraciones con GCP
* Description:      Clase de prueba para la clase TriggerHandlerBase
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    05/08/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest (seealldata=false)
public with sharing class TriggerHandlerBaseTest {
    /** 
	* @description This method tests the SObjectService methods
	*/
	@isTest static void testAllMethods() {
        TestTriggerHandlerBase cls = new TestTriggerHandlerBase();
        cls.mainEntry(null);
        cls.inProgressEntry(null);
        cls.futureEntry(null);
        cls.execute(null);
    }
}