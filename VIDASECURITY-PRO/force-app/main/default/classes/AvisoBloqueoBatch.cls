global with sharing class AvisoBloqueoBatch implements Database.Batchable<Sobject>, Database.Stateful {

	private List<string> errorCollection {get; set;}
	
	global AvisoBloqueoBatch() { // 2
		errorCollection = new List<String>();
	  system.debug('pasa AvisoBloqueoBatch');
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) { // 3
	  system.debug('pasa start()');
		Filial__c[] filiales = AvisoBloqueoService.getFilialesPorBloquear();
		Set<Id> corredorIds = new Set<Id>();
		for (Filial__c filial : filiales) {
			Id corredorId = filial.Poliza__r.Corredor__c;
			if (corredorId != null && !corredorIds.contains(corredorId))
			corredorIds.add(corredorId);
				}
		String query = 'SELECT Id FROM Corredor__c WHERE Id IN :corredorIds';
    system.debug( 'corredorIds-start() : ' + corredorIds);
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Sobject> scope) { // 4
    system.debug('pasa execute()');
		try {
			Corredor__c[] corredores = (Corredor__c[])scope;
			List<Id> corredorIds = new List<Id>();
			for (Corredor__c corredor : corredores) 
				corredorIds.add(corredor.Id);
      
      system.debug('pasa execute try before ' + corredorIds );
			AvisoBloqueoService.notificarAvisosBloqueo(corredorIds);	
      system.debug('pasa execute try after ' + corredorIds );
		} catch (Exception e) {
			String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString();
			system.debug('pasa execute catch err ' + errorMsg );
      errorCollection.add(errorMsg);
		}
	}
	
	global void finish(Database.BatchableContext bc) { //5
    system.debug('pasa finish before ' + bc );
		CobranzaService.notifyProcessResult('Aviso de Bloqueo Filial', errorCollection);
    system.debug('pasa finish after ' + errorCollection );
	}
	
	global static void start() { // 1 
    system.debug('pasa start before batch ');
		AvisoBloqueoBatch batch = new AvisoBloqueoBatch();
    system.debug('pasa start after batch ' + batch);
		Database.executeBatch(batch, 50);
    system.debug('pasa start after execute ' );
	}
}