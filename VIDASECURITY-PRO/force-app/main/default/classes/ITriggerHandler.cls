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
* @version   1.0    27/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public interface ITriggerHandler {
	void mainEntry(TriggerParameters tp);
	void inProgressEntry(TriggerParameters tp);
	void futureEntry(TriggerParameters tp);
	void execute(TriggerParameters tp);
}