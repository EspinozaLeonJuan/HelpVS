@IsTest
private class EmailResultTest {
	
	static testMethod void getErrorMessageTest() {
		EmailResult result = new EmailResult('error', (Id)null, (Id)null, 'TemplateName');
		String errorMessage = result.getErrorMessage();
	}
		 			
	static testMethod void getMessageTest() {
		String addressTo = 'foo@bar.cl';
		String subject = 'foo';
		String plainBody = 'test';
		Messaging.SendEmailResult sendEmailResult = EmailUtils.sendSingleEmail(addressTo, subject, plainBody);
		EmailResult result = new EmailResult(sendEmailResult, (id)null, (Id)null, 'Templatename');
		String errorMessage = result == null ? null : result.getErrorMessage();
	}
}