@isTest
private class BloqueaIngresoRespuestasCATTerminadoTest {
	
	static {
		TriggerHandler.enable(BloqIngresoRespuestasCATTerminadoHandler.class);
	}

    static testMethod void myUnitTest() {
        Factory.crearAccountAnonimo();
    	Account cuenta = Factory.buildAccount('Cuenta Corporativa');
        insert cuenta;
        Case casoReclamo = Factory.buildCasoSF('Reclamos', cuenta);
        casoReclamo.AccountId = cuenta.Id; 
        insert casoReclamo;
        
        Caso_Cat__c c = new Caso_Cat__c();
        c.Caso__c = casoReclamo.Id;
        insert c;
        
        Respuesta__c r = new Respuesta__c();
        r.Caso_Cat__c = c.Id;
        insert r;
        
        c.Estado__c = 'Terminado';
        update c;
        Respuesta__c r2 = new Respuesta__c();
        r2.Caso_Cat__c = c.Id;
        
        Test.startTest();
        
        try {
			insert r2;
		}
		catch (DmlException e) {
			System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION', e.getDmlStatusCode(0));
		}
        
        Test.stopTest();
       
    }
}