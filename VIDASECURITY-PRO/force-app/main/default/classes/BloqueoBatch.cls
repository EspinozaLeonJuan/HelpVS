global with sharing class BloqueoBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
	// Solo para que funcione la query
	private static final string BLOQUEADO = Filial.EstadoBeneficio.BLOQUEADO.name();
	private List<string> errorCollection {get; set;}
    global BloqueoBatch() {
		errorCollection = new List<String>();
    }
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = BloqueoService.queryBloquearFiliales();
    Factura__c[] facturasResult = (Factura__c[])Database.query(query);
    if( facturasResult.isEmpty() ) { List<String> errors = new List<String>(); errors.add('La query ejecutada es : ' + query ); CobranzaService.notifyProcessResult('NO SE ENCONTRÓ NINGUNA FACTURA PARA BLOQUEAR, REVISAR LA SIGUIENTE QUERY', errors);
    }
    system.debug('@@@ query : ' + query );
		return Database.getQueryLocator(query);
	}
		
	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		try {
      system.debug('@@@ scope : ' + (Factura__c[])scope);
			BloqueoService.bloquearFiliales((Factura__c[])scope);	
		} catch (Exception e) {
			String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString();
			system.debug('@@@ errorCollection : ' + errorCollection);
      errorCollection.add(errorMsg);
		}
	}
		
	
	global void finish(Database.BatchableContext bc) {
    system.debug('@@@ errorCollection 2 : ' + errorCollection);
		CobranzaService.notifyProcessResult('Bloqueo de Filial', errorCollection);
	}
	
	global static void start() {
		BloqueoBatch batch = new BloqueoBatch();
    system.debug('@@@ batch : ' + batch);
		Database.executeBatch(batch, 200);
	}
}