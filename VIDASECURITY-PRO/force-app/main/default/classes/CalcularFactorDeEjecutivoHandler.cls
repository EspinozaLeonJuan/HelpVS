public class CalcularFactorDeEjecutivoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		List<Id> polizaIds = new List<Id>();
		if (Trigger.new != null) {
			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c old = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);
				if (!polizaIds.contains(poliza.Id) && (poliza.Estatus__c == 'Activa' || (old != null && old.Estatus__c == 'Activa')) && (old == null || old.Estatus__c != poliza.Estatus__c || poliza.Prima_Total__c != old.Prima_Total__c || poliza.Valor_Poliza__c != old.Valor_Poliza__c)) {
					polizaIds.add(poliza.Id);
									}
			}
		}
		if (Trigger.old != null) {
			for (Poliza__c poliza : (Poliza__c[])Trigger.old) {
				Poliza__c newp = (Poliza__c)(Trigger.isUpdate ? Trigger.newMap.get(poliza.Id) : null);
				if (!polizaIds.contains(poliza.Id) && (poliza.Estatus__c == 'Activa' || (newp != null && newp.Estatus__c == 'Activa')) && (newp == null || newp.Estatus__c != poliza.Estatus__c || poliza.Prima_Total__c != newp.Prima_Total__c || poliza.Valor_Poliza__c != newp.Valor_Poliza__c))
					polizaIds.add(poliza.Id);
			}
		}
		if (polizaIds.isEmpty())
			return;
		
		List<Id> ejecutivoIds = new List<Id>();		
		Poliza__c[] polizas = [SELECT Id, Cuenta__r.OwnerId FROM Poliza__c WHERE Id IN :polizaIds];
		Map<Id, Poliza__c[]> polizaMap = new Map<Id, Poliza__c[]>(); // OwnerId => Poliza__c
		for (Poliza__c poliza : polizas) {
			Poliza__c[] lpolizas = polizaMap.get(poliza.Cuenta__r.OwnerId);
			if (lpolizas == null) {
				lpolizas = new List<Poliza__c>();
				polizaMap.put(poliza.Cuenta__r.OwnerId, lpolizas);
			}
			if (Trigger.newMap != null && Trigger.newMap.containsKey(poliza.Id))
				lpolizas.add((Poliza__c)Trigger.newMap.get(poliza.Id));
				else if (Trigger.oldMap != null && Trigger.oldMap.containsKey(poliza.Id))
				lpolizas.add((Poliza__c)Trigger.oldMap.get(poliza.Id));
			if (!ejecutivoIds.contains(poliza.Cuenta__r.OwnerId))
			ejecutivoIds.add(poliza.Cuenta__r.OwnerId);
					}
		
if (!ejecutivoIds.isEmpty()) {
			CalcularFactorDeEjecutivoUtils.Result result = CalcularFactorDeEjecutivoUtils.calcular(ejecutivoIds);
			if (!result.errors.isEmpty())
			for (CalcularFactorDeEjecutivoUtils.Error error : result.errors) {
				polizas = polizaMap.get(error.id);
				if (polizas == null)
				continue;
				for (Poliza__c poliza : polizas)
				poliza.addError(error.message);
			}
}
	}
}