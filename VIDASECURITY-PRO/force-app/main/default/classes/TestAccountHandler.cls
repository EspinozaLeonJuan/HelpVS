public class TestAccountHandler implements TriggerHandler.HandlerInterface {

	@testVisible
	public static Boolean wasExecuted = false;

	public void handle() {
		if (!Test.isRunningTest()) return; // Only test proporses
		for (Account account : (Account[])Trigger.new) {
			if (account.Name == 'exception')
				throw new HandlerException('Mensaje de prueba', account);
			if (account.Name == 'message')
				TriggerHandler.addError('Este es un mensaje de prueba', account);
			wasExecuted = true;
		}

	}
}