@isTest
private class CasoHibernacionControllerExtensionTest {

	private static Case caso;
	private static Account cuenta;

	static {
		Factory.crearAccountAnonimo();
		cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		caso = Factory.buildCasoSF('Solicitudes', cuenta);
		insert caso;
	}


	@isTest static void validaDiasPorHibernar() {
		caso.Dias_por_hibernar__c = null;
		update caso;
		Test.startTest();
		System.Pagereference hibernarCasoPage = Page.HibernarCaso;
		ApexPages.currentPage().getParameters().put('Id', caso.Id);
		Test.setCurrentPage(hibernarCasoPage);
		ApexPages.standardController controller = new ApexPages.standardController(caso);
		CasoHibernacionControllerExtension controllerExtension = new CasoHibernacionControllerExtension(controller);
		System.Pagereference nextPage = controllerExtension.hibernarCaso();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() > 0);
		System.assert(ApexPages.getMessages().get(0).getSummary().contains('Debe ingresar una cantidad de días para hibernar el caso'), 'El mensaje de error es: ' + ApexPages.getMessages().get(0).getSummary());
		System.assertEquals(null, nextPage);
	}

	@isTest static void validaAreaComercial() {
		caso.Dias_por_hibernar__c = '3';
		caso.Area_comercial__c = null;
		update caso;
		Test.startTest();
		System.Pagereference hibernarCasoPage = Page.HibernarCaso;
		ApexPages.currentPage().getParameters().put('Id', caso.Id);
		Test.setCurrentPage(hibernarCasoPage);
		ApexPages.standardController controller = new ApexPages.standardController(caso);
		CasoHibernacionControllerExtension controllerExtension = new CasoHibernacionControllerExtension(controller);
		System.Pagereference nextPage = controllerExtension.hibernarCaso();
		Test.stopTest();
		System.assert(ApexPages.getMessages().size() > 0);
		System.assert(ApexPages.getMessages().get(0).getSummary().contains('Debe especificar un área comercial para continuar.'), 'El mensaje de error es: ' + ApexPages.getMessages().get(0).getSummary());
		System.assertEquals(null, nextPage);
	}

	@isTest static void hibernarSinAviso() {
		caso.Dias_por_hibernar__c = '3';
		caso.Area_comercial__c = 'Producción';
		caso.Aviso_informativo__c = null;
		update caso;
		Test.startTest();
		System.Pagereference hibernarCasoPage = Page.HibernarCaso;
		ApexPages.currentPage().getParameters().put('Id', caso.Id);
		Test.setCurrentPage(hibernarCasoPage);
		ApexPages.standardController controller = new ApexPages.standardController(caso);
		CasoHibernacionControllerExtension controllerExtension = new CasoHibernacionControllerExtension(controller);
		System.Pagereference nextPage = controllerExtension.hibernarCaso();
		Test.stopTest();
		caso = [SELECT Id, Fecha_termino_hibernacion__c, Fecha_aviso_informativo__c, Dias_por_hibernar__c FROM Case WHERE Id = :caso.Id];
		System.assertEquals(0, ApexPages.getMessages().size());
		System.assertEquals(Datetime.newInstance(Date.today().addDays(Integer.valueOf(caso.Dias_por_hibernar__c)), Time.newInstance(9, 0, 0, 0)), caso.Fecha_termino_hibernacion__c);
		System.assertEquals(null, caso.Fecha_aviso_informativo__c);
		System.assert(nextPage.getUrl().contains('/' + caso.Id));
	}

	@isTest static void hibernarConAviso() {
		caso.Dias_por_hibernar__c = '3';
		caso.Area_comercial__c = 'Producción';
		caso.Aviso_informativo__c = '2 días antes';
		update caso;
		Test.startTest();
		System.Pagereference hibernarCasoPage = Page.HibernarCaso;
		ApexPages.currentPage().getParameters().put('Id', caso.Id);
		Test.setCurrentPage(hibernarCasoPage);
		ApexPages.standardController controller = new ApexPages.standardController(caso);
		CasoHibernacionControllerExtension controllerExtension = new CasoHibernacionControllerExtension(controller);
		System.Pagereference nextPage = controllerExtension.hibernarCaso();
		Test.stopTest();
		caso = [SELECT Id, Fecha_termino_hibernacion__c, Fecha_aviso_informativo__c, Dias_por_hibernar__c FROM Case WHERE Id = :caso.Id];
		System.assertEquals(0, ApexPages.getMessages().size());
		System.assertEquals(Datetime.newInstance(Date.today().addDays(Integer.valueOf(caso.Dias_por_hibernar__c)), Time.newInstance(9, 0, 0, 0)), caso.Fecha_termino_hibernacion__c);
		System.assertEquals(caso.Fecha_termino_hibernacion__c.addDays(-2), caso.Fecha_aviso_informativo__c);
		System.assert(nextPage.getUrl().contains('/' + caso.Id));
	}

}