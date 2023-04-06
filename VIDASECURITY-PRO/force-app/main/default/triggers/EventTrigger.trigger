trigger EventTrigger on Event (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler()
	.bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
				new RutEventHandler(),
				new AsignaRutCuentaATaskYEventHandler()
	})
	.bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
				new NewParticipanteEPAHandler(),
				new AsignaFechaUltimoContactoHandler()
	})
	.manage();
}