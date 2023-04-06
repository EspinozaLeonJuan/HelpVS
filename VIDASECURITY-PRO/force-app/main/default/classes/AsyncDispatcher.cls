// El objetivo de esta clase son los siguientes:
// 1- Despachar un proceso asincrono, sea un metodo futuro, cola, batch o proceso programado.
// 2- Prevenir nuevas ejecuciones me metodos futuros dentro de contextos futuros (future o batch)
// 3- Prevenir volver a ejecutar un proceso futuro si ya está ejecutandose independientemente del contexto de ejecución. Investigar acerca de isBatchActive()
// 4- Prevenir del limite de encolamientos.

// Performance:
// Queue        >         Future Calls        >         Batch
// Chainable              No Chainable                  Chainable
// JobId                  No JobId                      JobId
public class AsyncDispatcher {


	public static Id dispatch(AsyncExecutable async) {
		return async.execute();
	}

	public static Id execute(Queueable queue, Boolean noChain) {
		return AsyncDispatcher.dispatch(new AsyncQueueExecutable(queue, noChain));
	}

	public static Id execute(Queueable queue) {
		return AsyncDispatcher.execute(queue, false);
	}

	public static Id execute(Futurable future) {
		return AsyncDispatcher.dispatch(new AsyncFutureExecutable(future));
	}

	public static Id execute(Database.Batchable<Sobject> batch, Boolean noChain, Integer batchSize) {
		return AsyncDispatcher.dispatch(new AsyncBatchExecutable(batch, noChain, batchSize));
	}

	public static Id execute(Database.Batchable<Sobject> batch, Integer batchSize) {
		return AsyncDispatcher.execute(batch, false, batchSize);
	}

	public static Id execute(Database.Batchable<Sobject> batch) {
		return AsyncDispatcher.execute(batch, null);
	}
}