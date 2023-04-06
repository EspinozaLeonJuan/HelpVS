public class ReasignarCasoPorCreacionCuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		List<Case> CasosList= new List<Case>();
		List<Integer> RutsCuentas = new List<Integer>();
    
		for (Account a : (Account[])Trigger.new) {
			if (a.IsPersonAccount && a.Rut__c != null){  
				if (Integer.valueOf(a.Rut__c) != 0){// rut 0 es el valor por defecto de Reasignar_a_Rut__c, por lo mismo se omite
					RutsCuentas.add(Integer.ValueOf(a.Rut__c.replace('.', '')));
				}
			}
		}
    
		List<Case> CasosAReasignar = [select id, Reasignar_a_Rut__c, LastModifiedDate, Account.Rut__c FROM Case WHERE Reasignar_a_Rut__c IN: RutsCuentas and Reasignar_a_Rut__c != 0 AND LastModifiedDate = TODAY FOR UPDATE];
    
		For(Account a: (Account[])Trigger.new){
			if (a.IsPersonAccount && a.Rut__c != null){
				if (Integer.valueOf(a.Rut__c) != 0) {
					for (Case ca: CasosAReasignar){
						if (ca.Reasignar_a_Rut__c == integer.ValueOf(a.Rut__c)) {
							ca.AccountId = a.Id;
							ca.Reasignar_a_Rut__c = null;
							CasosList.add(ca);
						}
					}
				}
			}
		}
		update CasosList;
	}
}