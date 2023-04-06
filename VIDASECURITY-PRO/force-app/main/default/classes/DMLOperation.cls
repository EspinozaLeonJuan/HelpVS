public abstract class DMLOperation {
	
	public class CallerOperationException extends Exception {}
	
	protected Sobject[] sobjects;
	protected Boolean allOrNone;
	protected Type[] enabledTriggers;
	protected String callerStackTrace {get; set;}
	
	public DMLOperation(Sobject[] sobjects, Boolean allOrNone, Type[] enabledTriggers) {
		this.sobjects = sobjects;
		this.allOrNone = allOrNone;
		this.enabledTriggers = enabledTriggers;
		try {
			throw new CallerOperationException();
		} catch (CallerOperationException e) {
			this.callerStackTrace = e.getStackTraceString();
		}
			}
	
	public abstract void execute();
	
  virtual String hashCode() {
  	String name = String.valueOf(this).split(':')[0];
  	return name + (sobjects == null ? 'null' : String.valueOf(System.hashCode(sobjects)));
  }
}