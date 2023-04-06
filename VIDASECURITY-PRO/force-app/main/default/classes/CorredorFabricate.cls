@IsTest
public class CorredorFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Corredor__c(
			RUT__c = '76316883',
			DV__c = '2',
			Name = 'Corredor Test'
			);
	}
	
	public CorredorFabricate corredor() {
		return new CorredorFabricate();
	}

}