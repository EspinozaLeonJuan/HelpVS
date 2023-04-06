public class ActualizaFechaUltimaLlamadaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
        String recordTypeOnco = [SELECT Id FROM RecordType WHERE Name = 'Ventas Oncológico'].Id;
        
        List<Account> cuentasUpdate = new List<Account>();
    	Map<Id,Account> cuentasUpdateMap = new Map<Id,Account>();
        
        List<Id> cuentasIds = new List<Id>();
        for(Task t : (List<Task>)Trigger.new){
            cuentasIds.add(t.AccountId);
        }
		Map<Id, Account> cuentasMap = new Map<Id, Account>([SELECT Id, Fecha_ltima_Llamada__c FROM Account WHERE Id in: cuentasIds]);
        
		for(Id cNew : Trigger.newMap.keySet()) {
            Task t = (Task)Trigger.newMap.get(cNew);            
            if (t.RecordTypeId != recordTypeOnco && t.Fecha_de_Llamada__c != null && t.AccountId != null){				   
				Account a = cuentasMap.get(t.AccountId);                
                if(!cuentasUpdateMap.containsKey(a.Id) || cuentasUpdateMap.get(a.Id).Fecha_ltima_Llamada__c <= t.Fecha_de_Llamada__c){
                    a.Fecha_ltima_Llamada__c = t.Fecha_de_Llamada__c;
                	cuentasUpdateMap.put(a.Id, a);
                }                            
            }
		}
        if(cuentasUpdateMap.Values().size() > 0){
			cuentasUpdate.addAll(cuentasUpdateMap.Values());
			update cuentasUpdate;
    	}
	}
}

/*
List<Account> cuentasUpdate = new List<Account>();
    
		for( Id cNew : Trigger.newMap.keySet() ) {
			Task t = (Task)Trigger.newMap.get(cNew);
            String recordTypeOnco = [SELECT Id FROM RecordType WHERE Name = 'Ventas Oncológico'].Id;
            if (t.RecordTypeId != recordTypeOnco){
                if (t.Fecha_de_Llamada__c != null) {
                	if (t.AccountId != null){
                        Account a = [select Id from Account where Id =: t.AccountId limit 1];                        
                        a.Fecha_ltima_Llamada__c = t.Fecha_de_Llamada__c;
                        cuentasUpdate.add(a);
                    }
                }
            }
		}
        for(Account a : cuentasUpdate){
            System.debug('@@@@' + a.Id + ' / ' + a.Fecha_ltima_Llamada__c);
        }
			update cuentasUpdate;
*/