@IsTest
public class DesBloqueoTest {
	
	@TestSetup
	public static void init() {
		AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
		CorredorFabricate corredor = Corredor.fabricate();
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
		ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion('Desbloqueo de Beneficios').save();
		PolizaFabricate poliza = Poliza.fabricate().activa().colectivos().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().bloqueado().setPoliza(poliza);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoPagado().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()+1).save();
		Notificacion_Procesos__c notificacionProcesos = Notificacion_Procesos__c.getOrgDefaults();
		if (notificacionProcesos == null)
			notificacionProcesos = new Notificacion_Procesos__c();
		notificacionProcesos.Email__c = 'mauricio.offermann@gocode.cl';
		upsert notificacionProcesos;
	}

	@IsTest
	public static void testDesBloqueoController(){
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().load(new String[] {'Name', 'Estado_Beneficio__c', 'Grupo_Cobranza__c', 'Rut_Empresa__c', 'Numero_Poliza__c', 'Poliza__r.Corredor__c'});
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(filial.get());
		DesBloqueoController controller = new DesBloqueoController(standardController);
		Continuation conti = (Continuation)controller.desBloquearFilial();
		System.assertNotEquals(null, conti, 'Ocurrió un error al crear el continuation: ' + ApexPages.getMessages());
		Map<String, HttpRequest> requests = conti.getRequests();
		system.assert(requests.size() == 1);
		system.assert(requests.get(controller.requestLabel) != null);
		// Perform mock callout
		String responseJson = '{"codigo":0,"descripcion":"Proceso realizado correctamente"}';
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

        Filial__c filialResult = [SELECT Id, Estado_Beneficio__c FROM Filial__c WHERE Id =: filial.getId() ];
        System.assertEquals('ACTIVO', filialResult.Estado_Beneficio__c);
	}

    @IsTest
    public static void testErrorHandleDesBloqueo(){
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().load(new String[] {'Name'});//.load(new String[] {'Id','MyCustomField__c'});
		
		Test.startTest();
		
		ApexPages.StandardController standardController = new ApexPages.StandardController(filial.get());
		DesBloqueoController controller = new DesBloqueoController(standardController);
        controller.filial = null;
        Object viewResult = controller.desBloquearFilial();
		Test.stopTest();

        //System.assert(viewResult != null);
        //System.assert(false, System.Apexpages.getMessages()[0].getSummary());
        //System.assertEquals('No se han especificado las filiales de bloqueo', System.Apexpages.getMessages()[0].getSummary());
		
	}

	@IsTest
	public static void testDesBloqueoService(){
        FilialFabricate filial = (FilialFabricate)Filial.fabricate().load(new String[] {'Name'});//.load(new String[] {'Id','MyCustomField__c'});
        
		String responseJson = '{"codigo":0,"descripcion":"Proceso realizado correctamente"}';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		Test.startTest();

        DesBloqueoService.desBloquearFiliales();

		Test.stopTest();

        Filial__c filialResult = [SELECT Id, Estado_Beneficio__c FROM Filial__c WHERE Id =: filial.getId() ];
        System.assertEquals('ACTIVO', filialResult.Estado_Beneficio__c);
	}

	@IsTest
	public static void testDesBloqueoProcess(){
		String responseJson = '{"codigo":0,"descripcion":"Proceso realizado correctamente"}';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		
		Test.startTest();
		DesBloqueoProcess process = new DesBloqueoProcess();
	process.execute(null);
		Test.stopTest();
	}
	
	static testMethod void testDesbloqueoAPI() {
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().load(new String[] {'Numero_Poliza__c', 'Rut_Empresa__c', 'Grupo_Cobranza__c'});
		String responseJson = '{"codigo":0,"descripcion":"Proceso realizado correctamente"}';
		Test.setMock(HttpCalloutMock.class, new HttpMock(responseJson));
		Test.startTest();
		EstadoBeneficioRequest request = new EstadoBeneficioRequest((Filial__c)filial.get());
		EstadoBeneficioResponse response = EstadoBeneficioAPI.DesbloquearBeneficio(request);
		Test.stopTest();
		System.assertEquals('0', response.codigo, 'La respuesta no fue exitosa.');
		System.assertEquals('Proceso realizado correctamente', response.descripcion);
	}
			
	static testMethod void testInitContinuationDesbloquearBeneficio() {
		String continuationMethod = 'foo';
		FilialFabricate filial = (FilialFabricate)Filial.fabricate().load(new String[] {'Numero_Poliza__c', 'Rut_Empresa__c', 'Grupo_Cobranza__c'});
		EstadoBeneficioRequest request = new EstadoBeneficioRequest((Filial__c)filial.get());
		Test.startTest();
		ContinuationContext context = EstadoBeneficioAPI.initContinuationDesbloquearBeneficio(request, continuationMethod);
		Test.stopTest();
		System.assertNotEquals(null, context);
		System.assertNotEquals(null, context.continuation);
		System.assertNotEquals(null, context.requestLabel);
	}
	

    @IsTest
    public static void corredorDesbloqueoTest() {
		CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
		Test.startTest();
		ApexPages.StandardController standardController = new ApexPages.StandardController(corredor.get());
		DesBloqueoController controller = new DesBloqueoController(standardController);
		controller.getFiliales();
                		Test.stopTest();
	}

}