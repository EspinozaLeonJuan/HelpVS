public virtual class BaseAPIResponse {

    public String Codigo {get; set;}
    public String Descripcion{get; set;}
    //Exception 
    public Integer httpCode{get; set;}
    public String httpMessage{get; set;}
    public String moreInformation{get; set;}
    
    

    public BaseAPIResponse() {
    }

    public Boolean isSuccess(){
        return (this.Codigo == '0');
    }
    
    public Boolean hasException(){
        return (httpCode != 200 || String.isNotBlank(httpMessage));
    }
    
    public String getMessage() {
		if (isSuccess())
			return this.Codigo + ' - ' + this.Descripcion;
		return getErrorMessage();
	}
    
	private String getErrorMessage() {
		if (isSuccess())
			return null;
		return toString(' - ');
	}
	
	public String toString(String separator) {
		List<String> messages = new List<String>();
		if (String.isNotBlank(this.codigo))	messages.add(this.codigo);
		if (String.isNotBlank(this.descripcion))	messages.add(this.descripcion);
		if (this.httpCode != null)	messages.add('HTTP Code: ' + this.httpCode);
		if (String.isNotBlank(this.httpMessage))	messages.add('HTTP Message: ' + this.httpMessage);
		if (String.isNotBlank(this.moreInformation))	messages.add('More Info: ' + this.moreInformation);
		return String.join(messages, separator);
	}
	
	public override String toString() {
		return toString('\n');
	}
	
	/**
	* En algunas ocasiones el servicio no retorna una lista, sino que devuelve un objeto BaseAPIResponse con error
	* El llamador de este método debe hacer el casting correspondiente según la instancia retornada
	*/	
	public static Object parse(String response, Type responseType, Type responseListType) {
		if (response == null)
			throw new CobranzaException('No se ha especificado respuesta');
			//System.debug('\nRESPONSE BODY:\n'+response);
		if (response.startsWith('{'))
			return JSON.deserialize(response, responseType);
		if (response.startsWith('['))
			return JSON.deserialize(response, responseListType);
		throw new CobranzaException('No fue posible interpretar la respuesta del servicio: ' + response);
			}
}