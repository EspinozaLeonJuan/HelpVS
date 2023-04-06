@IsTest
public class ListaDeDistribucionFabricate extends AbstractFabricate { 
    public override SObject default() {
		return new Lista_de_Distribucion__c();
	}

    public ListaDeDistribucionFabricate setCorredor(CorredorFabricate corredor) {
		return (ListaDeDistribucionFabricate)set('Corredor__c', corredor);
	}

    public ListaDeDistribucionFabricate setContacto(ContactFabricate contacto) {
		return (ListaDeDistribucionFabricate)set('Contacto__c', contacto);
	}

	public ListaDeDistribucionFabricate setTipoDeNotificacion(String tipoNotificacion) {
		return (ListaDeDistribucionFabricate)set('Tipo_de_Notificacion__c', tipoNotificacion);
	}
	
	public ListaDeDistribucionFabricate setCuenta(AccountFabricate account) {
		return (ListaDeDistribucionFabricate)set('Cuenta__c', account);
	}
	
	public ListaDeDistribucionFabricate notificacionCuenta() {
		return (ListaDeDistribucionFabricate) set('RecordTypeId', Schema.SObjectType.Lista_de_Distribucion__c.getRecordTypeInfosByName().get('Notificaciones de Cuenta').getRecordTypeId());
	}
	
	public ListaDeDistribucionFabricate notificacionCorredor() {
		return (ListaDeDistribucionFabricate) set('RecordTypeId', Schema.SObjectType.Lista_de_Distribucion__c.getRecordTypeInfosByName().get('Notificaciones de Corredor').getRecordTypeId());
	}
}