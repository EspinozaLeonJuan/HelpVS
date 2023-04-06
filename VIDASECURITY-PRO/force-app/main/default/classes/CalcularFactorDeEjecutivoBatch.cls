global class CalcularFactorDeEjecutivoBatch implements Database.Batchable<Sobject>, Database.Stateful {
	
	private static final Integer LIMIT_MESSAGES = 50;
	
	
	public List<String> errors {get; set;}
	private Integer successes;
	private List<Id> ejecutivoIds;

	
	global CalcularFactorDeEjecutivoBatch(Id[] ejecutivoIds) {
		this.ejecutivoIds = ejecutivoIds;
		this.successes = 0;
		this.errors = new List<String>();
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id FROM User WHERE IsActive = true';
		if (ejecutivoIds != null)
			query += ' AND Id IN :ejecutivoIds';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		CalcularFactorDeEjecutivoUtils.Result result = CalcularFactorDeEjecutivoUtils.calcular((User[])scope);
		successes += result.successes;
		if (errors.size() < LIMIT_MESSAGES)
		errors.addAll(result.getMessages());
}
	
	global void finish(Database.BatchableContext bc) {
		if (!Test.isRunningTest() && errors.isEmpty())
			return;
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.setSubject('[Vida Security] Reporte de Resultados de Cálculo de Factor de Ejecutivos');
		message.setToAddresses(new String[] {'contacto@gocode.cl'});
		String body = 'Se han recalculado ' + successes + ' factores exitosamente.\n';
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
	
	public static void start(Id[] ejecutivoIds) {
		CalcularFactorDeEjecutivoBatch batch = new CalcularFactorDeEjecutivoBatch(ejecutivoIds);
		Database.executeBatch(batch, 50);
	}
	}