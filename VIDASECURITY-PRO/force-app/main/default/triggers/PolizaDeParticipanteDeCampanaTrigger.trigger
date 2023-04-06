trigger PolizaDeParticipanteDeCampanaTrigger on Poliza_de_Participante_de_Campana__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler().bind(TriggerHandler.AFTER_ALL_EVENTS, new ConcatenaNombreProductoHandler()).manage();    
}