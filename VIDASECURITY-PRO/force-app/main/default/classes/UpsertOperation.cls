public without sharing class UpsertOperation extends DMLOperation {
	private static final Log log = new Log(UpsertOperation.class);

	private Schema.SobjectField field;
	
	public UpsertOperation(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone, Type[] enabledTriggers) {
		super(sobjects, allOrNone, enabledTriggers);
				this.field = field;
					}

	public override void execute() {
		try {
			DatabaseUtils.upserts(sobjects, field, allOrNone, enabledTriggers);
		} catch (Exception e) {
			log.error(e.getTypeName() + ': ' + e.getMessage() + '\n' + callerStackTrace);
		}
	}
}