@isTest
public class CiudadFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Ciudad__c(
			CIUD_C_digo__c='00001',
			Name='Barquisimeto'
			// ATENCION: No podemos hacer save en los default() porque al instanciar duplicamos los registros, usar setRegion en su lugar.
			//CIUD_Region__c =  (Id)Fabricate.region().save().get().get('Id')
		);
	}

  	public CiudadFabricate setRegion(RegionFabricate region) {
		return (CiudadFabricate) this.set('CIUD_Region__c', region);
	}
}