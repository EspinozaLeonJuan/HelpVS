global with sharing class RecordatorioBloqueoBatch implements Database.Batchable<Sobject>, Database.Stateful {

	private List<string> errorCollection {get; set;}
	
	global RecordatorioBloqueoBatch() {
		errorCollection = new List<String>();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		Filial__c[] filiales = RecordatorioBloqueoService.getFilialesBloqueadas();
		Set<Id> corredorIds = new Set<Id>();
		for (Filial__c filial : filiales) {
			Id corredorId = filial.Poliza__r.Corredor__c;
			if (corredorId != null)
			    corredorIds.add(corredorId);
    }
    String query = 'SELECT Id FROM Corredor__c WHERE Id IN :corredorIds';
    if( corredorIds.isEmpty() ) { List<String> errors = new List<String>(); errors.add('La query ejecutada es : ' + query ); CobranzaService.notifyProcessResult('(Recordatorio Bloqueo Batch) NO SE ENCONTRÓ NINGUNA FACTURA PARA RECORDAR BLOQUEAR, REVISAR LA SIGUIENTE QUERY', errors); }
    system.debug('@@@ query : ' + query );
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		try {
			Corredor__c[] corredores = (Corredor__c[])scope;
			List<Id> corredorIds = new List<Id>();
			for (Corredor__c corredor : corredores) 
				corredorIds.add(corredor.Id);
			RecordatorioBloqueoService.notificarRecordatorioBloqueo(corredorIds);	
		} catch (Exception e) {
			String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString();
			errorCollection.add(errorMsg);
		}
	}
	
	global void finish(Database.BatchableContext bc) {
		CobranzaService.notifyProcessResult('Recordatorio de Bloqueo Filial', errorCollection);
	}
	
	global static void start() {
		RecordatorioBloqueoBatch batch = new RecordatorioBloqueoBatch();
		Database.executeBatch(batch, 50);
	}
}