public with sharing class AsignaEmpresaAAseguradoHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {

		Map<String, Account> mapCuentasEmpresa = new Map<String, Account>();
		Set<Id> idsEmpresas = new Set<Id>();
		Set<String> rutsEmpresas = new Set<String>();
		Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');

		if (Trigger.new != null) {

			for (Account cuenta : (Account[])Trigger.new) {
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( (Trigger.isInsert && cuenta.Cuenta_Corporativa__c != null) ||  (cuentaOld!=null && cuentaOld.Cuenta_Corporativa__c != cuenta.Cuenta_Corporativa__c && cuenta.Cuenta_Corporativa__c!= null)){
					if(!idsEmpresas.contains(cuenta.Cuenta_Corporativa__c))
						idsEmpresas.add(cuenta.Cuenta_Corporativa__c);
					continue;
				}

				if (String.isNotBlank(cuenta.RUT_Empresa__c) && !rutsEmpresas.contains(cuenta.RUT_Empresa__c) && cuenta.RecordTypeId == recordTypeCuentaPersonal )
					rutsEmpresas.add(cuenta.RUT_Empresa__c.toUpperCase());
			}

			List<Account> empresas = [Select Id, Rut__c From Account WHere Rut__c IN :rutsEmpresas and RecordType.Name = 'Cuenta Corporativa'];
			Map<Id, Account> mapCuentasById = new Map<ID, Account>([Select Id, Rut__c From Account Where Id IN :idsEmpresas and RecordType.Name = 'Cuenta Corporativa']);

			for (Account cuenta : empresas) {
				if (!mapCuentasEmpresa.containsKey(cuenta.Rut__c.toUpperCase())) {
					mapCuentasEmpresa.put(cuenta.Rut__c.toUpperCase(), cuenta);
				}
			}

			for (Account cuenta : (Account[])Trigger.new) {
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( (Trigger.isInsert && cuenta.Cuenta_Corporativa__c != null) ||  (cuentaOld!=null && cuentaOld.Cuenta_Corporativa__c != cuenta.Cuenta_Corporativa__c && cuenta.Cuenta_Corporativa__c!= null)){
					if(mapCuentasById.containsKey(cuenta.Cuenta_Corporativa__c))
						cuenta.RUT_Empresa__c = mapCuentasById.get(cuenta.Cuenta_Corporativa__c).Rut__c;
					continue;
				}
				
				if (String.isNotBlank(cuenta.RUT_Empresa__c) && mapCuentasEmpresa.containsKey(cuenta.RUT_Empresa__c.toUpperCase()) && cuenta.RecordTypeId == recordTypeCuentaPersonal)
					cuenta.Cuenta_Corporativa__c =  mapCuentasEmpresa.get(cuenta.RUT_Empresa__c.toUpperCase()).Id;
			}

		}

	}
}