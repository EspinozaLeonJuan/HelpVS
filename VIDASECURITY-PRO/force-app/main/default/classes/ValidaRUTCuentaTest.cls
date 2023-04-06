@isTest
private class ValidaRUTCuentaTest {
	static {
		TriggerHandler.enable(ValidaRUTCuentaHandler.class);
	}
	
	static testMethod void validaTest() { 
		Test.startTest();
		Fabricate.cuenta().personal().save();
		Test.stopTest();
        	}
}