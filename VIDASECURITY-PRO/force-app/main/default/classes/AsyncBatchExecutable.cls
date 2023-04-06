public class AsyncBatchExecutable implements AsyncExecutable {
	
	public Database.Batchable<Sobject> batch;
	public Boolean noChain;
	public Integer batchSize;
	
	public AsyncBatchExecutable(Database.Batchable<Sobject> batch, Boolean noChain, Integer batchSize) {
		this.batch = batch;
		this.noChain = noChain;
		this.batchSize = batchSize;
	}
	
	public Id execute() {
		if ((noChain && (System.isBatch() || System.isQueueable())) || System.isFuture())
			return null;
		if (batchSize == null)
			batchSize = 200;
		return Database.executeBatch(batch, batchSize);
	}
}