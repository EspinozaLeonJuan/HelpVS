public class ACSELQueueable implements Queueable, Database.AllowsCallouts {

	public Set<Id> cuentasIds;

	public ACSELQueueable(Set<Id> cuentasIds){
		this.cuentasIds = cuentasIds;
	}

	public void execute(QueueableContext context) {
        List<ACSELAsignacion> asignacionesEfectivas = new List<ACSELAsignacion>();
		List<Account> cuentas = [Select Id, Rut__c, Ejecutivo_de_Cliente__c, Ejecutivo_de_Cliente__r.Codigo__c From Account Where Id IN :this.cuentasIds];
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