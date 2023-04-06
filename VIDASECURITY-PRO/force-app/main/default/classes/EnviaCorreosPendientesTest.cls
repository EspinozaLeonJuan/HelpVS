@IsTest
private class EnviaCorreosPendientesTest {
	
	@TestSetup
	static void init() {
		UserFabricate owner = (UserFabricate)Fabricate.usuario().postVenta().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().setPropietario(owner).set('Correo_Pendiente_de_Envio__c', true).save();
			}
	
	static testMethod void enviarTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c', 'Correo_Pendiente_de_Envio__c', 'OwnerId'});
		Id ownerId = (Id)account.get().get('OwnerId');
		User postVenta = [SELECT Id FROM User WHERE Id = :ownerId];
		Test.startTest();
		System.runAs(postVenta) {
			EnviaCorreosPendientesController controller = new EnviaCorreosPendientesController();
			controller.getCorreosPendientes();
			controller.enviar();
					}
		Test.stopTest();
		account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c', 'Correo_Pendiente_de_Envio__c', 'OwnerId'});
		System.assertEquals(false, account.get().get('Correo_Pendiente_de_Envio__c'), 'El correo aun está pendiente de envio: ' + ApexPages.getMessages());
		//System.assert(ApexPages.hasMessages())
	}
}