@IsTest
private class AnulacionTest {
	
	private static void createEmailTemplate(String templateName) {
		EmailTemplate validEmailTemplate = new EmailTemplate();
		validEmailTemplate.isActive = true;
		validEmailTemplate.Name = templateName;
		validEmailTemplate.DeveloperName = templateName;
		validEmailTemplate.TemplateType = 'text';
		validEmailTemplate.FolderId = UserInfo.getUserId();
		validEmailTemplate.Subject = 'Your Subject Here';
		validEmailTemplate.Body = 'Foo';
		insert validEmailTemplate;
	}
	
    @TestSetup
	public static void init() {
		AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
		CorredorFabricate corredor = Corredor.fabricate();
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
		ListaDistribucion.fabricate().notificacionCuenta().setCuenta(cuenta).setContacto(contacto).setTipoDeNotificacion('Anulación Póliza').save();
		ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion('Anulación Póliza').save();
		PolizaFabricate poliza = Poliza.fabricate().colectivos().activa().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().activo().setPoliza(poliza);
		Factura.fabricate()
			.setPoliza(poliza)
			.setFilial(filial)
			.facturada()
			.estadoPagoAbierto()
			.setFechaBloqueoBeneficio(Date.today()-3)
			.setFechaVencimiento(Date.today()-2)
			.setPeriodoCobertura(201906)
			.save();
		Factura.fabricate()
			.setPoliza(poliza)
			.setFilial(filial)
			.facturada()
			.estadoPagoAbierto()
			.setFechaBloqueoBeneficio(Date.today()-3)
			.setFechaVencimiento(Date.today()-2)
			.setPeriodoCobertura(201905)
			.save();
		Factura.fabricate()
			.setPoliza(poliza)
			.setFilial(filial)
			.facturada()
			.estadoPagoAbierto()
			.setFechaBloqueoBeneficio(Date.today()-3)
			.setFechaVencimiento(Date.today()-2)
			.setPeriodoCobertura(201904)
			.save();
	}
	
	static testMethod void testAnulacionController() {
		Test.startTest();
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().load(new String[] {'Name', 'Estatus__c', 'RecordType.Name'});
		ApexPages.StandardController standard = new ApexPages.StandardController(poliza.get());
		AnulacionController controller = new AnulacionController(standard);
		controller.init();
		System.assert(!ApexPages.hasMessages(), ApexPages.getMessages());
		controller.anularPoliza();
		Test.stopTest();
		System.assert(!PageUtils.hasErrors(), ApexPages.getMessages());
		poliza.load(new String[] {'Estatus__c'});
		System.assertEquals('ANULADA', poliza.get('Estatus__c'), 'La póliza no fue anulada.');
	}
	
	static testMethod void testNotificarAnulacionesController() {
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().load(new String[] {'Name', 'Estatus__c', 'RecordType.Name', 'Corredor__c'});
		ApexPages.StandardSetController standard = new ApexPages.StandardSetController(new Poliza__c[] {(Poliza__c)poliza.get()});
				createEmailTemplate('Notificacion_de_Anulacion_Cliente');
		createEmailTemplate('Notificacion_de_Anulacion_Corredor');
		Test.startTest();
		AnulacionController controller = new AnulacionController(standard);
		controller.notificarAnulacion();
		Test.stopTest();
		System.assert(!PageUtils.hasErrors(), ApexPages.getMessages());
		//poliza.load(new String[] {'Estatus__c'});
		//System.assertEquals('ANULADA', poliza.get('Estatus__c'), 'La póliza no fue anulada.');
	}
	
	static testMethod void testNotificarAnulacionController() {
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().load(new String[] {'Name', 'Estatus__c', 'RecordType.Name', 'Corredor__c'});
		ApexPages.StandardController standard = new ApexPages.StandardController(poliza.get());
				createEmailTemplate('Notificacion_de_Anulacion_Cliente');
		createEmailTemplate('Notificacion_de_Anulacion_Corredor');
		Test.startTest();
		AnulacionController controller = new AnulacionController(standard);
		controller.notificarAnulacion();
		Test.stopTest();
		//System.assert(!PageUtils.hasErrors(), ApexPages.getMessages());
		//poliza.load(new String[] {'Estatus__c'});
		//System.assertEquals('ANULADA', poliza.get('Estatus__c'), 'La póliza no fue anulada.');
	}
	
	static testMethod void marcarAnulacionTest() {
		upsert new Notificacion_Procesos__c (SetupOwnerId = Userinfo.getOrganizationId(), Email__c = 'esteban.lopez@gocode.cl');
		AnulacionProcess process = new AnulacionProcess();
		process.execute(null);
		PolizaFabricate poliza = (PolizaFabricate)Poliza.fabricate().load(new String[] {'Es_Anulable__c'});
		System.assertEquals(true, poliza.get('Es_Anulable__c'), 'La póliza no se marcó como anulable.');
	}
	
	static testMethod void emailExceptionTest() {
		try {
			throw new EmailException('Test');
		} catch (Exception e) {
			
		}
	}
}