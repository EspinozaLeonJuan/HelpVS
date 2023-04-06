@IsTest
private class ReflectionUtilsTest {

	static testMethod void getSobjectNameTest() {
		Account account = new Account(Name = 'ACME');
		insert account;
		String sobjectName = ReflectionUtils.getSobjectName(account.Id);
		System.assertEquals('Account', sobjectName);
	}

	static testMethod void getSobjectTypeTest() {
		Account account = new Account(Name = 'ACME');
		insert account;
		Schema.SobjectType sobjectType = ReflectionUtils.getSobjectType(account.Id);
		System.assertEquals(Account.getSobjectType(), sobjectType);
	}

	static testMethod void existsTest() {
		System.assert(ReflectionUtils.exists('account', 'name'), 'Name field does not exist');
	}

	/*
	static testMethod void getSobjectNameByLabelTest() {
		String sobjectName = ReflectionUtils.getSobjectNameByLabel('Cuenta');
		System.assertEquals('account', sobjectName, 'No existe la etiqueta cuenta');
	}

	static testMethod void getSobjectNameByLabelWrongLabelTest() {
		ReflectionUtils.ReflectionException cve = null;
		try {
			String sobjectName = ReflectionUtils.getSobjectNameByLabel('Nombre_de_Objeto_Malo__c');
		} catch (ReflectionUtils.ReflectionException e) {
			cve = e;
		}
		System.assertNotEquals(null, cve, 'Una excepción no fué lanzada');
	}
	*/

	static testMethod void itShouldTestRecordTypeCache() {
		System.assertEquals(Schema.sObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId(),
												ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa'));
		System.assertEquals(Schema.sObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId(),
												ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal'));
		System.assertEquals(2, ReflectionUtils.getCountRecordTypeCacheMap());
	}

	static testMethod void isValidIdTest() {
		System.assert(ReflectionUtils.isValidId(UserInfo.getUserId(), User.getSobjectType()), 'No es Id de usuario válido');
		System.assert(!ReflectionUtils.isValidId(UserInfo.getUserId(), Account.getSobjectType()), 'No se está validando correctamente el tipo');
		System.assert(!ReflectionUtils.isValidId(null, User.getSobjectType()), 'Se está validando un id null');
		System.assert(!ReflectionUtils.isValidId('ABC', User.getSobjectType()), 'Se está validando un id muy corto');
			}
}