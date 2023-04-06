public class ActualizaComentarioSinHTMLHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
    for (Respuesta__c respuesta: (Respuesta__c[])Trigger.new) {
        if (respuesta.Comentario_Respuesta__c != null) {
            respuesta.Comentario_Respuesta_Sin_HTML__c = respuesta.Comentario_Respuesta__c.replaceAll('<[^>]+>',' ');
        }
    }
	}
}