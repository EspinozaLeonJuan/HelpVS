@isTest
private class AsignaAdminProdACuentaTest {
	
	static {
		TriggerHandler.enable(AsignaAdminProdACuentaHandler.class);
	}

	@isTest static void insertAsignandoAdminACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;

		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Administrador_de_Produccion__c='482123880');
		insert cuentaCorporativa;
		Test.stopTest();
		
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where Administrador_de_Produccion__c = :contacto.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontrada.size());
		System.assertNotEquals(null, cuentaCorporativaEncontrada[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto.Id, cuentaCorporativaEncontrada[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto.RUT__c, cuentaCorporativaEncontrada[0].RUT_Administrador_de_Produccion__c);
	}

	@isTest static void insertAsignandoRutAdminACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;

		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', Administrador_de_Produccion__c=contacto.Id);
		insert cuentaCorporativa;
		Test.stopTest();
		
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where RUT_Administrador_de_Produccion__c = :contacto.RUT__c and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontrada.size());
		System.assertNotEquals(null, cuentaCorporativaEncontrada[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto.Id, cuentaCorporativaEncontrada[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto.RUT__c, cuentaCorporativaEncontrada[0].RUT_Administrador_de_Produccion__c);
	}

	@isTest static void updatedAsignandoAdminACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		Contact contacto2 = new Contact(FirstName='Alejandro', LastName='Gutierrez', RUT__c='1111111111');
		insert contacto2;

		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Administrador_de_Produccion__c='482123880');
		insert cuentaCorporativa;
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where Administrador_de_Produccion__c = :contacto.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		Account cuentaCorporativaUpdated = cuentaCorporativaEncontrada[0];
		cuentaCorporativaUpdated.RUT_Administrador_de_Produccion__c = contacto2.Rut__c;
		update cuentaCorporativaUpdated;
		Test.stopTest();
		
		List<Account> cuentaCorporativaEncontradaUpdated = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where Administrador_de_Produccion__c = :contacto2.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontradaUpdated.size());
		System.assertNotEquals(null, cuentaCorporativaEncontradaUpdated[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto2.Id, cuentaCorporativaEncontradaUpdated[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto2.RUT__c, cuentaCorporativaEncontradaUpdated[0].RUT_Administrador_de_Produccion__c);
	}

	@isTest static void updatedAsignandoRutAdminACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		Contact contacto2 = new Contact(FirstName='Alejandro', LastName='Gutierrez', RUT__c='1111111111');
		insert contacto2;

		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Administrador_de_Produccion__c='482123880');
		insert cuentaCorporativa;
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where RUT_Administrador_de_Produccion__c = :contacto.Rut__c and RecordTypeId = :recordTypeCuentaCorporativa];
		Account cuentaCorporativaUpdated = cuentaCorporativaEncontrada[0];
		cuentaCorporativaUpdated.Administrador_de_Produccion__c = contacto2.Id;
		update cuentaCorporativaUpdated;
		Test.stopTest();
		
		List<Account> cuentaCorporativaEncontradaUpdated = [Select RUT_Administrador_de_Produccion__c, Administrador_de_Produccion__c From Account Where RUT_Administrador_de_Produccion__c = :contacto2.Rut__c and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontradaUpdated.size());
		System.assertNotEquals(null, cuentaCorporativaEncontradaUpdated[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto2.Id, cuentaCorporativaEncontradaUpdated[0].Administrador_de_Produccion__c);
		System.assertEquals(contacto2.RUT__c, cuentaCorporativaEncontradaUpdated[0].RUT_Administrador_de_Produccion__c);
	}
	
}