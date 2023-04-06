global class ActualizarCategoriaDePolizaBatch implements Database.Batchable<Sobject>, Database.Stateful {
	
	
	public class ActualizarCategoriaDePolizaException extends Exception {}
	
	private static final Integer LIMIT_MESSAGES = 2000;
	
	public List<String> errors {get; set;}
	private Integer successes;
	private List<Id> polizaIds;
	
	global ActualizarCategoriaDePolizaBatch(Id[] polizaIds) {
		this.polizaIds = polizaIds;
		this.successes = 0;
		this.errors = new List<String>();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, Name FROM Poliza__c WHERE RecordType.Name = \'Individuales\' AND Estatus__c = \'ACTIVA\'';
		if (polizaIds != null)	query += ' AND Id IN :polizaIds';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		for (Poliza__c poliza : (Poliza__c[])scope) {
			poliza.Categoria_de_Poliza__c = null;
		}
		Database.SaveResult[] sresults = Database.update(scope, false);
		for (Integer i=0; i < sresults.size(); i++) {
			Database.SaveResult sresult = sresults[i];
			Poliza__c poliza = (Poliza__c)scope[i];
			if (sresult.isSuccess()) {
				successes++;
				continue;
			}
			if (errors.size() >= LIMIT_MESSAGES)
				continue;
			for (Database.Error error : sresult.getErrors()) {
				String message = 'Error al actualizar la poliza ' + poliza.Name + ':' + error.getMessage();
				if (Test.isRunningTest()) throw new ActualizarCategoriaDePolizaException(message);
				errors.add(message);
			}
		} 
	}
	
	global void finish(Database.BatchableContext bc) {
		if (!Test.isRunningTest() && errors.isEmpty())
			return;
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.setSubject('[Vida Security] Reporte de Resultados de Cálculo de Categoría de Póliza');
		message.setToAddresses(new String[] {'contacto@gocode.cl'});
		String body = 'Se han recalculado ' + successes + ' categorias de póliza exitosamente.\n';
		if (!errors.isEmpty()) {
			body += 'Se han producido los siguientes errores:\n';
			for (String error : errors)
				body += error + '\n';
				}
		message.setPlainTextBody(body);
		message.setSaveAsActivity(false);
		if (!Test.isRunningTest())
			Messaging.sendEmail(new Messaging.Email[] {message});
	}
	
	public static void start(Id[] polizaIds) {
		ActualizarCategoriaDePolizaBatch batch = new ActualizarCategoriaDePolizaBatch(polizaIds);
		Database.executeBatch(batch, 50);
	}
	}