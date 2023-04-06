/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    15/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class PolizaAsignaCategoriaCliente {
    
    public static String getCuenta(Poliza__c newPoliza, Poliza__c oldPoliza, Id tipoRegistroIndividual) {
		if(	( newPoliza.RecordTypeId == tipoRegistroIndividual || ( oldPoliza != null && oldPoliza.RecordTypeId == tipoRegistroIndividual && newPoliza.RecordTypeId != tipoRegistroIndividual ) ) && 
			newPoliza.Estatus__c == 'ACTIVA' && newPoliza.Prima_Total__c != null && 
			newPoliza.Valor_Poliza__c != null && ( 	oldPoliza == null || oldPoliza.Estatus__c != newPoliza.Estatus__c || oldPoliza.RecordTypeId != newPoliza.RecordTypeId || oldPoliza.Prima_Total__c != newPoliza.Prima_Total__c || oldPoliza.Valor_Poliza__c != newPoliza.Valor_Poliza__c ) ){
			return newPoliza.Cuenta__c;
		}
		return '';
	}
}