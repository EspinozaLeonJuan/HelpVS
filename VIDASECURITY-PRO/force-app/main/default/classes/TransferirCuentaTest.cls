@isTest
private class TransferirCuentaTest {
	
	static testMethod void transferenciaDeCuentaTest() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().save();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		TransferirCuentaController controller = new TransferirCuentaController();
		SelectOption a = controller.getTransferirAOptions().get(0);
		controller.rut = '16355278';
		controller.transferirA = a.getValue();
		controller.buscar();
		System.assert(!ApexPages.hasMessages(), ApexPages.getMessages());
		System.assertEquals(1, controller.accounts.size(), 'La cantidad de cuentas a transferir es incorrecta');
		PageReference p = Page.asignacion_de_cartera;
		p.getParameters().put('accountId', account.getId());
		Test.setCurrentPage(p);
		controller.seleccionar();
		
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