public with sharing class RevisionCartasReclamosHandler implements TriggerHandler.HandlerInterface {

	public void handle(){
		Set<Case> casos = New Set<Case>();

		for (Case c : (Case[]) Trigger.New) {
				if (c.Entrega_Respuesta__c && Schema.SObjectType.Case.getRecordTypeInfosById().get(c.RecordTypeId).getname() == 'Reclamos' && c.Origin != 'Servicios Colectivos' && c.Canal__c != 'Servicios Colectivos') {
						casos.add(c);
				}
		}

		Map<Id, Attachment> mapAdjuntos = New Map<Id, Attachment>([Select Id, ParentId, Name from Attachment where ParentId in :casos]);

		for (Case c : casos) {

				Boolean tieneCartaClienteCheck = false;
				//Boolean tieneAdjuntoCartaRespuesta = false;
				Boolean tieneAdjuntoCartaCliente = false;

				for (Attachment a : mapAdjuntos.values()) {

						// Val 1: Carta respuesta reclamo ejecutiva
						/*if ( a.ParentId == c.Id && a.Name.StartsWithIgnoreCase('RESPUESTA') ){
								tieneAdjuntoCartaRespuesta = true;
								continue;
						} */

						// Val 2: Carta reclamo cliente
						if ( a.ParentId == c.Id && a.Name.StartsWithIgnoreCase('CARTACLIENTE') ) {
								tieneAdjuntoCartaCliente = true;
								continue;
						}

						if (a.ParentId == c.Id && c.Carta_Cliente__c){
							tieneCartaClienteCheck = true;
							continue;
						}
				}
				// Si el caso no tiene carta de respuesta.
			/*	if (!tieneAdjuntoCartaRespuesta){
					c.addError('No se ha adjuntado la carta de respuesta, no se puede cerrar el reclamo. El nombre del archivo debe empezar por \'Respuesta\'.');
					continue;
				}*/
				// Si el caso tiene adjunto carta cliente pero no tiene la casilla Carta Cliente seleccionada.
				if (tieneAdjuntoCartaCliente && !c.Carta_Cliente__c){
					c.addError('No ha seleccionado la casilla \'Carta Cliente\', no se puede cerrar el caso.');
					continue;
				}
				// Si el caso NO tiene adjunto carta cliente y tiene la casilla Carta Cliente seleccionada.
				if (!tieneAdjuntoCartaCliente && c.Carta_Cliente__c){
					c.addError('No se ha adjuntado la carta del cliente, no se puede cerrar el reclamo. El nombre del archivo debe empezar por \'CartaCliente\'.');
					continue;
				}
		}
	}

}