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
public virtual class TriggerDispatcherBase implements ITriggerDispatcher {
    private final static String TRIGGER_HANDLER = 'TriggerHandler';
    private static Map<System.TriggerOperation, ITriggerHandler> operationController = new Map<System.TriggerOperation, ITriggerHandler>();
    // Stores handlers for trigger events
    private static Map<String, Map<TriggerParameters.TriggerEvent, ITriggerHandler>> triggerHandlersMap;
    /** 
	* @description This method is called prior to execution of a before trigger event. If you want 
	* to load any lookup data or cache the data, then this is the place that you need 
	* to put your code. 
	*/
    public virtual void bulkBefore() {}
    public virtual void bulkAfter() {}
    public virtual void andFinally() {}

    public virtual void beforeInsert(TriggerParameters tp) {}
    public virtual void beforeUpdate(TriggerParameters tp) {}
    public virtual void beforeDelete(TriggerParameters tp) {}
    public virtual void afterInsert(TriggerParameters tp) {} 
    public virtual void afterUpdate(TriggerParameters tp) {}
    public virtual void afterDelete(TriggerParameters tp) {}
    public virtual void afterUnDelete(TriggerParameters tp) {}
    
    public virtual void beforeInsert(List<SObject> newRecords) {}
    public virtual void beforeUpdate(List<SObject> newRecords, Map<Id,SObject> oldMap) {}
    public virtual void beforeDelete(List<SObject> newRecords) {}
    public virtual void afterInsert(List<SObject> newRecords) {} 
    public virtual void afterUpdate(List<SObject> newRecords, Map<Id,SObject> oldMap) {}
    public virtual void afterDelete(List<SObject> newRecords) {}
    public virtual void afterUnDelete(List<SObject> newRecords) {}

    public virtual void beforeInsertInProgress(List<SObject> newRecords) {}
    public virtual void beforeUpdateInProgress(List<SObject> newRecords, Map<Id,SObject> oldMap) {}
    public virtual void beforeDeleteInProgress(List<SObject> newRecords) {}
    public virtual void afterInsertInProgress(List<SObject> newRecords) {}
    public virtual void afterUpdateInProgress(List<SObject> newRecords, Map<Id,SObject> oldMap) {}
    public virtual void afterDeleteInProgress(List<SObject> newRecords) {}
    public virtual void afterUnDeleteInProgress(List<SObject> newRecords) {}
    /** 
    * @description execute
    */
    public virtual void execute(TriggerParameters tp) {
        ITriggerHandler handlerInstance = ( operationController.containsKey(tp.tOperation) ? operationController.get(tp.tOperation):null );
        if( handlerInstance == null ) {
            handlerInstance = getTriggerHandlerInstance( tp.triggerObject );					
            operationController.put(tp.tOperation, handlerInstance);
            handlerInstance.mainEntry( tp );
            operationController.remove( tp.tOperation );
        }
    }
    /** 
	* @description Called by the event handlers. If this is the first call in the context, then this method will create a new 
	* instance of the appropriate handler and execute the mainEntry method. If there is an existing call runing 
	* on the same context, then this method will use the existing handler instance created by the original call
	* and execute the inProgressEntry method.
	* @param ITriggerHandler The trigger handler instance. The dispatcher need to pass an instance of the trigger handler, such
	* as AccountAfterInsertTriggerHandler if this is the first call in a given context. If it is retry,
	* then the dispatcher will need to pass null.
	* @param TriggerParameters The trigger parameters passed by the framework.
	* @param TriggerParameters.TriggerEvent The trigger event.
	*/
   	protected void execute(ITriggerHandler handlerInstance, TriggerParameters tp, TriggerParameters.TriggerEvent tEvent) {
        if( handlerInstance != null ) {
            addTriggerHandler(handlerInstance, tEvent, tp.triggerObject);
            /*if( System.isFuture() ){
                handlerInstance.futureEntry(tp);
            }else if (System.isBatch()){
                handlerInstance.batchEntry(tp);
            }
            else if (System.isQueueable()){
                handlerInstance.queueableEntry(tp);
            }
            else if (System.isScheduled()){
                handlerInstance.scheduledEntry(tp);
            }
            else {
                
            }*/
            handlerInstance.mainEntry(tp);
            //handlerInstance.updateObjects();
        }
        else {//reentrant handling
            ITriggerHandler handler = getTriggerHandler(tEvent, tp.triggerObject);
            if( handler != null ){
                handler.inProgressEntry(tp);
            }
        }
    }
    /** 
    * @description Adds ITriggerHandler instance to static map 
    * @param ITriggerHandler The trigger handler instance.
    * @param TriggerParameters.TriggerEvent The trigger event.
    * @param String The API name of the SObject for the trigger event.
    **/
    private static void addTriggerHandler(ITriggerHandler handlerInstance, TriggerParameters.TriggerEvent tEvent, String soType) {
        if (triggerHandlersMap == null) {
            triggerHandlersMap = new Map<String, Map<TriggerParameters.TriggerEvent, ITriggerHandler>>();
        }
        if (!triggerHandlersMap.containsKey(soType)) {
            triggerHandlersMap.put(soType, new Map<TriggerParameters.TriggerEvent, ITriggerHandler>());
        }
        triggerHandlersMap.get(soType).put(tEvent, handlerInstance);
    }
    /** 
    * @description Gets ITriggerHandler instance from static map
    * @param TriggerParameters.TriggerEvent The trigger event.
    * @param String The API name of the SObject for the trigger event.
    * @return ITriggerHandler The ITriggerHandler instance for the trigger event.
    **/
    private static ITriggerHandler getTriggerHandler(TriggerParameters.TriggerEvent tEvent, String soType) {
        if (triggerHandlersMap == null || !triggerHandlersMap.containsKey(soType) || !triggerHandlersMap.get(soType).containsKey(tEvent)) {
            return null;
        }
        return triggerHandlersMap.get(soType).get(tEvent);
    }
    /** 
    * @description 
    * @param String objectName
    * @return ITriggerHandler The ITriggerHandler instance for the trigger event.
    **/
    private ITriggerHandler getTriggerHandlerInstance( String objectName ){
		Type objType = Type.forName(String.format('{0}Entry',new String[]{TRIGGER_HANDLER}));
		if ( objType == null ){
			throw new TriggerHandlerException(String.format('Invalid Type for TriggerHandler [{0}]', new String[]{objectName}));
		}
		return (ITriggerHandler)objType.newInstance();
	}
}