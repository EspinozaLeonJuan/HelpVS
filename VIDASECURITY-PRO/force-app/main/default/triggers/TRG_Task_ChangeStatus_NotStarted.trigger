/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-30-2022
 * @last modified by  : Juan Espinoza León
**/
trigger TRG_Task_ChangeStatus_NotStarted on Task (before insert, before update) {

    if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore){
        try
        {
            String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
            system.debug('@@@@ Task_RecordTypeId '+Task_RecordTypeId);

            for(Task task :  Trigger.new){

                if (task.RecordTypeId == Task_RecordTypeId)
                {
                    if (String.isBlank(task.Status) || task.Status == 'Not Started')
                    {
                        task.Priority = 'Alta';
                        task.Status = 'Abierta';
                    }
                }
            }
        }
        catch(Exception ex)
        {

        }

    }
}