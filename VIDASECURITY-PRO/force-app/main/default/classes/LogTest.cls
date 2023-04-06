@isTest
private class LogTest {

	static {
		Depuracion__c depuracion = new Depuracion__c(Name = UserInfo.getOrganizationId(), Enviar_Email__c = true,
																								 Salida_Estandar__c = true, Objeto_Log__c = true,
																								 Email_de_Administrador__c = 'contacto@gocode.cl');
		insert depuracion;
	}

	static testMethod void logTest() {
		Log log = new Log(LogTest.class, false);
		log.error('TEST');
		log.warn('TEST');
		log.info('TEST');
		log.debug('TEST');
		log.save();
		log.commitLogs();
	}

	static testMethod void logTestWithCommit(){
		Log log = new Log(LogTest.class, true);
		log.error('TEST');
		log.warn('TEST');
		log.info('TEST');
		log.debug('TEST');
		log.save();
		log.commitLogs();
	}

	static testMethod void assertionTest() {
		Log log1 = new Log(LogTest.class, false);
		Log.objetoLog = true;
		log1.assertEquals(1, 0);
		//System.assertEquals(1, Log.logs.size());
		log1.assertNotEquals(1,0);
		//System.assertEquals(1, Log.logs.size());
		log1.debugTrigger();

	}

	static testMethod void cobertura() {
		Log.printException(new VidaSecurityException());
	}
}