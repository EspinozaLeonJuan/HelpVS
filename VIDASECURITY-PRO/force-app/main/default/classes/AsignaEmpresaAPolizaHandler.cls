public class AsignaEmpresaAPolizaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {
		
		Map<String, Account> mapEmpresas = new Map<String, Account>();
		Set<Id> idsEmpresas = new Set<Id>();
		Set<String> rutsEmpresas = new Set<String>();

		if (Trigger.new != null) {
			
			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c polizaOld = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);

				if( (Trigger.isInsert && poliza.Cuenta__c != null) ||  (polizaOld!=null && polizaOld.Cuenta__c != poliza.Cuenta__c && poliza.Cuenta__c!=null)){
					if(!idsEmpresas.contains(poliza.Cuenta__c))
						idsEmpresas.add(poliza.Cuenta__c);
					continue;
				}

				if (String.isNotBlank(poliza.Rut_Empresa__c) && !rutsEmpresas.contains(poliza.Rut_Empresa__c))
					rutsEmpresas.add(poliza.Rut_Empresa__c.toUpperCase());
			}

			List<Account> empresas = [Select Id, Rut__c From Account WHere Rut__c IN :rutsEmpresas and RecordType.Name = 'Cuenta Corporativa'];
			Map<Id, Account> mapCuentasById = new Map<ID, Account>([Select Id, Rut__c From Account Where Id IN :idsEmpresas and RecordType.Name = 'Cuenta Corporativa']);

			
			for(Account empresa: empresas){
				if(!mapEmpresas.containsKey(empresa.Rut__c.toUpperCase())){
					mapEmpresas.put(empresa.Rut__c.toUpperCase(), empresa);
				}
			}

			for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
				Poliza__c polizaOld = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);

				if( (Trigger.isInsert && poliza.Cuenta__c != null) ||  (polizaOld!=null && polizaOld.Cuenta__c != poliza.Cuenta__c && poliza.Cuenta__c!=null)){
					if(mapCuentasById.containsKey(poliza.Cuenta__c))
						poliza.RUT_Empresa__c = mapCuentasById.get(poliza.Cuenta__c).Rut__c;
					continue;
				}
				
				if (String.isNotBlank(poliza.Rut_Empresa__c) && mapEmpresas.containsKey(poliza.Rut_Empresa__c.toUpperCase()))
					poliza.Cuenta__c =  mapEmpresas.get(poliza.Rut_Empresa__c.toUpperCase()).Id;
			}

		}

	}
}