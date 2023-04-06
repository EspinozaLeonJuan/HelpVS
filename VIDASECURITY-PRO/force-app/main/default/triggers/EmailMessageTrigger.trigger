trigger EmailMessageTrigger on EmailMessage (after delete, after insert, after undelete, after update, before delete, before insert, before update) {

	new TriggerHandler()
		.bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.TriggerInterface[]{
			new CheckAndSaveEmailTemplateHandler()
		})
		.bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.TriggerInterface[]{
			new AddEmailAsAttachmentHandler()
		})
		.manage();
}