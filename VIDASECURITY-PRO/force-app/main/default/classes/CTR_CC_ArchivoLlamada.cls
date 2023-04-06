/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 04-13-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   10-04-2020   Juan Espinoza Leon   Initial Version
**/
public class CTR_CC_ArchivoLlamada {
	public PageReference Redirect()
    {
        String Id = apexpages.currentpage().getparameters().get('Id');
        Case caso = [SELECT Id, CaseNumber FROM Case WHERE Id =: Id];
        String url = 'http://10.50.26.23:8083/calls?id_salesforce='+caso.CaseNumber;
        return new System.Pagereference(url);
    } 
}