@IsTest
private class AsignaEjecutivoDeClienteTest {
	
	
	static {
		TriggerHandler.enable(AsignaEjecutivoDeClienteHandler.class);
			}
	
	@TestSetup
	static void init() {
		Fabricate.cuenta().personal().save();
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
				Fabricate.ejecutivoDeCliente().setUsuario(ejecutivo).save();
	}
	
	static testMethod void cambiarPorEjecutivoDeClienteTest() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().load('Username', 'user.ejecutivo.cliente@security.cl');
				AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load();
		Test.startTest();
		account.set('OwnerId', ejecutivo.getId()).save();
		Test.stopTest();
		account.load(new String[] {'Ejecutivo_de_Cliente__c'});
		Ejecutivo_de_Cliente__c e = [SELECT Id FROM Ejecutivo_de_Cliente__c WHERE Usuario__c = :ejecutivo.getId() AND Codigo__c <> '0'];
		System.assertEquals(e.Id, account.get('Ejecutivo_de_Cliente__c'), 'Ele ejecutivo de cliente no fue asignado');
	}
    
}