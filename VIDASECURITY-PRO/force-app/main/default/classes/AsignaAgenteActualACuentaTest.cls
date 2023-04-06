@isTest
private class AsignaAgenteActualACuentaTest {
	
	static {
		TriggerHandler.enable(AsignaAgenteActualACuentaHandler.class);
	}
	
	@TestSetup
	static void init() {
		Fabricate.contacto().supervisor().save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').save();
			}
	
	static testMethod void asignaAgenteTest() {
		Test.startTest();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('Codigo_Agente__c', '123456').save();
		Test.stopTest();
		account.load(new String[] {'Agente_Actual__c', 'Agente_Original__c'});
		System.assertNotEquals(null, account.get().get('Agente_Actual__c'), 'El agente actual no fue asignado');
		System.assertNotEquals(null, account.get().get('Agente_Original__c'), 'El Agente Original no fue asignado');
			}
}