public class AsyncFutureExecutable implements AsyncExecutable {

	private static final Log log = new Log(AsyncFutureExecutable.class);
	private static final Integer LIMIT_TOLERANCE = 2;

	public Futurable future;

	public AsyncFutureExecutable(Futurable future) {
		this.future = future;
	}

	public Id execute() {
		log.debug('Entrando al metodo future');
		if (System.isFuture()){
			//TODO: Hacer llamada sincrona
			log.debug('Es Contexto futuro! saliendo');
			return null;
		}
		if (Limits.getFutureCalls() >= Limits.getLimitFutureCalls()){
			//TODO: Hacer llamada sincrona
			log.error('Has alcanzado el limites de llamadas futuras que se pueden hacer. Llamadas: ' + Limits.getFutureCalls());
			return null;
		}
		if (Limits.getFutureCalls() >= (Limits.getLimitFutureCalls() - LIMIT_TOLERANCE)){
			log.error('Estas proximo a alcanzar el limite de llamadas futuras que se pueden hacer. Llamadas: ' + Limits.getFutureCalls());
		}
		if (System.isFuture() || System.isBatch() || System.isQueueable() || System.isScheduled()) {
			future.execute(false);
			return null;
		}
		try {
			future.execute(true);
			// Revisar esto, una idea podría ser retornar el methodName en la interfaz futurable para mejorar la query.
			//AsyncApexJob[] jobs = [SELECT Id, CreatedById, CreatedBy.Name, ApexClassId,MethodName,Status FROM AsyncApexJob WHERE JobType = 'Future' AND CreatedById = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
			//if (jobs.isEmpty())
			//return null;
			//AsyncApexJob job = jobs[0];
			//return job.Id;
			return null;
		} catch (System.HandledException e) {
			// No cae en este catch
			// The maximum number of asynchronous Apex method executions (batch Apex, future methods, Queueable Apex, and scheduled Apex) per a 24-hour period
			// 250,000 or the number of user licenses in your organization multiplied by 200, whichever is greater
		} finally {

		}
		return null;
	}
}