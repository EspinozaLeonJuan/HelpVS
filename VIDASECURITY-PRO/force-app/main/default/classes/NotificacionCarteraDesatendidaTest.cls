@IsTest
private class NotificacionCarteraDesatendidaTest {
    	
	@TestSetup
	static void init() {
		Date dateMonthsAgo = Date.today().addMonths(-6);
		String emailTest = 'testmail@example.com';
		//cuenta cliente
		Account cuentaOriginal = Factory.buildAccount('Cuenta personal');
        cuentaOriginal.Rut_contacto__pc = '11111111';
        cuentaOriginal.DV_contacto__pc = '1';
        cuentaOriginal.PersonEmail = emailTest;
        cuentaOriginal.Fecha_Ultima_Actividad__c = dateMonthsAgo;
		insert cuentaOriginal;

		//poliza
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza()
			.individual()
			.conCuenta(cuentaOriginal)
			.activa()
			.save();

		//cuenta ejecutivo
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		Fabricate.cuenta().load().set('OwnerId', ejecutivo).save();

	}
			
	static testMethod void notificacionAsignacionCarteraTest() {
		Test.startTest();
		NotificacionAsignacionCarteraProcess process = new NotificacionAsignacionCarteraProcess();
		process.execute(null);
		Test.stopTest();
		List<Task> tasks = [SELECT Id, OwnerId, AccountId FROM Task];
	}

	static testMethod void notificacionCarteraDesatendida() {
		Test.startTest();
		NotificacionCarteraDesatendidaProcess process = new NotificacionCarteraDesatendidaProcess();
		process.execute(null);
		Test.stopTest();
		List<Task> tasks = [SELECT Id, OwnerId, AccountId FROM Task];
	}
	
}