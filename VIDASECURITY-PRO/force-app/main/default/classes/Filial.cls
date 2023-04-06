public with sharing class Filial {
	
	public enum EstadoBeneficio {ACTIVO, BLOQUEADO}


	public static FilialFabricate fabricate() {
		return new FilialFabricate();
	}
}