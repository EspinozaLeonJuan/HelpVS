@isTest
private class LinksControllerTest {

	static LinksController controllerPoliza;
    static LinksController controllerCuenta;
    static LinksController controllerCaso;

	static {
        Factory.crearAccountAnonimo();
        
		Account cuenta = Factory.cuenta.buildInsert();
		Poliza__c poliza = new Poliza__c();
		poliza.Cuenta__c = cuenta.Id;
		insert poliza;
        Case caso = Factory.buildCasoSF('Consultas', cuenta);
        insert caso;
        
		ApexPages.Standardcontroller standardPoliza = new ApexPages.Standardcontroller(poliza);
		controllerPoliza = new LinksController(standardPoliza);
        ApexPages.Standardcontroller standardCuenta = new ApexPages.Standardcontroller(cuenta);
		controllerCuenta = new LinksController(standardCuenta);
        ApexPages.Standardcontroller standardCaso = new ApexPages.Standardcontroller(caso);
		controllerCaso = new LinksController(standardCaso);
	}
    
    // Pólizas
	static testMethod void cartolaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaCartola();
		Test.stopTest();
	}
    
	static testMethod void estadoPagoTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaEstadoPago();
		Test.stopTest();
	}

	static testMethod void DatosPolizaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaDatosPoliza();
		Test.stopTest();
	}

	static testMethod void rentabilidadTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaRentabilidad();
		Test.stopTest();
	}

	static testMethod void trasladosTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaTraslados();
		Test.stopTest();
	}

	static testMethod void valoresCuotaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.aportaValoresCuota();
		Test.stopTest();
	}

	static testMethod void fichaClienteTest() {
		Account account = Factory.cuenta.buildInsert(new Map<String,Object> {'Rut__c' => '16355278', 'DV__c' => '7'});
		controllerPoliza.objectId = account.Id;
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerPoliza.fichaCliente();
		Test.stopTest();
	}
    
    // Cuentas
	static testMethod void rescatesConsultaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerCuenta.rescatesConsulta();
		Test.stopTest();
	}

	static testMethod void siniestrosConsultaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerCuenta.siniestrosConsulta();
		Test.stopTest();
	}
    
    static testMethod void getPolizasCuentaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerCuenta.getPolizasCuenta();
		Test.stopTest();
	}
    
    // Casos
    static testMethod void casoSFTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginMock());
		Test.startTest();
		controllerCaso.getCasoSF();
		Test.stopTest();
	}
    
    //WSAccess
	static testMethod void obtenerMenuTest() {
		Test.setMock(WebServiceMock.class, new WSAccessObtenerMenuMock());
		WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
		Test.startTest();
		service.ObtenerMenu(null);
		Test.stopTest();
	}

	static testMethod void mantienePersistenciaTest() {
		Test.setMock(WebServiceMock.class, new WSAccessMantienePersistenciaMock());
		WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
		Test.startTest();
		service.MantienePersistencia(null);
		Test.stopTest();
	}

	static testMethod void validaAccesoTest() {
		Test.setMock(WebServiceMock.class, new WSAccessValidaAccesoMock());
		WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
		Test.startTest();
		service.ValidaAcceso(null);
		Test.stopTest();
	}

	static testMethod void ObtenerOpcionTest() {
		Test.setMock(WebServiceMock.class, new WSAccessObtenerOpcionMock());
		WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
		Test.startTest();
		service.ObtenerOpcion(null);
		Test.stopTest();
	}

	static testMethod void loginRutTest() {
		Test.setMock(WebServiceMock.class, new WSAccessLoginRutMock());
		WSAccess.WsAccessSoap service = new WSAccess.WsAccessSoap();
		Test.startTest();
		service.LoginRut(null);
		Test.stopTest();
	}

	static testMethod void persistenciaEjecutivaSimulacion() 
    { Test.startTest();
 		
		//Account cuenta = Factory.cuenta.buildInsert();
       
        //ApexPages.Standardcontroller standardCuenta = new ApexPages.Standardcontroller(cuenta);
		//controllerCuenta = new LinksController(standardCuenta);
        LinksController.persistenciaEjecutivaSimulacion('15045517-0', '123'); 
        Test.stopTest();
    }

}