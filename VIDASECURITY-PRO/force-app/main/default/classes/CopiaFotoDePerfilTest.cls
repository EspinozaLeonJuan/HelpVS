@isTest
private class CopiaFotoDePerfilTest {
	
	@TestSetup
	static void init() {
//Fabricate.usuario.save();
	}

	static testMethod void copiaUrlTest() {
		String responseBody = '';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		Test.startTest();
		CopiaFotoDePerfilProcess process = new CopiaFotoDePerfilProcess();
		process.daysAgo = null; // para que agarre todos los usuarios
		process.execute(null);
		Test.stopTest();
        	}
        	
        	static testMethod void testTriggerTest() {
        		TriggerHandler.enable(CopiaFotoDePerfilHandler.class);
		String responseBody = '';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		UserFabricate user = (UserFabricate)Fabricate.usuario().save();
		Test.startTest();
		user.save();
		Test.stopTest();
        	}
        	
        		static testMethod void copiaUrl2Test() {
		String responseBody = '';
		Test.setMock(HttpCalloutMock.class, new StandardHttpCalloutMock(responseBody));
		User[] users = [SELECT Id, Name, SmallPhotoUrl, FullPhotoUrl FROM User WHERE FullPhotoUrl <> NULL AND IsActive = true AND (NOT FullPhotoUrl LIKE '%/005/F') LIMIT 1];
		System.assertEquals(1, users.size(), 'No hay usuarios para probar, favor suba una foto de perfil');
		Test.startTest();
		CopiaFotoDePerfilProcess.execute(new Id[]{users[0].Id});
		Test.stopTest();
        	}
        	
}