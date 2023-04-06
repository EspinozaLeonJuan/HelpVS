/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 08-13-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   08-13-2020   Juan Espinoza Leon   Initial Version
**/
public class CalcularFactorDeEjecutivoEnCuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		User[] ejecutivos = [SELECT Id FROM User WHERE Ejecutivo_de_Cliente__c = true AND IsActive = true];
		Set<Id> ejecutivoClienteIds = new Set<Id>();
		for (User ejecutivo : ejecutivos) {
			ejecutivoClienteIds.add(ejecutivo.Id);
		}
		
		List<Id> ejecutivoIds = new List<Id>();
		Map<Id, Account[]> accountMap = new Map<Id, Account[]>(); // ownerId => Account[]
		if (Trigger.new != null) {
			for (Account account : (Account[])Trigger.new) {
				Account old = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(account.Id) : null);
				if (ejecutivoClienteIds.contains(account.OwnerId) && account.OwnerId != null && !ejecutivoIds.contains(account.OwnerId) && (old == null || old.OwnerId != account.OwnerId || old.Categoria_del_Cliente__c != account.Categoria_del_Cliente__c)) {
					ejecutivoIds.add(account.OwnerId);
					Account[] accounts = accountMap.get(account.OwnerId);
					if (accounts == null) {
						accounts = new List<Account>();
						accountMap.put(account.OwnerId, accounts);
					}
					accounts.add(account);
				}
			}
		}
		if (Trigger.old != null) {
			for (Account account : (Account[])Trigger.old) {
				Account newp = (Account)(Trigger.isUpdate ? Trigger.newMap.get(account.Id) : null);
				if (ejecutivoClienteIds.contains(account.OwnerId) && account.OwnerId != null && !ejecutivoIds.contains(account.OwnerId) && (newp == null || newp.OwnerId != account.OwnerId || newp.Categoria_del_Cliente__c != account.Categoria_del_Cliente__c)) {
					ejecutivoIds.add(account.OwnerId);
					Account[] accounts = accountMap.get(account.OwnerId);
					if (accounts == null) {
						accounts = new List<Account>();
						accountMap.put(account.OwnerId, accounts);
					}
					accounts.add(account);
				}
			}
		}
		
		if (!ejecutivoIds.isEmpty() && !System.isBatch())
		{
			system.debug('@@@@ paso 1');
			CalcularFactorDeEjecutivoUtils.calcularFuturo(ejecutivoIds);
		}
		else if (System.isBatch())
		{
			system.debug('@@@@ paso 2');
			CalcularFactorDeEjecutivoUtils.calcular(ejecutivoIds);
		}
		
	}
}