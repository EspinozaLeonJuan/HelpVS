@isTest
private class TriggerHandlerTest {

	static {
		TriggerHandler.enable();
		TriggerHandler.disable();
		TriggerHandler.disable(new Type[] {
			TestAccountHandler.class,
			TestAsyncHandler.class
		});
		TriggerHandler.enable(new Type[] {
			TestAccountHandler.class,
			TestAsyncHandler.class
		});
	}

	static testMethod void normalExecutionTest() {
		Test.startTest();
		AbstractFabricate accountFabricate = Fabricate.cuenta().corporativa().save();
		Test.stopTest();
		Account account = (Account) accountFabricate.reload();
		System.assert(TestAccountHandler.wasExecuted);
	}


	static testMethod void exceptionExecutionTest() {
		TriggerHandler.isTesting = true;
		AbstractFabricate accountFabricate = Fabricate.cuenta().corporativa().set('Name', 'bar').inserts();
		Test.startTest();
		HandlerException he = null;
		try {
			accountFabricate.set('Name', 'foo').updates();
		} catch (HandlerException e) {
			he = e;
		}
		Test.stopTest();
		Account account = (Account) accountFabricate.reload();
		System.assert(TestAccountHandler.wasExecuted);
	}

	static testMethod void messageExecutionTest() {
		TriggerHandler.isTesting = true;
		Test.startTest();
		AbstractFabricate af = Fabricate.cuenta().corporativa().set('Name', 'message').inserts();
		TriggerHandler.stack.push(new TestAccountHandler()); // por mientras
		TriggerHandler.addError((System.Dmlexception)af.error);
		Test.stopTest();
		System.assertNotEquals(null, af.error);
	}
}