@isTest
private class CalculaHorasHabilesTest {
	static {
		TriggerHandler.enable(new Type[]{
			CalculaHorasHabilesHandler.class
		});
	}

	@testSetup
	static void setup(){
		Fabricate.caso().save();
	}

	@isTest
	static void dado_UnCaso_cuando_SeCierra_debe_CalcularHorasHabiles() {
		Datetime createdDate = DateTime.newInstance(2019,8,30,8,30,0);
		CalculaHorasHabilesHandler.newCloseDate = DateTime.newInstance(2019,9,2,14,0,0);
		CaseFabricate caseFab = Fabricate.caso().loadCase();
		Case c = (Case) caseFab.get();
		Test.setCreatedDate(c.Id, createdDate);
		c.Status = 'Cerrado';
		Test.startTest();
		update c;
		Test.stopTest();
		c = (Case) caseFab.reload(new String[]{'CreatedDate', 'Cantidad_de_Horas_Habiles__c'});
		System.assertNotEquals(null, c);
		System.assertEquals(createdDate, c.CreatedDate);
		System.assertEquals(14, c.Cantidad_de_Horas_Habiles__c);
	}

	@IsTest
	static void dado_UnCaso_cuando_SeCierraElMismoDia_debe_CalcularHorasHabiles(){
		Datetime createdDate = DateTime.newInstance(2019,9,5,14,49,0);
		CalculaHorasHabilesHandler.newCloseDate = DateTime.newInstance(2019,9,5,15,25,0);
		CaseFabricate caseFab = Fabricate.caso().loadCase();
		Case c = (Case) caseFab.get();
		Test.setCreatedDate(c.Id, createdDate);
		c.Status = 'Cerrado';
		Test.startTest();
		update c;
		Test.stopTest();
		c = (Case) caseFab.reload(new String[]{'CreatedDate', 'Cantidad_de_Horas_Habiles__c'});
		System.assertNotEquals(null, c);
		System.assertEquals(createdDate, c.CreatedDate);
		System.assertEquals(0.6, c.Cantidad_de_Horas_Habiles__c);
	}

}