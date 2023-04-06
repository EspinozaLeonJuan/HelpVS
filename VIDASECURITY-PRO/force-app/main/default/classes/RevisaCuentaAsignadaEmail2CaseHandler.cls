/*******************************************************************************************
 *  NOMBRE                 : RevisaCuentaAsignadaEmail2CaseHandler
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : CASOS
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.1     - 20/03/2019  - I. SALAZAR       - Se agregan origen Cobranzas Vida - Recepción Pagos
 *
 * *****************************************************************************************/
public without sharing class RevisaCuentaAsignadaEmail2CaseHandler implements TriggerHandler.HandlerInterface {

    private static final Set<String> ORIGENES = new Set<String>{'Contacto SBS','Contacto Vida','Producción Individuales','Cobranzas Vida','Recepción Pagos', 'WEB'};

	public void handle() {
		// Rut Anónimo VS
		Account[] cuentasAnonimos = [select Id from Account where RUT__c = '99999998' limit 1];
		// Esto se hace para controlar la posible NO existencia de la cuenta anónima.
		Account cuentaAnonimo = cuentasAnonimos.isEmpty() ? null : cuentasAnonimos[0];
        system.debug(cuentaAnonimo);
		System.assertNotEquals(null, cuentaAnonimo, 'No existe una cuenta (debe ser corporativa) anonima con RUT 99999998.');
		Map<Id, Case> email2CaseCasosMap = new Map<Id, Case>();

		String  Contact_RecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contratante').getRecordTypeId();
        system.debug('Contact_RecordTypeId  '+Contact_RecordTypeId);

		Set<String> suppliedEmails = new Set<String>();
		// Agregamos el origen de Servicios Colectivos. Caso # 2503
		// Incluimos solo casos sin cuenta asignada.
		for (Case caso : (Case[])Trigger.new){
			if (ORIGENES.contains(caso.Origin) && caso.AccountId == null && String.isNotBlank(caso.SuppliedEmail)){
				email2CaseCasosMap.put(caso.Id, caso);
				String suppliedEmailTrim = caso.SuppliedEmail.trim();
				if (!suppliedEmails.contains(suppliedEmailTrim))
					suppliedEmails.add(suppliedEmailTrim);
			}
		}
		if (email2CaseCasosMap.isEmpty())
			return;

		Map<String,Contact> mapEmailContact = new Map<String,Contact>();
		Account[] cuentas = [SELECT Id, PersonEmail, (SELECT Id FROM Contacts WHERE RecordTypeId =: Contact_RecordTypeId LIMIT 1)  FROM Account WHERE PersonEmail IN : suppliedEmails];

		if (cuentas.size() > 0)
		{
			for (Case caso : email2CaseCasosMap.values()) {
				caso.AccountId = cuentas[0].Id;
				if (cuentas[0].Contacts.size() > 0)
				{
					caso.ContactId = cuentas[0].Contacts[0].Id;
				}
			}
		}
		else
		{
			Contact[] contactos = [SELECT Id, AccountId, Email FROM Contact WHERE Email IN :suppliedEmails];

			for (Contact contacto : contactos)
				mapEmailContact.put(contacto.Email, contacto);

			List<Contact> contacts = new List<Contact>();
			for (Case caso : email2CaseCasosMap.values()) {
				Contact contacto = mapEmailContact.get(caso.SuppliedEmail.trim());
				if (contacto == null) {
					contacto = new Contact();
					contacto.Email = caso.SuppliedEmail.trim();
					contacto.LastName = caso.SuppliedName == null ? caso.SuppliedEmail.split('@')[0] : caso.SuppliedName;
					contacto.AccountId = cuentaAnonimo.Id;
					contacts.add(contacto);
					mapEmailContact.put(contacto.Email, contacto);
				} else if (contacto.AccountId == null) {
					contacto.AccountId = cuentaAnonimo.Id;
					contacts.add(contacto);
				}
			}

			//se evita la creacion de contactos duplicados cuando se gatilla mas de email2case al mismo tiempo
			//se inserta la operacion DML en un bloque try-catch
			if (!contacts.isEmpty()){
				try{

					upsert contacts;

				}
				catch(exception ex){

					if(ex.getTypeName() == 'System.DMLException' || ex.getTypeName() == 'System.MailException'){

						for (Case caso : (Case[])Trigger.new){//se evita la creacion de un contacto duplicado
							Contact contacto = mapEmailContact.get(caso.SuppliedEmail.trim());
							caso.ContactId = contacto.Id;
						caso.AccountId = contacto.AccountId;}

					return;
					}
				}
				}


			for (Case caso : email2CaseCasosMap.values()) {
				System.assertNotEquals(null, caso.SuppliedEmail, 'Es imposible que sea null porque ya filtramos esto en el primer for');
				Contact contacto = mapEmailContact.get(caso.SuppliedEmail.trim());
				System.assertNotEquals(null, contacto, 'El contacto no puede ser nulo porque los creamos anteriormente');
				System.assertNotEquals(null, contacto.Id, 'El Id del contacto no puede ser null porque lo insertamos previamente');
				caso.ContactId = contacto.Id;
				caso.AccountId = contacto.AccountId;
			}
		}
	}
}