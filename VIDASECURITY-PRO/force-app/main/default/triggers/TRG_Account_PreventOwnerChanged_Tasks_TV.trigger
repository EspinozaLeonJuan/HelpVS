/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-30-2022
 * @last modified by  : Juan Espinoza León
**/
trigger TRG_Account_PreventOwnerChanged_Tasks_TV on Account (after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        try
        {
            String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
            system.debug('@@@@ Task_RecordTypeId '+Task_RecordTypeId);

            List <Task> changedTasks = new List <Task> ();

            Set<Id> recordIds = Trigger.newMap.keySet();

            List<Task> lTareas = [SELECT Id, AccountId, OwnerId, Account.OwnerId, Last_Assigned_Owner__c
                FROM Task
                WHERE RecordTypeId =: Task_RecordTypeId AND
                (Status = 'No iniciada' OR Status = 'Abierta' OR Status = 'En curso' OR Status = 'Abierto' OR Status = 'No trabajado') AND
                AccountId in: recordIds];

                for (Task task : lTareas)
                {
                    if (String.isNotBlank(task.Last_Assigned_Owner__c) && task.OwnerId != task.Last_Assigned_Owner__c)
                    {
                        task.OwnerId = task.Last_Assigned_Owner__c;
                        changedTasks.add(task);
                    }
                }


            system.debug('@@@@ preventsTask '+changedTasks);

            if (changedTasks.size() > 0)
            {
                update changedTasks;
            }
        }
        catch(Exception ex)
        {

        }
    }
}