@isTest
public class AreaFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Area__c(
			TP_Negocio__c='Formal', 
			Name='Barquisimeto',
			TP_Pais__c =  'Chile'
		);
	}

}