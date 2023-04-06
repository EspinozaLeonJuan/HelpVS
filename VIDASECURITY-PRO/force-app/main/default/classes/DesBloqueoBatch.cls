global with sharing class DesBloqueoBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
	//Importante para que funcione la query	
	private static final string BLOQUEADO = Filial.EstadoBeneficio.BLOQUEADO.name();
	private List<string> errorCollection {get; set;}
    global DesBloqueoBatch() {
		errorCollection = new List<String>();
    }
    
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = DesBloqueoService.queryDesBloquearFiliales();
    Factura__c[] facturasResult = (Factura__c[])Database.query(query);
    if( facturasResult.isEmpty() ) { List<String> errors = new List<String>(); errors.add('La query ejecutada es : ' + query ); CobranzaService.notifyProcessResult('(Desbloqueo) NO SE ENCONTRÓ NINGUNA FACTURA PARA BLOQUEAR, REVISAR LA SIGUIENTE QUERY', errors); }
    system.debug('@@@ query : ' + query );
		return Database.getQueryLocator(query);
	}
	
	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		try {
			DesBloqueoService.desBloquearFiliales((Factura__c[])scope);	
		} catch (Exception e) { String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString(); errorCollection.add(errorMsg);
		}
	}
		
	
	global void finish(Database.BatchableContext bc) {
		CobranzaService.notifyProcessResult('Desbloqueo de Filial', errorCollection);
	}
	
	global static void start() {
		DesBloqueoBatch batch = new DesBloqueoBatch();
		Database.executeBatch(batch, 200);
	}
}