/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-02-2021   Juan Espinoza León   Initial Version
**/
public class CTR_CM_SendEmail {
    public CTR_CM_SendEmail() {
 
    }

    public String Id {get; set;}

    public String Call {get; set;}

    public String IdCmp {get; set;}

    public PageReference inicio()
    {
        this.Call = apexpages.currentpage().getparameters().get('Call'); 

        this.Id = apexpages.currentpage().getparameters().get('Id'); 

        if (this.Call == 'L')
        {
            String recordTypeId = [SELECT Id FROM Recordtype WHERE name='Miembros Salud Protegida'].Id;

            List<CampaignMember> miembros = [SELECT Id, CampaignId FROM CampaignMember WHERE LeadId =: this.Id AND RecordTypeId =: recordTypeId];
            
            if (miembros.size () > 0)
            {
	            this.IdCmp = miembros[0].CampaignId;                
            }
        }

        return null;
    }
}