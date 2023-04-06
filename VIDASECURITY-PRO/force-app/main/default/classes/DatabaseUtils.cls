public without sharing class DatabaseUtils {

	public class DatabaseException extends Exception {}

	private static final Log logger = new Log(DatabaseUtils.class);
	private static final Boolean ASYNCHRONUS_CONTEXT;

	public static DatabaseQueue queue = new DatabaseQueue();

	static {
		ASYNCHRONUS_CONTEXT = System.isFuture() || System.isScheduled() || System.isQueueable() || System.isBatch();
	}

	public static Database.SaveResult updates(SObject sobj){
		return updates(new SObject[]{sobj}, false).get(0);
	}

	public static Database.SaveResult[] updates(SObject[] sobjects){
		return updates(sobjects, false);
	}

	public static Database.SaveResult[] updates(SObject[] sobjects, Boolean allOrNone){
		return updates(sobjects, allOrNone, false);
	}

	private static void logErrors(Database.SaveResult[] saveResults, Sobject[] sobjects, Boolean throwsException) {
		for (Integer i=0; i < saveResults.size(); i++) {
			Database.SaveResult result = saveResults[i];
			if (result.IsSuccess()) continue;
			SObject obj = sobjects[i];
			String name = ReflectionUtils.getDescribe(obj.getSobjectType()).getLabel();
			Id recordId = result.getId();
			for (Database.Error error : result.getErrors()) {
				if (Test.isRunningTest())
					throw new DatabaseException('There is an error on update or insert! [Id:' + recordId + ']: ' + error.getMessage());
				else if (Trigger.isExecuting && throwsException && !ASYNCHRONUS_CONTEXT) {
					Sobject target = Trigger.isDelete? Trigger.old[0] : Trigger.new[0];
					target.addError('Ocurrió un problema actualizando los registros de ' + name + '. ' + error.getMessage() + '. <a href="/' + recordId + '">Ver ' + name + '</a>', false);
				} else
					logger.error('There is an error on update!: ' + error.getMessage(), obj);
			}
		}
	}

	private static void logErrors(Database.UpsertResult[] results, Sobject[] sobjects, Boolean throwsException) {
		for (Integer i=0; i < results.size(); i++) {
			Database.UpsertResult result = results[i];
			if (result.IsSuccess()) continue;
			SObject obj = sobjects[i];
			String name = ReflectionUtils.getDescribe(obj.getSobjectType()).getLabel();
			Id recordId = result.getId();
			for (Database.Error error : result.getErrors()) {
				if (Test.isRunningTest())
					throw new DatabaseException('There is an error on upsert! [Id:' + recordId + ']: ' + error.getMessage());
				else if (Trigger.isExecuting && throwsException && !ASYNCHRONUS_CONTEXT) {
					Sobject target = Trigger.isDelete? Trigger.old[0] : Trigger.new[0];
					target.addError('Ocurrió un problema actualizando los registros de ' + name + '. ' + error.getMessage() + '. <a href="/' + recordId + '">Ver ' + name + '</a>', false);
				} else
					logger.error('There is an error on upsert!: [User Id: ' + UserInfo.getUserId() + ']: ' + error.getMessage(), obj);
			}
		}
	}

	private static void logErrors(Database.DeleteResult[] results, Sobject[] sobjects, Boolean throwsException) {
		for (Integer i=0; i < results.size(); i++) {
			Database.DeleteResult result = results[i];
			if (result.IsSuccess()) continue;
			SObject obj = sobjects[i];
			String name = ReflectionUtils.getDescribe(obj.getSobjectType()).getLabel();
			Id recordId = result.getId();
			for (Database.Error error : result.getErrors()) {
				if (Test.isRunningTest())
					throw new DatabaseException('There is an error on upsert! [Id:' + recordId + ']: ' + error.getMessage());
				else if (Trigger.isExecuting && throwsException && !ASYNCHRONUS_CONTEXT) {
					Sobject target = Trigger.isDelete? Trigger.old[0] : Trigger.new[0];
					target.addError('Ocurrió un problema al eliminar el registro de ' + name + '. ' + error.getMessage() + '. <a href="/' + recordId + '">Ver ' + name + '</a>', false);
				} else
					logger.error('There is an error on delete!: [User Id: ' + UserInfo.getUserId() + ']: ' + error.getMessage(), obj);
			}
		}
	}

	public static Database.SaveResult[] inserts(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers){
		return inserts(sobjects, allOrNone, disableTriggers, false);
	}

	public static Database.SaveResult[] inserts(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers, Boolean throwsExceptions){
		Type[] enabledTriggers = disableTriggers ? new Type[] {} : null;
		return inserts(sobjects, allOrNone, enabledTriggers, throwsExceptions);
	}

	public static Database.SaveResult[] inserts(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers) {
		return inserts(sobjects, allOrNone, enabledTriggers, false);
	}

	public static Database.SaveResult[] inserts(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers, Boolean throwsExceptions) {
		if (sobjects == null || sobjects.size() == 0) return null;
		if (enabledTriggers != null)
			TriggerSettings.enableOnly(enabledTriggers);
		Database.SaveResult[] saveResults = null;
		try {
			saveResults = Database.insert(sobjects, allOrNone);
			if (!allOrNone)
				logErrors(saveResults, sobjects, throwsExceptions);
		} catch (Exception e) {
			throw e;
		} finally {
			if (enabledTriggers != null)
				TriggerSettings.restore();
		}
		return saveResults;
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects) {
		return deletes(sobjects, true, false);
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects, Boolean allOrNone) {
		return deletes(sobjects, allOrNone, false);
	}

	public static Database.DeleteResult[] deletes(SObject sobjects) {
		return deletes(new SObject[] {sobjects});
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers) {
		return deletes(sobjects, allOrNone, disableTriggers, false);
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers, Boolean throwsExceptions) {
		Type[] enabledTriggers = disableTriggers ? new Type[] {} : null;
		return deletes(sobjects, allOrNone, enabledTriggers, throwsExceptions);
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers) {
		return deletes(sobjects, allOrNone, enabledTriggers, false);
	}

	public static Database.DeleteResult[] deletes(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers, Boolean throwsExceptions) {
		if (sobjects == null || sobjects.size() == 0) return null;
		if (enabledTriggers != null)
			TriggerSettings.enableOnly(enabledTriggers);
		Database.DeleteResult[] deleteResults = null;
		try {
			deleteResults = Database.delete(sobjects, allOrNone);
			if (!allOrNone)
				logErrors(deleteResults, sobjects, throwsExceptions);
		} catch (Exception e) {
			throw e;
		} finally {
			if (enabledTriggers != null)
				TriggerSettings.restore();
		}
		return deleteResults;
	}

	public static Database.SaveResult[] updates(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers) {
		return updates(sobjects, allOrNone, disableTriggers, false);
	}

	public static Database.SaveResult[] updates(SObject[] sobjects, Boolean allOrNone, Boolean disableTriggers, Boolean throwsException){
		Type[] enabledTriggers = disableTriggers ? new Type[] {} : null;
		return updates(sobjects, allOrNone, enabledTriggers, throwsException);
	}

	public static Database.SaveResult[] updates(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers) {
		return updates(sobjects, allOrNone, enabledTriggers, false);
	}

	/**
	 * Funcion utilitaria que actualiza un arreglo de objetos de tipo sobjects.
	 *
	 * @param  sobjects        Arreglo de objetos sobjects a actualizar.
	 * @param  allOrNone       Verdadero: La operación DML se anula completamente si existe error. Falso: Actualiza lo que puede.
	 * @param  enabledTriggers Nulo: Habilita todos los triggers | Arreglo vacio: Deshabilita todo | Arreglo lleno: Habilita solo lo especificado.
	 * @param  throwsException Verdadero: Lanza siempre la excepción para que sea controlada por la capa de más arriba, esto es independientemente si el parametro allOrNone.
	 * @return                 Arreglo de Database.Result.
	 */
	public static Database.SaveResult[] updates(SObject[] sobjects, Boolean allOrNone, Type[] enabledTriggers, Boolean throwsException) {
		if (sobjects == null || sobjects.size() == 0) return null;
		if (enabledTriggers != null)
			TriggerSettings.enableOnly(enabledTriggers);
		Database.SaveResult[] saveResults = null;
		try {
			saveResults = Database.update(sobjects, allOrNone);
			if (!allOrNone)
				logErrors(saveResults, sobjects, throwsException);
		} catch (Exception e) {
			throw e;
		} finally {
			if (enabledTriggers != null)
				TriggerSettings.restore();
		}
		return saveResults;
	}

	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone) {
		return upserts(sobjects, field, allOrNone, false, false);
	}

	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone, Boolean disableTriggers) {
		return upserts(sobjects, field, allOrNone, disableTriggers, false);
	}

	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone, Boolean disableTriggers, Boolean throwsException) {
		Type[] enabledTriggers = disableTriggers ? new Type[] {} : null;
		return upserts(sobjects, field, allOrNone, enabledTriggers, throwsException);
	}

	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone, Type[] enabledTriggers) {
		return upserts(sobjects, field, allOrNone, enabledTriggers, false);
	}

	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone, Type[] enabledTriggers, Boolean throwsException) {
		if (sobjects == null || sobjects.size() == 0) return null;
		if (enabledTriggers != null)
			TriggerSettings.enableOnly(enabledTriggers);
		Database.UpsertResult[] results = null;
		try {
			results = UpsertCasting.upserts(sobjects, field, allOrNone);
			if (!allOrNone)
				logErrors(results, sobjects, throwsException);
		} catch (Exception e) {
			throw e;
		} finally {
			if (enabledTriggers != null)
				TriggerSettings.restore();
		}
		return results;
	}

	public static void enqueueDMLJob() {
		if (DatabaseUtils.queue.hasOperations()) {
			Id jobId = AsyncDispatcher.execute(DatabaseUtils.queue);
			DatabaseUtils.queue = new DatabaseQueue();
		}
	}

}