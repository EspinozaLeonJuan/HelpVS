@isTest
private class RutEventTest {
	
	static {
		TriggerHandler.enable(RutEventHandler.class);
	}

	static testMethod void asignaRutAEventoTest() {
		Test.startTest();
		AbstractFabricate eventFabricate = Fabricate.evento()
			.set('WhoId', Fabricate.contacto()
				.set('AccountId', Fabricate.cuenta().corporativa()))
			.save();
		Test.stopTest();
		Event event = (Event)eventFabricate.reload(new String[] {'Rut__c'});
		System.assertNotEquals(null, event.Rut__c);
	}
}