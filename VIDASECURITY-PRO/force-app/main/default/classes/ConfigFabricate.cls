@isTest
public class ConfigFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Config__c(Dias_Fecha_Ultima_Actividad__c = 1);
	}
	
	public ConfigFabricate setDiasFechaUltimaActividad(Integer dias) {
		return (ConfigFabricate)set('Dias_Fecha_Ultima_Actividad__c', dias);
	} 
}