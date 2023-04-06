public class HandlerException extends AbstractHandlerException {

	public HandlerException(String message, Sobject target, Sobject source) {
		super(message, target, source);
	}

	public HandlerException(String message, Sobject target) {
		super(message, target);
	}

	public HandlerException(Exception e, Sobject target, Sobject source) {
		super(e, target, source);
	}
    }