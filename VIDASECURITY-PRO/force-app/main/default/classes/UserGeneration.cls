@isTest
public class UserGeneration extends AbstractFabricate{

    public static final String ADMIN_ACCOUNT_RT_NAME = 'Administrador del Sistema';
    
    public override Sobject default() {
		return new User(
			TimeZoneSidKey = 'America/Santiago',
			LanguageLocaleKey = 'es',
			LocaleSidKey = 'es_CL',
			EmailEncodingKey = 'UTF-8',
			Country = 'Chile',
			IsActive = true );
	}

    public UserGeneration adminNombre(String nombre,String apellido, String alias, String rut) {
		Profile profile = [SELECT Id FROM Profile WHERE Name =: ADMIN_ACCOUNT_RT_NAME ];
        return (UserGeneration)set('ProfileId', profile.Id)
            .set('Username', nombre+'_'+apellido+'@vidasecurity.cl.generate')
            .set('Email', nombre+'_'+apellido+'@'+nombre+'.test'+'.cl')
            .set('LastName', apellido)
            .set('FirstName', nombre)
            .set('Alias', alias)
            .set('CommunityNickname', alias)
            .set('RUT_Usuario__c', rut);
	}
}