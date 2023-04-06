// @author eduardo@gocode.cl
// @description Este handler da cumplimiento con las especificaciones del caso # 3421
public without sharing class LlenadoAutomaticoColectivosHandler implements TriggerHandler.HandlerInterface {

	public void handle(){
		Account[] cuentasAnonimos = [select Id from Account where RUT__c = '99999998' limit 1];
		System.assert(!cuentasAnonimos.isEmpty(), 'Ingrese una cuenta corporativa anonima con el RUT: 99999998-0');
		Account cuentaAnonima = cuentasAnonimos[0];
		Case[] news = (Case[]) Trigger.new;
		Set<String> emails = new Set<String>();
		for (Case caso : news)
			if (caso.Origin == 'Servicios Colectivos' && String.isNotBlank(caso.SuppliedEmail) && !emails.contains(caso.SuppliedEmail))
				emails.add(caso.SuppliedEmail);
		if (emails.isEmpty()) return;

		//CASO: 3866
		//se elimina esta query por la de la linea 21 ya que contenia referencia a Corredor__c y este campo fue eliminado de cuenta
		/*Contact[] contactos = [SELECT Id, Email, Account.Cuenta_Corporativa__r.Corredor__c, RecordType.Name, AccountId,
																	Empresa_Corredora__c, Account.RecordType.Name, Account.Corredor__c
														FROM Contact WHERE Email IN :emails];*/			

		Contact[] contactos = [SELECT Id, Email, RecordType.Name, AccountId,
																	Empresa_Corredora__c, Account.RecordType.Name
														FROM Contact WHERE Email IN :emails];
		Map<String,Contact[]> mapContactsByEmail = new Map<String,Contact[]>();
		for (Contact contacto : contactos){
			Contact[] contactosEnMapa = mapContactsByEmail.get(contacto.Email);
			if (contactosEnMapa == null)
				contactosEnMapa = new Contact[]{};
			contactosEnMapa.add(contacto);
			mapContactsByEmail.put(contacto.Email, contactosEnMapa);
		}
		for (Case caso : news) {
			Contact[] contactosEnMapa = mapContactsByEmail.get(caso.SuppliedEmail);
			if (contactosEnMapa == null || contactosEnMapa.size() > 1) {
				caso.AccountId = cuentaAnonima.Id;
				caso.ContactId = null;
				caso.Corredor__c = null;
				caso.Contacto_Corredor__c = null;
			}else if (contactosEnMapa.size() == 1){
				Contact contacto = contactosEnMapa[0];
				caso.AccountId = contacto.AccountId;
				caso.ContactId = null;
				//caso.Corredor__c = contacto.Account.Cuenta_Corporativa__r.Corredor__c; //se elimina por descripcion del caso 3866
				if (contacto.RecordType.Name == 'Corredor'){
					caso.AccountId = cuentaAnonima.Id;
					caso.ContactId = contacto.Id;
					caso.Corredor__c = contacto.Empresa_Corredora__c;
					caso.Contacto_Corredor__c = contacto.Id;
				} else if (contacto.Account.RecordType.Name == 'Cuenta Corporativa' && contacto.RecordType.Name == 'Contratante') {
					caso.AccountId = cuentaAnonima.Id;
					caso.ContactId = contacto.Id;
					//caso.Corredor__c = contacto.Account.Corredor__c; //se elimina por descripcion del caso 3866
					caso.Contacto_Corredor__c = null;
				}
			}
		}
	}
}