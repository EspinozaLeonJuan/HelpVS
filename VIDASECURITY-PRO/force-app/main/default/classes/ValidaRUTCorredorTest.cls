@isTest
private class ValidaRUTCorredorTest {
	
	static {
		TriggerHandler.enable(ValidaRUTCorredorHandler.class);
	}
	
	@isTest
	static void itShouldValidateRutCorredorSuccess() {
		Corredor__c corredor = new Corredor__c(RUT__c = '16355278', DV__c = '7', Name = 'Corredor de Prueba', Ciudad_Comercial__c = 'Santiago', Comuna_Comercial__c = 'Macul', Direccion_Comercial__c = 'Los Industriales', Region_Comercial__c = 'RM');
		Test.startTest();
		insert corredor;
		Test.stopTest();
	}

	@isTest
	static void itShouldValidateRutCorredorFailure() {
		Corredor__c corredor = new Corredor__c(RUT__c = '16355279', DV__c = '7', Name = 'Corredor de Prueba', Ciudad_Comercial__c = 'Santiago', Comuna_Comercial__c = 'Macul', Direccion_Comercial__c = 'Los Industriales', Region_Comercial__c = 'RM');
		try {
			Test.startTest();
			insert corredor;
			Test.stopTest();
			System.assert(false);
		} catch (Exception e) {
			System.assert(true);
		}
	}
}