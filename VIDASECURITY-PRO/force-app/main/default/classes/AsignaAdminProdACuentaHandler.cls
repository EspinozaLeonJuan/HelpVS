public with sharing class AsignaAdminProdACuentaHandler  implements TriggerHandler.HandlerInterface{
	
	public void handle() {

		Map<String, Contact> mapAdmins = new Map<String, Contact>();
		Set<String> rutsAdmins = new Set<String>();
		Set<Id> idsAdmins = new Set<Id>();

		Id recordTypeCuentaEmpresa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

		if (Trigger.new != null) {

			for (Account cuenta : (Account[])Trigger.new) {
				
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( ( (Trigger.isInsert && cuenta.Administrador_de_Produccion__c != null) ||  (cuentaOld!=null && cuentaOld.Administrador_de_Produccion__c != cuenta.Administrador_de_Produccion__c && cuenta.Administrador_de_Produccion__c!=null) ) && cuenta.RecordTypeId == recordTypeCuentaEmpresa){
					if(!idsAdmins.contains(cuenta.Administrador_de_Produccion__c))
						idsAdmins.add(cuenta.Administrador_de_Produccion__c);
					continue;
				}

				if (String.isNotBlank(cuenta.RUT_Administrador_de_Produccion__c) && !rutsAdmins.contains(cuenta.RUT_Administrador_de_Produccion__c) && cuenta.RecordTypeId == recordTypeCuentaEmpresa )
					rutsAdmins.add(cuenta.RUT_Administrador_de_Produccion__c.toUpperCase());
			}

			List<Contact> contactos = [Select Id, Rut__c From Contact WHere Rut__c IN :rutsAdmins];
			Map<Id, Contact> mapContactosById = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsAdmins]);

			for (Contact contacto : contactos) {
				if (!mapAdmins.containsKey(contacto.Rut__c.toUpperCase())) {
					mapAdmins.put(contacto.Rut__c.toUpperCase(), contacto);
				}
			}

			for (Account cuenta : (Account[])Trigger.new) {
				Account cuentaOld = (Account)(Trigger.isUpdate ? Trigger.oldMap.get(cuenta.Id) : null);

				if( ( (Trigger.isInsert && cuenta.Administrador_de_Produccion__c != null) ||  (cuentaOld!=null && cuentaOld.Administrador_de_Produccion__c != cuenta.Administrador_de_Produccion__c && cuenta.Administrador_de_Produccion__c!=null) && cuenta.RecordTypeId == recordTypeCuentaEmpresa) ){
					if(mapContactosById.containsKey(cuenta.Administrador_de_Produccion__c))
						cuenta.RUT_Administrador_de_Produccion__c = mapContactosById.get(cuenta.Administrador_de_Produccion__c).Rut__c;
					continue;
				}

				if (String.isNotBlank(cuenta.RUT_Administrador_de_Produccion__c) && mapAdmins.containsKey(cuenta.RUT_Administrador_de_Produccion__c.toUpperCase()) && cuenta.RecordTypeId == recordTypeCuentaEmpresa)
					cuenta.Administrador_de_Produccion__c =  mapAdmins.get(cuenta.RUT_Administrador_de_Produccion__c.toUpperCase()).Id;
			}

		}

	}

}