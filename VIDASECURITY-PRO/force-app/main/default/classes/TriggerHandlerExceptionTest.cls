/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      Clase de prueba para la clase DataFactoryService
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    13/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest (seealldata=false)
private class TriggerHandlerExceptionTest {
    @isTest static void testGetSObjectTypeName(){
        try{
            throw new TriggerHandlerException('Error de prueba.');
        }catch(Exception ex){

        }
    }
}