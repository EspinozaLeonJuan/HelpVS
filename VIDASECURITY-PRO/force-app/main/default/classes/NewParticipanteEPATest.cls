@isTest
private class NewParticipanteEPATest {
	
	static {
		TriggerHandler.enable(NewParticipanteEPAHandler.class);
	}
	
	@TestSetup
	static void init() {
		Fabricate.campanaVidaSecurity().epa().save();
	}

	static testMethod void creaParticipanteTest() {
		Test.startTest();
		Event evento = (Event) Fabricate.evento()
			.withContact()
			.set('Visita_Finalizada__c', 'Si')
			.set('Cliente_Molesto__c', 'No')
			.set('Motivo_Visita__c', 'Visita Normal')
			.set('Contactar_a_Cliente__c', 'Si')
			.save()
			.get();
					Test.stopTest();
					System.assertNotEquals(evento.WhoId, 'El contacto no fue asignado');
					Participantes_de_Campa_a__c participante = [SELECT Id, Campa_a_Vida_Security__c FROM Participantes_de_Campa_a__c WHERE Contacto__c = :evento.WhoId];
					System.assertNotEquals(null, participante.Campa_a_Vida_Security__c, 'La campaña no fue asignada');
            }
}