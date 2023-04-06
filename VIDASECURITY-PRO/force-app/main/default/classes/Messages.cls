public with sharing class Messages {


	public static Boolean addMessage(ApexPages.Severity severity, String message) {
		if (System.currentPageReference() == null)
			System.debug(message);
		else
			ApexPages.addMessage(new ApexPages.Message(severity, message));
		return (severity != ApexPages.Severity.ERROR);
	}

	public static Boolean addError(String message) {
		return addMessage(ApexPages.Severity.ERROR, message);
	}

	public static Boolean addInfo(String message) {
		return addMessage(ApexPages.Severity.INFO, message);
	}

	public static Boolean addWarn(String message) {
		return addMessage(ApexPages.Severity.WARNING, message);
	}

}