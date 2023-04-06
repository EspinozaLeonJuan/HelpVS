@isTest
private class AsignaEjecutivoComercialACuentaTest {

	static {
		TriggerHandler.enable(AsignaEjecutivoComercialACuentaHandler.class);
	}

	@isTest static void insertAsignandoEjecutivoACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		
		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Ejecutivo_Comercial__c='482123880');
		insert cuentaCorporativa;
		Test.stopTest();

		List<Account> cuentaCorporativaEncontrada = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where Ejecutivo_Comercial__c = :contacto.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontrada.size());
		System.assertNotEquals(null, cuentaCorporativaEncontrada[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto.Id, cuentaCorporativaEncontrada[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto.RUT__c, cuentaCorporativaEncontrada[0].RUT_Ejecutivo_Comercial__c);
	}

	@isTest static void insertAsignandoRutEjecutivoACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		
		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', Ejecutivo_Comercial__c=contacto.Id);
		insert cuentaCorporativa;
		Test.stopTest();

		List<Account> cuentaCorporativaEncontrada = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where RUT_Ejecutivo_Comercial__c = :contacto.RUT__c and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontrada.size());
		System.assertNotEquals(null, cuentaCorporativaEncontrada[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto.Id, cuentaCorporativaEncontrada[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto.RUT__c, cuentaCorporativaEncontrada[0].RUT_Ejecutivo_Comercial__c);
	}
	
	@isTest static void updateAsignandoEjecutivoACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		Contact contacto2 = new Contact(FirstName='Alejandro', LastName='Gutierrez', RUT__c='11111111');
		insert contacto2;
		
		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Ejecutivo_Comercial__c='482123880');
		insert cuentaCorporativa;
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where Ejecutivo_Comercial__c = :contacto.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		Account cuentaCorporativaUpdate = cuentaCorporativaEncontrada[0];
		cuentaCorporativaUpdate.RUT_Ejecutivo_Comercial__c = contacto2.Rut__c;
		update cuentaCorporativaUpdate;
		Test.stopTest();

		List<Account> cuentaCorporativaEncontradaUpdated = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where Ejecutivo_Comercial__c = :contacto2.Id and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontradaUpdated.size());
		System.assertNotEquals(null, cuentaCorporativaEncontradaUpdated[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto2.Id, cuentaCorporativaEncontradaUpdated[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto2.RUT__c, cuentaCorporativaEncontradaUpdated[0].RUT_Ejecutivo_Comercial__c);
	}

	@isTest static void updateAsignandoRutEjecutivoACuenta() {
		Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
		Contact contacto = new Contact(FirstName='Winder', LastName='Ojeda', RUT__c='482123880');
		insert contacto;
		Contact contacto2 = new Contact(FirstName='Alejandro', LastName='Gutierrez', RUT__c='11111111');
		insert contacto2;
		
		Test.startTest();
		Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '123456789', RUT_Ejecutivo_Comercial__c='482123880');
		insert cuentaCorporativa;
		List<Account> cuentaCorporativaEncontrada = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where RUT_Ejecutivo_Comercial__c = :contacto.RUT__c and RecordTypeId = :recordTypeCuentaCorporativa];
		Account cuentaCorporativaUpdate = cuentaCorporativaEncontrada[0];
		cuentaCorporativaUpdate.Ejecutivo_Comercial__c = contacto2.Id;
		update cuentaCorporativaUpdate;
		Test.stopTest();

		List<Account> cuentaCorporativaEncontradaUpdated = [Select RUT_Ejecutivo_Comercial__c, Ejecutivo_Comercial__c From Account Where RUT_Ejecutivo_Comercial__c = :contacto2.RUT__c and RecordTypeId = :recordTypeCuentaCorporativa];
		System.assertEquals(1, cuentaCorporativaEncontradaUpdated.size());
		System.assertNotEquals(null, cuentaCorporativaEncontradaUpdated[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto2.Id, cuentaCorporativaEncontradaUpdated[0].Ejecutivo_Comercial__c);
		System.assertEquals(contacto2.RUT__c, cuentaCorporativaEncontradaUpdated[0].RUT_Ejecutivo_Comercial__c);
	}
}