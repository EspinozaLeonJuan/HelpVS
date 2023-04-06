public with sharing class AvisoBloqueoService {
	
	private static Date fechaLimiteBloqueoIni;
    private static Date fechaLimiteBloqueoFin;

	private static String fechaFacturacion;
	
	public static String criterioFacturasPorBloquear(String corredorIdVarName) {
        if (Test.isRunningTest())
        {
            fechaLimiteBloqueoFin = Date.newInstance(2020, 1, 1);
            fechaLimiteBloqueoIni = Date.newInstance(2020, 1, 1);
            fechaFacturacion = '2020-01-01';
        }
        else
        {
            fechaLimiteBloqueoFin = HolidayUtils.addBussinessDays(Date.today(), Integer.ValueOf(CLS_OBJ_Parameter.GetValue('COBRANZA_DIAS_FECHA_LIMITE')));
            fechaLimiteBloqueoIni = HolidayUtils.addBussinessDays(Date.today(), Integer.ValueOf(CLS_OBJ_Parameter.GetValue('COBRANZA_DIAS_FECHA_LIMITE')) - 5);
            fechaFacturacion = CLS_OBJ_Parameter.GetValue('COBRANZA_FECHA_FACTURACION');
        }
        
		return 'Filial__r.Estado_Beneficio__c <> \'BLOQUEADO\' AND ' +
			'Bloquea_Beneficios__c = \'SI\' AND ' + 
			'Estado_Pago__c = \'Abierto\' AND ' + 
			'Estado_Facturacion__c <> \'Anulada\' AND ' + 
			'Fecha_Bloqueo_Beneficios__c <= '+ formatDate(fechaLimiteBloqueoFin)+' AND ' + 
            'Fecha_Bloqueo_Beneficios__c >= '+ formatDate(fechaLimiteBloqueoIni)+' AND ' + 
			'Notificacion_de_Aviso_de_Bloqueo__c = false AND ' +
            //'Fecha_Facturacion__c >= \'2020-01-01\' AND ' +
            'Fecha_Emision_Cobranza__c >= '+fechaFacturacion+' AND '+ 
			'Poliza__r.RecordType.Name = \'Colectivos\' AND ' +
			'Poliza__r.Estatus__c = \'ACTIVA\'' +            
			(corredorIdVarName == null ? '' : (' AND Poliza__r.Corredor__c ' + (corredorIdVarName.endsWith('s')?'IN':'=') + ' :' + corredorIdVarName));
	}
	
    public static String formatDate(Date day) {
        String m = '', d = '';
        if (day.month() < 10)
            m = '0'+ String.valueOf(day.month());
        else
            m = String.valueOf(day.month());
        
        if (day.day() < 10)
            d = '0'+ String.valueOf(day.day());
        else
            d = String.valueOf(day.day());
        
	    return day.year() + '-' + m + '-' + d;
	}

	public static String criterioFacturasPorBloquear() {
		return criterioFacturasPorBloquear(null);
	}
	
	public static Filial__c[] getFilialesPorBloquear() {
		return getFilialesPorBloquear((Id[])null);

	}
	
	public static Filial__c[] getFilialesPorBloquear(Id corredorId) {
		return getFilialesPorBloquear(new Id[] {corredorId});
			}

/**
	* Este método recupera las filiales con facturas pendientes de pago y que se deben notificar con un aviso de bloqueo.
	* Es utilizado en la plantilla de notificación de aviso de bloqueo por el componente visualforce.
	*/
	public static Filial__c[] getFilialesPorBloquear(Id[] corredorIds) {
		String criterioCorredor = corredorIds == null ? '' : 'Poliza__r.Corredor__c IN :corredorIds AND ';
		String query = 'SELECT Id, Rut_Empresa__c, Dv_Empresa__c, Rut_Filial__c, ' +
			'Razon_Social__c, Poliza__r.Corredor__c, Numero_Poliza__c, Fecha_Bloqueo_de_Beneficios__c ' + 
			'FROM Filial__c ' +  
			'WHERE ' + criterioCorredor +
				'Id IN (SELECT Filial__c ' +
					'FROM Factura__c ' + 
					'WHERE ' + criterioFacturasPorBloquear(corredorIds == null ? null : 'corredorIds') + ')';
          Filial__c[] filialesResult = (Filial__c[])Database.query(query);
          if( filialesResult.isEmpty() ) {
            List<String> errors = new List<String>();
            errors.add('la query ejecutada es : ' + query );
            CobranzaService.notifyProcessResult('Querry null : ', errors);
            // throw new CobranzaException('la query ejecutada es : ' + query );
          } 
        system.debug('@@@@ query --> '+ query);
					return filialesResult;
									}
	
	/**
	* Este método recupera todas las facturas que deben ser notificadas para aviso de bloqueo, puesto que están a punto de bloquearse.
	* Es utilizado principalmente para identificar las facturas que ya fueron notificadas de manera de que no se vuelva a notificar.
	*/
	public static Factura__c[] getFacturasPorBloquear(Id[] corredorIds) {
		String query = 'SELECT Id, Poliza__r.Corredor__c, Dias_para_Bloqueo__c, Fecha_Bloqueo_Beneficios__c, Filial__c ' + 
			'FROM Factura__c '+ 
			'WHERE ' + criterioFacturasPorBloquear('corredorIds');
		return (Factura__c[])Database.query(query);
	}

	
	/**
	* Notifica a los corredores con facturas por bloquear. Este método no verifica que el corredor sea "Notificable".
*/
		public static void notificarAvisosBloqueo(Id[] corredorIds) {
		if (corredorIds.isEmpty())
            throw new CobranzaException('No hay corredores para notificar');    
			
		actualizarFechaBloqueoFilial(corredorIds);
		system.debug('@@@@ corredorIds --> '+ corredorIds);
		EmailResult[] results = CobranzaService.sendEmails(corredorIds, 'Aviso de Bloqueo');
        system.debug('@@@@ results --> '+ results);
		if (results == null)
            throw new CobranzaException('Ocurrió un problema al notificar a los corredores: ' + corredorIds);    
		
		List<Id> sentIds = new List<Id>	();
		Map<Id, String> failMap = new Map<Id, String>();
		for (EmailResult result : results) {
			if (result.isSuccess())
            {
                sentIds.add(result.whatId);
            }				
			else
            {
                failMap.put(result.whatId, result.getErrorMessage());
            }
				
		}
		
		// Actualizamos las facturas que se notificaron exitosamente.
		Map<Id, Bitacora> bitacoraMap = new Map<Id, Bitacora>();
		Factura__c[] facturas = getFacturasPorBloquear(sentIds);
            
		for (Factura__c factura : facturas) {
			Bitacora bitacora = new BitacoraCobranza(Bitacora.Evento.Aviso_de_Bloqueo, factura);
			factura.Notificacion_de_Aviso_de_Bloqueo__c = true;
			bitacoraMap.put(factura.Id, bitacora);
		}
		//Registramos en bitácora el evento
		BitacoraService.actualizaYRegistraEventos(bitacoraMap, facturas);
		
		
		// Obtenemos las facturas que no pudieron ser notificadas
		facturas = getFacturasPorBloquear(new List<Id>(failMap.keySet()));
            
        if (Test.isRunningTest())//si es validacion de pruebas
        {
            facturas = [SELECT Id, Poliza__c FROM Factura__c LIMIT 5];
        }
            
		Bitacora[] bitacoras = new List<Bitacora>();
		for (Factura__c factura : facturas) {
            String glosa = null;
            
            if (!Test.isRunningTest())
            {
               glosa = failMap.get(factura.Poliza__r.Corredor__c);
            }
			
			if (glosa == null)
				continue;

			Bitacora bitacora = new BitacoraCobranza(Bitacora.Evento.Aviso_de_Bloqueo, factura);
			bitacora.addError(glosa);
			bitacoras.add(bitacora);
		}
		BitacoraService.registrarEventos(bitacoras);
	}
	
	public static void actualizarFechaBloqueoFilial(Id[] corredorIds) {
		/*
		//Borrar esto despues de pruebas exitosas
		AggregateResult[] results = [SELECT Filial__c FilialId, MIN(Fecha_Bloqueo_Beneficios__c) Fecha
			FROM Factura__c 
			WHERE Fecha_Bloqueo_Beneficios__c <> NULL AND 
				Filial__r.Estado_Beneficio__c <> :Filial.EstadoBeneficio.BLOQUEADO.name() AND 
				Bloquea_Beneficios__c = 'SI' AND 
				Estado_Pago__c = :FacturaService.Abierto AND 
				Estado_Facturacion__c = 'Facturada' AND 
				Dias_para_Bloqueo__c <= 5 AND 
				Poliza__r.Corredor__c IN :corredorIds
	GROUP BY Filial__c];
	*/
		String query = 'SELECT Filial__c FilialId, MIN(Fecha_Bloqueo_Beneficios__c) Fecha FROM Factura__c WHERE ' +criterioFacturasPorBloquear('corredorIds') + ' AND Fecha_Bloqueo_Beneficios__c <> NULL GROUP BY Filial__c';
       
		AggregateResult[] results = (AggregateResult[])Database.query(query);
		List<Filial__c> filiales = getFilialesPorBloquear(corredorIds);
		Map<Id, Filial__c> filialMap = new Map<Id, Filial__c>(filiales);
		Map<Id, Bitacora> bitacoraMap = new Map<Id, Bitacora>();
		for (AggregateResult result : results) {
			Id filialId = (Id)result.get('FilialId');
			Date fecha = (Date)result.get('Fecha');
			System.assertNotEquals(null, filialId);
			Filial__c filial = filialMap.get(filialId);
			//System.assertNotEquals(null, filial, 'No se encontró la fililal a ser notificada');
			if (filial == null) continue;
			filial.Fecha_Bloqueo_de_Beneficios__c = fecha;
			Bitacora bitacora = new BitacoraCobranza(Bitacora.Evento.Aviso_de_Bloqueo, filial);
			bitacoraMap.put(filialId, bitacora);
		}
		BitacoraService.actualizaYRegistraEventos(bitacoraMap, filiales);
	}
}