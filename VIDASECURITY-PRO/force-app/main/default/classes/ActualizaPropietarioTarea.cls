/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-26-2022
 * @last modified by  : Juan Espinoza León
**/
public class ActualizaPropietarioTarea {

    @InvocableMethod(label='Actualiza propietario de tareas')
    public static void ActualizaPropietarioTarea(Id[] recordIds){

        if(!recordIds.isEmpty()){

            String  Task_RecordTypeId  = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Ventas Oncológico').getRecordTypeId();
        		system.debug('#### Task_RecordTypeId '+Task_RecordTypeId);

            Account[] cuentas = [SELECT Id, OwnerId FROM Account WHERE Id in: recordIds];
            Task[] tareas = [SELECT Id, AccountId FROM Task WHERE RecordTypeId !=: Task_RecordTypeId AND Status != 'Completada' AND AccountId in: recordIds];

            if(cuentas.size() > 0 && tareas.size() > 0){
                List<Task> tareasUpdate = new List<Task>();

            	Map<Id, Account> cuentasMap = new Map<Id, Account>(cuentas);
                Map<String, List<Task>> tareasMap = new Map<String, List<Task>>();

                for(Task t : tareas){
                    if(tareasMap.get(t.AccountId) == null){
                        tareasMap.put(t.AccountId, new List<Task>());
                    }
                    tareasMap.get(t.AccountId).Add(t);
                }

                for(Id accountId : recordIds){
                    List<Task> tareasDeCuenta = tareasMap.get(accountId);
                    Id propietarioNuevo = cuentasMap.get(accountId).OwnerId;
                    for(Task t : tareasDeCuenta){
                        t.OwnerId = propietarioNuevo;
                    }
                    tareasUpdate.addAll(tareasDeCuenta);
                }
                if(tareasUpdate.Size() > 0)
                    update tareasUpdate;
            }
        }
	}
}