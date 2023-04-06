public with sharing class BloqueoService {
	
	public static final string BLOQUEADO = Filial.EstadoBeneficio.BLOQUEADO.name();
	
	/**
	* Se factoriza la lógica de obtención de facturas a bloquear para ser llamado desde el batch y desde el controlador (en forma indirecta).
	* Retorna la lista de facturas cuyas filiales deben ser bloqueadas.
	*/
	public static String queryBloquearFiliales() {
	return 'SELECT Id, '+
				'Filial__c, ' +
				'Filial__r.Poliza__r.Corredor__c, ' +
				'Filial__r.Grupo_Cobranza__c, ' +
				'Filial__r.Numero_Poliza__c, ' +
				'Filial__r.Estado_Beneficio__c, ' +
				'Filial__r.Rut_Empresa__c, ' +
				'Filial__r.Dv_Empresa__c, ' +
				'Fecha_Compromiso__c, ' + 
				'Fecha_Bloqueo_Beneficios__c, ' +
				'Notificacion_de_Aviso_de_Bloqueo__c ' +
							'FROM Factura__c ' + 
			'WHERE ' +
				'Filial__r.Estado_Beneficio__c <> :BLOQUEADO AND ' +
				'Estado_Pago__c = \'Abierto\' AND ' +
				'Bloquea_Beneficios__c = \'SI\' AND ' +
				'Poliza__r.RecordType.Name = \'Colectivos\' AND ' +
				'Poliza__r.Estatus__c = \'ACTIVA\' AND ' +
				'Notificacion_de_Aviso_de_Bloqueo__c = true AND ' +
				'(Fecha_Bloqueo_Beneficios__c <> NULL AND Fecha_Bloqueo_Beneficios__c < TODAY) AND ' +
   				'(Fecha_Compromiso__c = NULL OR Fecha_Compromiso__c < TODAY)';
    }
	
	// Usado para bloquear todas las filiales con facturas impagas, es usado solo como test
	public static void bloquearFiliales() {
		Factura__c[] facturas = (Factura__c[])Database.query(queryBloquearFiliales());
		bloquearFiliales(facturas);
	}

	// Usado por el proceso batch, aca deben enviarse solo las facturas que cumplen las condiciones de bloqueo
	public static void bloquearFiliales(Factura__c[] facturas) {
		if (facturas == null || facturas.isEmpty())
			return;
		Set<Id> filialIds = new Set<Id>();
		for (Factura__c factura : facturas) {
			if (!filialIds.contains(factura.Filial__c))
			filialIds.add(factura.Filial__c);
		}
		bloquearFiliales(new List<Id>(filialIds));
	}
	
	// public static void bloquearFilial(Filial__c filial) {
	// 	bloquearFiliales(new Filial__c[] {filial});
	// }
	
	// public static void BloquearFiliales(Filial__c[] filiales) {
	// 	if (filiales == null)
	// 	throw new CobranzaException('No se han especificado las filiales de bloqueo');
	// 	List<Id> filialIds = new List<Id>();
	// 	for (Filial__c filial : filiales) {
	// 		filialIds.add(filial.Id);
	// 	}
	// 	bloquearFiliales(filialIds);
	// }
	
    public static void bloquearFiliales(Id[] filialIds) {         
        system.debug('@@@@ BloqueoService.bloquearFiliales in --> '+ filialIds);
		Proceso_Cobranza__c procesoCobranza = Proceso_Cobranza__c.getOrgDefaults();
		if (procesoCobranza == null)
			procesoCobranza = new Proceso_Cobranza__c();
		procesoCobranza.Fecha_Ultimo_Proceso_de_Bloqueo__c = Datetime.now();
		Filial__c[] filiales =  [SELECT Id, Grupo_Cobranza__c, Poliza__r.Corredor__c, Rut_Empresa__c, Dv_Empresa__c, Numero_Poliza__c FROM Filial__c WHERE Id IN :filialIds];
		system.debug('@@@@ filiales  --> '+ filiales);
		Map<Id, BitacoraCobranza> bitacoraMap = new Map<Id, BitacoraCobranza>();
		Map<Id, Id[]> whatMap = new Map<Id, Id[]>();
		for (Filial__c filialObj : filiales) {
			//Service Call
        	EstadoBeneficioResponse response;
			BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Bloqueo_de_Beneficios, filialObj);
			system.debug('@@@@ filialObj --> '+ filialObj);
            try
            {
			response = EstadoBeneficioAPI.bloquearBeneficio(new EstadoBeneficioRequest(filialObj));
            system.debug('@@@@ response --> '+ response);
			if (response.isSuccess()) {
                system.debug('@@@@ response.isSuccess true');
				procesoCobranza.Fecha_Ultimo_Bloqueo_Realizado__c = Datetime.now();
				filialObj.Fecha_Hora_Bloqueo_de_Beneficios__c = procesoCobranza.Fecha_Ultimo_Proceso_de_Bloqueo__c;
				filialObj.Estado_Beneficio__c = Filial.EstadoBeneficio.BLOQUEADO.name();
				Id corredorId = filialObj.Poliza__r.Corredor__c;
				System.assertNotEquals(null, corredorId, 'La filial no posee un correcdor asociado a la póliza');
				//corredorIds.add(corredorId);
				List<Id> whatIds = whatMap.get(corredorId);
				if (!whatMap.containsKey(corredorId)) {
					whatIds = new List<Id>();
					whatMap.put(corredorId, whatIds);
									}
									whatIds.add(filialObj.Id);
			} else
            {
                system.debug('@@@@ response.isSuccess false --> ' +response.getMessage());
                bitacora.addError(response.getMessage());
            }
            }
            catch (Exception e)
            {
                system.debug('@@@@ API Exception');
                bitacora.addError(e.getMessage());
            }
            system.debug('@@@@ bitacora --> '+ bitacora);
			bitacoraMap.put(filialObj.Id, bitacora);
            system.debug('@@@@ bitacoraMap.put --> '+ bitacoraMap);
				
		}
		Database.SaveResult[] dbResults = Database.update(filiales, false);
		BitacoraService.setResultados(bitacoraMap, dbResults);

		List<Id> corredorIds = new List<Id>();        
        corredorIds = new List<Id>(whatMap.keySet());

		EmailResult[] emailResults = CobranzaService.sendEmails(corredorIds, 'Bloqueo_de_Beneficios', whatMap);
		if (emailResults != null) {
			for (EmailResult emailResult : emailResults) {
				Id filialId = emailResult.whatId; // filialId
				Bitacora bitacora = bitacoraMap.get(filialId);
				System.assertNotEquals(null, bitacora, 'La bitacora es nula');
				if (!emailResult.isSuccess())
					bitacora.addError(emailResult.getErrorMessage());
			}
		}
  		
        system.debug('@@@@ bitacoraMap.values() --> '+ bitacoraMap.values());
        
		BitacoraService.registrarEventos(bitacoraMap.values());
		system.debug('@@@@ bitacoraMap out --> '+ bitacoraMap);
        
        
		upsert procesoCobranza;
        system.debug('@@@@ procesoCobranza out --> '+ procesoCobranza);
	}

	public static void procesarResponseAPI(EstadoBeneficioResponse response, Filial__c filialObj){
		Map<Id, BitacoraCobranza> bitacoraMap = new Map<Id, BitacoraCobranza>();
		BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Bloqueo_de_Beneficios, filialObj);

		if (response.isSuccess()){
			filialObj.Fecha_Hora_Bloqueo_de_Beneficios__c = Datetime.now();
			filialObj.Estado_Beneficio__c = Filial.EstadoBeneficio.BLOQUEADO.name();
		}
		else{
			bitacora.addError(response.getMessage());
			// throw new CobranzaException(response.getMessage());
		}
		
		bitacoraMap.put(filialObj.Id, bitacora);
		if (filialObj.Poliza__r.Corredor__c == null)
			bitacora.addError('La póliza de esta filial no tiene asignado un Corredor');
		
		Database.SaveResult[] dbResults = Database.update(new Filial__c[] {filialObj}, false);
		BitacoraService.setResultados(bitacoraMap, dbResults);

		try {
			if(CobranzaService.userToNotify(new Id[] {filialObj.Poliza__r.Corredor__c}, 'Bloqueo_de_Beneficios')){
				EmailResult[] results = CobranzaService.sendEmails(new Id[] {filialObj.Poliza__r.Corredor__c}, 'Bloqueo_de_Beneficios', new Map<Id, Id> {filialObj.Poliza__r.Corredor__c => filialObj.Id});
				if (results == null || results.isEmpty())
					bitacora.addGlosa('No se obtuvo respuesta del envio de notificación');
				EmailResult result = results[0];
				if (!result.isSuccess())
					bitacora.addGlosa(result.getErrorMessage());
			}
			else
				bitacora.addSuccess('Se han bloqueado los beneficios por falta de pago de esta filial. No se encontró contacto a quien notificar');
		
		} catch (Exception e) {
			bitacora.addGlosa('Ocurrio un error al intentar enviar correo de notificacion: ' + e.getMessage());
		}
		
		
		BitacoraService.registrarEventos(bitacoraMap.values());
	}
}