trigger SurveyTakerTrigger on SurveyTaker__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler().bind(TriggerHandler.AFTER_UPDATE, new EnviaCorreoNotaEncuestaHandler()).manage();
}