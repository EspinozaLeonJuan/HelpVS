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
* @version   1.0    28/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class PolizaTriggerDispacher extends TriggerDispatcherBase{
    private static Boolean isBeforeInsertProcessing = false;
	private static Boolean isBeforeUpdateProcessing = false;
	private static Boolean isAfterInsertProcessing = false;
	private static Boolean isAfterUpdateProcessing = false;
	/**
	* @description: Lo llama el framework para realizar las acciones ANTES de que se inserten los registros. Si hay una llamada 
	* que se ejecute en el mismo contexto, la llamada utilizará el controlador que se creó en la llamada original.
	* @param TriggerParameters Contiene los parámetros de activación que incluyen los registros que se van a insertar.
	*/
	public virtual override void beforeInsert(TriggerParameters tp) {
		if(!isBeforeInsertProcessing) {
			isBeforeInsertProcessing = true;
			execute(new PolizaBeforeInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeInsert);
			isBeforeInsertProcessing = false;
		}/*
        else{
            execute(null, tp, TriggerParameters.TriggerEvent.beforeInsert);
        }*/
	}
	/** 
	* @description Lo llama el framework para realizar las acciones ANTES de que se actualicen los registros. Si hay una llamada 
	* que se ejecute en el mismo contexto, la llamada utilizará el controlador que se creó en la llamada original.
	* @param TriggerParameters Contiene los parámetros de activación que incluyen los registros que se van a actualizar.
	*/
	public virtual override void beforeUpdate(TriggerParameters tp) {
		if(!isBeforeUpdateProcessing) {
			isBeforeUpdateProcessing = true;
			execute(new PolizaBeforeUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.beforeUpdate);
			isBeforeUpdateProcessing = false;
		}/*
        else{
			execute(null, tp, TriggerParameters.TriggerEvent.beforeUpdate);
		}*/
	}
	/** 
	* @description Lo llama el framework para realizar las acciones DESPÚES de que se inserten los registros. Si hay una llamada 
	* que se ejecute en el mismo contexto, la llamada utilizará el controlador que se creó en la llamada original.
	* @param TriggerParameters Contiene los parámetros de activación que incluyen los registros que se van a insertar.
	*/
	public virtual override void afterInsert(TriggerParameters tp) {
		if(!isAfterInsertProcessing) {
			isAfterInsertProcessing = true;
			execute(new PolizaAfterInsertTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterInsert);
			isAfterInsertProcessing = false;
		}/*
        else{
			execute(null, tp, TriggerParameters.TriggerEvent.afterInsert);
        }*/
	}
	/** 
	* @description Lo llama el framework para realizar las acciones DESPÚES de que se actualicen los registros. Si hay una llamada 
	* que se ejecute en el mismo contexto, la llamada utilizará el controlador que se creó en la llamada original.
	* @param TriggerParameters Contiene los parámetros de activación que incluyen los registros que se van a actualizar.
	*/	
	public virtual override void afterUpdate(TriggerParameters tp) {
		if(!isAfterUpdateProcessing) {
			isAfterUpdateProcessing = true;
			execute(new PolizaAfterUpdateTriggerHandler(), tp, TriggerParameters.TriggerEvent.afterUpdate);
			isAfterUpdateProcessing = false;
		}/*
        else{
			execute(null, tp, TriggerParameters.TriggerEvent.afterUpdate);
        }*/
	}
}