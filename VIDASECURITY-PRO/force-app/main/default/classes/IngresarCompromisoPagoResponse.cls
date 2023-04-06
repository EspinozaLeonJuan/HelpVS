public with sharing class IngresarCompromisoPagoResponse extends BaseAPIResponse {
	
	public Integer codFactura {get; set;}

    public static Object parse(String response) {
    	return BaseAPIResponse.parse(response, IngresarCompromisoPagoResponse.class, List<IngresarCompromisoPagoResponse>.class);
    }
}