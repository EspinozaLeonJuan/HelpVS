public with sharing class DesBloqueoService {
	public static final string BLOQUEADO = Filial.EstadoBeneficio.BLOQUEADO.name();
	
	public static String criterioFacturas() {
		     return 'Estado_Pago__c = \'Cerrado\' AND ' +
            'Filial__r.Estado_Pago__c != \'DEUDA VENCIDA\' AND ' + 
			'Poliza__r.RecordType.Name = \'Colectivos\' AND ' +
			'Poliza__r.Estatus__c = \'ACTIVA\' AND ' +
			'Filial__r.Estado_Beneficio__c = \'BLOQUEADO\' ';
			}
	
	/**
	* Se factoriza la lógica de obtención de facturas a desbloquear para ser llamado desde el batch y desde el controlador (en forma indirecta).
	* Retorna la lista de facturas cuyas filiales deben ser desbloqueadas.
	*/
	public static String queryDesBloquearFiliales() {
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
			'WHERE ' + criterioFacturas();

	}
	
	// Usado para desbloquear todas las filiales con todas las facturas pagadas, es usado solo como test
	public static void desBloquearFiliales() {
		Factura__c[] facturas = (Factura__c[])Database.query(queryDesBloquearFiliales());
		desBloquearFiliales(facturas);
	}

	// Usado por el proceso batch, aca deben enviarse solo las facturas que cumplen las condiciones de desbloqueo
	public static void desBloquearFiliales(Factura__c[] facturas) {
		if (facturas == null || facturas.isEmpty())
			return;
		Set<Id> filialIds = new Set<Id>();
		for (Factura__c factura : facturas) {
			if (!filialIds.contains(factura.Filial__c))
			filialIds.add(factura.Filial__c);
		}
		desBloquearFiliales(new List<Id>(filialIds));
	}
	
	public static Filial__c[] getFilialesDesbloqueadas(Id corredorId) {
		return [SELECT Id, Rut_Filial__c, Razon_Social__c, Fecha_Bloqueo_de_Beneficios__c, Grupo_Cobranza__c, Poliza__r.Corredor__c, Rut_Empresa__c, Dv_Empresa__c, Numero_Poliza__c FROM Filial__c WHERE Poliza__r.Corredor__c = :corredorId AND Estado_Beneficio__c = 'ACTIVO' AND Desbloqueadas_en_ultimo_proceso__c = true];
	}
	
	public static void desBloquearFiliales(Id[] filialIds) {
        System.debug('@@@@ DesBloqueoService.desBloquearFiliales --> '+ filialIds);
		Datetime now = Datetime.now();
		Proceso_Cobranza__c procesoCobranza = Proceso_Cobranza__c.getOrgDefaults();
        System.debug('@@@@ procesoCobranza --> '+ procesoCobranza);
        
		if (procesoCobranza == null)
			procesoCobranza = new Proceso_Cobranza__c();

		procesoCobranza.Fecha_Ultimo_Proceso_de_Desbloqueo__c = now;

		Filial__c[] filiales = [SELECT Id, Grupo_Cobranza__c, Poliza__r.Corredor__c, Rut_Empresa__c, Numero_Poliza__c FROM Filial__c WHERE Id IN :filialIds];
		System.debug('@@@@ filiales --> '+ filiales);
		
        Map<Id, BitacoraCobranza> bitacoraMap = new Map<Id, BitacoraCobranza>();
		Map<Id, Id> whatMap = new Map<Id, Id>();
		for (Filial__c filialObj : filiales) {
			//Service Call
			System.debug('@@@@ filialObj --> '+ filialObj);
            EstadoBeneficioResponse response;
            BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Desbloqueo_de_Beneficios, filialObj); 
            try
            {	
                response = EstadoBeneficioAPI.desbloquearBeneficio(new EstadoBeneficioRequest(filialObj));
                System.debug('@@@@ response --> '+ response);
                if (response.isSuccess()){
                    system.debug('@@@@ response.isSuccess true');
                    filialObj.Estado_Beneficio__c = Filial.EstadoBeneficio.ACTIVO.name();
                    procesoCobranza.Fecha_Ultimo_Desbloqueo_Realizado__c = now;
                    filialObj.Fecha_Hora_Bloqueo_de_Beneficios__c = null;
                    filialObj.Fecha_Hora_Desbloqueo_de_Beneficios__c = now;
                    Id corredorId = filialObj.Poliza__r.Corredor__c;
                    System.assertNotEquals(null, corredorId, 'La filial no posee un correcdor asociado a la póliza');
                    if (!whatMap.containsKey(corredorId)) {
                        whatMap.put(corredorId, corredorId);
                                        }
                                }
                else{
                    system.debug('@@@@ response.isSuccess false');
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

        
		List<Id> corredorIds = new List<Id>(whatMap.keySet());

        /*
		EmailResult[] emailResults = CobranzaService.sendEmails(corredorIds, 'Desbloqueo_de_Beneficios', whatMap);
		for (EmailResult emailResult : emailResults) {
				Id corredorId = emailResult.whatId; // corredorId
				System.assertNotEquals(null, corredorId, 'El corredorId es null en whatMap');
				BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.DESBloqueo_de_Beneficios, new Corredor__c(Id = corredorId));
				bitacoraMap.put(corredorId, bitacora);
			if (!emailResult.isSuccess())
				bitacora.addError(emailResult.getErrorMessage());
					else
					bitacora.addSuccess('Se ha notificado al contactoespecificado el desbloqueo de las filiales.');
		}
		*/
               
       
 		system.debug('@@@@ bitacoraMap.values() --> '+ bitacoraMap.values());
		BitacoraService.registrarEventos(bitacoraMap.values());
		system.debug('@@@@ bitacoraMap out --> '+ bitacoraMap);
		
		//BitacoraService.actualizaYRegistraEventos(bitacoraMap, filiales);
		upsert procesoCobranza;
        system.debug('@@@@ procesoCobranza out --> '+ procesoCobranza);
	}

	public static void procesarResponseAPI(EstadoBeneficioResponse response, Filial__c filialObj){
		System.debug('DesBloqueoService.procesarResponseAPI - BEGIN');
		Map<Id, BitacoraCobranza> bitacoraMap = new Map<Id, BitacoraCobranza>();
		BitacoraCobranza bitacora = new BitacoraCobranza(Bitacora.Evento.Desbloqueo_de_Beneficios, filialObj); //TODO: Evento desbloqueo
		
		System.debug('response');
		System.debug(response);

		if (response.isSuccess()){
			filialObj.Fecha_Hora_Bloqueo_de_Beneficios__c = null;
			filialObj.Estado_Beneficio__c = Filial.EstadoBeneficio.ACTIVO.name();
		}
			
		 else{
			bitacora.addError(response.getMessage());
			// throw new CobranzaException(response.getMessage());
		 }
		
		

		bitacoraMap.put(filialObj.Id, bitacora);
		BitacoraService.actualizaYRegistraEventos(bitacoraMap, new Filial__c[]{filialObj});
	}
}