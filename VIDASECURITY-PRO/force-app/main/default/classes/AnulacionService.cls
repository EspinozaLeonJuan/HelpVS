public with sharing class AnulacionService {
	
	private static Id[] getPolizaIds(AggregateResult[] results) {
		List<Id> polizaIds = new List<Id>();
		for (AggregateResult result : results) {
			Id polizaId = (Id)result.get('Poliza__c');
			polizaIds.add(polizaId);
		}
		return polizaIds;
	}
	
	/**
	* De todas las polizaIds ingresadas como parámetro retorna solo las que cumplen el criterio de anulación por falta de pago.
	* En caso de que polizaIds sea null retorna todas las polizas en esta condición.
	*/
	private static Id[] getPolizasAnulables(Id[] polizaIds) {
		String criterioPolizaIds = polizaIds == null ? '' : ' AND Poliza__c IN :polizaIds ';
		// ¿Y que sucede con el compromiso de pago?
		String query = 'SELECT Poliza__c ' + 
			'FROM Factura__c ' + 
			'WHERE Estado_Pago__c = \'Abierto\' AND ' +
			'	Fecha_Vencimiento_Plazo__c < TODAY AND ' +
			'	Periodo_Cobertura__c <> NULL AND ' + 
			'	Poliza__c <> NULL ' +
			criterioPolizaIds +
			'GROUP BY Poliza__c ' +
			'HAVING COUNT(Periodo_Cobertura__c) >= 3';
		AggregateResult[] results = (AggregateResult[])Database.query(query);
		return getPolizaIds(results);
	}
	
	/**
	* Criterio de anulación aplicable sobre pólizas "anulables"
	*/
	private static String criterioAnulacion() {
		return 'Estatus__c = \'ACTIVA\' AND ' +
			'RecordType.Name = \'Colectivos\' AND ' +
			'Id IN :polizaIds';
	}
	
	public static Boolean isAnulable(Id polizaId) {
		if (polizaId == null)
			return false;
		return !getPolizasAnulables(new Id[] {polizaId}).isEmpty();
	}
	
	public static void anular(Poliza__c poliza) {
		validarAnulacion(poliza);
		poliza.Estatus__c = 'ANULADA';
		update poliza;
	}
	
	private static void validarAnulacion(Poliza__c poliza) {
		if (poliza.Estatus__c == 'ANULADA')
			throw new CobranzaException('Esta póliza ya fue anulada.');
		// Esta condición se podría relajar
		if (poliza.Estatus__c != 'ACTIVA')
			throw new CobranzaException('La póliza no se encuentra activa');
		// Esta restricción se pone porque no hay definición de anulación para otro tipo de pólizas en este proyecto.
		if (poliza.RecordType.Name != 'Colectivos')
			throw new CobranzaException('Solo es posible anular pólizas de colectivos');
		if (!isAnulable(poliza.Id))
				throw new CobranzaException('La póliza seleccionada no cumple los criterios de anulación. Tener 3 periodos de cobertura con facturas pendientes de pago y con su fecha de vencimiento cumplida.');
	}
	
	private static void enviarNotificacion(Poliza__c poliza, Id targetId) {
		//System.debug(Od)
		EmailResult[] results = CobranzaService.sendEmails(new Id[] {targetId}, 'Anulacion_Poliza', new Map<Id, Id> {targetId => poliza.Id});
		for (EmailResult result : results) {
			if (!result.isSuccess())
				throw new CobranzaException('No fue posible enviar el email al destinatario. Error: ' + result.getErrorMessage());
		}
	}
	
	private static void enviarNotificacion(Poliza__c poliza) {
				if (poliza.Corredor__c == null)
			throw new CobranzaException('La póliza no tiene asociado un corredor');
		if (poliza.Cuenta__c == null)
			throw new CobranzaException('La póliza no tiene asociado una cuenta');
		enviarNotificacion(poliza, poliza.Cuenta__c);
		enviarNotificacion(poliza, poliza.Corredor__c);
	}
	
	public static void notificarAnulacion(Poliza__c[] polizas) {
		for (Poliza__c poliza : polizas) {
			validarAnulacion(poliza); 
			enviarNotificacion(poliza);
		}
	}
	
	public static void notificarAnulacion(Poliza__c poliza) {
		notificarAnulacion(new Poliza__c[] {poliza});
	}
	
	public static void marcarPolizasAnulables() {
		Id[] polizaIds = getPolizasAnulables(null);
		Poliza__c[] polizas = [SELECT Id FROM Poliza__c WHERE RecordType.Name = 'Colectivos' AND Es_Anulable__c = true AND (NOT Id IN :polizaIds) FOR UPDATE];
		for (Poliza__c poliza : polizas) {
			poliza.Es_Anulable__c = false;
		}
		Database.SaveResult[] results = Database.update(polizas, false);
		String query = 'SELECT Id FROM Poliza__c WHERE Es_Anulable__c = false AND ' + criterioAnulacion();
		polizas = (Poliza__c[])Database.query(query);
		for (Poliza__c poliza: polizas) {
			poliza.Es_Anulable__c = true;
		}
		results = Database.update(polizas, false);
	}
}