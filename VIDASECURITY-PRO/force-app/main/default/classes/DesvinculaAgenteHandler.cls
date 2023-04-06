public class DesvinculaAgenteHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<Id> vinculadoIds = new Set<Id>();
		Set<Id> desvinculadoIds = new Set<Id>();
		if (Trigger.isUpdate) {
			for (Contact contact : (Contact[])Trigger.new) {
				Contact old = (Contact)(Trigger.isUpdate ? Trigger.oldMap.get(contact.Id) : null);
				if ((contact.Estado__c == 'Desvinculado' || contact.Estado__c == 'Cambio de Cargo') && old != null && old.Estado__c != contact.Estado__c && !desvinculadoIds.contains(contact.Id))
					desvinculadoIds.add(contact.Id);
				if (contact.Estado__c == 'Vigente' && old != null && old.Estado__c != contact.Estado__c && !vinculadoIds.contains(contact.Id))
					vinculadoIds.add(contact.Id);
			}
		}
		if (Trigger.isDelete) {
			for (Contact contact : (Contact[])Trigger.old) {
				if (contact.Estado__c == 'Vigente')
					contact.addError('No es posible eliminar un agente vigente. Para eliminarlo, establezca el Estado a Desvinculado y vuelva a intentar la operación.');
			}
		}		
		
		if (!desvinculadoIds.isEmpty()) {
            
            List<Account> accountsUpdate = new List<Account>();
            for (Account accountsBusqueda : [SELECT Id, Ciudad_Particular_B__c FROM Account
                                           WHERE Agente_Actual__c IN :desvinculadoIds 
                                             AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false)
                                             AND Ciudad_Particular_B__c = null] ) 
            	{
            	accountsBusqueda.Omitir_Validaciones_AMAC__c = true;
                accountsBusqueda.Fecha_Sin_Asignacion_Ejecutivo__c = Date.today();
            	accountsUpdate.add(accountsBusqueda);
        	}
        	update accountsUpdate;
            /*for (Account[] accountsBusqueda : [SELECT Id, Ciudad_Particular_B__c FROM Account WHERE Agente_Actual__c IN :desvinculadoIds AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) FOR UPDATE]) 
				for (Account account : accounts1) {
                    if (account.Ciudad_Particular_B__c == null)
						account.Omitir_Validaciones_AMAC__c = true;
                		account.Fecha_Sin_Asignacion_Ejecutivo__c = Date.today();	                    
				}
                accounts.add(account)
			
            update accounts;*/
	}
	
			if (!vinculadoIds.isEmpty()) {
			
            for (Account[] accounts : [SELECT Id FROM Account WHERE Agente_Actual__c IN :vinculadoIds AND Fecha_Sin_Asignacion_Ejecutivo__c <> null FOR UPDATE]) {
				for (Account account : accounts) {
					account.Fecha_Sin_Asignacion_Ejecutivo__c = null;
				}
				update accounts;
			}
	}
	
	}
    }