public class BloqIngresoRespuestasCATTerminadoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<Id> casoCatIds = new Set<Id>();
		for (Respuesta__c resp: (Respuesta__c[])Trigger.new) {
			casoCatIds.add(resp.Caso_Cat__c);
		}
		
		Map<ID, Caso_Cat__c> casoCatMapa = new map<ID, Caso_Cat__c>([select id, Estado__c from Caso_Cat__c where id IN: casoCatIds]);
		    
		User activeUser = [Select Email From User where Username = : UserInfo.getUserName() limit 1];
		    
		User[] lAdmins = [select Email from User where IsActive = true and Profile.Name = 'Administrador del sistema' and Email =: activeUser.Email];
		                                          
		for (Respuesta__c resp : (Respuesta__c[])Trigger.new) {
			Caso_Cat__c casoCatRelacionado = casoCatMapa.get(resp.Caso_Cat__c);
			if (casoCatRelacionado != null){
				System.Debug('estado:' + casoCatRelacionado.Estado__c);
				if (casoCatRelacionado.Estado__c == 'Terminado' && lAdmins.size() == 0) {
					TriggerHandler.addError('No es posible agregar ni modificar respuestas de un caso ya terminado', resp);
				}
			} else {
		            TriggerHandler.addError('No existe Caso CAT SF relacionado a esta respuesta', resp);
			}
		}
		    		    
	}
    }