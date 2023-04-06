public class ActualizaEnvioEncuestaHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		Set<Id> idCuentasUpdate = new Set<Id>();
		Set<Id> cuentasUpdate = new Set<Id>();
		List<Account> cuentasUpdateFinal = new List<Account>();

		for( Case caso : (Case[]) Trigger.new ) {
			Case old = (Case)Trigger.oldMap.get(caso.Id);
			Case kase = (Case)Trigger.newMap.get(caso.Id);
			if(old.Fecha_de_EPA_Contact_Center_Caso__c != kase.Fecha_de_EPA_Contact_Center_Caso__c) {
				idCuentasUpdate.add(caso.AccountId);
			}
		}

		Map<Id, Account> mapCtaUpdate = new Map<Id, Account>([select Id from Account where Id =:idCuentasUpdate FOR UPDATE]);

		for ( Case caso : (Case[]) Trigger.new ){
			if (idCuentasUpdate.contains(caso.AccountId) && !cuentasUpdate.contains(caso.AccountId)) {
				Account a = mapCtaUpdate.get(caso.AccountId);
				a.Fecha_de_Envio_de_Encuesta__c = caso.Fecha_de_EPA_Contact_Center_Caso__c;
				a.Pendiente_Envio_Encuesta__c = false;
				cuentasUpdate.add(a.Id);
				cuentasUpdateFinal.add(a);
			}
		}

		update cuentasUpdateFinal;
	}
}