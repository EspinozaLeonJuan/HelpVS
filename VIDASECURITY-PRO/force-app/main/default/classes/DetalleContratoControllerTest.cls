@isTest
private class DetalleContratoControllerTest {

	static testMethod void obtenerContactos() {
		Test.startTest();
		Account cuenta = Factory.cuenta.buildInsert();
		Contact contactoContratante = Factory.contacto.buildInsert(new Map<String,Object>{ 'FirstName' => 'Persona 1',
																																											'LastName' => 'Contratante 1',
																																											'AccountId' => cuenta.Id,
																																					 					  'Rut__c' => '1111111-1' });
		Contact contactoAsegurado = Factory.contacto.buildInsert(new Map<String,Object>{ 'FirstName' => 'Persona 2',
																																											'LastName' => 'Asegurado 1',
																																											'AccountId' => cuenta.Id,
																																					 					  'Rut__c' => '2222222-2' });
		Contact contactoIntermediario = Factory.contacto.buildInsert(new Map<String,Object>{ 'FirstName' => 'Persona 3',
																																											'LastName' => 'Intermediario',
																																											'AccountId' => cuenta.Id,
																																					 					  'Rut__c' => '3333333-3' });
	  Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id,
	  																																			 'Contratante__c' => contactoContratante.Id,
	  																																			 'Asegurado_Titular__c' => contactoAsegurado.Id,
	  																																			 'Intermediario_Poliza__c' => contactoIntermediario.Id});
		ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		System.Pagereference detalleContrato = Page.DetalleContrato;
		Test.setCurrentPage(detalleContrato);
		DetalleContratoController detalleController = new DetalleContratoController(estandarController);
		List<Contact> contactos = detalleController.getContacto();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(contactos.size() > 0);
	}
	
	static testMethod void obtenerListaBeneficiarios(){
		Test.startTest();
		Account cuenta = Factory.cuenta.buildInsert();
	  Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id});
		ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		System.Pagereference detalleContrato = Page.DetalleContrato;
		Test.setCurrentPage(detalleContrato);
		DetalleContratoController detalleController = new DetalleContratoController(estandarController);
		List<Beneficiario__c> beneficiarios = detalleController.getListaBenef();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(beneficiarios.size() > 0);
	}

	static testMethod void obtenerListaDependientes(){
		Test.startTest();
		Account cuenta = Factory.cuenta.buildInsert();
	  Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id});
		ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		System.Pagereference detalleContrato = Page.DetalleContrato;
		Test.setCurrentPage(detalleContrato);
		DetalleContratoController detalleController = new DetalleContratoController(estandarController);
		List<Dependiente__c> dependientes = detalleController.getListaDepend();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(dependientes.size() > 0);
	}

}