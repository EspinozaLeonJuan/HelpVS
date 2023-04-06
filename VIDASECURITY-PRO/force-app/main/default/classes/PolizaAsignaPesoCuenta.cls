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
public class PolizaAsignaPesoCuenta {
    
    public static Id getAccountId(Poliza__c newPoliza, Poliza__c oldPoliza, Id individualId, Set<Id> accountIds ) {
		if( accountIds != null &&  !accountIds.contains(newPoliza.Cuenta__c) && newPoliza.Cuenta__c != null && 
			newPoliza.RecordTypeId == individualId && newPoliza.Estatus__c == 'ACTIVA' && 
			newPoliza.Categoria_de_Poliza__c != null && 
			(oldPoliza == null || newPoliza.RecordTypeId != oldPoliza.RecordTypeId || newPoliza.Estatus__c != oldPoliza.Estatus__c || 
			 newPoliza.Categoria_de_Poliza__c != oldPoliza.Categoria_de_Poliza__c || newPoliza.Peso_de_Poliza__c != oldPoliza.Peso_de_Poliza__c))
		{
			return newPoliza.Cuenta__c;
		}
			
		if( accountIds != null && oldPoliza != null && !accountIds.contains( oldPoliza.Cuenta__c ) && 
			oldPoliza.Cuenta__c != null && 
			oldPoliza.RecordTypeId == individualId && 
			oldPoliza.Estatus__c == 'ACTIVA' && 
			oldPoliza.Categoria_de_Poliza__c != null && 
			(newPoliza == null || oldPoliza.RecordTypeId != newPoliza.RecordTypeId || oldPoliza.Estatus__c != newPoliza.Estatus__c || 
			 oldPoliza.Categoria_de_Poliza__c != newPoliza.Categoria_de_Poliza__c && oldPoliza.Peso_de_Poliza__c != newPoliza.Peso_de_Poliza__c))
		{
			return oldPoliza.Cuenta__c;
		}
		return null;
	}

	public static void updatePesoCuenta(Set<Id> accountIds){
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Id IN :accountIds]);
		for(Account account : accountMap.values()){
			account.Peso_de_Cuenta__c = 0; // Inicializamos todo, por si nos eliminan una póliza.
		}
			
		AggregateResult[] results = [
			SELECT SUM(Peso_de_Poliza__c) Peso, Cuenta__c FROM Poliza__c 
			WHERE Cuenta__c IN :accountIds 
			AND RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA' GROUP BY Cuenta__c];
		
		for( AggregateResult result : results ){
			Id accountId = (Id)result.get('Cuenta__c');
			Decimal peso = (Decimal)result.get('Peso');
			Account account = accountMap.get(accountId);
			if (account != null){
				account.Peso_de_Cuenta__c = peso;
			}
		}
		DatabaseUtils.updates(accountMap.values(), true, true);
	}
}