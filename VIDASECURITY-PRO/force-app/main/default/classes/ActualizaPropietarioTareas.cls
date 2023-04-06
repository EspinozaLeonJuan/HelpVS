/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-26-2022
 * @last modified by  : Juan Espinoza León
**/
public class ActualizaPropietarioTareas implements TriggerHandler.HandlerInterface{

    public void handle() {
        if (Trigger.isUpdate) {
            Set<Id> recordIds = Trigger.newMap.keySet();
            if(!recordIds.isEmpty()){

                String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        		system.debug('@@@@ Task_RecordTypeId '+Task_RecordTypeId);

                Task[] tareas = [SELECT Id, AccountId, OwnerId, Account.OwnerId
                                 FROM Task
                                 WHERE RecordTypeId !=: Task_RecordTypeId AND
                                       (Status = 'No iniciada' OR Status = 'Abierta' OR Status = 'En curso' OR Status = 'Abierto' OR Status = 'No trabajado') AND
                                       AccountId in: recordIds];

                if(tareas.size() > 0){
                    List<Task> tareasUpdate = new List<Task>();

                    for(Task t : tareas){
                        if(t.OwnerId != t.Account.OwnerId){
                            t.OwnerId = t.Account.OwnerId;
                            tareasUpdate.Add(t);
                        }
                    }

                    if(tareasUpdate.Size() > 0)
                        update tareasUpdate;
                }
            }
        }
	}
}