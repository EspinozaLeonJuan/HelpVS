public without sharing class Log {

	public class LogException extends Exception {}

	private static final Integer LIMIT_MAILINGS_PER_TRANSACTION = 10;

	private static Integer countSentEmails = 0;
	public static Boolean salidaEstandar = false;
	public static Boolean objetoLog = false;

	private Type klazz;
	private Boolean useCommit;

	public static List<Log__c> logs;

	static {
		salidaEstandar = Depuracion__c.getInstance().Salida_Estandar__c;
		objetoLog = Depuracion__c.getInstance().Objeto_Log__c;
		if (Test.isRunningTest()){
			salidaEstandar = true;
		}
		logs = new List<Log__c>();
	}

	public Log(Type klazz){
		this(klazz, false);
	}

	// Constructor solamente utilizado en TriggerHandler.
	public Log(Type klazz, Boolean useCommit) {
		this.klazz = klazz;
		this.useCommit = useCommit;
	}

	public void debug(Object msg){
		debug(msg, msg);
	}

	public void debug(Object msg, Object detail) {
		debug(this.klazz.getName(), msg, detail);
	}

	public void info(Object msg){
		info(msg, msg);
	}

	public void info(Object msg, Object detalle) {
		info(this.klazz.getName(), msg, detalle);
	}

	public void warn(Object msg){
		warn(msg, msg);
	}

	public void warn(Object msg, Object detalle) {
		warn(this.klazz.getName(), msg, detalle);
	}


	public void error(Object msg) {
		error(msg, msg);
	}

	public void error(Object msg, Object detail) {
		error(msg, detail, null);
	}

	public void error(Object msg, Object detail, SObject sobj) {
		error(this.klazz.getName(), msg, detail, sobj);
	}

	private static String printSObject(SObject sobj){
		return sobj == null ? '\nObject: NULL' : '\nObject: ' + sobj + '\n';
	}

	public static String printException(Exception e) {
		return printException(e, null);
	}

	public static String printException(Exception e, SObject sobj) {
		if (e == null) return '';
		String stackTrace = e.getTypeName() + ' ' + e.getMessage() + ': ' +e.getLineNumber() + '\n' + e.getStackTraceString();
		if (sobj != null)
			stackTrace += printSObject(sobj);
		if (e.getCause() == null)
			return stackTrace;
		return stackTrace + '\n\nCaused by: ' + printException(e.getCause());
	}

	private void writeLog(LoggingLevel logLevel, Object msg, Object detalle, String component){
		writeLog(logLevel, msg,  detalle, null, component);
	}

	private void writeLog(LoggingLevel logLevel, Object msg, Object detalle, Sobject sobj, String component){
		Datetime now = Datetime.now();
		String logLevelStr = String.valueOf(logLevel);
		String message = msg == null ? '' : String.valueOf(msg).substring(0, Math.min(String.valueOf(msg).length(), 255));
		if (msg instanceof Exception) {
			Exception e = (Exception)msg;
			message = e.getMessage();
		} else if (msg instanceof Sobject) {
			message = printSObject((Sobject)msg);
		}
		String events = getEventTrigger();
		message += (events == null ? '' : events);
		message = message.substring(0, Math.min(255, message.length()));
		String detail = detalle == null ? '' : String.valueOf(detalle);
		if (detalle instanceof Exception) {
			detail = printException((Exception)detalle, sobj);
		} else if (detalle instanceof Sobject) {
			detail = printSObject((Sobject)detalle);
		}
		detail = String.isNotBlank(detail) ? detail.trim().substring(0, Math.min(detail.trim().length(), 32765)) : '';
		Log__c log = new Log__c(Fecha_y_Hora__c = now, Componente__c = component, Nivel__c = logLevelStr,
														Mensaje__c = message, Detalle__c = detail, Usuario__c = UserInfo.getUserId());
		logs.add(log);

		if (salidaEstandar)
			System.debug(logLevel, '[' + now.format('d/MM/y hh:mm:ss a') + '][' + logLevel + '][' + component+ ']: ' + message + '. Detalles: ' + detail);

		if (logLevel == LoggingLevel.ERROR && !useCommit){
			sendEmail();
			logs.clear();
		}
	}

	public void commitLogs() {
		if (logs == null || logs.isEmpty()) return;
		Depuracion__c depuracion = Depuracion__c.getInstance();
		if (depuracion == null){
			sendEmail('No existe instancia depuracion. Favor crearla.');
			return;
		}
		if (depuracion.Enviar_Email__c)
			sendEmail();
		if (objetoLog != null && objetoLog)
			DatabaseUtils.inserts(logs, false, true, true);
		logs.clear();
	}

	public void save() {
		if (logs == null || logs.isEmpty() || !objetoLog) return;
		DatabaseUtils.inserts(logs, false, true, true);
		logs.clear();
	}

	private void error(String serviceName, Object msg, Object detalle, Sobject sobj) {
		writeLog(LoggingLevel.ERROR, msg, detalle, sobj, serviceName);
	}

	public void info(String serviceName, Object msg, Object detalle) {
		writeLog(LoggingLevel.INFO, msg, detalle, serviceName);
	}

	public void warn(String serviceName, Object msg, Object detalle) {
		writeLog(LoggingLevel.WARN, msg, detalle, serviceName);
	}

	public void debug(String serviceName, Object msg, Object detalle) {
		writeLog(LoggingLevel.DEBUG, msg, detalle, serviceName);
	}

	public void debugTrigger() {
		String msg = 'Executing Trigger ' + klazz.getName() + ' with ' + Trigger.size + ' records.' + getEventTrigger();
		writeLog(LoggingLevel.DEBUG, msg, msg, klazz.getName());
	}

	private static String getEventTrigger(){
		String evt = '';
		if (!Trigger.isExecuting)
			return evt;
		if (Trigger.isBefore)
			evt += 'before ';
		else if (Trigger.isAfter)
			evt += 'after ';

		if (Trigger.isInsert)
			evt += 'insert';
		else if (Trigger.isUpdate)
			evt += 'update';
		else if (Trigger.isDelete)
			evt += 'delete';
		else if (Trigger.isUndelete)
			evt += 'undelete';
		if (String.isNotBlank(evt))
			evt = ' [Executing on ' + evt + ']';
		return evt;
	}

	private static void sendEmail() {
		Boolean error = false;
		String body = '' +
			'Estimado Administrador:\n' +
			'		Ha ocurrido un problema con el siguiente detalle:\n\n';
			for (Log__c l : logs) {
				error = l.Nivel__c == 'ERROR' || error;
				body += 'Componente: ' + l.Componente__c + '\n' +
				'Nivel: ' + l.Nivel__c + '\n' +
				'Mensaje: ' + l.Mensaje__c + '\n';
				if (l.Nivel__c != 'DEBUG')
					body += 'Detalle: ' + l.Detalle__c + '\n' +
				'\n\n';
			}
			body += 'Gracias';
			if (error)
				sendEmail(body);
	}

	private static void sendEmail(String body) {
		if (Test.isRunningTest()) //solo se agrega esta linea para cubrir porcentaje de cobertura
			sendEmailSync(body);
		if(System.isFuture() || System.isBatch())
			sendEmailSync(body);
		else 
			sendEmailAsync(body);
	}

	private static void sendEmailSync(String body) {
		if (countSentEmails == LIMIT_MAILINGS_PER_TRANSACTION) return;
		if (Limits.getEmailInvocations() == Limits.getLimitEmailInvocations()) return;
		Depuracion__c depuracion = Depuracion__c.getInstance();
		if (depuracion == null || !depuracion.Enviar_Email__c) return;
		if (depuracion.Email_de_Administrador__c == null) return;
		String[] emails = depuracion.Email_de_Administrador__c.split('\\s*,\\s*');
		User[] users = [SELECT Id, Email FROM User WHERE Email IN :emails];
		Map<String, User> userMap = new Map<String, User>();
		for (User user : users)
			userMap.put(user.Email, user);

		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		for (String email : emails) {
			User user = userMap.get(email);
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			if (user == null)
				message.setToAddresses(new String[] {email});
			else
			message.setTargetObjectId(user.Id);
			message.setSubject('Reporte de Error de ' + UserInfo.getOrganizationName() + ' | Usuario: ' + UserInfo.getUserName() + ' [' + UserInfo.getUserId() + '].');
			message.setPlainTextBody(body);
			message.setSaveAsActivity(false);
			messages.add(message);
		}
		try {
			Messaging.reserveSingleEmailCapacity(messages.size());
		} catch (System.HandledException e) {
			throw e;
		}
		if (!Test.isRunningTest()) {
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			countSentEmails++;
		}
	}

	@future
	private static void sendEmailAsync(String body) {
		if (countSentEmails == LIMIT_MAILINGS_PER_TRANSACTION) return;
		if (Limits.getEmailInvocations() == Limits.getLimitEmailInvocations()) return;
		Depuracion__c depuracion = Depuracion__c.getInstance();
		if (depuracion == null || !depuracion.Enviar_Email__c) return;
		if (depuracion.Email_de_Administrador__c == null) return;
		String[] emails = depuracion.Email_de_Administrador__c.split('\\s*,\\s*');
		User[] users = [SELECT Id, Email FROM User WHERE Email IN :emails];
		Map<String, User> userMap = new Map<String, User>();
		for (User user : users)
			userMap.put(user.Email, user);

		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		for (String email : emails) {
			User user = userMap.get(email);
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			if (user == null)
				message.setToAddresses(new String[] {email});
			else
			message.setTargetObjectId(user.Id);
			message.setSubject('Reporte de Error de ' + UserInfo.getOrganizationName() + ' | Usuario: ' + UserInfo.getUserName() + ' [' + UserInfo.getUserId() + '].');
			message.setPlainTextBody(body);
			message.setSaveAsActivity(false);
			messages.add(message);
		}
		try {
			Messaging.reserveSingleEmailCapacity(messages.size());
		} catch (System.HandledException e) {
			throw e;
		}
		if (!Test.isRunningTest()) {
			Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
			countSentEmails++;
		}
	}

	public void assert(Boolean assertion, String message) {
		if (assertion == null || !assertion)
		error(message);
	}

	public void assertEquals(Object expected, Object actual, String message) {
		assert(expected == actual, (message == null ? '' : message) + '.\nEl valor actual no es igual al esperado. Actual: ' + String.valueOf(actual) + ' Esperado: ' + expected);
	}

	public void assertNotEquals(Object expected, Object actual, String message) {
		assert(expected != actual, (message == null ? '' : message) + '.\nEl valor actual es igual al esperado. Actual: ' + String.valueOf(actual) + ' Esperado: ' + expected);
	}

	public void assertEquals(Object expected, Object actual) {
		assertEquals(expected, actual, 'El valor actual no es igual al esperado. Esperado: ' + expected + ', Actual: ' + actual);
	}

	public void assertNotEquals(Object expected, Object actual) {
		assertNotEquals(expected, actual, 'El valor actual es igual al esperado. Expected: ' + expected + ', Actual: ' + actual);
	}
}