public with sharing class AsignaEjecutivoComercialACuentaHandler implements TriggerHandler.HandlerInterface {
	
	public void handle() {

		Map<String, Contact> mapEjecutivos = new Map<String, Contact>();
		Set<Id> idsEjecutivos = new Set<Id>();
		Set<String> rutsEjecutivos = new Set<String>();
		Id recordTypeCuentaEmpresa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

		if (Trigger.new != null) {

			for (Account cuenta : (Account[])Trigger.new) {
				
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( ( (Trigger.isInsert && cuenta.Ejecutivo_Comercial__c != null) ||  (cuentaOld!=null && cuentaOld.Ejecutivo_Comercial__c != cuenta.Ejecutivo_Comercial__c && cuenta.Ejecutivo_Comercial__c != null) ) && cuenta.RecordTypeId == recordTypeCuentaEmpresa){
					if(!idsEjecutivos.contains(cuenta.Ejecutivo_Comercial__c))
						idsEjecutivos.add(cuenta.Ejecutivo_Comercial__c);
					continue;
				}

				if (String.isNotBlank(cuenta.RUT_Ejecutivo_Comercial__c) && !rutsEjecutivos.contains(cuenta.RUT_Ejecutivo_Comercial__c) && cuenta.RecordTypeId == recordTypeCuentaEmpresa )
					rutsEjecutivos.add(cuenta.RUT_Ejecutivo_Comercial__c.toUpperCase());
			}

			List<Contact> contactos = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsEjecutivos];
			Map<Id, Contact> mapContactosById = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsEjecutivos]);


			for (Contact contacto : contactos) {
				if (!mapEjecutivos.containsKey(contacto.Rut__c.toUpperCase())) {
					mapEjecutivos.put(contacto.Rut__c.toUpperCase(), contacto);
				}
			}

			for (Account cuenta : (Account[])Trigger.new) {
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( ( (Trigger.isInsert && cuenta.Ejecutivo_Comercial__c != null) ||  (cuentaOld!=null && cuentaOld.Ejecutivo_Comercial__c != cuenta.Ejecutivo_Comercial__c && cuenta.Ejecutivo_Comercial__c != null) && cuenta.RecordTypeId == recordTypeCuentaEmpresa) ){
					if(mapContactosById.containsKey(cuenta.Ejecutivo_Comercial__c))
						cuenta.RUT_Ejecutivo_Comercial__c = mapContactosById.get(cuenta.Ejecutivo_Comercial__c).Rut__c;
					continue;
				}

				if (String.isNotBlank(cuenta.RUT_Ejecutivo_Comercial__c) && mapEjecutivos.containsKey(cuenta.RUT_Ejecutivo_Comercial__c.toUpperCase()) && cuenta.RecordTypeId == recordTypeCuentaEmpresa)
					cuenta.Ejecutivo_Comercial__c =  mapEjecutivos.get(cuenta.RUT_Ejecutivo_Comercial__c.toUpperCase()).Id;
			}

		}

	}
}