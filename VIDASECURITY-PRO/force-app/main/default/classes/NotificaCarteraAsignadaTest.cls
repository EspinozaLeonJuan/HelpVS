@IsTest
private class NotificaCarteraAsignadaTest {
	
    	
	@TestSetup
	static void init() {
	}
	
	static testMethod void notificaCarteraAsignadaTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().save();
		account.load(new String[] {'OwnerId'});
		Id ownerId = (Id)account.get('OwnerId');
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		account = (AccountFabricate)Fabricate.cuenta().load().set('OwnerId', ejecutivo).save();
		Test.startTest();
		NotificaCarteraAsignadaController controller = new NotificaCarteraAsignadaController();
		controller.ownerId = ejecutivo.get().Id;
		Account[] accounts = controller.accounts;
		Test.stopTest();
		account.load(new String[] {'Fecha_Ultimo_Cambio_Propietario__c', 'OwnerId', 'Agente_Vigente__c'});
		System.assertEquals(false, account.get('Agente_Vigente__c'), 'El agente vigente no es falso!');
		System.assertNotEquals(ownerId, account.get('OwnerId'), 'Los propietarios no cambiaron');
		System.assertNotEquals(null, account.get('Fecha_Ultimo_Cambio_Propietario__c'), 'La Fecha_Ultimo_Cambio_Propietario__c no es hoy');
		System.assertEquals(1, accounts.size(), 'No se ha notificado la cuenta');
			}
			
			static testMethod void notificaCarteraAsignadaOnInsertTest() {
				UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('OwnerId', ejecutivo).save();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		Test.startTest();
		NotificaCarteraAsignadaController controller = new NotificaCarteraAsignadaController();
		controller.ownerId = ejecutivo.get().Id;
		Account[] accounts = controller.accounts;
		Test.stopTest();
		account.load(new String[] {'Fecha_Ultimo_Cambio_Propietario__c', 'OwnerId', 'Agente_Vigente__c'});
		System.assertEquals(false, account.get('Agente_Vigente__c'), 'El agente vigente no es falso!');
		System.assertNotEquals(null, account.get('Fecha_Ultimo_Cambio_Propietario__c'), 'La Fecha_Ultimo_Cambio_Propietario__c no es hoy');
		System.assertEquals(1, accounts.size(), 'No se ha notificado la cuenta');
			}
    }