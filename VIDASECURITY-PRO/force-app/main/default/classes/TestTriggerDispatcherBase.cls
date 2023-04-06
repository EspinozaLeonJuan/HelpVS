/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          Integraciones con GCP
* Description:      Clase base para la clase de prueba de la clase TriggerDispatcherBase
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    13/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class TestTriggerDispatcherBase extends TriggerDispatcherBase{

    public TestTriggerDispatcherBase(TriggerParameters tp){
        execute(tp);
    }

    public TestTriggerDispatcherBase(ITriggerHandler handlerInstance, TriggerParameters tp, TriggerParameters.TriggerEvent tEvent){
        execute(handlerInstance, tp, tEvent);
    }
}