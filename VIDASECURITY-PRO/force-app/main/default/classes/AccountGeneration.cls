@isTest
public class AccountGeneration extends AbstractFabricate{
    public static final String PERSON_ACCOUNT_RT_NAME = 'Cuenta personal';
	public static final String COMPANY_ACCOUNT_RT_NAME = 'Cuenta Corporativa';

	public override Sobject default() {
		return new Account(
			Rut__c = '11111111',
			DV__c = '1' );
	}

	public AbstractFabricate anonima() {
		return this.set('Name', 'Anonimo')
            .set('Rut__c', '99999998')
            .set('DV__c', '0')
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, COMPANY_ACCOUNT_RT_NAME));
	}

	public AbstractFabricate corporativa() {
		return this
            .set('Name', 'Test')
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, COMPANY_ACCOUNT_RT_NAME) );
	}

	public AccountGeneration personal() {
		return (AccountGeneration) this
            .set('FirstName', 'Will')
            .set('LastName', 'Smith')
            .set('Rut__c', '16355278')
            .set('DV__c', '7')
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, PERSON_ACCOUNT_RT_NAME))
            .set('Rut_contacto__pc', (String)instance.get('Rut__c'))
            .set('DV_contacto__pc', (String)instance.get('DV__c'));
	}
	
	public AccountGeneration generico(String nombre, String apellido, String rut, String dv, Id owner ) {
		return (AccountGeneration) this
            .set('FirstName', nombre)
            .set('LastName', apellido)
            .set('Rut__c', rut)
			.set('Rut_contacto__pc', (String)instance.get('Rut__c'))
            .set('DV__c', dv)
			.set('DV_contacto__pc', (String)instance.get('DV__c'))
			.set('OwnerId', owner)
            .set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, PERSON_ACCOUNT_RT_NAME));
	}

	public AccountGeneration setPropietario(UserFabricate user) {
		return (AccountGeneration) set('OwnerId', user);
	}

	public AccountGeneration setAgenteActual(ContactFabricate agente){
		return (AccountGeneration) set('Agente_Actual__c', agente);
	}

	public AccountGeneration setCiudad(CiudadFabricate ciudad){
		return (AccountGeneration) set('Ciudad_Particular_B__c', ciudad);
	}

	public AccountGeneration setCategoriaCliente(CategoriaDeClienteFabricate categoria){
		return (AccountGeneration) set('Categoria_del_Cliente__c', categoria);
	}

	public AccountGeneration setRelacionDeCategoria(RelacionDeCategoriaFabricate relacion){
		return (AccountGeneration) set('Relacion_de_Categoria__c', relacion);
	}

	public AccountGeneration setCiudadSucursal(CiudadSucursalFabricate ciudad_sucursal){
		return (AccountGeneration) set('Sucursal_Asignada__c', ciudad_sucursal);
	}
}