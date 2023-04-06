public class ValidaRUTCuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		for (Account a : (Account[])Trigger.new) {
			String rut = a.IsPersonAccount ? (a.Rut_contacto__pc + a.DV_contacto__pc) : a.Rut__c + a.DV__c;
			if (!RUTUtils.isValid(rut))
				TriggerHandler.addError('RUT no válido', a);
		}
	}
}