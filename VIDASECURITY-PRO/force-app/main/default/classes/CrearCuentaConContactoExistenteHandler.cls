public class CrearCuentaConContactoExistenteHandler implements TriggerHandler.HandlerInterface {
	private static final Log log = new Log(CrearCuentaConContactoExistenteHandler.class);

	public void handle() {

		List<Contact> contactos = new List <Contact>();
		List<Account> cuentas = new List <Account>();

		Map<Id, Contact> mapContactosCuentaAnonima = new Map <Id, Contact>();
		Map<String, Account> mapCuentas = new Map<String, Account>();
		Map<String, Contact> mapContactos = new Map<String, Contact>();

		Set<String> rutsContacto = new Set<String>();

		for (Account a : (Account[])Trigger.new) {
			if (a.IsPersonAccount && a.rut_contacto__pc != null)
				rutsContacto.add(a.Rut_contacto__pc);
		}

		//queries
		List<Account> cuentaAnonima = [select id from Account where Rut__c = '99999998' limit 1];
		contactos = [select Id, AccountId, rut_contacto__c from Contact where rut_contacto__c IN :rutsContacto];
		cuentas = [select Id, rut__c from Account where rut__c IN :rutsContacto];

		for (Contact c : contactos) {
			if (!mapContactos.containsKey(c.rut_contacto__c))
				mapContactos.put(c.rut_contacto__c, c);
		}

		for (Account a : cuentas) {
			if (!mapCuentas.containsKey(a.rut__c))
				mapCuentas.put(a.rut__c, a);
		}

		for (Account a : (Account[])Trigger.new) {
			if (a.IsPersonAccount && a.rut_contacto__pc != null) {

				if (mapCuentas.containsKey(a.Rut_contacto__pc))
					continue;

				if (mapContactos.containsKey(a.Rut_Contacto__pc)) {

					Contact contactoCuenta = mapContactos.get(a.Rut_Contacto__pc);
					if (!cuentaAnonima.isEmpty() && contactoCuenta.AccountId == cuentaAnonima[0].Id)
						mapContactosCuentaAnonima.put(contactoCuenta.Id, contactoCuenta);

				}
			}
		}

		List<Case> casosContacto = [select Id, Contact.Rut_Contacto__c, Contact.Id from Case where Contact.Id IN :mapContactosCuentaAnonima.keySet() FOR UPDATE];

		for (Case ca : casosContacto) {
			ca.Reasignar_a_Rut__c = Integer.valueOf(ca.Contact.Rut_Contacto__c);
			ca.ContactId = null;
		}

		if (!casosContacto.isEmpty())
			DatabaseUtils.updates(casosContacto);

		//eliminación de contactos de cuenta anonima
		if (!mapContactosCuentaAnonima.isEmpty())
			DatabaseUtils.deletes(mapContactosCuentaAnonima.values());
	}
}