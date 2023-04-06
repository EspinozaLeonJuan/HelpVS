@isTest
private class LlenadoAutomaticoColectivosTest {

	private static AbstractFabricate cuentaCorporativa;
	private static AbstractFabricate cuentaPersonal;
	private static AbstractFabricate cuentaAnonima;
	private static AbstractFabricate corredor;
	private static AbstractFabricate contactoCorredor;
	private static AbstractFabricate contactoEmpresa;

	static {
		TriggerHandler.enable();

		cuentaAnonima = Fabricate.cuenta().anonima().save();
		cuentaCorporativa = Fabricate.cuenta().corporativa().save();
		corredor = Fabricate.corredor().save();

		//cuentaCorporativa.set('Corredor__c', corredor.get().Id).updatesNoCatch(); //por eliminacion de relacion cuenta-corredor
	}

	@isTest
	static void cuandoCreaContactoAseguradoConCorredor() {
		cuentaPersonal = Fabricate.cuenta().
															 personal().
															 set('Cuenta_Corporativa__c', cuentaCorporativa.get().Id).
															 set('PersonEmail','asegurado@security.cl').
															 save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().
																					email2CaseColectivos('Contacto Asegurado', 'asegurado@security.cl').
																					save();
		Test.stopTest();
		Case caso = (Case) casoFabricate.reload(new String[] {'AccountId', 'ContactId', 'Corredor__c', 'Contacto_Corredor__c',
																														'Empresa_Asegurada__c'});
		System.assertNotEquals(null, caso);
		System.assertEquals(cuentaPersonal.get().Id, caso.AccountId, 'No se especifico correctamente el cliente en el caso.');
		System.assertEquals(null, caso.ContactId);
		//System.assertEquals(corredor.get().Id, caso.Corredor__c); //por eliminacion de relacion cuenta-corredor
		System.assertEquals(null, caso.Contacto_Corredor__c);
		System.assertEquals(((Account)cuentaCorporativa.get()).Name, caso.Empresa_Asegurada__c);
	}

	@isTest
	static void cuandoCreaContactoCorredor() {
		contactoCorredor = Fabricate.contacto().corredor().
																set('Empresa_Corredora__c', corredor.get().Id).
																set('Email', 'corredor@security.cl').
																save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().
																					email2CaseColectivos('Contacto Corredor', 'corredor@security.cl').
																					save();
		Test.stopTest();
		Case caso = (Case) casoFabricate.reload(new String[] {'AccountId', 'ContactId', 'Corredor__c', 'Contacto_Corredor__c',
																														'Empresa_Asegurada__c'});
		System.assertNotEquals(null, caso);
		System.assertEquals(cuentaAnonima.get().Id, caso.AccountId, 'Se debe especificar la cuenta anonima.');
		System.assertEquals(contactoCorredor.get().Id, caso.ContactId, 'Se debe especificar el contacto corredor en el contacto nativo del caso.');
		System.assertEquals(corredor.get().Id, caso.Corredor__c, 'Se debe especificar la empresa corredora.');
		System.assertEquals(contactoCorredor.get().Id, caso.Contacto_Corredor__c, 'Se debe especificar el contacto corredor en el contacto corredor del caso.');
		System.assertEquals(null, caso.Empresa_Asegurada__c, 'No debe haber empresa aseguradora cuando la cuenta es anonima.');
	}

	@isTest
	static void cuandoCreaContactoEmpresa() {
		contactoEmpresa = Fabricate.contacto().empresa().
																set('AccountId', cuentaCorporativa.get().Id).
																set('Email', 'contacto_empresa@security.cl').
																save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().
																			 email2CaseColectivos('Contacto Empresa', 'contacto_empresa@security.cl').
																			 save();
		Test.stopTest();
		Case caso = (Case) casoFabricate.reload(new String[] {'AccountId', 'ContactId', 'Corredor__c', 'Contacto_Corredor__c',
																														'Empresa_Asegurada__c'});
		System.assertNotEquals(null, caso);
		System.assertEquals(cuentaAnonima.get().Id, caso.AccountId, 'Debe ser manual, la ejecutiva decide a que cuenta asignar.');
		System.assertEquals(contactoEmpresa.get().Id, caso.ContactId, 'Debe ser el contacto empresa (Ejecutiva puede elegir contestar a corredor).');
		//System.assertEquals(corredor.get().Id, caso.Corredor__c, 'Se debe especificar la empresa corredora.'); //por eliminacion de relacion cuenta-corredor
		System.assertEquals(null, caso.Contacto_Corredor__c, 'Contacto corredor manual');
		System.assertEquals(null, caso.Empresa_Asegurada__c, 'Empresa asegurada manual.');
	}

	@isTest
	static void cuandoCreaContactoDesconocido() {
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().
																			 email2CaseColectivos('Contacto Desconocido', 'contacto_desconocido@security.cl').
																			 save();
		Test.stopTest();
		Case caso = (Case) casoFabricate.reload(new String[] {'AccountId', 'ContactId', 'Corredor__c', 'Contacto_Corredor__c',
																														'Empresa_Asegurada__c'});
		System.assertNotEquals(null, caso);
		System.assertEquals(cuentaAnonima.get().Id, caso.AccountId, 'Debe ser manual, la ejecutiva decide a que cuenta asignar.');
		System.assertEquals(null, caso.ContactId, 'Contacto Manual.');
		System.assertEquals(null, caso.Corredor__c, 'Corredor manual.');
		System.assertEquals(null, caso.Contacto_Corredor__c, 'Contacto corredor manual.');
		System.assertEquals(null, caso.Empresa_Asegurada__c, 'Empresa asegurada manual.');

	}

	@isTest
	static void cuandoCreaContactoConMasDeUnRol() {
		cuentaPersonal = Fabricate.cuenta().
													 personal().
													 set('Cuenta_Corporativa__c', cuentaCorporativa.get().Id).
													 set('PersonEmail','contacto_repetido@security.cl').
													 save();
		contactoCorredor = Fabricate.contacto().corredor().
																set('Empresa_Corredora__c', corredor.get().Id).
																set('Email', 'contacto_repetido@security.cl').
																save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().
																			 email2CaseColectivos('Contacto Repetido', 'contacto_repetido@security.cl').
																			 save();
		Test.stopTest();
		Case caso = (Case) casoFabricate.reload(new String[] {'AccountId', 'ContactId', 'Corredor__c', 'Contacto_Corredor__c',
																														'Empresa_Asegurada__c'});
		System.assertNotEquals(null, caso);
		System.assertEquals(cuentaAnonima.get().Id, caso.AccountId, 'Debe ser manual, la ejecutiva decide a que cuenta asignar.');
		System.assertEquals(null, caso.ContactId, 'Contacto Manual.');
		System.assertEquals(null, caso.Corredor__c, 'Corredor manual.');
		System.assertEquals(null, caso.Contacto_Corredor__c, 'Contacto corredor manual.');
		System.assertEquals(null, caso.Empresa_Asegurada__c, 'Empresa asegurada manual.');

	}

}