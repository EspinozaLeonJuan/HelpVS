@isTest
public class CampanaVidaSecurityFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Campana_Vida_Security__c(
			Name = 'Campaña FOO',
			Fecha_Inicio_de_Campa_a__c = Date.today(),
			Fecha_de_Termino_de_Campa_a__c = Date.today() + 2 );
	}
	
	public AbstractFabricate epa() {
		return this.set('Name', 'Campaña EPA');
	}

	public AbstractFabricate cobranza() {
		return this.set('Name', 'Campaña Cobranzas PV');
	}
}