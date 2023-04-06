public without sharing class DatabaseQueue implements Queueable {

	public DMLOperation[] operations {get; set;}

	public DatabaseQueue() {
		this.operations = new List<DMLOperation>();
	}

	public void add(DMLOperation operation) {
		if (operation!= null)
			this.operations.add(operation);
	}

	public void execute(QueueableContext context) {
		for (DMLOperation operation : operations)
			operation.execute();
	}

	public Boolean hasOperations(){
		return (this.operations != null && this.operations.size() > 0);
	}
}