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
public interface ITriggerDispatcher {
    void bulkBefore();
    void bulkAfter();
    void andFinally();

    void beforeInsert(TriggerParameters tp);
    void beforeUpdate(TriggerParameters tp);
    void beforeDelete(TriggerParameters tp);
    void afterInsert(TriggerParameters tp);
    void afterUpdate(TriggerParameters tp);
    void afterDelete(TriggerParameters tp);
    void afterUnDelete(TriggerParameters tp);

    void execute(TriggerParameters tp);

    void beforeInsert(List<SObject> newRecords);
    void beforeUpdate(List<SObject> newRecords, Map<Id,SObject> oldMap);
    void beforeDelete(List<SObject> newRecords);
    void afterInsert(List<SObject> newRecords);
    void afterUpdate(List<SObject> newRecords, Map<Id,SObject> oldMap);
    void afterDelete(List<SObject> newRecords);
    void afterUnDelete(List<SObject> newRecords);
  
    void beforeInsertInProgress(List<SObject> newRecords);
    void beforeUpdateInProgress(List<SObject> newRecords, Map<Id,SObject> oldMap);
    void beforeDeleteInProgress(List<SObject> newRecords );
    void afterInsertInProgress(List<SObject> newRecords);
    void afterUpdateInProgress(List<SObject> newRecords, Map<Id,SObject> oldMap);
    void afterDeleteInProgress(List<SObject> newRecords);
    void afterUnDeleteInProgress(List<SObject> newRecords);
}