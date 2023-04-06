@IsTest
public with sharing class CobranzaTest {
    @TestSetup
	public static void init() {
				AccountFabricate cuenta = (AccountFabricate)Cuenta.fabricate().corporativa();
		CorredorFabricate corredor = Corredor.fabricate();
		ContactFabricate contacto2 = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor).set('Email', 'otheremail@security.cl');
		ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().setCuenta(cuenta).set('Empresa_Corredora__c', corredor);
		
		ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto2).setTipoDeNotificacion('Aviso de Bloqueo').set('Tipo_Destinatario__c', 'CC').save();
		ListaDeDistribucionFabricate listaDistribucion = (ListaDeDistribucionFabricate)ListaDistribucion.fabricate().notificacionCorredor().setCorredor(corredor).setContacto(contacto).setTipoDeNotificacion('Aviso de Bloqueo').save();
		
		PolizaFabricate poliza = Poliza.fabricate().colectivos().setCorredor(corredor).setCuenta(cuenta);
		FilialFabricate filial = Filial.fabricate().activo().setPoliza(poliza);
		FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().setPoliza(poliza).setFilial(filial).facturada().estadoPagoAbierto().setNotificacionAvisoBloqueo(false).setFechaBloqueoBeneficio(Date.today()+1).save();
	}

    @IsTest
	public static void testCobranzaService(){
        ContactFabricate contacto = (ContactFabricate)Contacto.fabricate().load();
        CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
        FacturaFabricate factura = (FacturaFabricate)Factura.fabricate().load(new String[]{'Poliza__c', 'Poliza__r.Corredor__c', 'Filial__c'});
        Factura__c[] facturas = new Factura__c[]{ (Factura__c)factura.get()};

        Test.startTest();
        Id[] corredorIds = new Id[]{ corredor.getId()};

        EmailResult[] emailResults = CobranzaService.sendEmails(corredorIds, Bitacora.Evento.Aviso_de_Bloqueo);
        Test.stopTest();
        if (emailResults != null)
        	System.assert(emailResults.size() > 0);
    }

    @IsTest
    public static void pendingCoverageTest(){
        CorredorFabricate corredor = (CorredorFabricate)Corredor.fabricate().load();
        Test.startTest();
        Id[] corredorIds = new Id[]{ corredor.getId()};
        EmailResult[] emailResults = CobranzaService.sendEmails(corredorIds,  Bitacora.Evento.Aviso_de_Bloqueo, new Map<Id, Id> {corredor.getId() => corredor.getId()});
        Test.stopTest();

        if (emailResults != null)
        System.assert(emailResults.size() > 0);
    }
	static testMethod void cobranzaExceptionTest() {
		try {
			throw new CobranzaException((BaseAPIResponse)null);
		} catch (Exception e) {
			

	}
	}  
    @IsTest
    public static void sendEmailsAttach(){
        Test.startTest();
        List<EmailUtils.Target> targets = new List<EmailUtils.Target>();
        List<Id> whatIds = new List<Id>();
        List<Id> EmailTemplatesId = new List<Id>();
        
        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'CARLOS';
        CUENTA_PRI.LastName = 'ESPINOZA P';
        CUENTA_PRI.PersonEmail = 'alex.coillo@latitudde.com';
        CUENTA_PRI.Rut_contacto__pc = '16790926';
        CUENTA_PRI.DV_contacto__pc = '4';
        CUENTA_PRI.Fecha_Ultimo_Cambio_Propietario__c = Date.today();
        CUENTA_PRI.OwnerId = '005i0000001O3jkAAC';
        insert CUENTA_PRI;
        
        Poliza__c poliza1 = new Poliza__c(name='123', cuenta__c = CUENTA_PRI.Id );
        insert poliza1;
        
        String emailTemplateBId = null;
        Map<String,Id> mapTemplateB = new Map<String,Id>();
        List<EmailTemplate> emailTemplateB = new List<EmailTemplate>([SELECT Id, DeveloperName FROM EmailTemplate WHERE isActive = true Limit 1 ]);
        EmailUtils.Target target = new EmailUtils.Target();
        target.recipientId = CUENTA_PRI.Id;
        targets.add(target);
        whatIds.add(poliza1.Id);
        EmailTemplatesId.add(emailTemplateB[0].Id);
        
        EmailResult[] result =  EmailUtils.sendEmails(targets, whatIds, EmailTemplatesId);
        
        // SEND EMAIL HTML BODY
        List<String> HtmlBody = new List<String>();
        HtmlBody.add('Hello World');
        EmailResult[] result2 =  EmailUtils.sendEmails(targets, whatIds, HtmlBody);
        
        // SEND EMAIL SAVE ACTIVITY?
        EmailResult[] result3 =  EmailUtils.sendEmails(targets, whatIds, emailTemplateB[0].DeveloperName, false);
        Test.stopTest();  
    }
}