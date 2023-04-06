@isTest
private class TransferirCarteraTest {
	
	static testMethod void transferenciaDeCarteraEntreEjecutivosTest() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().setPropietario(ejecutivo).save();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		TransferirCarteraController controller = new TransferirCarteraController();
		SelectOption de = controller.getTransferirDeOptions().get(0);
		SelectOption a = controller.getTransferirAOptions().get(0);
		controller.transferirDe = de.getValue();
		controller.transferirA = a.getValue();
		controller.obtenerCantidad();
		System.assert(!ApexPages.hasMessages(), ApexPages.getMessages());
		System.assertEquals(1, controller.cantidad, 'La cantidad de cuentas a transferir es incorrecta');
		controller.transferir();
		account.load(new String[]{'OwnerId'});
		System.assertEquals(controller.transferirA, account.get().get('OwnerId'), 'El propietario no fue asignado');
		// Solo para cobertura
		controller.cancelar();
		controller.volverAForm();
		controller.addError('Error message');
		controller.addWarn('Warn message');
			}
}