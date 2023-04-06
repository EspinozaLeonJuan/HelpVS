public class NewParticipanteEPAHandler implements TriggerHandler.HandlerInterface {
	//TODO: Revisar este handler porque está haciendo SELECT y upsert dentro del for.	
	public void handle() {

		List<Event> eventos = new List<Event>();
		for(Event evento : (Event[])Trigger.new)
			eventos.add(evento);

		String campana = 'Campaña EPA'; //EPA__c.getOrgDefaults().Campana_EPA__c; //// no hay defaults en api > 23
		Campana_Vida_Security__c campania = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = :campana limit 1];
		if(campania != null){
		List<Participantes_de_Campa_a__c> participantes = new List<Participantes_de_Campa_a__c>();
		for(Event evento : eventos){
			if(evento != null){
				if(evento.WhoId != null){
					if(evento.Visita_Finalizada__c == 'Si' && evento.Cliente_Molesto__c != 'Sí' && evento.Motivo_Visita__c != 'Visita Conjunta' && evento.Motivo_Visita__c != 'Suspendida' && evento.Contactar_a_Cliente__c == 'Si'){
						
						Contact contacto = [SELECT Id, Name FROM Contact WHERE Id =: evento.WhoId limit 1];
						Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c();
						Id epaRecordTypeId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('EPA').getRecordTypeId();
						
						participante.Name = 'EPA: ' + contacto.Name + ' / ' +evento.StartDateTime.addHours(-4).addMinutes(-30);	// Nombre Participante de Campaña
						participante.Campa_a_Vida_Security__c = campania.Id;								// Campaña Vida Security
						participante.Fecha_y_Hora_Reunion__c = evento.StartDateTime;			  // Fecha y Hora Reunión
						participante.Comuna__c = evento.Comuna__c;											    // Comuna
						participante.Contacto__c = evento.WhoId;											      // Nombre del Cliente - Contacto
						participante.Motivo_Visita__c = evento.Motivo_Visita__c;						// Motivo Visita
						participante.Visita_Finalizada__c = evento.Visita_Finalizada__c;		// Visita Finalizada
						participante.Nombre_de_Contacto__c = contacto.Name;
						participante.RecordTypeId = epaRecordTypeId;
						participante.OwnerId = evento.OwnerId;
						
						upsert participante participante.Name;
						
						participantes.add(participante);
					}
				}else{
					TriggerHandler.addError('Debe ingresar un contacto, además asegurese que el contacto sea correcto.', evento);
				}
			}
		}
	}
		
	}
}