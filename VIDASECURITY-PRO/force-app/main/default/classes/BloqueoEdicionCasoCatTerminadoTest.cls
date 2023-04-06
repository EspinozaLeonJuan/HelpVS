@isTest
private class BloqueoEdicionCasoCatTerminadoTest {
	
	static {
		TriggerHandler.enable(BloqueoEdicionCasoCatTerminadoHandler.class);
	}

    static testMethod void myUnitTest() {
        Factory.crearAccountAnonimo();

    	ControlTest.BloqueoEdicionCasoCatTerminado = true; 

		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
        insert cuenta;
        Case casoReclamo = Factory.buildCasoSF('Reclamos', cuenta);
        casoReclamo.AccountId = cuenta.Id; 
        insert casoReclamo;

		Caso_Cat__c c = new Caso_Cat__c();
		c.Caso__c = casoReclamo.Id;
		c.Estado__c = 'Nuevo';
		c.Titulo_del_Caso__c = 'Prueba';
		String tituloNew = 'Prueba2';
		insert c;
		
		c.Estado__c = 'Terminado';
		update c;
		
		Test.startTest();
		c.Titulo_del_Caso__c = tituloNew;
		
		try {
			update c;
		}
		catch (DmlException e) {
			System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
		}
		
		Test.stopTest();

        ControlTest.BloqueoEdicionCasoCatTerminado = false;

    }
}