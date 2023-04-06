@isTest
private class ACSELTest {

	@isTest
	static void dado_cambioPropietarioEnCuenta_seRealizaCallout() {
		TriggerHandler.enable(ACSELHandler.class);
		UserFabricate usuarioPostVenta = (UserFabricate)Fabricate.usuario().postVenta().set('Ejecutivo_de_Cliente__c', true).save();
		AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().corporativa().set('OwnerId', (Id)usuarioPostVenta.get().get('Id')).save();
	}


}