public class AsignaAgenteActualACuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<String> codigos = new Set<String>();
		for (Account account : (Account[])Trigger.new) {
			if (account.Codigo_Agente__c != null && !codigos.contains(account.Codigo_Agente__c))
				codigos.add(account.Codigo_Agente__c);
		}
		
		Contact[] agentes = [SELECT Id, Codigo_Agente__c FROM Contact WHERE Codigo_Agente__c IN :codigos];
		Map<String, Contact> agenteMap = new Map<String, Contact>();
		for (Contact agente : agentes) {
			agenteMap.put(agente.Codigo_Agente__c, agente);
		}
		
		for (Account account : (Account[])Trigger.new) {
			Contact agente = agenteMap.get(account.Codigo_Agente__c);
			if (agente == null)
				continue;
			if (account.Agente_Actual__c != agente.Id)
				account.Agente_Actual__c =agente.Id;
				if (account.Agente_Original__c == null)
				account.Agente_Original__c =agente.Id;
		}
	}
}