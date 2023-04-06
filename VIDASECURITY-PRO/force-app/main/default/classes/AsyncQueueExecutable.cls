/**
 * Existen tres tipos de limites en las colas Salesforce:
 *
 * 1- Se pueden encolar como máximo 50 colas en un proceso asincrono con System.enqueueJob
 * 2- No existe limite de encolamientos siempre y cuando se realice un System.enqueueJob en los contextos asincronos de cola.
 * 3- Para la org Developer y Trial existe un limite de encolamientos de 5.
 *
 * Todo esto está controlado por las funciones getQueueableJobs y getLimitQueueableJobs de la clase Limits.
 */
public class AsyncQueueExecutable implements AsyncExecutable, Schedulable {

	private static final Log log = new Log(AsyncDispatcher.class);
	private static final Integer SLEEP_MINUTES = 30;
	private static Integer queuedTimes = 0;


	private Queueable queue;
	private Boolean noChain;
	private String queueName;

	public AsyncQueueExecutable(Queueable queue, Boolean noChain) {
		this.queue = queue;
		this.noChain = noChain;
		this.queueName = String.valueOf(this.queue).split(':')[0];
	}

	public Id execute() {
		// No se pueden encadenar queues en los tests.
		if (Test.isRunningTest() && (System.isQueueable() || System.isFuture()))
			return null;
		if (noChain && (System.isQueueable() || System.isFuture())){
			log.error('[WARNING]!!!!!!!!!!!!!!!!!!! La ejecución de la cola ' + this.queueName + ' fue despachada con la instrucción de no encadenarse. Saliendo de la cola.');
			return null;
		}
		if (Limits.getQueueableJobs() >= Limits.getLimitQueueableJobs()){
			if (System.isQueueable())
				queue.execute(null);
			return null;
		}
		try {
			return System.enqueueJob(queue);
		} catch (Exception e) {
			log.error(e);
		} finally {

		}
		return null;
	}




	public void execute(SchedulableContext SC) {
		AsyncDispatcher.dispatch(this);
	}

	public void schedule() {
		Decimal frequency = SLEEP_MINUTES;
		String cronexpression = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('s m H d M \'?\' yyyy');
		String jobName = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('\'Async Queue \'dd-MM-yyyy HH:mm:ss');
		Datetime notificationTime = Datetime.now().addMinutes(Integer.valueOf(frequency)).addMinutes(20);
		//Async_Monitor__c monitor = new Async_Monitor__c(Name = 'Monitoring', Message__c = 'Process executed at ' + DateTime.now().format('dd-MM-yyyy HH:mm:ss'), Notification_Time__c = notificationTime);
		//upsert monitor Async_Monitor__c.Name;
		String jobId = null;
		if (!Test.isRunningTest())
			jobID = system.schedule(jobName, cronexpression, this);
		//monitor.Message__c += ' and  scheduled with id: ' + jobId + ' named ' + jobName;
		//upsert monitor Async_Monitor__c.Name;
	}
}