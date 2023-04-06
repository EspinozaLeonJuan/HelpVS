@isTest
public class CampaignFabricate extends AbstractFabricate {
	public override Sobject default() {
		return new Campaign(Name = 'Campaign Test');
	}
}