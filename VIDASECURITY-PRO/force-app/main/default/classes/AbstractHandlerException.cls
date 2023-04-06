public abstract class AbstractHandlerException extends Exception {

	public Sobject target {get; set;}
	public Sobject source {get; set;}

	  public AbstractHandlerException(String message, SObject target, Sobject source) {
		    this(message);
		    this.target = target;
		    this.source = source;
		  }

	  public AbstractHandlerException(Exception e, SObject target, Sobject source) {
	    this(e.getMessage(), e);
	    this.target = target;
	    this.source = source;
	  }

	  public AbstractHandlerException(String message, Sobject target) {
	  	this(message, target, target);
	  }

	  public AbstractHandlerException(Exception e, Sobject target) {
	  	this(e, target, target);
	  }

	      }