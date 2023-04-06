public with sharing class AsignaEjecutivoDeClienteHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<Id> ownerIds = new Set<Id>();
		for (Account account : (Account[])Trigger.new) {
			Account old = (Account)( Trigger.isUpdate ? Trigger.oldMap.get(account.Id) : null);
			if (old != null && old.OwnerId != account.OwnerId && !ownerIds.contains(account.OwnerId))
				ownerIds.add(account.OwnerId);
		}
		if (ownerIds.isEmpty())
			return;
			
		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id IN :ownerIds]);
		Ejecutivo_de_Cliente__c[] ejecutivos = [SELECT Id, Codigo__c, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Usuario__c IN :ownerIds AND Codigo__c <> '0'];
		Map<Id, Ejecutivo_de_Cliente__c> ejecutivoMap = new Map<Id, Ejecutivo_de_Cliente__c>();
		for (Ejecutivo_de_Cliente__c ejecutivo : ejecutivos) {
			ejecutivoMap.put(ejecutivo.Usuario__c, ejecutivo);
		}
		Ejecutivo_de_Cliente__c[] noAsignados = [SELECT Id, Codigo__c, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Codigo__c = '0'];
		Ejecutivo_de_Cliente__c sinAsignar = null;
		if (noAsignados.isEmpty()) {
			User u = [SELECT Id FROM User WHERE Username LIKE 'sfvida@security.cl%' LIMIT 1];
			sinAsignar = new Ejecutivo_de_Cliente__c(Codigo__c = '0', Name = 'SIN EJECUTIVO', Usuario__c = u.Id);
			insert sinAsignar; 
		} else
		sinAsignar = noAsignados[0];
		for (Account account : (Account[])Trigger.new) {
			Ejecutivo_De_Cliente__c ejecutivo = ejecutivoMap.get(account.OwnerId);
			if (ejecutivo == null)
			account.Ejecutivo_de_Cliente__c = sinAsignar.Id;
			else
			account.Ejecutivo_de_Cliente__c = ejecutivo.Id;
					}
			}
    }