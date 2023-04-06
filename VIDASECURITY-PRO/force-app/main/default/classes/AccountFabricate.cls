@isTest
public class AccountFabricate extends AbstractFabricate{

	public static final String PERSON_ACCOUNT_RT_NAME = 'Cuenta personal';
	public static final String COMPANY_ACCOUNT_RT_NAME = 'Cuenta Corporativa';

	public override Sobject default() {
		return new Account(
			Rut__c = '11111111',
			DV__c = '1'
			 			);
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
			.set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, COMPANY_ACCOUNT_RT_NAME));
	}

	public AccountFabricate personal() {
		return (AccountFabricate) this
			.set('FirstName', 'Will')
			.set('LastName', 'Smith')
			.set('Rut__c', '16355278')
			.set('DV__c', '7')
			.set('RecordTypeId', ReflectionUtils.getRecordTypeId(Account.sObjectType, PERSON_ACCOUNT_RT_NAME))
			.set('Rut_contacto__pc', (String)instance.get('Rut__c'))
			.set('DV_contacto__pc', (String)instance.get('DV__c'));
	}
	
	public AccountFabricate setPropietario(UserFabricate user) {
		return (AccountFabricate) set('OwnerId', user);
	}

	public AccountFabricate setAgenteActual(ContactFabricate agente){
		return (AccountFabricate) set('Agente_Actual__c', agente);
	}

	public AccountFabricate setCiudad(CiudadFabricate ciudad){
		return (AccountFabricate) set('Ciudad_Particular_B__c', ciudad);
	}

	public AccountFabricate setCategoriaCliente(CategoriaDeClienteFabricate categoria){
		return (AccountFabricate) set('Categoria_del_Cliente__c', categoria);
	}

	public AccountFabricate setRelacionDeCategoria(RelacionDeCategoriaFabricate relacion){
		return (AccountFabricate) set('Relacion_de_Categoria__c', relacion);
	}

	public AccountFabricate setCiudadSucursal(CiudadSucursalFabricate ciudad_sucursal){
		return (AccountFabricate) set('Sucursal_Asignada__c', ciudad_sucursal);
	}
}