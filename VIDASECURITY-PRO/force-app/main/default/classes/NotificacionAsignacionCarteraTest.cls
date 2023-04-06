@IsTest
private class NotificacionAsignacionCarteraTest {
    	
	@TestSetup
	static void init() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().save();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		Fabricate.cuenta().load().set('OwnerId', ejecutivo).save();
	}
			
	static testMethod void notificacionAsignacionCarteraTest() {
		Test.startTest();
		NotificacionAsignacionCarteraProcess process = new NotificacionAsignacionCarteraProcess();
		process.execute(null);
		Test.stopTest();
	}
	
}