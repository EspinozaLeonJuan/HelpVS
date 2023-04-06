public class AsignarRelacionDeCategoriaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		Map<Id, Categoria_de_Cliente__c> categoriaClienteMap = new Map<Id, Categoria_de_Cliente__c>([SELECT Id, Name FROM Categoria_de_Cliente__c]);
		Map<Id, Ciudad__c> ciudadMap = new Map<Id, Ciudad__c>([SELECT Id, Name FROM Ciudad__c]);
		
		List<Id> categoriaIds = new List<Id>();
		List<Id> ciudadIds = new List<Id>();
		List<Account> accounts = new List<Account>();
		if (Trigger.new != null) {
			for (Account account : (Account[])Trigger.new) {
				Account old = (Account)(Trigger.oldMap!= null ? Trigger.oldMap.get(account.Id) : null);
				if (old == null || old.Ciudad_Particular_B__c != account.Ciudad_particular_B__c || old.Categoria_del_Cliente__c != account.Categoria_del_Cliente__c || account.Relacion_de_Categoria__c == null || account.Sucursal_Asignada__c == null) {
					if (account.Categoria_del_Cliente__c != null && !categoriaIds.contains(account.Categoria_del_Cliente__c))
						categoriaIds.add(account.Categoria_del_Cliente__c);
					if (account.Ciudad_particular_B__c != null && !ciudadIds.contains(account.Ciudad_Particular_B__c))
						ciudadIds.add(account.Ciudad_Particular_B__c);
						accounts.add(account);
				}
			}
		}
		if (ciudadIds.isEmpty())
			return;
		
		//TODO: Esta asignación de sucursal debería inckluir también la comuna!
		Ciudad_de_Sucursal__c[] ciudadSucursales = [SELECT Id, Ciudad__c, Sucursal__c, Ciudad__r.Name, Sucursal__r.Name FROM Ciudad_de_Sucursal__c];
		Map<Id, Ciudad_de_Sucursal__c> ciudadSucursalMap = new Map<Id, Ciudad_de_Sucursal__c>();
		List<Id> sucursalIds = new List<Id>();
		for (Ciudad_de_sucursal__c ciudadSucursal : ciudadSucursales) {
			ciudadSucursalMap.put(ciudadSucursal.Ciudad__c, ciudadSucursal);
			sucursalIds.add(ciudadSucursal.Sucursal__c);
		}
							
		Relacion_de_Categoria__c[] relaciones = [SELECT Id, Categoria_de_Cliente__c, Categoria_de_Ejecutivo__c, Sucursal__c FROM Relacion_de_Categoria__c WHERE Categoria_de_Cliente__c IN :categoriaIds AND Sucursal__c IN :sucursalIds AND Sucursal__c <> NULL AND Categoria_de_Cliente__c <> NULL];
		// sucursalId => categoriaId => relacion
		Map<Id, Map<Id, Relacion_de_Categoria__c>> relacionMap = new Map<Id, Map<Id, Relacion_de_Categoria__c>>();
		for (Relacion_de_Categoria__c relacion : relaciones) {
			Map<Id, Relacion_de_Categoria__c> categoriaMap = relacionMap.get(relacion.Sucursal__c);
			if (categoriaMap == null) {
				categoriaMap = new Map<Id, Relacion_de_Categoria__c>();
				relacionMap.put(relacion.Sucursal__c, categoriaMap);
			}
			categoriaMap.put(relacion.Categoria_de_Cliente__c, relacion);
		}
		
		System.debug('asignar relacion old');
		for (Account account : accounts) {
			Categoria_de_Cliente__c categoriaCliente = categoriaClienteMap.get(account.Categoria_del_Cliente__c);
			if (account.Ciudad_Particular_B__c == null) {
				if (account.Omitir_Validaciones_AMAC__c == null || account.Omitir_Validaciones_AMAC__c == false)
					account.Ciudad_Particular_B__c.addError('old, La ciudad particular es obligatoria para la cuenta con RUT: ' + account.RUT__c + ', Omitir Validaciones AMAC=' + account.Omitir_Validaciones_AMAC__c); account.Relacion_de_Categoria__c = null;				account.Sucursal_Asignada__c =null;				continue;
			}
			Ciudad_de_Sucursal__c sucursalAsignada = ciudadSucursalMap.get(account.Ciudad_Particular_B__c);
			if (sucursalAsignada == null) {
				Ciudad__c ciudad = ciudadMap.get(account.Ciudad_Particular_B__c);
								if (account.Omitir_Validaciones_AMAC__c == null || account.Omitir_Validaciones_AMAC__c == false)
					account.addError('old, No se han especificado sucursales para la ciudad ' + (ciudad == null ? account.Ciudad_Particular__c : ciudad.Name) + ', por favor comuníquese con el administrador del sistema para incluir un registro de Ciudad de Sucursal'); account.Relacion_de_Categoria__c = null; account.Sucursal_Asignada__c =null; continue;
							}
			account.Sucursal_Asignada__c = sucursalAsignada.Id;
			Map<Id, Relacion_de_Categoria__c> categoriaMap = relacionMap.get(sucursalAsignada.Sucursal__c);
			if (categoriaMap == null && account.Categoria_del_Cliente__c != null) {
				if (account.Omitir_Validaciones_AMAC__c == null || account.Omitir_Validaciones_AMAC__c == false)
				account.addError('old, No se ha especificado una relación de categoría para la sucursal ' + sucursalAsignada.Sucursal__r.Name + ' y categoría de cliente ' + (categoriaCliente == null ? (String)null : categoriaCliente.Name) + '. Por favor, comuníquese con el administrador del sistema.'); account.Relacion_de_Categoria__c = null; continue;
							}
			if (account.Categoria_del_Cliente__c == null) {
				account.Relacion_de_Categoria__c = null; continue;
			}
			Relacion_de_Categoria__c relacion = categoriaMap.get(account.Categoria_del_Cliente__c);
			if (relacion == null && account.Categoria_del_Cliente__c != null) {
				if (account.Omitir_Validaciones_AMAC__c == null || account.Omitir_Validaciones_AMAC__c == false)
					account.addError('old, No se ha especificado una relación de categoría para la sucursal ' + sucursalAsignada.Sucursal__r.Name + ' y la categoría de cliente ' + (categoriaCliente == null ? String.valueOf(account.Categoria_del_Cliente__c) : categoriaCliente.Name) + ', RUT CLIENTE: ' + account.RUT__c); account.Relacion_de_Categoria__c = null; continue;
							}
			account.Relacion_de_Categoria__c = relacion == null ? null : relacion.Id;
		}
	}
    }