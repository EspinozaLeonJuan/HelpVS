@isTest
public class RegionFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Region__c(
			REGI_C_digo__c='00001', 
			Name='Metropolitana'
		);
	}

}