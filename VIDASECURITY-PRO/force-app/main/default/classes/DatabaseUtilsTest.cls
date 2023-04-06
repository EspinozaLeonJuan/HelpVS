@isTest
private class DatabaseUtilsTest {

	static testMethod void upsertSimpleTest() {
		Log__c log = new Log__c(Mensaje__c = 'Foo', Usuario__c = UserInfo.getUserId(), Nivel__c = 'DEBUG');
		Test.startTest();
		DatabaseUtils.upserts(new Log__c[] {log}, Log__c.Id, false);
		Test.stopTest();
	}

	static testMethod void updatesTest() {
		Log__c log = new Log__c();
		insert log;
		Test.startTest();
		log.Mensaje__c = 'Log de prueba';
		DatabaseUtils.updates(log);
		DatabaseUtils.updates(new Log__c[] {log});
		Test.stopTest();
		log = [SELECT Mensaje__c FROM Log__c WHERE Id = :log.Id];
		System.assertEquals('Log de prueba', log.Mensaje__c);
	}

	static testMethod void errorUpdatesTest() {
		Log__c log = new Log__c();
		insert log;
		try {
			Test.startTest();
			log.Nivel__c = '123456789123456789'; // 15 Characters max, forcing error.
			DatabaseUtils.updates(new Log__c[] {log}, false);
			Test.stopTest();
		} catch (DatabaseUtils.DatabaseException error) {
			System.assert(true);
		}
	}

	static testMethod void insertsTest() {
		Log__c log = new Log__c(Mensaje__c = 'Log de prueba');
		Test.startTest();
		DatabaseUtils.inserts(new Log__c[]{log}, true, false);
		Test.stopTest();
		log = [SELECT Mensaje__c FROM Log__c WHERE Id = :log.Id];
		System.assertEquals('Log de prueba', log.Mensaje__c);
	}

	static testMethod void deletesTest() {
		Log__c log = new Log__c();
		insert log;
		Test.startTest();
		DatabaseUtils.deletes(log);
		Test.stopTest();
		Log__c[] logs = [SELECT Mensaje__c FROM Log__c WHERE Id = :log.Id];
		System.assertEquals(0, logs.size());
	}

	static testMethod void upsertsTest() {
		Log__c log = new Log__c();
		insert log;
		Test.startTest();
		log.Mensaje__c = 'Log de prueba';
		DatabaseUtils.upserts(new Log__c[] {log}, Log__c.Id, true, false);
		Test.stopTest();
		log = [SELECT Mensaje__c FROM Log__c WHERE Id = :log.Id];
		System.assertEquals('Log de prueba', log.Mensaje__c);
	}

	static testMethod void errorUpsertsTest() {
		Log__c log = new Log__c();
		insert log;
		try {
			Test.startTest();
			log.Nivel__c = '123456789123456789'; // 15 Characters max, forcing error.
			DatabaseUtils.upserts(new Log__c[] {log}, Log__c.Id, false);
			Test.stopTest();
		} catch (DatabaseUtils.DatabaseException error) {
			System.assert(true);
		}
	}

}