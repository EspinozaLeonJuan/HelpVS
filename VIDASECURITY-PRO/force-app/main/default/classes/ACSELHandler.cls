public class ACSELHandler implements TriggerHandler.HandlerInterface {
	
	//private static final String PERFIL_EJECUTIVO_POST_VENTA = 'Ejecutiva Post Venta';
	private static Boolean hasExecuted = false;

	public void handle() {
		Map<Id, User> mapUsuariosEjecutivosCliente = new Map<Id, User>([Select Id From User Where Ejecutivo_de_Cliente__c = True]);

		Set<Id> accountsIds = new Set<Id>();

		for (Account account : (Account[])Trigger.new) {
			Account oldAccount = Trigger.isUpdate ? (Account)Trigger.oldMap.get(account.id) : null;
			if( mapUsuariosEjecutivosCliente.containsKey(account.OwnerId) && (oldAccount == null || (oldAccount !=null && oldAccount.OwnerId != account.OwnerId)) || account.OwnerId == '005i0000004xhHp')
				accountsIds.add(account.Id);
		}

		if(!accountsIds.isEmpty()){
			if( System.isBatch() || System.isFuture()  ){
				if(!hasExecuted)
					System.enqueueJob(new ACSELQueueable(accountsIds));
				hasExecuted = true;
			}
			else 
				asignacionACSEL(accountsIds);
		}

	}

	@Future(callout=true)
	private static void asignacionACSEL(Set<Id> cuentasIds){
		List<ACSELAsignacion> asignacionesEfectivas = new List<ACSELAsignacion>();
		List<Account> cuentas = [Select Id, Rut__c, Ejecutivo_de_Cliente__c, Ejecutivo_de_Cliente__r.Codigo__c From Account Where Id IN :cuentasIds];
		for(Account cuenta: cuentas){
			ACSELAsignacion asignacionEfectiva = new ACSELAsignacion();
			asignacionEfectiva.rut = Integer.valueOf(cuenta.Rut__c == null ? '0' : cuenta.Rut__c);
			asignacionEfectiva.codigoEjecutivo = (cuenta.Ejecutivo_de_Cliente__c == null ? 0 : Integer.valueOf(cuenta.Ejecutivo_de_Cliente__r.Codigo__c));
			asignacionesEfectivas.add(asignacionEfectiva);
		}

		if (!asignacionesEfectivas.isEmpty() && !Test.isRunningTest())
			ACSELCalloutService.asignaEjecutivos(asignacionesEfectivas);

	}
}