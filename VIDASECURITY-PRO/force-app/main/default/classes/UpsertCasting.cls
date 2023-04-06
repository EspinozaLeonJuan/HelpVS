public with sharing class UpsertCasting {
	
	/*
	private static void generateUpsertCode() {
		Map<String, Schema.Sobjecttype> classMap =  Schema.getGlobalDescribe();
		String result = '';
		for (String className : classMap.keySet()) {
			Schema.Sobjecttype stype = classMap.get(className);
			Schema.SobjectResult sresult = stype.getDescribe();
		if (sresult.isCreateable() || sresult.isUpdateable()) {
				result += '\t\tif (sot == ' + className + '.getSobjectType())';
				result += '\treturn Database.upsert((' + className + '[])sobjects, field, allOrNone);\n';
			}
		}
		System.debug(result);
	}
	**/

	// Fix that
	public static Database.UpsertResult[] upserts(Sobject[] sobjects, Schema.SobjectField field, Boolean allOrNone) {
		if (sobjects == null || sobjects.size() == 0)
		return null;
		Schema.SObjectType sot = sobjects[0].getSobjectType();
		if (sot == log__c.getSobjectType())	return Database.upsert((log__c[])sobjects, field, allOrNone);

		throw new DatabaseUtils.DatabaseException('No se ha completado el upsert con el ovbjeta que intenta upsertear: ' + sot);
	}
}