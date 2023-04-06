trigger AttachmentTrigger on Attachment (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
	new TriggerHandler()
		.bind(TriggerHandler.BEFORE_INSERT, new EmailAttachmentReassignerHandler())
		.bind(TriggerHandler.AFTER_INSERT, new TriggerHandler.TriggerInterface[] {
			new CopiaAdjuntoDeCasoSFHandler(),
			new CopiaAdjuntoDeEmailCasoSFHandler()
		})
		.bind(TriggerHandler.AFTER_ALL_EVENTS, new RespuestaTieneAdjuntoHandler())
		.manage();
}