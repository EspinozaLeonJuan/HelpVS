public with sharing class EstadoBeneficioResponse extends BaseAPIResponse {
    // public EstadoBeneficioResponse() {
    // }

    
	public static Object parse(String response) {
		return BaseAPIResponse.parse(response, EstadoBeneficioResponse.class, List<EstadoBeneficioResponse>.class);
	}
}