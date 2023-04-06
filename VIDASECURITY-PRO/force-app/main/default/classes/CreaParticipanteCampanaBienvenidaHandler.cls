public class CreaParticipanteCampanaBienvenidaHandler implements TriggerHandler.HandlerInterface {

	public void handle() {

		Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		Date hoy = Date.today();

	    if (!ControlTest.CreaParticipanteCampanaBienvenida && Test.isRunningTest())
			return;

		if (!Trigger.isInsert) 
			return;
		// Campañas
		Map<String, Campana_Vida_Security__c> campaignMap = new Map<String, Campana_Vida_Security__c>();
		Set<Id> accountIds = new Set<Id>();
		Set<Id> polizaIds = new Set<Id>();
		for (Poliza__c poliza : (Poliza__c[])Trigger.new) {

			if (poliza.Fecha_Entrega_de_la_Poliza__c == null)
				continue;
			if (poliza.Cuenta__c == null) {
				poliza.Cuenta__c.addError('La cuenta es obligatoria.');
				continue;
			}
			// Sanatorio alemán no genera campaña bienvenida
			if (string.isNotBlank(poliza.Nombre_de_Producto__c) && (poliza.Nombre_de_Producto__c.containsIgnoreCase('Cruz Sanatorio') || poliza.Nombre_de_Producto__c.containsIgnoreCase('Sanatorio Alem')))
				continue;


			if(poliza.RecordTypeId != recordTypeIndividuales)
				continue;

			if(poliza.Fecha_Inicio_de_Poliza__c == null ||  poliza.Fecha_Inicio_de_Poliza__c.addDays(30) < hoy)				
				continue;

			String campaignName = 'Bienvenida_' + DateTime.newInstance(poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(1), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
			if (!campaignMap.containsKey(campaignName)) {
				Date inicio = poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(1).toStartOfMonth();
				Date fin = poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(2).toStartOfMonth().addDays(-1);
				campaignMap.put(campaignName, new Campana_Vida_Security__c(Name = campaignName, Descripcion__c = 'Campaña de Bienvenida', Tipo_de_Campa_a__c = 'Bienvenida', Fecha_Inicio_de_Campa_a__c = inicio, Fecha_de_Termino_de_Campa_a__c = fin));
			}
			if (!accountIds.contains(poliza.Cuenta__c)) {
				accountIds.add(poliza.Cuenta__c);
			if (!polizaIds.contains(poliza.Id))
				polizaIds.add(poliza.Id);
			}
		}

		if (campaignMap.isEmpty()) return;

		upsert campaignMap.values() Campana_Vida_Security__c.Name;

		Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE Id IN :accountIds]);
		Participantes_de_Campa_a__c[] members = [SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c FROM Participantes_de_Campa_a__c WHERE Contacto__r.AccountId IN :accountIds AND Poliza__c IN :polizaIds FOR UPDATE];
		Map<String, Participantes_de_Campa_a__c> currentMemberMap = new Map<String, Participantes_de_Campa_a__c>();
		for (Participantes_de_Campa_a__c member : members) {
			currentMemberMap.put(String.valueOf(member.Contacto__c) + '|' + String.valueOf(member.Poliza__c), member);
		}
		// Participantes de Campaña
		Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Bienvenida').getRecordTypeId();
		

		for (Id polizaId : polizaIds) {
			Poliza__c poliza = (Poliza__c) Trigger.newMap.get(polizaId);
			Account account = accountMap.get(poliza.Cuenta__c);
			if (account == null || !account.isPersonAccount) continue;
			String campaignName = 'Bienvenida_' + DateTime.newInstance(poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(1), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
			Campana_Vida_Security__c campana = campaignMap.get(campaignName);
			if (campana == null) {
				poliza.addError('La Campaña Vida Security ' + campaignName + ' no existe.');
				continue;
			}
			String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
			if (currentMemberMap.containsKey(key)) continue;

			Participantes_de_Campa_a__c participante = new Participantes_de_Campa_a__c(
				Name = 'BIENVENIDA: ' + DateTime.newInstance(poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(1), Time.newInstance(0, 0, 0, 0)).format('MMyyyy')+ ' ' + account.Name,
				Campa_a_Vida_Security__c = campana.Id,
				Contacto__c = account.PersonContactId,
				Contactado__c = 'No',
				Estado_Cierre__c= 'Abierto',
				Nombre_de_Contacto__c = account.Name,
				Poliza__c = poliza.Id,
				OwnerId = account.OwnerId,
				Cuenta__c = account.Id,
				RecordTypeId = recordId);
			currentMemberMap.put(key, participante);
			members.add(participante);
		}
		upsert members;
	// Pólizas de participantes de campaña
	List<Poliza_de_Participante_de_Campana__c> ppcs = new List<Poliza_de_Participante_de_Campana__c>();
	for (Id polizaId : polizaIds) {
		Poliza__c poliza = (Poliza__c) Trigger.newMap.get(polizaId);	
		Account account = accountMap.get(poliza.Cuenta__c);
		if (account == null || !account.IsPersonAccount)
		continue;
		String campaignName = 'Bienvenida_' + DateTime.newInstance(poliza.Fecha_Entrega_de_la_Poliza__c.addMonths(1), Time.newInstance(0, 0, 0, 0)).format('MMyyyy');
		Campana_Vida_Security__c campana = campaignMap.get(campaignName);
		if (campana == null)
			continue;
		String key = String.valueOf(account.PersonContactId) + '|' + String.valueOf(poliza.Id);
		Participantes_de_Campa_a__c participante = currentMemberMap.get(key);
		String codigo = String.valueOf(campana.Id) + String.valueOf(account.PersonContactId) + String.valueOf(poliza.Id);
		Poliza_de_Participante_de_Campana__c ppc = new Poliza_de_Participante_de_Campana__c(Codigo__c = codigo, Poliza__c = poliza.Id, Participante_de_Campana__c = participante.Id);
		ppcs.add(ppc);
	}
	if (!ppcs.isEmpty())
		upsert ppcs Poliza_de_Participante_de_Campana__c.Codigo__c;
	}
}