public with sharing class CompromisoPagoService {

	public static List<Factura__c> getFacturas(Id[] facturaIds){
		System.debug('CompromisoPagoService.getFacturas - BEGIN');
		return [SELECT Id, 
			Poliza__r.Corredor__c,
			Fecha_Compromiso__c, 
			Fecha_Bloqueo_Beneficios__c, 
			Filial__c,
			Rut_Empresa__c,
			Razon_Social__c,
			Filial__r.Rut_Empresa__c,
			Filial__r.Dv_Empresa__c,
			N_Poliza__c, 
            Name,
            Id_Factura__c,
			Numero_Factura__c,
			Fecha_Bloqueo_Automatica__c
		FROM  Factura__c 
		WHERE Id IN: facturaIds];
	}

	public static IngresarCompromisoPagoRequest[] getCompromisoPagoRequest(List<Factura__c> facturas, Date fechaCompromisoPago){
		System.debug('CompromisoPagoService.getCompromisoPagoRequest - BEGIN');
		List<IngresarCompromisoPagoRequest> requests = new List<IngresarCompromisoPagoRequest>();
    system.debug('requests 1 : ' + requests );
		for (Factura__c factura : facturas) {
			System.debug(factura.Fecha_Bloqueo_Beneficios__c);	
			requests.add(new IngresarCompromisoPagoRequest(factura, fechaCompromisoPago));
		}
    system.debug('requests : ' + requests );
		return requests;
	}

	public static void procesarResponseAPI(IngresarCompromisoPagoResponse[] responses, List<Factura__c> facturas, Date fechaCompromisoPago){
		System.debug('CompromisoPagoService.procesarResponseAPI - BEGIN');
		Map<Id,BitacoraCobranza> mapIdFacturaBitacora = new Map<Id,BitacoraCobranza>();
		for (Integer i=0; i < responses.size(); i++) {
			IngresarCompromisoPagoResponse response = responses[i];
      System.debug('@@@ responses[' + i + ' ] : ' + responses[i] );
			Factura__c factura = facturas[i];
      System.debug('@@@ factura : ' + factura );
			BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Compromiso_de_Pago, factura);
      System.debug('@@@ bitacora : ' + bitacora);
			System.debug('@@@ response 2 : ' + response );

			if (response.isSuccess()){
				factura.Fecha_Compromiso__c = fechaCompromisoPago;
				if ((factura.Fecha_Bloqueo_Beneficios__c != null && factura.Fecha_Bloqueo_Beneficios__c <= fechaCompromisoPago)
					|| factura.Fecha_Bloqueo_Automatica__c){
					factura.Fecha_Bloqueo_Beneficios__c = fechaCompromisoPago.addDays(1);
					factura.Fecha_Bloqueo_Automatica__c = true;
				}
		
				System.debug('factura');
				System.debug(factura);
				bitacora.addSuccess('Se establece fecha compromiso pago para el día ' + Datetime.newInstance(fechaCompromisoPago, Time.newInstance(0, 0, 0, 0)).format('dd-MM-yyyy'));
			}
			else{
				bitacora.addError(response.getMessage());
			}
			
			System.debug('bitacora');
			System.debug(bitacora);

			mapIdFacturaBitacora.put(factura.ID, bitacora);
		}

		BitacoraService.actualizaYRegistraEventos(mapIdFacturaBitacora, facturas);
	}
}