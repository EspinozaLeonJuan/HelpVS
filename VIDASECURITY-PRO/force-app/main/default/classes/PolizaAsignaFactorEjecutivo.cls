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
public class PolizaAsignaFactorEjecutivo {
    
    public static void process(List<Id> polizaIds, Map<Id,Poliza__c> newMap, Map<Id,Poliza__c> oldMap ) {
		List<Id> ejecutivoIds = new List<Id>();		
		List<Poliza__c> polizas = [SELECT Id, Cuenta__r.OwnerId FROM Poliza__c WHERE Id IN :polizaIds];
		Map<Id, Poliza__c[]> polizaMap = new Map<Id, Poliza__c[]>(); // OwnerId => Poliza__c
		for( Poliza__c poliza : polizas ){
			Poliza__c[] lpolizas = polizaMap.get(poliza.Cuenta__r.OwnerId);
			if( lpolizas == null ){
				lpolizas = new List<Poliza__c>();
				polizaMap.put(poliza.Cuenta__r.OwnerId, lpolizas);
			}
			if( newMap != null && newMap.containsKey(poliza.Id) ){
				lpolizas.add((Poliza__c)newMap.get(poliza.Id));
			}else if( oldMap != null && oldMap.containsKey(poliza.Id) ){
				lpolizas.add((Poliza__c)oldMap.get(poliza.Id));
			}
			if( !ejecutivoIds.contains(poliza.Cuenta__r.OwnerId) ){
				ejecutivoIds.add(poliza.Cuenta__r.OwnerId);
			}
		}
		
		if( !ejecutivoIds.isEmpty() ){
			CalcularFactorDeEjecutivoUtils.Result result = CalcularFactorDeEjecutivoUtils.calcular(ejecutivoIds);
		}
	}

	public static Id getPolizaId(Poliza__c newPoliza, Poliza__c oldPoliza, List<Id> polizaIds ){
		if( !polizaIds.contains(newPoliza.Id) && 
			(newPoliza.Estatus__c == 'Activa' || (oldPoliza != null && oldPoliza.Estatus__c == 'Activa')) && 
			(oldPoliza == null || oldPoliza.Estatus__c != newPoliza.Estatus__c || newPoliza.Prima_Total__c != oldPoliza.Prima_Total__c || newPoliza.Valor_Poliza__c != oldPoliza.Valor_Poliza__c) ){
			return newPoliza.Id;
		}
		if( oldPoliza != null && !polizaIds.contains(oldPoliza.Id) && 
			(oldPoliza.Estatus__c == 'Activa' || (newPoliza != null && newPoliza.Estatus__c == 'Activa')) && 
			(newPoliza == null || newPoliza.Estatus__c != oldPoliza.Estatus__c || oldPoliza.Prima_Total__c != newPoliza.Prima_Total__c || oldPoliza.Valor_Poliza__c != newPoliza.Valor_Poliza__c)){
			return oldPoliza.Id;
		}
		return null;
	}
}