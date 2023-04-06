public class DesactivaEjecutivoHandler implements TriggerHandler.AsyncHandlerInterface {
	
	public void handle(TriggerContext context) {
		if (!context.isUpdate)
			return;

			
		Set<Id> enabledIds = new Set<Id>();
		Set<Id> disabledIds = new Set<Id>();
		for (User ejecutivo : (User[])context.newList) {
			User old = (User)(context.isUpdate ? context.oldMap.get(ejecutivo.Id) : null);
			if (ejecutivo.Ejecutivo_de_Cliente__c && ejecutivo.IsActive && old != null && (!old.IsActive || !old.Ejecutivo_de_Cliente__c) && !enabledIds.contains(ejecutivo.Id))
				enabledIds.add(ejecutivo.Id);
			if ((!ejecutivo.Ejecutivo_de_Cliente__c || !ejecutivo.IsActive) && old != null && old.IsActive && old.Ejecutivo_de_Cliente__c && !disabledIds.contains(ejecutivo.Id))
				disabledIds.add(ejecutivo.Id);
		}
		
		if (!enabledIds.isEmpty()) {
			for (Account[] accounts : [SELECT Id FROM Account WHERE OwnerId IN :enabledIds AND Owner.Ejecutivo_de_Cliente__c = true AND (Agente_Actual__c = NULL OR Agente_Actual__r.Estado__c = 'Desvinculado' OR Agente_Actual__r.Estado__c = 'Cambio de Cargo') AND Fecha_Sin_Asignacion_Ejecutivo__c <> NULL AND ID IN (SELECT Cuenta__c FROM Poliza__c WHERE RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA')]) {
				for (Account account : accounts) {
					account.Fecha_Sin_Asignacion_Ejecutivo__c = null;
									}
									update accounts;
			}
		}
		
		
		if (!disabledIds.isEmpty()) {
			for (Account[] accounts : [SELECT Id FROM Account WHERE OwnerId IN :disabledIds AND Owner.Ejecutivo_de_Cliente__c = true AND (Agente_Actual__c = NULL OR Agente_Actual__r.Estado__c = 'Desvinculado' OR Agente_Actual__r.Estado__c = 'Cambio de Cargo') AND ID IN (SELECT Cuenta__c FROM Poliza__c WHERE RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA')]) {
				for (Account account : accounts) {
					account.Fecha_Sin_Asignacion_Ejecutivo__c = Date.today();
									}
									update accounts;
			}
		}		
		
	}
}