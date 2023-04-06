public class RespuestaTieneAdjuntoHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		if (Trigger.isAfter && Trigger.isUpdate) return; // Se agrega esta linea para dar cumplimiento con los eventos originales del trigger.
		Set<Id> respuestaIds = new Set<Id>();

		if (Trigger.new != null) {
			for (Attachment attachment : (Attachment[])Trigger.new) {
				String sObjParent= attachment.ParentId.getSObjectType().getDescribe().getName();
				if (sObjParent == 'Respuesta__c' && !respuestaIds.contains(attachment.ParentId))
					respuestaIds.add(attachment.ParentId);
			}
		}

		if (Trigger.old != null) {
			for (Attachment attachment : (Attachment[])Trigger.old) {
				String sObjParent = attachment.ParentId.getSObjectType().getDescribe().getName();
				if (sObjParent == 'Respuesta__c' && !respuestaIds.contains(attachment.ParentId))
					respuestaIds.add(attachment.ParentId);
			}
		}

		AggregateResult[] results = [SELECT ParentId, COUNT(Id) Cuenta FROM Attachment WHERE ParentId IN :respuestaIds GROUP BY ParentId];
		List<Respuesta__c> respuestas = new List<Respuesta__c>();
		for (AggregateResult result : results) {
			Id respuestaId = (Id)result.get('ParentId');
			Decimal cuenta = (Decimal)result.get('Cuenta');
			Respuesta__c respuesta = null;
			if (cuenta > 0)
				respuesta = new Respuesta__c(Id = respuestaId, Tiene_attachement__c = true);
			else
				respuesta = new Respuesta__c(Id = respuestaId, Tiene_attachement__c = false);
			respuestaIds.remove(respuestaId);
			respuestas.add(respuesta);
		}

		for (Id respuestaId : respuestaIds) {
			Respuesta__c respuesta = new Respuesta__c(Id = respuestaId, Tiene_attachement__c = false);
			respuestas.add(respuesta);
		}
		if (respuestas.size() > 0)
			update respuestas;
	}
}