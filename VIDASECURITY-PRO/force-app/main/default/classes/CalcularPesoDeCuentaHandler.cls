public class CalcularPesoDeCuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<Id> accountIds = new Set<Id>();
		RecordTypeInfo individualType = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales');
		Id individualId = individualType == null ? null : individualType.getRecordTypeId();
		System.assertNotEquals(null, individualId, 'El tipo de registro Individuales fue eliminado o renombrado');
		if (Trigger.new != null) {
			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c old = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);
				if (!accountIds.contains(poliza.Cuenta__c) && poliza.Cuenta__c != null && poliza.RecordTypeId == individualId && poliza.Estatus__c == 'ACTIVA' && poliza.Categoria_de_Poliza__c != null && (old == null || poliza.RecordTypeId != old.RecordTypeId || poliza.Estatus__c != old.Estatus__c || poliza.Categoria_de_Poliza__c != old.Categoria_de_Poliza__c || poliza.Peso_de_Poliza__c != old.Peso_de_Poliza__c))
					accountIds.add(poliza.Cuenta__c);
			}
		}
		if (Trigger.old != null) {
			for (Poliza__c poliza : (Poliza__c[])Trigger.old) {
				Poliza__c newp = (Poliza__c)(Trigger.isUpdate ? Trigger.newMap.get(poliza.Id) : null);
				if (!accountIds.contains(poliza.Cuenta__c) && poliza.Cuenta__c != null && poliza.RecordTypeId == individualId && poliza.Estatus__c == 'ACTIVA' && poliza.Categoria_de_Poliza__c != null && (newp == null || poliza.RecordTypeId != newp.RecordTypeId || poliza.Estatus__c != newp.Estatus__c || poliza.Categoria_de_Poliza__c != newp.Categoria_de_Poliza__c && poliza.Peso_de_Poliza__c != newp.Peso_de_Poliza__c))
					accountIds.add(poliza.Cuenta__c);
			}
		}
		
		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id FROM Account WHERE Id IN :accountIds]);
		for (Account account : accountMap.values())
			account.Peso_de_Cuenta__c = 0; // Inicializamos todo, por si nos eliminan una póliza.
			
		AggregateResult[] results = [SELECT SUM(Peso_de_Poliza__c) Peso, Cuenta__c FROM Poliza__c WHERE Cuenta__c IN :accountIds AND RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA' GROUP BY Cuenta__c];
		for (AggregateResult result : results) {
			Id accountId = (Id)result.get('Cuenta__c');
			Decimal peso = (Decimal)result.get('Peso');
			Account account = accountMap.get(accountId);
			if (account != null)
				account.Peso_de_Cuenta__c = peso;
		}
		DatabaseUtils.updates(accountMap.values(), true, true);
	}
    }