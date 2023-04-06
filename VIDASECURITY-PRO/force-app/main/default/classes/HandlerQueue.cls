public without sharing class HandlerQueue implements Queueable {


	private TriggerContext context;
	private List<TriggerHandler.AsyncHandlerInterface> handlers;
	private static final Log logger = new Log(HandlerQueue.class);

	public HandlerQueue() {
		this.context = new TriggerContext();
		this.handlers = new List<TriggerHandler.AsyncHandlerInterface>();
	}

	public void add(TriggerHandler.AsyncHandlerInterface handler) {
		this.handlers.add(handler);
	}

	public Boolean isEmpty() {
		return this.handlers.isEmpty();
	}

	// Se crea este metodo para instanciar el contexto solo cuando sea necesario.
	public void initTriggerContext(){
		this.context = new TriggerContext();
	}

	public void execute(){
		Savepoint sp = Database.setSavepoint();
		for (TriggerHandler.AsyncHandlerInterface handler : this.handlers) {
			String name = String.valueOf(handler).split(':')[0];
			Boolean success = TriggerHandler.handle(handler, this.context);
			if (!success) {
				//Database.rollback(sp);
				break;
			}
		}
	}

	public void execute(QueueableContext context) {
		execute();
	}
}