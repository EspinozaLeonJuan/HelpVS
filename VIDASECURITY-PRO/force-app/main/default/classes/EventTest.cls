@isTest
private class EventTest {

    static testMethod void myUnitTest() {
		Factory.crearAccountAnonimo();

    	Account cuenta = Factory.buildAccount('Cuenta Corporativa');
        insert cuenta;

    	Poliza__c poliza = new Poliza__c();
    	poliza.Apellidos_Asegurado__c = 'Apellidos prueba';
    	poliza.Cuenta__c = cuenta.Id;
    	insert Poliza;

    	Contact contacto = new Contact();
    	contacto.LastName = 'LastName prueba';
    	insert contacto;

    	Poliza__c pol = [SELECT Id FROM Poliza__c WHERE Apellidos_Asegurado__c =: 'Apellidos prueba' limit 1];
    	Contact con = [SELECT Id FROM Contact WHERE LastName =: 'LastName prueba' limit 1];

		Event evento = new Event();
		evento.DurationInMinutes = 90;
		evento.WhatId = pol.Id;
		evento.WhoId = con.Id;
		evento.Visita_Finalizada__c = 'Si';
		evento.Motivo_Visita__c = 'Motivo';
		evento.Contactar_a_Cliente__c = 'Si';
		evento.ActivityDateTime = DateTime.now().addDays(2);
        
        Campana_Vida_Security__c campanaEPA = Factory.buildCampanaEPA();
        insert campanaEPA;
        
        Test.startTest();
		insert evento;
		Test.stopTest();
    }
}