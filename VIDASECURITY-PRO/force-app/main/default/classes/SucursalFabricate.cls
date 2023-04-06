@isTest
public class SucursalFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Sucursal__c(
			Codigo_Sucursal__c='00001', 
			Name='Barquisimeto',
			Area__c =  (Id)Fabricate.area().save().get().get('Id'),
			TP_Oficina__c = 10
		);
	}

  	public SucursalFabricate setArea(AreaFabricate area) {
		return (SucursalFabricate) this.set('Area__c', area);
	}
}