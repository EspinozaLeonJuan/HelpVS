/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-14-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-14-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public class FacturaFabricate extends AbstractFabricate {
	
	public override SObject default() {
		return new Factura__c(Bloquea_Beneficios__c = 'SI');
	}
	
	public FacturaFabricate setPoliza(PolizaFabricate poliza) {
		return (FacturaFabricate)set('Poliza__c', poliza);
	}
	
	public FacturaFabricate setFilial(FilialFabricate filial) {
		return (FacturaFabricate)set('Filial__c', filial);
	}

	public FacturaFabricate setEstadoFacturacion(String estadoFacturacion) {
		return (FacturaFabricate)set('Estado_Facturacion__c', estadoFacturacion);
	}

	public FacturaFabricate facturada() {
		return setEstadoFacturacion('Facturada');
	}

	public FacturaFabricate setEstadoPago(String estadoPago) {
		return (FacturaFabricate)set('Estado_Pago__c', estadoPago);
	}

	public FacturaFabricate estadoPagoAbierto() {
		return setEstadoPago('Abierto');
	}

	public FacturaFabricate estadoPagoPagado() {
		return setEstadoPago('Cerrado');
	}

	public FacturaFabricate setNotificacionAvisoBloqueo(Boolean isNotificado){
		return (FacturaFabricate)set('Notificacion_de_Aviso_de_Bloqueo__c', isNotificado);
	}

	public FacturaFabricate setFechaBloqueoBeneficio(Date fecha){
		return (FacturaFabricate)set('Fecha_Bloqueo_Beneficios__c', fecha);
	}

	public FacturaFabricate setFechaCompromiso(Date fecha){
		return (FacturaFabricate)set('Fecha_Compromiso__c', fecha);
	}

	public FacturaFabricate bloqueaBeneficios(){
		return (FacturaFabricate)set('Bloquea_Beneficios__c', 'SI');
	}
	
	public FacturaFabricate setFechaVencimiento(Date fechaVencimiento) {
		return (FacturaFabricate)set('Fecha_Vencimiento_Plazo__c', fechaVencimiento);
	}
	
	public FacturaFabricate setPeriodoCobertura(String periodo) {
		return (FacturaFabricate)set('Periodo_Cobertura__c', periodo);
	}

	public FacturaFabricate setPeriodoCobertura(Integer periodo) {
		return (FacturaFabricate)set('Periodo_Cobertura__c', String.valueOf(periodo));
	}
}