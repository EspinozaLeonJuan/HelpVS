public abstract class WSMock implements WebServiceMock {
	protected Object responseElement;

	public WSMock() {}
	
	public void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, String soapAction, String requestName, String responseNS,String responseName, String responseType) {
		response.put('response_x', responseElement); 
	}
}