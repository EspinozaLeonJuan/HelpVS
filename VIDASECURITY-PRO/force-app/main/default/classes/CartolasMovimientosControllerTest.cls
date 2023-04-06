@isTest
private class CartolasMovimientosControllerTest {

		static testMethod void contandoValoresSelectores() {
	  	Account cuenta = Factory.cuenta.buildInsert();
	  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
	  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
			CartolasMovimientosController cartolasController = new CartolasMovimientosController(estandarController);
			cartolasController.muestraResultado();
			System.assertEquals(cartolasController.movimiento, 'ahoraSi');
			System.assertEquals(cartolasController.getMonths().size(), 12);
			System.assertEquals(cartolasController.getYears().size(), 7);
			System.assertEquals(cartolasController.getTipoConsulta().size(), 2);
		}

		static testMethod void obtieneMovimientos() {
	  	Test.startTest();
	  	Account cuenta = Factory.cuenta.buildInsert();
	  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
	  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
			System.Pagereference cargosAbonos = Page.CartolasMovimientos;
  		Test.setCurrentPage(cargosAbonos);
			CartolasMovimientosController cartolasController = new CartolasMovimientosController(estandarController);
			
			cartolasController.anios = '2010';
			cartolasController.meses = '01';
			cartolasController.aniosH = '2015';
			cartolasController.mesesH = '01';
			
			List<Movimiento__c> movimientos = cartolasController.getMovimientos();
			Test.stopTest();
			System.assert(ApexPages.getMessages().size() == 0);
			System.assert(movimientos.size() > 0);
		}
		
}