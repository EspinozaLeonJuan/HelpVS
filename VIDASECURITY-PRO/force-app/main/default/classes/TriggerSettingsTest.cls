@isTest
private class TriggerSettingsTest {

	private static Trigger_Setting__c[] tSettings;
	private static user user;
	
	@TestSetup()
	static void setup() {
		String orgId = UserInfo.getOrganizationId();
		String fechaString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
		Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
		String nombreUnico = orgId + fechaString + randomInt;
		
		Profile perfilEstandar = [SELECT Id FROM Profile WHERE Name = 'Usuario estándar' LIMIT 1];
		
		User usuario = new User(); 
		usuario.Username = nombreUnico + '@' + orgId + '.gocode.cl';
		usuario.email = nombreUnico + '@' + orgId + '.gocode.cl';
		usuario.FirstName = 'Nombre';
		usuario.LastName = 'Apellido';
		usuario.Alias = 'pru';
		usuario.CommunityNickname = nombreUnico;
		usuario.LocaleSidKey = 'en_US';
		usuario.TimeZoneSidKey = 'GMT';
		usuario.ProfileID = perfilEstandar.Id;
		usuario.LanguageLocaleKey = 'en_US';
		usuario.EmailEncodingKey = 'UTF-8';
		usuario.RUT_Usuario__c = string.valueOf(randomInt);
		insert usuario;
	}

	private static void init(){
		user = [SELECT Id FROM User WHERE Alias = 'pru'];
		
		tSettings = new Trigger_Setting__c[]{};
		tSettings.add(new Trigger_Setting__c(Habilitado__c = false, Name = 'All'));
		tSettings.add(new Trigger_Setting__c(Habilitado__c = true, Name = 'TestHandler'));

		//tSettings.add(new Trigger_Setting__c(Habilitado__c = true, Name = 'All', Perfil__c = 'Perfil PRM'));
		//tSettings.add(new Trigger_Setting__c(Habilitado__c = false, Name = 'TestHandler', Perfil__c = 'Perfil PRM'));
		
		tSettings.add(new Trigger_Setting__c(Habilitado__c = false, Name = 'All', Usuario__c = user.Id));
		tSettings.add(new Trigger_Setting__c(Habilitado__c = true, Name = 'TestHandler', Usuario__c = user.Id));
		//tSettings.add(new Trigger_Setting__c(Habilitado__c = false, Name = 'FechaCreacionHandler', Usuario__c = user.Id));
		

		insert tSettings;
		EnabledHeap.init();
	}

	static testMethod void itShouldNotEnabledTriggers() {
		Test.startTest();
		init();
		Test.stopTest();
		System.assertEquals(false, TriggerSettings.isEnabled(), 'Los triggers no deberian estar habilitados. Mapa: ' + EnabledHeap.current());
		System.assertEquals(true, TriggerSettings.isEnabled(Type.forName('TestHandler')), 'La clase TestHandler deberia estar habilidada.');
		System.runAs(user){
			System.assertEquals(TriggerSettings.isEnabled(), false, 'Los triggers no deberian estar habilitados');
			System.assertEquals(TriggerSettings.isEnabled(Type.forName('TestHandler')), true, 'La clase TestHandler deberia estar habilidada.');
		}
	}

	static testMethod void itShouldSpecificEnabled(){
		Test.startTest();
		init();
		Test.stopTest();
		System.assertEquals(false, TriggerSettings.isEnabled(), 'Los triggers no deberian estar habilitados');
		TriggerHandler.enable(Type.forName('TestHandler'));
		System.assertEquals(false, TriggerSettings.isEnabled(), 'No deberian estar habilitados todos los triggers solo el de la clase.');
		System.assertEquals(true, TriggerSettings.isEnabled(Type.forName('TestHandler')), 'Deberia estar habilitado el trigger especifico TestHandler');
	}

	static testMethod void itShouldEnabledOrDisabledWithTriggerSettingsData(){
		Test.startTest();
		init();
		Test.stopTest();
		System.assertEquals(false, TriggerSettings.isEnabled(), 'Deberia estar deshabilitado todos los triggers para la org.');
		System.assertEquals(true, TriggerSettings.isEnabled(Type.forName('TestHandler')), 'Deberia estar habilitado el trigger');
		System.runAs(user){
			System.assertEquals(TriggerSettings.isEnabled(), false, 'Deberia estar deshabilitado todos los triggers para la org.');
			System.assertEquals(TriggerSettings.isEnabled(Type.forName('TestHandler')), true, 'Deberia estar habilitado el trigger');
					}
	}

	static testMethod void itShouldTestIsEnabledOrDisableProfileLevel(){
		Test.startTest();
		init();
		delete [SELECT Id FROM Trigger_Setting__c WHERE Usuario__c != NULL];
		Test.stopTest();
		System.assertEquals(TriggerSettings.isEnabled(), false, 'Deberia estar deshabilitado todos los triggers para la org.');
		System.assertEquals(TriggerSettings.isEnabled(Type.forName('TestHandler')), true, 'Deberia estar habilitado el trigger');
		System.runAs(user){
			System.assertEquals(TriggerSettings.isEnabled(), false, 'No deberia estar habilitado todos los triggers para la org.');
			System.assertEquals(TriggerSettings.isEnabled(Type.forName('TestHandler')), true, 'Deberia estar deshabilitado el trigger');
			System.assertEquals(TriggerSettings.isEnabled(Type.forName('FechaCreacionHandler')), false, 'No deberia estar habilitado el trigger');
		}
	}

	static testMethod void itShouldDisableClassIfAllIsEnabled(){
		user = [SELECT Id FROM User WHERE Alias = 'pru'];
		 
		Test.startTest();
		tSettings = new Trigger_Setting__c[]{};
		tSettings.add(new Trigger_Setting__c(Habilitado__c = true, Name = 'All'));
		 tSettings.add(new Trigger_Setting__c(Habilitado__c = false, Name = 'TestHandler', Usuario__c = user.Id));
		insert tSettings;
		EnabledHeap.init();
		Test.stopTest();
		System.runAs(user){
			System.assertEquals(false, TriggerSettings.isEnabled(Type.forName('TestHandler')), 'La clase no deberia estar habilitada para este usuario.');
		}
	}

}