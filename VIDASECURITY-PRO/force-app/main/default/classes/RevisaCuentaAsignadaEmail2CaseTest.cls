/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-06-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class RevisaCuentaAsignadaEmail2CaseTest {
	static {
		TriggerHandler.enable();
	}

	static testMethod void TestContactoExistente() {
		String  Contact_RecordTypeId  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contratante').getRecordTypeId();
        system.debug('Contact_RecordTypeId  '+Contact_RecordTypeId);

		Test.startTest();
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Contact contacto = new Contact();
		contacto.Email = 'mail@test.cl';
		contacto.LastName = 'NombreContacto';
		contacto.RecordTypeId = Contact_RecordTypeId;
		insert contacto;

		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;

		contacto.AccountId = cuenta.Id;
		update contacto;

		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto Vida';
		caso.SuppliedEmail = 'mail@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		insert caso;

		Case casoTrigger = [select Id, SuppliedName, SuppliedEmail, AccountId, Contact.Id, Contact.Email, Contact.LastName, Contact.AccountId from Case where Id =: caso.Id limit 1];

		System.assert(casoTrigger.Contact != null);
		System.assertEquals(casoTrigger.Contact.Email, casoTrigger.SuppliedEmail);
		System.assertEquals(casoTrigger.Contact.LastName, 'NombreContacto');
		System.assertNotEquals(casoTrigger.Contact.AccountId, null);
		System.assertNotEquals(casoTrigger.AccountId, null);

		Test.stopTest();
	}

	static testMethod void TestContactoNuevo() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto Vida';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();

		Contact[] contactos = [SELECT Id, Email FROM Contact];
		System.assertEquals(1, contactos.size());
		Contact contacto = contactos[0];
		System.assertEquals(cuenta.PersonEmail, contacto.Email);

		Case casoTrigger = [select Id, SuppliedName, SuppliedEmail, AccountId, Contact.Id, Contact.Email, Contact.LastName, Contact.AccountId from Case where Id =: caso.Id limit 1];

		//System.assert(casoTrigger.Contact != null);
//		System.assertEquals(casoTrigger.Contact.Email, 'mailcaso@test.cl');
	//	System.assertNotEquals(casoTrigger.AccountId, cuentaAnonimo.Id, 'No debe estar asignada la cuenta anonima.');
	//	System.assertEquals(casoTrigger.Contact.AccountId, casoTrigger.AccountId);
		// System.assertEquals(casoTrigger.AccountId, cuentaAnonimo.Id);
	//	System.assertEquals(casoTrigger.AccountId, cuenta.Id); // Se asume de que el Suppliername esta preguntando por su cuenta.
	}

	static testMethod void cuentaEmpresaContactoNoExistente() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto SBS';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();

		Contact[] contactos = [SELECT Id, Email FROM Contact];
		System.assertEquals(1, contactos.size());
		Contact contacto = contactos[0];
		System.assertEquals(caso.SuppliedEmail, contacto.Email);

		Case casoTrigger = [select Id, SuppliedName, SuppliedEmail, AccountId, Contact.Id, Contact.Email,
															 Contact.LastName, Contact.AccountId, Canal__c
													from Case where Id =: caso.Id limit 1];

		System.assertEquals('Contacto SBS', casoTrigger.Canal__c);
		System.assert(casoTrigger.Contact != null);
		System.assertEquals(casoTrigger.Contact.Email, 'mailcaso@test.cl');
		System.assertEquals(casoTrigger.AccountId, cuentaAnonimo.Id, 'Debe estar asignada la cuenta anonima.');
		System.assertEquals(casoTrigger.Contact.AccountId, casoTrigger.AccountId);
		System.assertEquals(casoTrigger.AccountId, cuentaAnonimo.Id);
	}

}