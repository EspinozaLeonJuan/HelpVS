public class TriggerHandler {

	private static final Log logger = new Log(TriggerHandler.class, true);
	public static Boolean isTesting = false;
	public static final Stack stack = new Stack();
	public static final List<Exception> exceptions = new List<Exception>();
	private Map<String, List<TriggerInterface>> eventHandlerMapping = new Map<String, List<TriggerInterface>>();
	private static Map<String,Integer> countExecutedHandlerMap = new Map<String,Integer>();

	public static final Evt[] AFTER_ALL_EVENTS = new Evt[] {Evt.afterinsert, Evt.afterupdate, Evt.afterdelete, Evt.afterundelete};
	public static final Evt[] AFTER_ALL_EVENTS_EXCEPT_INSERT = new Evt[] {Evt.afterupdate, Evt.afterdelete, Evt.afterundelete};
	public static final Evt[] AFTER_INSERT_UPDATE_UNDELETE = new Evt[] {Evt.afterinsert, Evt.afterupdate, Evt.afterundelete};
	public static final Evt[] BEFORE_INSERT_UPDATE = new Evt[] {Evt.beforeinsert, Evt.beforeupdate};
	public static final Evt[] BEFORE_INSERT = new Evt[] {Evt.beforeinsert};
	public static final Evt[] BEFORE_UPDATE = new Evt[] {Evt.beforeupdate};
	public static final Evt BEFORE_DELETE = Evt.beforedelete;
	public static final Evt[] AFTER_UPDATE = new Evt[] {Evt.afterupdate};
	public static final Evt[] AFTER_INSERT = new Evt[] {Evt.afterinsert};
	public static final Evt[] AFTER_DELETE = new Evt[] {Evt.afterdelete};
	public static final Evt[] AFTER_INSERT_UPDATE = new Evt[] {Evt.afterinsert,Evt.afterupdate};
	public static final Evt[] AFTER_INSERT_UPDATE_DELETE = new Evt[] {Evt.afterinsert, Evt.afterupdate, Evt.afterdelete};

	public enum Evt {
		afterdelete, afterinsert, afterundelete,
		afterupdate, beforedelete, beforeinsert, beforeupdate
	}

	public interface TriggerInterface {

	}

	public interface CountExecutionInterface {
		Integer getCount();
	}

	public interface HandlerInterface extends TriggerInterface {
		void handle();
	}

	public interface HandlerLogInterface extends HandlerInterface {
		Log getLog();
	}

	public interface AsyncHandlerInterface extends TriggerInterface {
		void handle(TriggerContext context);
	}

	// TODO: El objetivo de esta función es obtener dinamicamente todos los Handlers asociados al mapa
	// de instancia que estén implementando AsyncHandlerInterface. El problema que tengo es que debe ser
	// un metodo de instancia y no uno estático lo que me obliga a tener la referencia de la instancia
	// TriggerHandler en una clase utilitaria
	/*
	public AsyncHandlerInterface[] getAsyncHandlers(){
		Set<String> nameHandlers = new Set<String>();
		AsyncHandlerInterface[] asyncHandlers = new AsyncHandlerInterface[]{};
		for (String eventName : eventHandlerMapping.keySet()){
			TriggerInterface[] handlers = eventHandlerMapping.get(eventName);
			for (TriggerInterface ti : handlers){
				if (ti instanceof AsyncHandlerInterface){
					String name = String.valueOf(ti).split(':')[0];
					if (!nameHandlers.contains(name))
						asyncHandlers.add((AsyncHandlerInterface)ti);
				}
			}
		}
		return asyncHandlers;
	}
	*/

	public static void enable(Type[] handlerClasses) {
		for (Type t : handlerClasses)
			TriggerSettings.enable(t);
	}

	public static void enable(Type handlerClass) {
		TriggerSettings.enable(handlerClass);
	}

	public static void enable() {
		enable((Type)null);
	}

	public static void disable(Type[] handlerClasses) {
		for (Type t : handlerClasses)
			TriggerSettings.disable(t);
	}

	public static void disable(Type handlerClass) {
		TriggerSettings.disable(handlerClass);
	}

	public static void disable() {
		disable((Type)null);
	}

	public TriggerHandler bind(Evt[] events, TriggerInterface[] ehs) {
		for (TriggerInterface eh : ehs)
		bind(events, eh);
		return this;
	}

	public TriggerHandler bind(Evt[] events, TriggerInterface eh) {
		for (Evt event : events)
		bind(event, eh);
		return this;
	}

	public TriggerHandler bind(Evt event, TriggerInterface eh) {
		List<TriggerInterface> handlers = eventHandlerMapping.get(event.name());
		if (handlers == null) {
			handlers = new List<TriggerInterface>();
			eventHandlerMapping.put(event.name(), handlers);
		}
		handlers.add(eh);
		return this;
	}

	public TriggerHandler bind(Evt event, TriggerInterface[] ehs){
		for (TriggerInterface eh : ehs)
			bind(event, eh);
		return this;
	}

	public static void resetCountExecution(Type nameHandler){
		countExecutedHandlerMap.put(nameHandler.getName(), 0);
	}

	public static Integer getCountExecution(Type nameHandler){
		return getCountExecution(nameHandler.getName());
	}

	public static Integer getCountExecution(String nameHandler){
		Integer count = countExecutedHandlerMap.get(nameHandler);
		if (count == null)
			return 0;
		return count;
	}

	public void manage() {
		Evt ev = null;
		if(Trigger.isInsert && Trigger.isBefore)
		{
			ev = Evt.beforeinsert;
		}
		else if(Trigger.isInsert && Trigger.isAfter)
		{
			ev = Evt.afterinsert;
		}
		else if(Trigger.isUpdate && Trigger.isBefore)
		{
			ev = Evt.beforeupdate;
		}
		else if(Trigger.isUpdate && Trigger.isAfter)
		{
			ev = Evt.afterupdate;
		}
		else if(Trigger.isDelete && Trigger.isBefore)
		{
			ev = Evt.beforedelete;
		}
		else if(Trigger.isDelete && Trigger.isAfter)
		{
			ev = Evt.afterdelete;
		}
		else if(Trigger.isundelete)
		{
			ev = Evt.afterundelete;
		}

		List<TriggerInterface> handlers = eventHandlerMapping.get(ev.name());
		HandlerQueue queue = new HandlerQueue();
		//Savepoint sp = Database.setSavepoint();
		if (handlers != null && ! handlers.isEmpty()) {
			for (TriggerInterface h : handlers) {
				System.assertNotEquals(null, h, 'EL handler es nulo');
				String name = String.valueOf(h).split(':')[0];
				Type klass = Type.forName(name);
				System.assertNotEquals(null, klass, 'La clase es null');
				if (!TriggerSettings.isEnabled(klass)) {
					logger.warn('WARNING: El trigger ' + name + ' está deshabilitado.');
					continue;
				}
				if ((h instanceof TriggerHandler.CountExecutionInterface) && (getCountExecution(name) >= ((CountExecutionInterface) h).getCount())){
					logger.warn('WARNING: Ha superado la cantidad de execuciones definidas para el Handler: ' + name);
					continue;
				}
				if (h instanceof TriggerHandler.HandlerInterface) {
					logger.debug('Ejecutando trigger síncrono: ' + name);
					Boolean success = handle(h);
					if (!success) {
						//Database.rollback(sp);
						break;
					}
				} else if (h instanceof TriggerHandler.AsyncHandlerInterface) {
					logger.debug('Encolando trigger asíncrono: ' + name);
					queue.add((AsyncHandlerInterface)h);
				}
				logger.debug('Aumentando en 1 el contador del Handler: ' + name);
				countExecutedHandlerMap.put(name, getCountExecution(name) + 1);
			}
			if (!queue.isEmpty()) {
				logger.debug('Lanzando ejecución de triggers asíncronos');
				Id jobId = AsyncDispatcher.execute(queue);
			}
			logger.commitLogs();
		}
	}



	private static Boolean handle(TriggerInterface h) {
		return handle(h, null);
			}

	public static Boolean handle(TriggerInterface h, TriggerContext context) {
		Boolean success = false;
		try {
			stack.push(h);
			if (h instanceof HandlerInterface)
				((HandlerInterface)h).handle();
			else if (h instanceof AsyncHandlerInterface)
				((AsyncHandlerInterface)h).handle(context);
			success = true;
			stack.pop();
		} catch (Exception e) {
			addError(e);
		}
		return success;
	}



	/*public static void addError(Exception e) {
		if (Test.isRunningTest() && !isTesting)
		throw e;

		exceptions.add(e); // Vamos guardando las excepciones de cada nivel de la pila porque no se propagan bien, las sacaremos desde la primera hasta la última.
		//IMPORTANTE: Si estemétodo se llama desde un nivel de profundidad N el stack debe llenarse con N handlers. Cuando este método se llama directamente desde dentro de un handler, el manage ya hizo push() de ese handler así que no debería haber problema.
		if (stack.size() > 1) {
			stack.pop();
			throw e; // Se lanza para subir un nivel en la pila de ejecución.
		}
		TriggerInterface th = (TriggerInterface)stack.peek();
		Log logLocal = log;
		if (th instanceof HandlerLogInterface) {
			HandlerLogInterface hli = (HandlerLogInterface)th;
			logLocal = hli.getLog();
		}

		Exception root = exceptions.get(0); // sacamos la excepción raiz
		if (root instanceof AbstractHandlerException)
			addError((AbstractHandlerException)root, logLocal);
		else if (root instanceof System.Dmlexception)
			addError((System.Dmlexception)root, logLocal);
		else {
			logLocal.error(root);
			//String javascript = '<script type="text/javascript" src="/soap/ajax/30.0/connection.js" />' +
//'<script type="text/javascript" src="/soap/ajax/30.0/apex.js" />' +
//'sforce.apex.execute("LogWebService","error",{message: "Test"});' +
//'alert("works");';
			//addError('Ocurrió un problema al realizar esta operación,<br/>por favor comuníquese con el Administrador del sistema.<script>' + javascript + '</script>', null, logLocal);
		}
	}*/

	public static void addError(Exception e) {
		if (Test.isRunningTest() && !isTesting)
		throw e;

		exceptions.add(e); // Vamos guardando las excepciones de cada nivel de la pila porque no se propagan bien, las sacaremos desde la primera hasta la última.
		//IMPORTANTE: Si estemétodo se llama desde un nivel de profundidad N el stack debe llenarse con N handlers. Cuando este método se llama directamente desde dentro de un handler, el manage ya hizo push() de ese handler así que no debería haber problema.
		if (stack.size() > 1) {
			stack.pop();
			throw e; // Se lanza para subir un nivel en la pila de ejecución.
		}
		TriggerInterface th = (TriggerInterface)stack.peek();
		Log logLocal = logger;
		if (th instanceof HandlerLogInterface) {
			HandlerLogInterface hli = (HandlerLogInterface)th;
			logLocal = hli.getLog();
		}

		Exception root = exceptions.get(0); // sacamos la excepción raiz
		if (root instanceof AbstractHandlerException)
			addError((AbstractHandlerException)root, logLocal);
		else if (root instanceof System.Dmlexception)
			addError((System.Dmlexception)root, logLocal);
		else {
			logLocal.error(root);
			String javascript = 'var data = \'{"message" : "' + EncodingUtil.base64Encode(Blob.valueOf(root.getMessage())) + '", "stackTrace" : "' + EncodingUtil.base64Encode(Blob.valueOf(Log.printException(root))) + '"}\';' +
			'var xhr = new XMLHttpRequest();' +
			'console.log("ejecutando javascript");' +
			'xhr.addEventListener("readystatechange", function () {' +
			'if (this.readyState === this.DONE) {' +
			'console.log(this.responseText);' +
			'}' +
			'});' +
			'xhr.open("POST", "/services/apexrest/log.json");' +
			'xhr.setRequestHeader("Accept", "application/json");' +
			'xhr.setRequestHeader("Content-Type", "application/json");' +
			'xhr.setRequestHeader("Authorization", "Bearer ' + UserInfo.getSessionId() + '");' +
			'xhr.send(data);';
			addError('Ocurrió un problema al realizar esta operación,<br/>por favor comuníquese con el Administrador del sistema.<script type="text/javascript">' + javascript + '</script>', null, logLocal);
		}
	}

	public static void addError(AbstractHandlerException e, Log logLocal) {
		Sobject source = e.source;
		Id sourceId = source == null ? null : (Id)source.get('Id');
		Sobject currentTarget = Trigger.new != null ? Trigger.new[0] : (Trigger.old != null ? Trigger.old[0] : null);
		Sobject target = e.target;
		if (currentTarget != null && target != null && currentTarget.getSobjectType() != target.getSobjectType())
		target = currentTarget; // corregimos el target por el del tope de la pila.
		String message = e == null ? null : e.getMessage();
		String stackTrace = e.getStackTraceString();
		addError(message, stackTrace, target, source, logLocal);
	}

	private static Set<StatusCode> STATUS_CODES = new Set<StatusCode> {
		StatusCode.FIELD_CUSTOM_VALIDATION_EXCEPTION,
		StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION
	};


	public static void addError(System.DMLException e, Log logLocal) {
		for (Integer i=0; i < e.getNumDml(); i++) {
			String[] fields = e.getDmlFieldNames(i);
			String dmlId = e.getDmlId(i);
			String message = e.getDmlMessage(i);
			String stackTrace = e.getStackTraceString();
			StatusCode status = e.getDMLType(i);
			Schema.SObjectType dmlType = dmlId == null ? null : ReflectionUtils.getSobjectType(dmlId);
			Sobject dml = dmlType == null ? null : dmlType.newSobject(Id.valueOf(dmlId));
			if (STATUS_CODES.contains(status))
				addError(message, stackTrace, null, dml, logLocal);
			else
				logLocal.error(e);
		}
	}

	public static void addError(String message, Sobject target) {
		addError(message, target, logger);
	}

	public static void addError(String message, Sobject target, Log logLocal) {
		addError(message, null, target, target, logLocal);
		}


	/**
	* Método que reemplazará a target.addError(message);
	* @param message Texto de negocio del error
	* @param stackTrace Traza del error.
	* @param target Objeto donde se anexará el error en caso de Trigger.isExecuting, en caso de ser null se obtiene de Trigger.new[0] o Trigger.old[0], en caso de no sercontexto
	* de trigger, debe loggear el error para despachar el email en logLocal.
	* @param source Registro que provocó el error, no necesariamente está relacionado con target.
	* @param logLocal Log utilizado para agregar el error.
	**/
	public static void addError(String message, String stackTrace, Sobject target, Sobject source, Log logLocal) {
		if (stack.size() > 1)
			throw new HandlerException(message, target, source); // lanzamos para subir un nivel en la pila
		Id sourceId = source == null ? null : (Id)source.get('Id');
		Schema.SobjectType sourceType = sourceId == null ? null : ReflectionUtils.getSobjectType(sourceId);
		String sourceLabel = sourceType == null ? null : sourceType.getDescribe().getLabel();
		String sourceName = sourceType == null ? null : sourceType.getDescribe().getName();
		String linkField = ReflectionUtils.exists(sourceName, 'Name') ? 'Name' : 'Subject';
		Sobject sourceObject = null;
		if (sourceId != null && sourceName != null && Limits.getQueries() < Limits.getLimitQueries()) {
			String query = 'SELECT ' + linkField + ' FROM ' + sourceName + ' WHERE Id = \'' + sourceId + '\'';
			sourceObject = Database.query(query);
		}

		Sobject currentTarget = Trigger.new != null ? Trigger.new[0] : (Trigger.old != null ? Trigger.old[0] : null);
		if (Trigger.isExecuting && (target == null || (target != null && currentTarget.getSobjectType() != target.getSobjectType())))
			target = currentTarget;

			Id targetId = target == null ? null : (Id)target.get('Id');
			Schema.SObjectType targetType = targetId == null ? null : ReflectionUtils.getSobjectType(targetId);
			String targetLabel = targetType == null ? null : targetType.getDescribe().getLabel();

		String linkLabel = sourceLabel == null ? '' : sourceLabel;
		linkLabel += sourceObject == null ? '' : (' (' + (String)sourceObject.get(linkField) + ')');
		if (Trigger.isExecuting && target != null && !System.isBatch() && !System.isFuture() && !System.isQueueable() && !System.isScheduled()) {
			if (sourceId != null && sourceId != targetId)
			message = 'Ocurrió un error procesando los registros de <a href="/' + sourceId + '">' + linkLabel + '</a>. El error encontrado fue: ' + message;
			target.addError(message, false); // El parámetro false nos permite agregar un error HTML
		} else {
			Exception e = exceptions.isEmpty() ? null : exceptions.get(0);
			logLocal.error(message, e, source);
		}
	}
}