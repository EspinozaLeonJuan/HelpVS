@isTest
private class AsignaSupervisorAContactoTest {
	
	static {
		TriggerHandler.enable(AsignaSupervisorAContactoHandler.class);
	}
	
	@TestSetup
	static void init() {
		Fabricate.contacto().supervisor().save();
	}

	static testMethod void asignaSupervisorTest() {
		Test.startTest();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('ReportsToId', null).save();
		Test.stopTest();
		agente.load();
        Contact contactoResult = [Select Id, Rut_Supervisor__c, ReportsToId From Contact Where Rut_Supervisor__c = '22222222-2'];
		//System.assertNotEquals(null, agente.get().get('ReportsToId'), 'El supervisor no fue asignado');
		System.assertEquals('22222222-2', contactoResult.Rut_Supervisor__c);
        System.assertNotEquals(null, contactoResult.ReportsToId);
	}
}