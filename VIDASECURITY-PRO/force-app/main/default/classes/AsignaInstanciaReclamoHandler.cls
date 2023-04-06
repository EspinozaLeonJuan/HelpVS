public with sharing class AsignaInstanciaReclamoHandler implements TriggerHandler.HandlerInterface {

	public static Id RECLAMO = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reclamos').getRecordTypeId();
	public static Integer DIAS_CORTE = null;

	static {
		Reclamos__c reclamo = Reclamos__c.getOrgDefaults();
		if (reclamo != null)
			DIAS_CORTE = reclamo.Dias_de_Reclamos__c != null ? reclamo.Dias_de_Reclamos__c.intValue() : null;
	}

	public void handle() {
		Set<Id> accountIds = new Set<Id>();
		Set<String> tiposOperacion = new Set<String>();
		Set<String> detallesOperacion = new Set<String>();
		List<Case> cases = new List<Case>();
		for (Case c : (Case[])Trigger.new) {
			if (c.RecordTypeId != RECLAMO || !String.isBlank(c.Instancia_del_Reclamo__c))
				continue;
			if (c.Canal__c == 'DDA') {
				c.Instancia_del_Reclamo__c = 'DDA';
				continue;
			}
			if (!accountIds.contains(c.AccountId))
				accountIds.add(c.AccountId);
			if (!tiposOperacion.contains(c.Tipo_Operacion__c))
				tiposOperacion.add(c.Tipo_Operacion__c);
			if (!detallesOperacion.contains(c.Detalle_Operacion__c))
			detallesOperacion.add(c.Detalle_Operacion__c);
			cases.add(c);
					}

		if (cases.isEmpty())
			return;
		// Consultamos el producto cruz porque al filtrar por accountId no deberían haber muchas variantes.
		Case[] results = [SELECT Id, Instancia_del_Reclamo__c, CreatedDate, AccountId, Tipo_Operacion__c, Detalle_Operacion__c FROM Case WHERE AccountId IN :accountIds AND Tipo_Operacion__c IN :tiposOperacion AND Detalle_Operacion__c IN :detallesOperacion ORDER BY AccountId, Tipo_Operacion__c, Detalle_Operacion__c, CreatedDate ASC];
		// AccountId => tipoOperacion => detalleOperacion => Número de reclamos actual
		Map<Id, Map<String, Map<String, Case[]>>> instanciaMap = new Map<Id, Map<String, Map<String, Case[]>>>();
		for (Case result : results) {
			Id accountId = result.AccountId;
			String tipoOperacion = result.Tipo_Operacion__c;
			String detalleOperacion = result.Detalle_Operacion__c;
			Map<String, Map<String, Case[]>> tipoOperacionMap = instanciaMap.get(accountId);
			if (tipoOperacionMap == null) {
				tipoOperacionMap = new Map<String, Map<String, Case[]>>();
				instanciaMap.put(accountId,tipoOperacionMap);
			}
			Map<String, Case[]> detalleOperacionMap = tipoOperacionMap.get(tipoOperacion);
			if (detalleOperacionMap == null) {
				detalleOperacionMap = new Map<String, Case[]>();
				tipoOperacionMap.put(tipoOperacion, detalleOperacionMap);
			}
			List<Case> cs = detalleOperacionMap.get(detalleOperacion);
			if (cs == null) {
				cs = new List<Case>();
				detalleOperacionMap.put(detalleOperacion, cs);
			}
			cs.add(result);
		}

		for (Case c : cases) {
			Id accountId = c.AccountId;
			String tipoOperacion = c.Tipo_Operacion__c;
			String detalleOperacion = c.Detalle_Operacion__c;
			Map<String, Map<String, Case[]>> tipoOperacionMap = instanciaMap.get(accountId);
			if (tipoOperacionMap == null) {
				tipoOperacionMap = new Map<String, Map<String, Case[]>>();
				instanciaMap.put(accountId,tipoOperacionMap);
			}
			Map<String, Case[]> detalleOperacionMap = tipoOperacionMap.get(tipoOperacion);
			if (detalleOperacionMap == null) {
				detalleOperacionMap = new Map<String, Case[]>();
				tipoOperacionMap.put(tipoOperacion, detalleOperacionMap);
			}
			List<Case> cs = detalleOperacionMap.get(detalleOperacion);
			if (cs == null) {
				cs = new List<Case>();
				detalleOperacionMap.put(detalleOperacion, cs);
			}
			cs.add(c);
			Integer cantidad = cs.size();
			if (cantidad == 1) {
			c.Instancia_del_Reclamo__c = 'Primera';
			c.Numero_de_Caso_Inicial__c = c.Id;
			c.Numero_de_Caso_Anterior__c = null;
			} else {
				Case primero = cs[0];
				c.Numero_de_Caso_Inicial__c = primero == null ? null : primero.Id;
				Case ultimo = cs[cantidad - 2];
				c.Numero_de_Caso_Anterior__c = ultimo == null ? null : ultimo.Id;
				Date fechaAnterior = ultimo.CreatedDate == null ? Date.today() : ultimo.CreatedDate.date();
				Integer dias = fechaAnterior.daysBetween(Date.today());
				if (DIAS_CORTE != null && dias > DIAS_CORTE)
					c.Instancia_del_Reclamo__c = 'Primera';
								else if (ultimo.Instancia_del_Reclamo__c == 'Primera')
					c.Instancia_del_Reclamo__c = 'Segunda';
				else if (ultimo.Instancia_del_Reclamo__c == 'Segunda' || ultimo.Instancia_del_Reclamo__c == 'Tercera o Más')
					c.Instancia_del_Reclamo__c = 'Tercera o Más';
					else
					c.Instancia_del_Reclamo__c = 'Primera'; // Nunca debería caer aquí
			}
		}


	}
    }