@isTest
public class EjecutivoDeClienteFabricate extends AbstractFabricate {
	
	public override Sobject default() {
		return new Ejecutivo_de_Cliente__c(Codigo__c = '1');
	}
	
	public EjecutivoDeClienteFabricate setUsuario(UserFabricate usuario) {
		return (EjecutivoDeClienteFabricate)set('Usuario__c', usuario);
	}
	
	public EjecutivoDeClienteFabricate setUsuario(Id usuario) {
		return (EjecutivoDeClienteFabricate)set('Usuario__c', usuario);
	}
    }