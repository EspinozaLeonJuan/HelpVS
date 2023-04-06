public with sharing class Factura {
	
	public enum EstadoPago {Abierto, Cerrado}
	
	public static FacturaFabricate fabricate() {
		return new FacturaFabricate();
	}
}