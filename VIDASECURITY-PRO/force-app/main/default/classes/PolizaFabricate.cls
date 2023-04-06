@isTest
public class PolizaFabricate extends AbstractFabricate {
	
	public override Sobject default() {
		return new Poliza__c(Name = '123456', Fecha_Entrega_de_la_Poliza__c = Date.today());
	}
	
	public PolizaFabricate conCuenta(Account account) {
		return (PolizaFabricate) this.set('Cuenta__c', account.Id);
	}
	
	public PolizaFabricate setCuenta(AccountFabricate account) {
		return (PolizaFabricate) this.set('Cuenta__c', account);
	}

	public PolizaFabricate setCuenta(AccountGeneration account) {
		return (PolizaFabricate) this.set('Cuenta__c', account);
	}
	
	public PolizaFabricate individual() {
		return (PolizaFabricate) set('RecordTypeId', Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId());
	}
	
	public PolizaFabricate colectivos() {
		return (PolizaFabricate) set('RecordTypeId', Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Colectivos').getRecordTypeId());
	}

	public PolizaFabricate rentasVitalicias() {
		return (PolizaFabricate) set('RecordTypeId', Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Rentas Vitalicias').getRecordTypeId());
	}
	
	public PolizaFabricate setCorredor(CorredorFabricate corredor) {
		return (PolizaFabricate)set('Corredor__c', corredor);
	}

	public PolizaFabricate valorPoliza(){
		return (PolizaFabricate) set('Valor_Poliza__c', 150000);
	}

	public PolizaFabricate valorPrima(){
		return (PolizaFabricate) set('Prima_Total__c', 1500);
	}

	public PolizaFabricate activa(){
		return (PolizaFabricate) set('Estatus__c', 'ACTIVA');
	}

	public PolizaFabricate mandatoria(){
		return (PolizaFabricate) set('p_liza_mandatoria__c', true);
	}
}