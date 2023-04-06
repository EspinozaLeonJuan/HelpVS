global class ActualizaCategoriasDeClientesBatch implements Database.Batchable<Sobject>, Database.Stateful {
 	
	private static final Integer LIMIT_MESSAGES = 2000;
	
	public List<String> errors {get; set;}
	private Integer successes;
	private Set<String> categorias;
	private Id[] ejecutivoIds;
	private Boolean onlyNulls;
	
	global ActualizaCategoriasDeClientesBatch(Set<String> categorias) {
		this(categorias, false);
	}
	
	global ActualizaCategoriasDeClientesBatch(Set<String> categorias, Boolean onlyNulls) {
		this.categorias = categorias;
		this.ejecutivoIds = new List<Id>();
		this.successes = 0;
		this.errors = new List<String>();
		this.onlyNulls = onlyNulls;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		String query = 'SELECT Id, OwnerId FROM Account WHERE Cantidad_Polizas_Activas__c > 0';
		if (onlyNulls)
		query += ' AND Categoria_del_Cliente__c = NULL';
		if (categorias != null)
			query += ' AND Categoria_de_Cliente__c IN :categorias';
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Sobject> scope) {
		Set<String> accountIds = new Set<String>();
		for (Account account : (Account[])scope) {
			accountIds.add(account.Id);
			if (!ejecutivoIds.contains(account.OwnerId))
				ejecutivoIds.add(account.OwnerId);
		}
		
		if (!accountIds.isEmpty()) {
			List<String> messages = CategoriaClienteUtils.asignarCategoriaDeCliente(accountIds);
			if (messages != null && !messages.isEmpty())
		errors.addAll(messages);
		}
	}
	

	global void finish(Database.BatchableContext bc) {
		CalcularFactorDeEjecutivoBatch.start(ejecutivoIds);
		if (!errors.isEmpty())
			sendEmails();
		

	}
	
	public static void start(Set<String> categorias) {
		start(categorias, false);
			}
	
	public static void start(Set<String> categorias, Boolean onlyNulls) {
		ActualizaCategoriasDeClientesBatch batch = new ActualizaCategoriasDeClientesBatch(categorias, onlyNulls);
		Database.executeBatch(batch, 50);
	}

	public void sendEmails(){
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.setSubject('[Vida Security] Reporte de Resultados de Cálculo de categorías de clientes');
		message.setToAddresses(new String[] {'contacto@gocode.cl'});
		String body = 'Se han recalculado ' + successes + ' categorias de cliente exitosamente.\n';
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
	 
}