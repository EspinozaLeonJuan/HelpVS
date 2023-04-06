@isTest
private class CargosAbonosControllerTest {

  static testMethod void contandoValoresSelectores() {
  	Account cuenta = Factory.cuenta.buildInsert();
  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		CargosAbonosController cargosController = new CargosAbonosController(estandarController);
		cargosController.mostrarResPeriodo();
		cargosController.mostrarResMeses();
		System.assertEquals(cargosController.getMonths().size(), 12);
		System.assertEquals(cargosController.getYears().size(), 7);
		System.assertEquals(cargosController.getTipoConsulta().size(), 2);
	}

  static testMethod void cargoAbonosMensuales() {
  	Test.startTest();
  	Account cuenta = Factory.cuenta.buildInsert();
  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
  	System.Pagereference cargosAbonos = Page.CargosAbonos;
  	Test.setCurrentPage(cargosAbonos);
  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		CargosAbonosController cargosController = new CargosAbonosController(estandarController);
		
		cargosController.anios = '2014';
		cargosController.meses = '02';
		cargosController.aniosH = '2015';
		cargosController.mesesH = '04';
		
		List<Movimiento__c> movimientos = cargosController.getCargoAbonoMensuales();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(movimientos.size() >  0);
	}
	
  static testMethod void cargoAbonosPeriodos() {
  	Test.startTest();
  	Account cuenta = Factory.cuenta.buildInsert();
  	Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
  	System.Pagereference cargosAbonosPage = Page.CargosAbonos;
  	Test.setCurrentPage(cargosAbonosPage);
  	ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		CargosAbonosController cargosController = new CargosAbonosController(estandarController);
		
		cargosController.anios = '2014';
		cargosController.meses = '02';
		
		List<CargoAbono__c> cargosAbonos = cargosController.getCargoAbonoPeriodo();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(cargosAbonos.size() >  0);
	}
	
	static testMethod void listasMensuales(){
		Test.startTest();
		Account cuenta = Factory.cuenta.buildInsert();
		Poliza__c poliza = Factory.poliza.buildInsert(new Map<String,Object>{ 'Cuenta__c' => cuenta.Id });
		System.Pagereference cargosAbonosPage = Page.CargosAbonos;
		ApexPages.StandardController estandarController = new ApexPages.StandardController(poliza);
		CargosAbonosController cargosController = new CargosAbonosController(estandarController);
		List<WSCDS.DetalleMovimiento> cargosAbonos = cargosController.getListaMensuales();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() == 0);
		System.assert(cargosAbonos.size() >  0);
	}
}