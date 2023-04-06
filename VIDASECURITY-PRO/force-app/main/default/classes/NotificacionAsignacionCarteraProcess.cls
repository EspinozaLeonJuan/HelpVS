public class NotificacionAsignacionCarteraProcess implements Schedulable {
	
	private static final String EMAIL_ORIGEN = 'sfvida@security.cl';
	
	public void execute(SchedulableContext sc) {
		OrgWideEmailAddress[] fromAddresses = [select id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :EMAIL_ORIGEN];
		OrgWideEmailAddress fromAddress = null;
		if (!fromAddresses.isEmpty())
			fromAddress = fromAddresses[0];
		
		AggregateResult[] results = [SELECT COUNT(Id) Cantidad, OwnerId FROM Account WHERE Fecha_Ultimo_Cambio_Propietario__c IN (TODAY, YESTERDAY) AND Owner.Ejecutivo_de_Cliente__c = true GROUP BY OwnerId];
		Set<Id> ownerIds = new Set<Id>();
		for (AggregateResult result : results) {
			Id ownerId = (Id)result.get('OwnerId');
			ownerIds.add(ownerId);
		}
		if (ownerIds.isEmpty())
			return;
		Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
		EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Notificacion_de_Asignacion_de_Cartera' LIMIT 1];
		for (Id ownerId : ownerIds) {
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			message.setTargetObjectId(ownerId);
			message.setWhatId(ownerId);
			message.setTemplateId(template.Id);
			if (fromAddress != null)
				message.setOrgWideEmailAddressId(fromAddress.Id);
			message.setSaveAsActivity(false);
			messages.add(message);
		}
		Messaging.reserveSingleEmailCapacity(messages.size());
		if (!Test.isRunningTest())
			Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(messages);
	}
    }