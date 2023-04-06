@isTest
private class AsignaAgenteActualAPolizaTest {
	
	static {
		TriggerHandler.enable(AsignaAgenteActualAPolizaHandler.class);
	}
	
	@TestSetup
	static void init() {
		Fabricate.contacto().supervisor().save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').save();
			}
	
	static testMethod void asignaAgenteTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().save();
		Test.startTest();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().setCuenta(account).set('Codigo_Agente__c', '123456').save();
		Test.stopTest();
		poliza.load(new String[] {'Agente_Actual__c'});
		System.assertNotEquals(null, poliza.get().get('Agente_Actual__c'), 'El agente actual no fue asignado');
			}
}