/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      Esta clase proporciona servicios de verificación para métodos de prueba para garantizar que se ejecuten
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    02/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class TestVerificationService {
    /** 
    * @description: This method verifies if a given test method should execute
    * @param: String The full name (Class.Method) of the test method being verified for execution
    * @return: Boolean Determines if given test method should execute
    */
    @TestVisible private static Boolean ShouldExecute(String methodName){
        // Check for any org-specific settings have marked the given method as disabled by dynamically querying custom metadata
        for( SObject disabledTest : Database.query('SELECT DeveloperName FROM DisabledTestClass__mdt WHERE TestMethod__c = \'' + methodName.toLowerCase() + '\'') ){
            // Test method has been disabled
            return false;
        }
        return true;
    }
}