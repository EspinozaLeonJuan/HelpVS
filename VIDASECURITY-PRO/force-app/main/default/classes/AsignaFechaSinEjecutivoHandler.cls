public class AsignaFechaSinEjecutivoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<Id> ownerIds = new Set<Id>();
		Set<Id> agenteIds = new Set<Id>();
		List<Account> accounts = new List<Account>();
		for (Account account : (Account[])Trigger.new) {
			Account old = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(account.Id) : null);
			if (old == null || old.OwnerId != account.OwnerId || old.Agente_Actual__c != account.Agente_Actual__c) {
				accounts.add(account);
				if (!ownerIds.contains(account.OwnerId))
					ownerIds.add(account.OwnerId);
				if (account.Agente_Actual__c != null && !agenteIds.contains(account.Agente_Actual__c))
					agenteIds.add(account.Agente_Actual__c);
			}
		}
		if (accounts.isEmpty())
			return;
			
		Map<Id, Contact> agenteMap = new Map<Id, Contact>([SELECT Id, Estado__c FROM Contact WHERE Id IN :agenteIds]);
		Map<Id, User> ejecutivoMap = new Map<Id, User>([SELECT Id, Ejecutivo_de_Cliente__c, Username, IsActive FROM User WHERE Id IN :ownerIds]);
		for (Account account : accounts) {
			Contact agente = agenteMap.get(account.Agente_Actual__c);
			User ejecutivo = ejecutivoMap.get(account.OwnerId);
			if ((account.Agente_Actual__c != null && agente != null && agente.Estado__c == 'Vigente') || (ejecutivo != null && ejecutivo.IsActive && (ejecutivo.Ejecutivo_de_Cliente__c)))
			account.Fecha_Sin_Asignacion_Ejecutivo__c = null;
			else
			account.Fecha_Sin_Asignacion_Ejecutivo__c = Date.today();
		}
	}
}