trigger TaskTrigger on Task (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler()
	.bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
					new CopiaCasoSFATareaHandler(),
					new AsignaRutCuentaATaskHandler()
	})
	.bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
					new ActualizaFechaUltimaLlamadaHandler(),
					new AsignaFechaUltimoContactoTaskHandler()
	})
	.manage();
}