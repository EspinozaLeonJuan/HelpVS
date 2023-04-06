@isTest
private class SolicitarAprobacionDeReclamoTest {
	
	@TestSetup
	static void init() {
			}
			
	static testMethod void solicitaAprobacionSinReclamoTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().save();
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(ApexPages.hasMessages(), 'Debe haber un mensaje de error');
		String message = 'No puede solicitar la aprobación de este caso puesto que no es un reclamo. Asegúrese que el tipo de registro del caso sea "Reclamos".';
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary());
			}

	static testMethod void solicitaAprobacionSinInstanciaTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().reclamo().save();
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(ApexPages.hasMessages(), 'Debe haber un mensaje de error');
		String message = 'No puede solicitar la aprobación de este reclamo puesto que no tiene instancia de reclamo asignada.';
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary());
			}
			
	static testMethod void solicitaAprobacionConPrimeraInstanciaTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().reclamo().save();
		caso.set('Instancia_del_Reclamo__c', 'Primera').save();
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(ApexPages.hasMessages(), 'Debe haber un mensaje de error');
		String message = 'No puede solicitar la aprobación de un reclamo en primera instancia.';
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary());
								}
								
	static testMethod void solicitaAprobacionConReclamoAprobadoTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().reclamo().save();
		caso.set('Instancia_del_Reclamo__c', 'Segunda').set('Aprobado_Reclamo__c', true).save();
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(ApexPages.hasMessages(), 'Debe haber un mensaje de error');
		String message = 'Este reclamo ya se encuentra aprobado.';
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary());
								}
								
	static testMethod void solicitaAprobacionSinCartaClienteTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().reclamo().save();
		caso.set('Instancia_del_Reclamo__c', 'Segunda').set('Aprobado_Reclamo__c', false).save();
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(ApexPages.hasMessages(), 'Debe haber un mensaje de error');
		String message = 'Para poder solicitar la aprobación de este reclamo, primero debe adjuntar la carta de respuesta al cliente. Considere que el nombre del archivo debe comenzar con el texto Respuesta';
		System.assertEquals(message, ApexPages.getMessages()[0].getSummary());
								}
								
	static testMethod void solicitaAprobacionCorrectaTest() {
		CaseFabricate caso = (CaseFabricate) Fabricate.caso().reclamo().save();
		caso.set('Instancia_del_Reclamo__c', 'Segunda').set('Aprobado_Reclamo__c', false).save();
		Attachment attachment = new Attachment(Name='RespuestaClienteABC.txt', Body = Blob.valueOf('Foo'), ParentId = caso.get().Id);
		insert attachment;
		ApexPages.StandardController standard = new ApexPages.StandardController(caso.get());
		SolicitarAprobacionDeReclamoController controller = new SolicitarAprobacionDeReclamoController(standard);
		controller.init();
		System.assert(!ApexPages.hasMessages(), String.valueOf(ApexPages.getMessages()));
								}
}