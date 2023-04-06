/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-31-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_INV_ResetTaskOwner {

    @InvocableMethod
    public static void ActualizaDatos (List<String> Ids)
    {
        try
        {
            List<Task> lTareas = [SELECT Id, AccountId, OwnerId, Account.OwnerId, Last_Assigned_Owner__c, IsReminderSet, ReminderDateTime FROM Task WHERE Id IN : Ids];

            // RecordTypeId =: Task_RecordTypeId AND
            // (Status = 'No iniciada' OR Status = 'Abierta' OR Status = 'En curso' OR Status = 'Abierto' OR Status = 'No trabajado') AND
            // AccountId in: recordIds

            List <Task> changedTasks = new List <Task> ();

            for (Task task : lTareas)
            {
                if (String.isNotBlank(task.Last_Assigned_Owner__c) && task.OwnerId != task.Last_Assigned_Owner__c)
                {
                    task.OwnerId = task.Last_Assigned_Owner__c;

                    Date startDate = Date.Today();
                    if (task.IsReminderSet == true && task.ReminderDateTime != null)
                    {
                        Date dueDate = task.ReminderDateTime.date();
                        Integer numberDaysDue = startDate.daysBetween(dueDate);

                        if (numberDaysDue < 0)
                        {
                            task.IsReminderSet = false;
                        }
                     }
                    //task.ReminderDateTime = null;
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

   			system.debug('@@@@ Exception Line -->'+ ex.getLineNumber());
            system.debug('@@@@ Exception Causa -->'+ ex.getCause());
            system.debug('@@@@ Exception Mensaje -->'+ ex.getMessage());
        }
    }
}