public without sharing class ReflectionUtils {

	public class ReflectionException extends Exception {}

	// private static final Map<String, Schema.SObjectType> sobjectMap;
	// private static final Map<String, String> labelMap = new Map<String, String>();

	private static final Map<String,Id> recordTypeCacheMapId = new Map<String,Id>();
	private static final Map<Schema.SObjectType, Schema.DescribeSObjectResult> describeObjectMap =
																																new Map<Schema.SObjectType, Schema.DescribeSObjectResult>();

	/*
	static {
		sobjectMap = getGlobalDescribe();
		for (String sobjectName : sobjectMap.keySet()) {
			Schema.SObjectType stype = sobjectMap.get(sobjectName);
			Schema.DescribeSObjectResult result = stype.getDescribe();
			describeObjectMap.put(stype, result);
			labelMap.put(result.getLabel(), sobjectName);
		}
	}
	*/

	public static Map<String, Schema.SObjectType> getGlobalDescribe(){
		return Schema.getGlobalDescribe();
	}

	public static String getSobjectName(Id processId) {
		Schema.SObjectType sobjType = processId.getSobjectType();
		Schema.DescribeSObjectResult sObjectDescribe = getDescribe(sobjType);
		return sObjectDescribe.getName();
	}

	public static Schema.SObjectType getSobjectType(Id objectId) {
		if (objectId == null)
			throw new ReflectionException('El parametro ingresado es nulo.');
		return objectId.getSobjectType();
	}

	public static Boolean exists(String sobjectName, String fieldName) {
		if (String.isBlank(sobjectName) || String.isBlank(fieldName))
		return false;
		Schema.DescribeSObjectResult[] results = Schema.describeSObjects(new String[]{ sobjectName });
		if (results.isEmpty()) return false;
		Schema.DescribeSObjectResult result = results[0];
		if (result == null) return false;
		Map<String, Schema.Sobjectfield> fieldMap = result.fields.getMap();
		return fieldMap.containsKey(fieldName);
	}

	/*
	public static String getSobjectNameByLabel(String label) {
		if (label == null)
			throw new ReflectionException('No se ha especificado el nombre del objeto');
		if (!labelMap.containsKey(label))
			throw new ReflectionException('No existe un objeto con nombre: ' + label + ', los nombres permitidos son: ' + labelMap.keySet());
		return labelMap.get(label);
	}
*/

	public static Id getRecordTypeId(Schema.SObjectType sobjType, String recordTypeName){
		try {
			Schema.DescribeSObjectResult describeSObj = getDescribe(sobjType);
			String sobjName = describeSObj.getName();
			String key = sobjName + '_' + recordTypeName;
			Id recordTypeId = recordTypeCacheMapId.get(key);
			if (recordTypeId != null)
				return recordTypeId;
			recordTypeId = describeSObj.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
			if (recordTypeId == null)
				throw new ReflectionException('No existe el record type con nombre ' + sobjName + ' del objeto ' + sobjName);
			recordTypeCacheMapId.put(key, recordTypeId);
			return recordTypeId;
		} catch (Exception e) {
			throw e;
		}
	}

	public static Set<String> getPicklistValues(Schema.SObjectField sobjectField){
		Set<String> values = new Set<String>();
		List<Schema.PicklistEntry> ple = getPicklist(sobjectField);
		for(Schema.PicklistEntry f : ple)
			values.add(f.getValue());
		return values;
	}

	public static List<Schema.PicklistEntry> getPicklist(Schema.SObjectField sobjectField){
		Schema.DescribeFieldResult fieldResult = sobjectField.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		return ple;
	}

	public static String getDefaultPicklistValue(Schema.SObjectField sobjectField){
		List<Schema.PicklistEntry> ple = getPicklist(sobjectField);
		for(Schema.PicklistEntry f : ple)
			if (f.isDefaultValue())
				return f.getValue();
		return null;
	}

	public static Schema.DescribeSObjectResult getDescribe(Schema.SObjectType sobjType){
		Schema.DescribeSObjectResult describeSObj = describeObjectMap.get(sobjType);
		if (describeSObj == null){
			describeSObj = sobjType.getDescribe();
			describeObjectMap.put(sobjType, describeSObj);
		}
		return describeSObj;
	}

	@testVisible
	private static Integer getCountDescribeMap(){
		return describeObjectMap.size();
	}

	@testVisible
	private static Integer getCountRecordTypeCacheMap(){
		return recordTypeCacheMapId.size();
	}

	public static Boolean isValidId(String sobjectId, Schema.SobjectType sobjectType) {
		if (String.isBlank(sobjectId))
			return false;
		String regex = '^([a-zA-Z0-9]{15}|[a-zA-Z0-9]{18})$';
		if (!Pattern.matches(regex, sobjectId))
			return false;
		return Id.valueOf(sobjectId).getSobjectType() == sobjectType;
			}
}