@isTest
public class CampaignMemberFabricate extends AbstractFabricate {
	public override Sobject default() {
		return new CampaignMember(Status = 'Enviado'); 
	}
	
	public CampaignMemberFabricate conCampana() {
		return (CampaignMemberFabricate) set('CampaignId', Fabricate.campana());
	}
}