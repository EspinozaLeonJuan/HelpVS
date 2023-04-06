@isTest
private class WSCDSTest {

	static testMethod void validateDate() {
		System.assert(WSCDS.isValidDate('20150120'));
	}

	static testMethod void cargosAbonosMensuales(){
		WSCDS.IWsCdsSoap service = WSCDS.getInstance();
		WSCDS.ArrayOfDetalleCargo arr = service.CargosAbonosMensuales(new WSCDS.AccessInfo(), 174567.0d, '201002', '201501');
		System.assertNotEquals(arr, null);
	}
	
	static testMethod void coberturaAsegurado(){
		WSCDS.IWsCdsSoap service = WSCDS.getInstance();
		WSCDS.ArrayOfDetalleCoberturaAsegurado arr = service.CoberturaAsegurado(new WSCDS.AccessInfo(), 174567.0d, 11111111.0d);
		System.assertNotEquals(arr, null);
	}
	
	static testMethod void cubrirWSCDSreales() {
		WSCDS.IWsCdsSoap service = new WSCDS.WsCdsSoap();
		service.ResumenConsolidado(new WSCDS.AccessInfo(),'1111');
		service.ObtieneMovimientos(new WSCDS.AccessInfo(),174567.0d,'20100301','20150302');
		service.CoberturaPolizaIndividual(new WSCDS.AccessInfo(),174567.0d);
		service.DependienteIndividual(new WSCDS.AccessInfo(),174567.0d);
		service.CargosAbonosMensuales(new WSCDS.AccessInfo(),174567.0d,'20100301','20150302');
		service.BeneficiariosIndividuales(new WSCDS.AccessInfo(),174567.0d);
		service.CoberturaAsegurado(new WSCDS.AccessInfo(),174567.0d,174567.0d);
		service.CargoAbonoPoliza(new WSCDS.AccessInfo(),174567.0d,'201502');
	}
}