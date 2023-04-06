@isTest
public class CiudadSucursalFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Ciudad_de_Sucursal__c(
			Name='Barquisimeto'
		);
	}

  	public CiudadSucursalFabricate setSucursal(SucursalFabricate sucursal) {
		return (CiudadSucursalFabricate) this.set('Sucursal__c', sucursal);
	}

	public CiudadSucursalFabricate setCiudad(CiudadFabricate ciudad) {
		return (CiudadSucursalFabricate) this.set('Ciudad__c', ciudad);
	}
}