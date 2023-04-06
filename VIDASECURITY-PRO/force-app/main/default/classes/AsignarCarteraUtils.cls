public class AsignarCarteraUtils {
	
	private static final String TODAS_LAS_CATEGORIAS = 'Todas';
	
	private class AsignarCarteraException extends Exception {}
	private static Integer remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
    private static Integer upperBound = Math.min(remainingRows, 1000);
	private static final Map<Id, User> postVentaMap = new Map<Id, User>([SELECT Id, Username, Categoria_de_Ejecutivo__c, Codigo_Sucursal__c, Name, Factor_de_Ejecutivo__c FROM User WHERE IsActive = true AND Ejecutivo_de_Cliente__c = true AND Omitir_asignacion_AMAC__c = false LIMIT :upperBound]);
	public static final Map<Id, User> allUserMap = new Map<Id, User>([SELECT Id, Username, Categoria_de_Ejecutivo__c, Codigo_Sucursal__c, Name, Factor_de_Ejecutivo__c FROM User LIMIT :upperBound]);
	
	private static void addError(String message) {
		//if (Test.isRunningTest())
			//throw new AsignarCarteraException(message);
		
		if (System.currentPageReference() == null)
		System.debug(message);
		else
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, message));
	}
	
	// Retorna Map<SucursalId, Map<Idcategoria, User[]>>
	private static Map<Id, Map<String, User[]>> getUsuariosDeSucursal() {
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
    	upperBound = Math.min(remainingRows, 1000);
		Sucursal__c[] sucursales = [SELECT Id, Codigo_Sucursal__c, Name FROM Sucursal__c LIMIT :upperBound];
		Map<String, Sucursal__c> sucursalMap = new Map<String, Sucursal__c>();
		for (Sucursal__c sucursal : sucursales) {
			sucursalMap.put(sucursal.Codigo_Sucursal__c, sucursal);
		}
		
		// Mapa de usuarios sucrsalId => categoriaEjecutivo => Usuarios
		Map<Id, Map<String, User[]>> userMap = new Map<Id, Map<String, User[]>>();
		for (User user : postVentaMap.values()) {
			Sucursal__c sucursal = sucursalMap.get(user.Codigo_Sucursal__c);
			if (sucursal == null) {
				addError('La sucursal con código ' + user.Codigo_Sucursal__c + ' especificada en el usuario ' + user.Name + ' no existe. Por favor registre una sucursal con dicho código o corrija el código de sucursal en el usuario.');
				continue;
			}
			Map<String, User[]> sucursal2Map = userMap.get(sucursal.Id);
			if (sucursal2Map == null) {
				sucursal2Map = new Map<String, User[]>();
				userMap.put(sucursal.Id, sucursal2Map);
			}
			String[] categorias =new List<String> {user.Categoria_de_Ejecutivo__c};
			if (user.Categoria_de_Ejecutivo__c == 'Todas')
				categorias = new List<String> {'Prime', 'Preferente', 'Clientes', 'Todas'};
				for (String categoria : categorias) { 
				User[] users = sucursal2Map.get(categoria);
				if (users == null) {
					users = new List<User>();
									sucursal2Map.put(categoria, users);
				}
				users.add(user);
			}
		}
		//--- Fin de llenado de mapa de usuarios
		return userMap;
	}
	
	public static Map<Id, AsignacionDeEjecutivo> obtenerEjecutivos(Account[] accounts) {
		List<Id> accountIds = new List<Id>();
		for (Account account : accounts) {
			accountIds.add(account.Id);
		}
		return obtenerEjecutivos(accountIds);
	}
	
	public static Map<Id, AsignacionDeEjecutivo> obtenerEjecutivos(Id[] accountIds) {
		Map<Id, AsignacionDeEjecutivo> asignacionMap = new Map<Id, AsignacionDeEjecutivo>();
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
        upperBound = Math.min(remainingRows, 1000);
		try {
			Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Relacion_de_Categoria__c, Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c, Relacion_de_Categoria__r.Categoria_de_Cliente__c, Relacion_de_Categoria__r.Sucursal__c, Relacion_de_Categoria__r.Sucursal__r.Name, Sucursal_Asignada__c, Sucursal_Asignada__r.Sucursal__c, Sucursal_Asignada__r.Sucursal__r.Name, Peso_de_Cuenta__c, Categoria_del_Cliente__r.Name, Ciudad_Particular_B__r.Name, Categoria_del_Cliente__c, Ciudad_Particular_B__c, OwnerId, Name, FirstName, LastName FROM Account WHERE Id IN :accountIds LIMIT :upperBound]);
			remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
        	upperBound = Math.min(remainingRows, 1000);
			Map<Id, Ciudad__c> cityMap = new Map<Id, Ciudad__c>([SELECT Id, Name FROM Ciudad__c LIMIT :upperBound]);
						Map<Id, Map<String, User[]>> userMap = getUsuariosDeSucursal();
			for (Id accountId : accountMap.keySet()) {
				Account account = accountMap.get(accountId);
								AsignacionDeEjecutivo asignacion = new AsignacionDeEjecutivo(account);
				asignacionMap.put(accountId, asignacion);
				if (account.Ciudad_Particular_B__c == null) {
					addError('El cliente ' + account.Name + ' no ha especificado Ciudad Particular, por lo que no es posible inferir sus ejecutivos.');
					continue;
				}
				if (account.Categoria_del_Cliente__c == null) { 
					addError('No se ha especificado la categoria del cliente para ' + account.Name);
					continue;
				}
				if (account.Relacion_de_Categoria__c == null || account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c == null) {
					addError('No se ha especificado una relación de categoría para el cliente ' + account.Name + ' por lo que no es posible inferir sus ejecutivos.');
					continue;
				}
				if (account.Sucursal_Asignada__c == null || account.Sucursal_Asignada__r.Sucursal__c == null) {
					addError('No se ha asignado una sucursal al cliente ' + account.Name + ', por lo que no es posible inferir sus ejecutivos.');
					continue;
				}
		Map<String, User[]> categoriaMap = userMap.get(account.Sucursal_Asignada__r.Sucursal__c);
		if (categoriaMap == null) {
			addError('No se encontró la sucursal ' + account.Sucursal_Asignada__r.Sucursal__r.Name + ' en el mapa de sucursales' + accountIds);
			continue;
		}
					
		User[] ejecutivos = categoriaMap.get(account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c);
		asignacion.addEjecutivos(ejecutivos);
								asignacion.calcularPorcentajes();
				asignacion.ejecutivos.sort();
							}
		} catch(Exception e){
			addError(e.getMessage());
		}
		
		return asignacionMap;

	}
	
	public static void proponerAsignacion(Map<Id, AsignacionDeEjecutivo> asignacionMap) {
		Set<Id> accountIds = asignacionMap.keySet();
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
        upperBound = Math.min(remainingRows, 1000);
		AggregateResult[] results = [SELECT COUNT(Id) Cantidad, Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c CategoriaEjecutivo, Sucursal_Asignada__r.Sucursal__c Sucursal FROM Account WHERE Id = :accountIds AND Relacion_de_Categoria__c <> NULL AND Sucursal_Asignada__c <> NULL GROUP BY Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c, Sucursal_Asignada__r.Sucursal__c LIMIT :upperBound];
				// sucursalId => CategoriaId => Cantidad de cuentas
		Map<Id, Map<String, Decimal>> cantidadMap = new Map<Id, Map<String, Decimal>>();
		for (AggregateResult result : results) {
			Id sucursalId = (Id)result.get('Sucursal');
			String categoriaId = (String)result.get('CategoriaEjecutivo');
			Decimal cantidad = (Decimal)result.get('Cantidad');
			Map<String, Decimal> sucursalMap = cantidadMap.get(sucursalId);
			if (sucursalMap == null) {
				sucursalMap = new Map<String, Decimal>();
				cantidadMap.put(sucursalId, sucursalMap);
			}
			if (!sucursalMap.containsKey(categoriaId))
				sucursalMap.put(categoriaId, cantidad);
		}
		
		// Calculo de totales para porcentajes
		for (AsignacionDeEjecutivo asignacion : asignacionMap.values()) {
			//Asignamos el total a cada asignacion
			Account account = asignacion.cuenta;
			System.assertNotEquals(null, account, 'La cuenta registrada en la asignacion es nula');
			if (account.Ciudad_Particular_B__c == null) {
				addError('La ciudad particular de la cuenta de ' + account.Name + ' no se ha establecido, por lo tanto no es posible proponer asignaciones.');
				continue;
			}
			if (account.Sucursal_Asignada__c == null || account.Sucursal_Asignada__r.Sucursal__c == null) {
				addError('No se ha asignado una sucursal para ' + account.Name + ', por lo tanto no es posible proponer asignaciones de ejecutivos. Verifique que la cuenta tenga asignada una ciudad particular y que la ciudad tenga asociada sucursales vigentes, posteriormente vaya a la cuenta y asigne la sucursal correspondiente al campo Sucursal Asignada.');
				continue;
			}
			Map<String, Decimal> sucursalMap = cantidadMap.get(account.Sucursal_Asignada__r.Sucursal__c);
			System.assertNotEquals(null, sucursalMap, 'El mapa de sucursales es nulo para la sucursal: ' + account.Sucursal_Asignada__r.Sucursal__r.Name);
			if (account.Categoria_del_Cliente__c == null) {
				addError('No se ha establecido la categoria del cliente ' + account.Name);
				continue;
			}
			if (account.Relacion_de_Categoria__c == null || account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c == null) {
				addError('El campo relacion de categoria no se ha especificado para la cuenta ' + account.Name + ', este campo se establece automáticamente en función de la ciudad particular del cliente y su categoría. Verifique que la configuración de relación de categoría exista para los clientes con categoria ' + account.Categoria_del_Cliente__r.Name + ' y sucursal ' + account.Sucursal_Asignada__r.Sucursal__r.Name + ' y luego actualice la cuenta para establecer este campo.');
				continue;
			}
			Decimal cantidad = sucursalMap.get(account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c);
			asignacion.setTotalDeClientes(cantidad);
		}
		
							//Asignación
		ReporteDeAsignacion.newInstance();
		ReporteDeAsignacion.addHeaders();
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
        upperBound = Math.min(remainingRows, 1000);
		Account[] accounts = [SELECT Id, Name, Ciudad_Particular_B__c, Ciudad_Particular_B__r.Name, Categoria_del_Cliente__c, Categoria_del_Cliente__r.Name, Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c, Sucursal_Asignada__r.Sucursal__c FROM Account WHERE Id IN :accountIds ORDER BY Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c, Sucursal_Asignada__r.Sucursal__r.Name, Peso_de_Cuenta__c LIMIT :upperBound];
		Id sucursalId = null;
		String categoriaId = null;
		Integer index = 0;
		for (Account account : accounts) {
			AsignacionDeEjecutivo asignacion = asignacionMap.get(account.Id);
			System.assertNotEquals(null, asignacion, 'La asignación no se ha establecido para la cuenta: ' + account.Id);
			Ejecutivo[] ejecutivos = asignacion.ejecutivos;
			if (ejecutivos == null || ejecutivos.isEmpty())
				continue;
			if (categoriaId != account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c || sucursalId != account.Sucursal_Asignada__r.Sucursal__c)
				index = 0;
				categoriaId = account.Relacion_de_Categoria__r.Categoria_de_Ejecutivo__c;
				sucursalId = account.Sucursal_Asignada__r.Sucursal__c;
			while (index < ejecutivos.size()) {
				Ejecutivo ejecutivo = ejecutivos[index];
				System.assertNotEquals(null, asignacion, 'La asignacion no puede ser null');
				System.assertNotEquals(null, ejecutivo, 'El ejecutivo es null');
				Boolean asignado = asignacion.asignar(ejecutivo);
				System.assertNotEquals(null, asignado, 'Asignado no puede ser null');
				if (asignado) {
					System.assertNotEquals(null, asignacion.ejecutivoAsignado, 'El ejecutivo asignado no puede ser null si fue asignado satisfactoriamente.');
					break;
				}
				index++;
			}
			if (index >= ejecutivos.size()) {
				Ejecutivo ejecutivo = ejecutivos[ejecutivos.size() - 1];
				System.assertNotEquals(null, ejecutivo, 'No puede asignarse un ejecutivo null');
				if (!asignacion.asignar(ejecutivo, true))
				addError('No fue posible asignar forzadamente el ejecutivo ' + ejecutivo.usuario.Name + ' a la cuenta ' + account.Name);
			}
			//System.assertNotEquals(null, asignacion.ejecutivoAsignado, 'No se asigno el ejecutivo a la cuenta ' + account.Name);
		}
		ReporteDeAsignacion.save();
			}
	
	// AsignarCarteraUtils.reporteAsignacionCarteraDesvinculada();
			public static void reporteAsignacionCarteraDesvinculada() {
		List<Id> accountIds = new List<Id>();
		remainingRows = Limits.getLimitQueryRows() - Limits.getQueryRows();	
        upperBound = Math.min(remainingRows, 1000);
		Account[] accounts = [SELECT Id FROM Account WHERE Cliente_Fidelizado__c = false AND (Agente_Actual__c = NULL OR Agente_Actual__r.Estado__c = 'Desvinculado' OR Agente_Actual__r.Estado__c = 'Cambio de Cargo') AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) AND Id IN (Select Cuenta__c From Poliza__c Where RecordType.Name = 'Individuales' And Estatus__c = 'ACTIVA' AND Cantidad_de_Meses_Sin_Pago__c <= 3) order by Categoria_del_Cliente__r.Name asc LIMIT :upperBound];
		for (Account account : accounts) {
			accountIds.add(account.Id);
		}
		Map<Id, AsignacionDeEjecutivo> asignacionMap = AsignarCarteraUtils.obtenerEjecutivos(accountIds);
		//System.debug();
		AsignarCarteraUtils.proponerAsignacion(asignacionMap);
	}
	}