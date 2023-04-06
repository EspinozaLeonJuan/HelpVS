public with sharing class EnviaCorreosPendientesController {

	
	public System.PageReference enviar() {
		Account[] accounts = [SELECT Id FROM Account WHERE OwnerId = :UserInfo.getUserId() AND Correo_Pendiente_de_Envio__c = true LIMIT 800 FOR UPDATE];
		System.assertNotEquals(null, accounts);
		System.assert(!accounts.isEmpty(), 'El usuario ' + UserInfo.getName() + ' no tiene correos pendientes de envio');
		for (Account account : accounts) {
			account.Correo_Pendiente_de_Envio__c = false;
		}
		Database.SaveResult[] results = Database.update(accounts, false);
		Boolean success = true;
		for (Integer i=0; i < results.size(); i++) {
			Database.SaveResult result = results[i];
			Account account = accounts[i];
			if (result.IsSuccess())
				continue;
			success = false;
			for (Database.Error error : result.getErrors()) {
				String message = 'ERROR: ' + error.getMessage() + ' ID: ' + account.Id;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
			}
		}
		if (success)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Las cuentas fueron actualizadas exitosamente.'));
		return null;
	}
	
	public Integer getCorreosPendientes() {
		return [SELECT COUNT() FROM Account WHERE OwnerId = :UserInfo.getUserId() AND Correo_Pendiente_de_Envio__c = true];
	}
	}