public class AsignaSupervisorAContactoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		
		Set<String> ruts = new Set<String>();
		for (Contact contact : (Contact[])Trigger.new) {
			Contact old = (Contact)(Trigger.isUpdate ? Trigger.oldMap.get(contact.Id) : null);
			if (contact.Rut_Supervisor__c != null && contact.ReportsToId == null && !ruts.contains(contact.Rut_Supervisor__c))
			ruts.add(contact.Rut_Supervisor__c);
		}
		if (ruts.isEmpty())
			return;
		
		Contact[] contacts = [SELECT Id, Rut__c FROM Contact WHERE Rut__c IN :ruts AND Rut__c <> NULL];
		Map<String, Contact> contactMap = new Map<String, Contact>();
		for (Contact contact : contacts)
			contactMap.put(contact.Rut__c, contact);
			
		for (Contact contact : (Contact[])Trigger.new) {
			Contact supervisor = contactMap.get(contact.Rut_Supervisor__c);
			if (supervisor != null)
			contact.ReportsToId = supervisor.Id;
		}
	}
    
}