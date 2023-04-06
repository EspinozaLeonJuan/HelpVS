@IsTest
public class PagoFabricate extends AbstractFabricate {
    public override SObject default() {
		return new Pago__c();
	}

    public PagoFabricate setFilial(FilialFabricate obj) {
		return (PagoFabricate)set('Filial__c', obj);
	}

    public PagoFabricate setPoliza(PolizaFabricate obj) {
		return (PagoFabricate)set('Poliza__c', obj);
	}

    public PagoFabricate setMonto(Integer monto) {
		return (PagoFabricate)set('Monto__c', monto);
	}

	public PagoFabricate setPeriodoCobertura(String periodo) {
		return (PagoFabricate)set('Periodo_Cobertura__c', periodo);
	}
}