public class AsignaCuentaWeb2CaseHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Set<String> rutSolicitantes = new Set<String>(),
			correoSolicitantes = new Set<String>(),
            rutSolicitantesSinDv = new Set<String>();
			// Rut Anónimo VS
		Account[] cuentasAnonimos = [select Id from Account where RUT__c = '99999998' limit 1];
		// Esto se hace para controlar la posible NO existencia de la cuenta anónima.
		Account cuentaAnonimo = cuentasAnonimos.isEmpty() ? null : cuentasAnonimos[0];

		Case[] casosSeleccionados = new Case[]{};
		for (Case kase : (Case[])Trigger.new){
			System.debug('Rut Solicitante: ' + kase.RUT_Solicitante__c);
			System.debug('Account Id: ' + kase.AccountId);
			System.debug('SuppliedName: ' + kase.SuppliedName);
			System.debug('SuppliedEmail: ' + kase.SuppliedEmail);
			System.debug('ContactId: ' + kase.ContactId);
			if (String.isNotBlank(kase.RUT_Solicitante__c) && !rutSolicitantes.contains(kase.RUT_Solicitante__c.trim()) && String.isNotBlank(kase.SuppliedName) && String.isNotBlank(kase.SuppliedEmail) && kase.AccountId == null){
				rutSolicitantes.add(kase.RUT_Solicitante__c.trim());
				correoSolicitantes.add(kase.SuppliedEmail.trim());
				casosSeleccionados.add(kase);
                
                String rut = kase.RUT_Solicitante__c.trim();
                rut = rut.replace('-', '');
                integer rutAux = Integer.valueOf(rut.substring(0, rut.length() - 1));
                rutSolicitantesSinDv.add(String.valueOf(rutAux));
			}
		}
		System.debug('Los Rut solicitantes son estos: ' + rutSolicitantes);
		if (rutSolicitantes.isEmpty()) return;
		Account[] cuentas = [SELECT Id, Rut_con_dv__c FROM Account WHERE Rut__c IN :rutSolicitantesSinDv];
		Contact[] contactos = [SELECT Id, Email FROM Contact WHERE Email IN :correoSolicitantes];
        
		System.debug('Estos son las cuentas: ' + cuentas);
		System.debug('Estos son los contactos: ' + contactos);
		Map<String,Account> mapAccounts = new Map<String,Account>();
		Map<String,Contact> mapContacts = new Map<String,Contact>();
		for (Account cuenta : cuentas)
			mapAccounts.put(cuenta.Rut_con_dv__c, cuenta);
		for (Contact contacto : contactos)
			mapContacts.put(contacto.Email, contacto);
		for (Case caso : casosSeleccionados){
			Account cuenta = mapAccounts.get(caso.RUT_Solicitante__c.trim());
			Contact contacto = mapContacts.get(caso.SuppliedEmail.trim());
			caso.AccountId = (cuenta != null) ? cuenta.Id : caso.AccountId;
			caso.ContactId = (contacto != null) ? contacto.Id : caso.ContactId;
			if (caso.AccountId == null){
				System.assertNotEquals(null, cuentaAnonimo, 'No existe una cuenta (debe ser corporativa) anonima con RUT 99999998.');
				caso.AccountId = cuentaAnonimo.Id;
			}
		}
		
	}
}