@isTest
public class UserFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new User(
			FirstName = 'Rocky',
			LastName = 'Balboa',
			Alias = 'rocky',
			Email = 'rocky@balboa.cl',
			Username = 'ejecutivo.generico@vidasecurity.cl.fabricate',
			CommunityNickname = 'rocky10',
			TimeZoneSidKey = 'America/Santiago',
			LanguageLocaleKey = 'es',
			LocaleSidKey = 'es_CL',
			EmailEncodingKey = 'UTF-8',
			Country = 'Chile',
			IsActive = true,
			ProfileId = UserInfo.getProfileId(),
			RUT_Usuario__c = '22222222-2'
		);
	}
	
	public UserFabricate ejecutivoDeCliente() {
		return (UserFabricate)set('Ejecutivo_de_Cliente__c', true);
	}
	
	public UserFabricate postVenta() {
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Ejecutiva Post Venta'];
		return (UserFabricate)set('ProfileId', profile.Id);
	}

	public UserFabricate admin() {
		Profile profile = [SELECT Id FROM Profile WHERE Name = 'Administrador del Sistema'];
		return (UserFabricate)set('ProfileId', profile.Id);
	}
	
	public void establecerEjecutivasPostVenta() {
		User[] users = [SELECT Id FROM User WHERE Profile.Name = 'Ejecutiva Post Venta' AND Ejecutivo_de_Cliente__c = false];
		for (User user : users) {
			user.Ejecutivo_de_Cliente__c = true;
			user.Omitir_asignacion_AMAC__c = false;
		}
		update users;
	}

}