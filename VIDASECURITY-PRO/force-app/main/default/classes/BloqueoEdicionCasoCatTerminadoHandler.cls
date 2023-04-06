public class BloqueoEdicionCasoCatTerminadoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		for (Caso_Cat__c caso : (Caso_Cat__c[])Trigger.new) {
		
			Caso_Cat__c casoOld = (Caso_Cat__c)Trigger.oldMap.get(caso.Id);
			User activeUser = [Select Email From User where Username = : UserInfo.getUserName() limit 1];
		
			User[] lAdmins = [select Email from User where IsActive = true and Profile.Name = 'Administrador del sistema' and Email =: activeUser.Email];
		
			if (casoOld.Estado__c == 'Terminado' && lAdmins.size() == 0) {
				TriggerHandler.addError('No es posible editar detalles de un caso ya terminado', caso);
			}
		}
	}
    }