public class RutEventHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		List<Id> eventosIds = new List<Id>();
		for(Event evento : (Event[])Trigger.new){
			eventosIds.add(evento.WhoId);
		}
	
		Map<Id, String> mapaRut = new Map<Id, String>();
		Map<Id, String> mapaDigito = new Map<Id, String>();
	
		List<Contact> contactos = [SELECT Id, Account.Rut__c, Account.DV__c FROM Contact WHERE Id IN :eventosIds];
	
		if(contactos.size() > 0){
			for(Contact contacto : contactos){
				mapaRut.put(contacto.Id, contacto.Account.Rut__c);
				mapaDigito.put(contacto.Id, contacto.Account.DV__c);
			}
			for(Event evento : (Event[])Trigger.new) {
				evento.Rut__c = mapaRut.get(evento.WhoId) + '-' + mapaDigito.get(evento.WhoId);
			}
		}
	}
}