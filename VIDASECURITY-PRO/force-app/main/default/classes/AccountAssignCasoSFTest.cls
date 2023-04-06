@isTest
private class AccountAssignCasoSFTest {

	static {
		TriggerHandler.enable(AccountAssignCasoSFHandler.class);
	}

	static testMethod void assignAccountCasosTriggerTestDefault() {
		Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Contact contacto = Factory.buildContact(cuenta);
		insert contacto;
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Contact = contacto;
		caso.AccountId = cuenta.Id;
		Test.startTest();
		insert caso;
		update caso;
		Test.stopTest();
	}

	static testMethod void assignAccountCasosTriggerTestSinCuentaNiContacto() {
		Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Contact contacto = Factory.buildContact(cuenta);
		insert contacto;
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.ContactId = null;
		caso.AccountId = null;

		Test.startTest();
		try{
			insert caso;
			update caso;
		}
		catch(Exception e)
		{
			Boolean expectedExceptionThrown =  e.getMessage().contains('No se puede crear el caso, debe indicar la cuenta o el contacto') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
		}
		Test.stopTest();
	}

	static testMethod void assignAccountCasosTriggerTestContactoVida() {
		Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Contact contacto = Factory.buildContact(cuenta);
		insert contacto;
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto Vida';
		Test.startTest();
		insert caso;
		update caso;
		Test.stopTest();
	}

	static testMethod void assignAccountCasosTriggerTestSinCuenta() {
		Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Contact contacto = Factory.buildContact(cuenta);
		insert contacto;
		Case caso = new Case();
		caso.ContactId = contacto.Id;
		caso.Contact = contacto;
		caso.Account = null;
		caso.AccountId = null;
		Test.startTest();
		insert caso;
		update caso;
		Case casoTrigger = [select AccountId, Contact.AccountId from Case where Id =: caso.Id];
		System.assertEquals(casoTrigger.AccountId, casoTrigger.Contact.AccountId);
		Test.stopTest();
	}

}