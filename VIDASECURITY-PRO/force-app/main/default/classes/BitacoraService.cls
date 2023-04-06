public with sharing class BitacoraService {
	
	public static void registrarEventos(Bitacora[] bitacoras) {
        system.debug('@@@@ BitacoraService.registrarEventos in [] --> '+ bitacoras);
        
		List<Bitacora__c> sObjectBitacoras = new List<Bitacora__c>();
		for (Bitacora bitacora : bitacoras) {
            system.debug('@@@@ bitacora.getSObject() --> '+ bitacora.getSObject());
			sObjectBitacoras.add(bitacora.getSObject());
		}
        system.debug('@@@@ sObjectBitacoras --> '+ sObjectBitacoras);
		insert sObjectBitacoras;
	}
	
	
	/**
	* Este método actualiza el arreglo de sobjects y el resultado lo registra en la bitácora con el Id asociado.
	*/
	public static void actualizaYRegistraEventos(Map<Id, Bitacora> bitacoraMap, SObject[] sobjects) {
		System.debug('BitacoraService.actualizaYRegistraEventos - BEGIN');
		Database.SaveResult[] results = null;
		if (!PageUtils.hasErrors()) 
				results = Database.update(sobjects, false);
		registrarEventos(bitacoraMap, results);
	}
	
	
	/**
	* Este método recibe un mapa que tiene como llave el Id del objeto que se está actualizando, como valor la instancia de bitacora asociada
	* El segúndo parámetro es el arreglo de resultados de la actualización Database.update
	*/
	public static void registrarEventos(Map<Id, Bitacora> bitacoraMap, Database.SaveResult[] results) {
		setResultados(bitacoraMap, results);
		registrarEventos(bitacoraMap.values());
	}

	public static void setResultados(Map<Id, Bitacora> bitacoraMap, Database.SaveResult[] results) {
		if (results == null)
			return;
		for(Database.SaveResult saveResult : results) {
			ID sobjectId = saveResult.getId();
			System.assertNotEquals(null, sobjectId, 'El id es null');
			Bitacora bitacora = bitacoraMap.get(sobjectId);
			if (bitacora == null)
				continue;
			//System.assertNotEquals(null, bitacora, 'No se encontró la bitacora en el mapa');
			bitacora.setResultado(saveResult);
		}
	}
	

	
}