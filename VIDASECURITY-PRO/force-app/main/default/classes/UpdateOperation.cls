public without sharing class UpdateOperation extends DMLOperation {
	
	private static final Log log = new Log(UpdateOperation.class);
	
	public UpdateOperation(Sobject[] sobjects, Boolean allOrNone, Type[] enabledTriggers) {
		super(sobjects, allOrNone, enabledTriggers);
	}

	public override void execute() {
		try {
			DatabaseUtils.updates(sobjects, allOrNone, enabledTriggers, true);
		} catch (Exception e) {
			log.error(e.getTypeName() + ': ' + e.getMessage() + '\n' + callerStackTrace);
		}
	}
}