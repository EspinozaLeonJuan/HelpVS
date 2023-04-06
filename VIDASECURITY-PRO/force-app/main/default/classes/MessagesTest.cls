@isTest
private class MessagesTest {

	static testMethod void myUnitTest() {
		Messages.addError('Foo');
		Messages.addInfo('Foo');
		Messages.addWarn('foo');
	}
}