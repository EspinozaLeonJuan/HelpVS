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

public with sharing class TriggerHandlerEntry implements ITriggerHandler {

	private static Map<String,ITriggerDispatcher> runningInstanceList = new Map<String,ITriggerDispatcher>();

	public void mainEntry(TriggerParameters tp) {
		try{
			ITriggerDispatcher handler = getHandlerInstance(tp.dispatcherHandlerName, tp.triggerObject);

			if ( handler != null ){
				switch on tp.tOperation {
					when BEFORE_INSERT {
						handler.beforeInsert( tp.newList );
					}
					when BEFORE_UPDATE {
						handler.beforeUpdate( tp.newList, tp.oldMap );
					}
					when BEFORE_DELETE {
						handler.beforeDelete( tp.newList );
					}
					when AFTER_INSERT {
						handler.afterInsert( tp.newList );
					}
					when AFTER_UPDATE {
						handler.afterUpdate( tp.newList, tp.oldMap );
					}
					when AFTER_DELETE {
						handler.afterDelete( tp.newList );
					}
					when AFTER_UNDELETE {
						handler.afterUndelete( tp.newList );
					}
				}
			}
		}catch( HandlerException te ){
			for ( SObject record : tp.newList ){
				record.addError(te.getMessage());
			}
		}catch( Exception e ){
			for ( SObject record : tp.newList ){
				record.addError('Internal Error:' + e.getMessage());
			}
		}		
	}
	
	public void inProgressEntry(TriggerParameters tp) {
		try{
			ITriggerDispatcher handler = getHandlerInstance(tp.dispatcherHandlerName, tp.triggerObject);
		
			if ( handler != null ){
				switch on tp.tOperation {
					when BEFORE_INSERT {
						handler.beforeInsertInProgress( tp.newList );
					}
					when BEFORE_UPDATE {
						handler.beforeUpdateInProgress( tp.newList, tp.oldMap );
					}
					when BEFORE_DELETE {
						handler.beforeDeleteInProgress( tp.newList );
					}
					when AFTER_INSERT {
						handler.afterInsertInProgress( tp.newList );
					}
					when AFTER_UPDATE {
						handler.afterUpdateInProgress( tp.newList, tp.oldMap );
					}
					when AFTER_DELETE {
						handler.afterDeleteInProgress( tp.newList );
					}
					when AFTER_UNDELETE {
						handler.afterUndeleteInProgress( tp.newList );
					}
				}
			}
		}catch( HandlerException te ){
			for ( SObject record : tp.newList ){
				record.addError(te.getMessage());
			}
		}catch( Exception te ){
			for ( SObject record : tp.newList ){
				record.addError('Internal Error');
			}
		}
	}

	private ITriggerDispatcher getHandlerInstance( String dispacherName, String objectName ){
		String key = String.format('{0}', new String[]{objectName});
		
		if ( runningInstanceList.containsKey(key) ){
			return runningInstanceList.get(key);
		}

		Type objType = Type.forName( dispacherName );
		
		if ( objType == null ){
			return null;
		}
		
		ITriggerDispatcher handler = (ITriggerDispatcher)objType.newInstance();
		runningInstanceList.put( key, handler);
		
		return handler;
	}
	/** 
	* @description Called by asynchronous function. The trigger handlers can choose to ignore this method if they want future entries to behave no differently than main entries.
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public virtual void futureEntry(TriggerParameters tp) {
		mainEntry(tp);
	}
	/** 
	* @description Called execute
	* @param TriggerParameters The trigger parameters such as the list of records before and after the update.
	*/
	public virtual void execute(TriggerParameters tp) {

	}
}