public class ComentarioAPrimeraRespuestaHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		List<Respuesta__c> RespuestasInsert = new List<Respuesta__c>();

		for (Caso_Cat__c casoCat : (Caso_Cat__c[])Trigger.new) {
			Respuesta__c respuestaCat = new Respuesta__c(Comentario_Respuesta__c = casoCat.Comentario__c, Caso_Cat__c = casoCat.Id);
			RespuestasInsert.add(respuestaCat);
		}

		insert RespuestasInsert;
	}
}