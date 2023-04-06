trigger ParticipanteTrigger on Participantes_de_Campa_a__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	
    new TriggerHandler()
	.bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
		new IngresaMotivoAnulacionEnPoliza()
	})
	.manage();
}