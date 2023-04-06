public class AsignaCorredoresAPolizaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		
		Map<String, Corredor__c> mapCorredores = new Map<String, Corredor__c>();
		Set<Id> idsCorredores = new Set<Id>();
		Set<String> rutsCorredores = new Set<String>();
		
		if (Trigger.new != null) {
			
			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c polizaOld = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);
				
				if( (Trigger.isInsert && poliza.Corredor__c != null) ||  (polizaOld!=null && polizaOld.Corredor__c != poliza.Corredor__c && poliza.Corredor__c!=null)){
					if(!idsCorredores.contains(poliza.Corredor__c))
						idsCorredores.add(poliza.Corredor__c);
					continue;
				}

				if (String.isNotBlank(poliza.Rut_Corredor__c) && !rutsCorredores.contains(poliza.Rut_Corredor__c))
					rutsCorredores.add(poliza.Rut_Corredor__c.toUpperCase());
			}

			List<Corredor__c> corredores = [Select Id, Rut__c From Corredor__c WHere Rut__c IN :rutsCorredores];
			Map<Id, Corredor__c> mapCorredoresById = new Map<ID, Corredor__c>([Select Id, Rut__c From Corredor__c Where Id IN :idsCorredores]);
			
			for(Corredor__c corredor: corredores){
				if(!mapCorredores.containsKey(corredor.Rut__c.toUpperCase())){
					mapCorredores.put(corredor.Rut__c.toUpperCase(), corredor);
				}
			}

			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c polizaOld = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);

				if( (Trigger.isInsert && poliza.Corredor__c != null) ||  (polizaOld!=null && polizaOld.Corredor__c != poliza.Corredor__c && poliza.Corredor__c !=null)){

					if(mapCorredoresById.containsKey(poliza.Corredor__c))
						poliza.Rut_Corredor__c = mapCorredoresById.get(poliza.Corredor__c).Rut__c;
					continue;
				}

				if (String.isNotBlank(poliza.Rut_Corredor__c) && mapCorredores.containsKey(poliza.Rut_Corredor__c.toUpperCase())){
					poliza.Corredor__c =  mapCorredores.get(poliza.Rut_Corredor__c.toUpperCase()).Id;
				}
			}

		}

	}
}