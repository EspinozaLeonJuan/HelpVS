public with sharing class AsignaCorredoresAContactoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {

		Map<String, Corredor__c> mapCorredores = new Map<String, Corredor__c>();
		Set<Id> idsCorredores = new Set<Id>();
		Set<String> rutsCorredores = new Set<String>();

		if (Trigger.new != null) {

			for (Contact contacto : (Contact[])Trigger.new) {
				Contact contactoOld = (Contact)(Trigger.isUpdate ? Trigger.oldMap.get(contacto.Id) : null);

				if( (Trigger.isInsert && contacto.Empresa_Corredora__c != null) ||  (contactoOld!=null && contactoOld.Empresa_Corredora__c != contacto.Empresa_Corredora__c && contacto.Empresa_Corredora__c != null)){
					if(!idsCorredores.contains(contacto.Empresa_Corredora__c))
						idsCorredores.add(contacto.Empresa_Corredora__c);
					continue;
				}

				if (String.isNotBlank(contacto.Rut_Corredor__c) && !rutsCorredores.contains(contacto.Rut_Corredor__c))
					rutsCorredores.add(contacto.Rut_Corredor__c.toUpperCase());
			}

			List<Corredor__c> corredores = [Select Id, Rut__c From Corredor__c WHere Rut__c IN :rutsCorredores];
			Map<Id, Corredor__c> mapCorredoresById = new Map<ID, Corredor__c>([Select Id, Rut__c From Corredor__c Where Id IN :idsCorredores]);

			for (Corredor__c corredor : corredores) {
				if (!mapCorredores.containsKey(corredor.Rut__c.toUpperCase())) {
					mapCorredores.put(corredor.Rut__c.toUpperCase(), corredor);
				}
			}

			for (Contact contacto : (Contact[])Trigger.new) {
				Contact contactoOld = (Contact)(Trigger.isUpdate ? Trigger.oldMap.get(contacto.Id) : null);

				if( (Trigger.isInsert && contacto.Empresa_Corredora__c != null) ||  (contactoOld!=null && contactoOld.Empresa_Corredora__c != contacto.Empresa_Corredora__c && contacto.Empresa_Corredora__c != null)){
					
					if(mapCorredoresById.containsKey(contacto.Empresa_Corredora__c))
						contacto.Rut_Corredor__c = mapCorredoresById.get(contacto.Empresa_Corredora__c).Rut__c;
					continue;
				}

				if (String.isNotBlank(contacto.Rut_Corredor__c) && mapCorredores.containsKey(contacto.Rut_Corredor__c.toUpperCase()))
					contacto.Empresa_Corredora__c =  mapCorredores.get(contacto.Rut_Corredor__c.toUpperCase()).Id;
			}

		}

	}
}