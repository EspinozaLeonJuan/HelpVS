@isTest
private class AsignaCuentaWeb2CaseTest {
	
	static {
		TriggerHandler.enable(AsignaCuentaWeb2CaseHandler.class);
	}
	
	@TestSetup
	static void init() {
		Fabricate.cuenta().anonima().save();
	}

	static testMethod void asignaCuentaAnonimaTest() {
		Test.startTest();
		AbstractFabricate af = Fabricate.caso()
			.set('RUT_Solicitante__c', '13057161-1')
			.set('SuppliedName', 'Mauro')
			.set('SuppliedEmail', 'foo@bar.cl')
			.set('AccountId', null)
			.save();
		Test.stopTest();
		Case caso = (Case)af.reload();
		System.assertNotEquals(null, caso.AccountId);
		Account anonima = [SELECT Name FROM Account WHERE Id = :caso.AccountId];
		System.assertEquals('Anonimo', anonima.Name);
        	}
}