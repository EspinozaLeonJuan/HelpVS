trigger UserTrigger on User (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler()
	.bind(TriggerHandler.AFTER_UPDATE, new TriggerHandler.TriggerInterface[] {
		new DesactivaEjecutivoHandler()
			})
	.manage();
}