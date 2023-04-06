public class ValidaRUTCorredorHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		for (Corredor__c corredor : (Corredor__c[])Trigger.new) {
			String rut = corredor.RUT__c + corredor.DV__c;
			if (!RUTUtils.isValid(rut))
				TriggerHandler.addError('RUT no válido', corredor);
		}
		}
}