trigger ContactoTrigger on Contact (before insert, before update, before delete, after insert, after update, after delete, after undelete) {

  If (Trigger.isAfter && (Trigger.isUpdate || Trigger.isInsert)) {
    ContactTriggerHandler.crearTareaBirthday(Trigger.newMap);
  }

  new TriggerHandler()
  .bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.TriggerInterface[] {
    new AsignaSupervisorAContactoHandler(),
  new AsignaCorredoresAContactoHandler()
    })
  .bind(TriggerHandler.AFTER_ALL_EVENTS_EXCEPT_INSERT, new TriggerHandler.TriggerInterface[] {
    new DesvinculaAgenteHandler()
  })
  .manage();
}