@isTest
private class CoberturasControllerTest {

	static testMethod void listaDeCoberturas() {
	  	Test.startTest();
	  	Account cuenta = Factory.cuenta.buildInsert();
	  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
	  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
			System.Pagereference cargosAbonos = Page.Coberturas;
  		Test.setCurrentPage(cargosAbonos);
			CoberturasController coberturasController = new CoberturasController(estandarController);
			List<Cobertura__c> coberturas = coberturasController.getListaCoberturas();
			Test.stopTest();
			System.assert(ApexPages.getMessages().size() == 0);
			System.assert(coberturas.size() > 0);
	}

}