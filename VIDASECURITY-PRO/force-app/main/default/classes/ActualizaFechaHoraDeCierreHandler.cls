public class ActualizaFechaHoraDeCierreHandler implements TriggerHandler.HandlerInterface {


	public void handle() {
		if ([Select Id, Name from Profile where Id =:UserInfo.getProfileId()].Name.ContainsIgnoreCase('Admin')) {
			return;
		}

		for (Case c : (Case[]) Trigger.new) {
			if (c.Fecha_Hora_de_Cierre__c == null && c.ClosedDate != null) {
				c.Fecha_Hora_de_Cierre__c = c.ClosedDate;
							}
		}
	}
}