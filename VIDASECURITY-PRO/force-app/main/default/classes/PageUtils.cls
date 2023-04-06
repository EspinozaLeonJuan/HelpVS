public with sharing class PageUtils {
	
	public class PageException extends Exception {}
	
	public static System.PageReference addMessage(String message, ApexPages.Severity severity) {
		if (System.currentPageReference() == null)
			return null;
			
		ApexPages.addMessage(new ApexPages.Message(severity, message));
		return null;
	}
	
	public static System.PageReference addError(String message) {
		return addMessage(message, ApexPages.Severity.ERROR);
			}
			
		public static System.PageReference addInfo(String message) {
		return addMessage(message, ApexPages.Severity.INFO);
			}
	
	public static System.PageReference addError(Exception e) {
		ApexPages.addMessages(e);
		return null;
	}
	
	public static Boolean hasErrors() {
		if (System.currentPageReference() == null || !ApexPages.hasMessages())
			return false;
		for (ApexPages.Message message : ApexPages.getMessages()) {
			if (message.getSeverity() == ApexPages.Severity.ERROR || message.getSeverity() == ApexPages.Severity.FATAL)
				return true;
		}
		return false;
	}
}