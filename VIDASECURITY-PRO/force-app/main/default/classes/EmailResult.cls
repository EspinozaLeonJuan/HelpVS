public with sharing class EmailResult {
	
	public Id targetId {get; set;}
	public Id whatId {get; set;}
	public String templateName {get; set;}
	public String error {get; set;}
	public Messaging.SendEmailResult result {get; set;}
	
	public EmailResult(Messaging.SendEmailResult result, Id targetId, Id whatId, String templateName) {
		this.result = result;
		this.targetId = targetId;
		this.whatId = whatId;
		this.templateName = templateName;
		this.error = null;
	}
	
	public EmailResult(String error, Id targetId, Id whatId, String templateName) {
		this((Messaging.SendEmailResult)null, targetId, whatId, templateName);
		this.error = error;
	}
	
	public String getErrorMessage() {
		if (this.error != null)
		return this.error;
		if (result == null || result.isSuccess())
			return null;
		String message = '';
		for (Messaging.SendEmailError error : result.getErrors()) {
			message += error.getMessage() + '\n';
		}
		return message;
			}
			
			public Boolean isSuccess() {
		return this.error == null && result.isSuccess();
			}
}