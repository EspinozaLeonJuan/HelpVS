public with sharing class CobranzaException extends Exception {
	
	public CobranzaException(BaseAPIResponse response) {
		this(response == null ? 'No message' : response.getMessage());
	}	
}