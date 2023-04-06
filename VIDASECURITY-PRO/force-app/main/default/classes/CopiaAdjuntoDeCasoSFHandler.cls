public class CopiaAdjuntoDeCasoSFHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		if (!ControlTest.CopiaAdjuntoDeCaso && Test.isRunningTest())
			return;

		Set<Id> caseIds = new Set<Id>();
		for (Attachment attachment : (Attachment[])Trigger.new) {
			if (!caseIds.contains(attachment.ParentId) && attachment.ParentId != null && String.valueOf(attachment.ParentId).startsWith('500'))
				caseIds.add(attachment.ParentId);
		}

		Map<Id, Case> caseMap = new Map<Id, Case>([SELECT Id, Numero_caso_estandar__c FROM Case WHERE Numero_Caso_Estandar__c IN :caseIds]);
		for (Case caso : caseMap.values())
			caseMap.put(caso.Numero_Caso_Estandar__c, caso);

		List<Attachment> attachments = new List<Attachment>();
		for (Attachment original : (Attachment[])Trigger.new) {
			if (original.ParentId != null && String.valueOf(original.ParentId).startsWith('500')) {
				Case destino = caseMap.get(original.ParentId);
				if (destino != null) {
					Attachment attachment = new Attachment(Body = original.Body, ContentType = original.ContentType, Description = original.Description, Name = original.Name, OwnerId = original.OwnerId, ParentId = destino.Id);
					attachments.add(attachment);
				}
			}
		}
		if (attachments.size() > 0)
			insert attachments;
	}
}