@isTest
private class ActualizaFechaHoraDeCierreTest {
	
	static {
		TriggerHandler.enable(ActualizaFechaHoraDeCierreHandler.class);
	}

	static testMethod void ambasFechasNullTest() {
		Test.startTest();
		AbstractFabricate af = Fabricate.caso()
			.set('Fecha_Hora_de_Cierre__c', null)
			.set('ClosedDate', null)
			.save();
		Test.stopTest();
		Case caso = (Case)af.reload();
		System.assertEquals(null, caso.ClosedDate);
		System.assertEquals(null, caso.Fecha_Hora_de_Cierre__c);
	}
	
	static testMethod void fechaHoraCierreNullTest() {
		Test.startTest();
		AbstractFabricate af = Fabricate.caso()
			.set('Fecha_Hora_de_Cierre__c', null)
			.set('ClosedDate', Datetime.now())
			.save();
		Test.stopTest();
		Case caso = (Case)af.reload();
		System.assertEquals(caso.ClosedDate, caso.Fecha_Hora_de_Cierre__c);
	}
}