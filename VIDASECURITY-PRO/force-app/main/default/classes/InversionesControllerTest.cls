@isTest
private class InversionesControllerTest {

	static testMethod void obtenerDetalleConsolidado() {
		Test.startTest();
		Account cuenta = Factory.cuenta.buildInsert();
	  Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id});
		ApexPages.StandardController estandarController = new ApexPages.StandardController(cuenta);
		System.Pagereference inversionesPage = Page.inversiones;
		Test.setCurrentPage(inversionesPage);
		InversionesController inversionesController = new InversionesController(estandarController);
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(inversionesController.resumenConsolidados.size() > 0);
	}

}