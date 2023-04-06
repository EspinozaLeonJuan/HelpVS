@IsTest
public class FilialFabricate extends AbstractFabricate {
	
	public override SObject default() {
		return new Filial__c();
	}
	
	public FilialFabricate setPoliza(PolizaFabricate poliza) {
		return (FilialFabricate)set('Poliza__c', poliza);
	}

	public FilialFabricate activo(){
		return (FilialFabricate)set('Estado_Beneficio__c', Filial.EstadoBeneficio.ACTIVO.name());
	}

	public FilialFabricate bloqueado(){
		return (FilialFabricate)set('Estado_Beneficio__c', Filial.EstadoBeneficio.BLOQUEADO.name());
	}

	public FilialFabricate setFechaBloqueoDeBeneficio(Date fecha){
		return (FilialFabricate)set('Fecha_Bloqueo_de_Beneficios__c', fecha);
	}
}