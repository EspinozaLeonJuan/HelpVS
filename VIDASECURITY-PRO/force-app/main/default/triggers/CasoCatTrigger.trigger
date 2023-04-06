trigger CasoCatTrigger on Caso_Cat__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	new TriggerHandler()
		.bind(TriggerHandler.BEFORE_UPDATE, new BloqueoEdicionCasoCatTerminadoHandler())
		.bind(TriggerHandler.AFTER_INSERT, new ComentarioAPrimeraRespuestaHandler())
		.manage();
}