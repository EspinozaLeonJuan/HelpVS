public class AsignaAgenteActualAPolizaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<String> codigos = new Set<String>();
		for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
			if (poliza.Codigo_Agente__c != null && !codigos.contains(poliza.Codigo_Agente__c))
				codigos.add(poliza.Codigo_Agente__c);
		}
		
		Contact[] agentes = [SELECT Id, Codigo_Agente__c FROM Contact WHERE Codigo_Agente__c IN :codigos];
		Map<String, Contact> agenteMap = new Map<String, Contact>();
		for (Contact agente : agentes) {
			agenteMap.put(agente.Codigo_Agente__c, agente);
		}
		
		for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
			Contact agente = agenteMap.get(poliza.Codigo_Agente__c);
			if (agente == null)
				continue;
			if (poliza.Agente_Actual__c != agente.Id)
				poliza.Agente_Actual__c =agente.Id;
				//if (poliza.Agente_Original__c == null)
				//poliza.Agente_Original__c =agente.Id;
		}
	}
}