@IsTest
public with sharing class CompromisoPagoTest {
    
    @TestSetup
	public static void init() {
		AccountFabricate cuenta = Cuenta.fabricate().personal();
		ContactFabricate contacto = Contacto.fabricate();
		CorredorFabricate corredor = Corredor.fabricate();
		ListaDeDistribucionFabricate listaDistribucion = ListaDistribucion.fabricate().setCorredor(corredor).setContacto(contacto);
		PolizaFabricate poliza = Poliza.fabricate().colectivos().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().activo().setPoliza(poliza);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()+1).save();
	}

    @IsTest
    public static void testCompromisoPagoController(){
        FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().load(new String[] {'Name', 'Numero_Factura__c', 'Rut_Empresa__c', 'Razon_Social__c', 'Periodo_Cobranza__c', 'Filial__r.Name', 'Fecha_Bloqueo_Beneficios__c', 'Estado_Pago__c', 'Poliza__r.Corredor__c'});
        List<Factura__c> facturas = new List<Factura__c>();
        facturas.add((Factura__c)factura.get());

        Test.setCurrentPage(Page.CompromisoPago);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(facturas);
        stdSetController.setSelected(facturas);
		CompromisoPagoController controller = new CompromisoPagoController(stdSetController);
		controller.init();	
        controller.facturas = facturas;
        controller.fecha = Date.today() + 1;

		Continuation conti = (Continuation)controller.establecerCompromiso();
		System.assertNotEquals(null, conti, 'Ocurrió un error al crear el continuation: ' + ApexPages.getMessages());
		Map<String, HttpRequest> requests = conti.getRequests();
		system.assert(requests.size() == 1);
		system.assert(requests.get(controller.requestLabel) != null);

		// Perform mock callout
		String responseJson = '[{"codigo":0,"descripcion":"Proceso realizado correctamente"}]';
		HttpResponse response = new HttpResponse();
		response.setBody(responseJson);  
		// Set the fake response for the continuation    
		Test.setContinuationResponse(controller.requestLabel, response);
		// Invoke callback method
		Object result = Test.invokeContinuationMethod(controller, conti);
		// result is the return value of the callback
		System.assertEquals(null, result);

		// Verify that the controller's result variable
		//   is set to the mock response.
		//System.assertEquals(responseJson, controller.result);

        Factura__c facturaResult = [SELECT Id, Fecha_Compromiso__c, Fecha_Bloqueo_Beneficios__c FROM Factura__c WHERE Id =: factura.getId()];
        System.assertEquals(Date.today()+1, facturaResult.Fecha_Compromiso__c, 'No se estableció la fecha de compromiso de pago.');
        // Se deja la fecha de bloqueo para el día siguiente al compromiso
        System.assertEquals(Date.today()+2, facturaResult.Fecha_Bloqueo_Beneficios__c);
    }

	@IsTest
	public static void testCompromisoPagoAPI(){
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().load(new String[] {'Filial__r.Rut_Empresa__c', 'Filial__r.DV_Empresa__c','Name', 'Id_Factura__c', 'Numero_Factura__c', 'N_Poliza__c'});
		String responseJson = '[{"codigo":0,"descripcion":"Proceso realizado correctamente"}]';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		Date fechaCompromiso = Date.today();
		Test.startTest();
		IngresarCompromisoPagoRequest request = new IngresarCompromisoPagoRequest((Factura__c)factura.get(), fechaCompromiso);
		IngresarCompromisoPagoResponse[] responses = CompromisoPagoAPI.enviarCompromiso(new IngresarCompromisoPagoRequest[]{ request });
		Test.stopTest();
		System.assertNotEquals(null, responses);
		System.assertEquals(1, responses.size(), 'La cantidad de respuestas del servicio no fue la esperada.');
		IngresarCompromisoPagoResponse response = responses[0];
		System.assertEquals('0', response.codigo, 'La respuesta no fue exitosa.');
		System.assertEquals('Proceso realizado correctamente', response.descripcion);
	}
	
	static testMethod void compromisoPagoAPIIngresarCompromiso() {
		Factura__c factura = [SELECT Id, N_Poliza__c, Filial__r.Rut_Empresa__c, Filial__r.DV_Empresa__c, Name, Id_Factura__c, Numero_Factura__c FROM Factura__c LIMIT 1]; 		
		IngresarCompromisoPagoRequest request = new IngresarCompromisoPagoRequest(factura, Date.today().addDays(5));
		IngresarCompromisoPagoRequest[] requests = new IngresarCompromisoPagoRequest[] {request};
		String responseJson = '[{"codigo":0,"descripcion":"Proceso realizado correctamente"}]';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		Test.startTest();
		IngresarCompromisoPagoResponse[] responses = CompromisoPagoAPI.enviarCompromiso(requests);
		System.assertNotEquals(null, responses, 'La respuesta es nula');
		System.assertNotEquals(0, responses.size(), 'No hubo respuesta');
		responses[0].codFactura = 123;
		responses[0].hasException();
		responses[0].getMessage();
		System.debug(responses[0].toString());
		IngresarCompromisoPagoResponse.parse(responseJson);
		try {
			CompromisoPagoAPI.throwError(true, 'foo');
		} catch (Exception e) {
			
		}
		Test.stopTest();
	}
    }