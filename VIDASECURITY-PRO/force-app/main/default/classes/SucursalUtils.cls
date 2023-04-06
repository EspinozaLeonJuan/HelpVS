public with sharing class SucursalUtils {
	
	public static final Sucursal__c[] sucursales = [SELECT Id, Codigo_Sucursal__c, Name FROM Sucursal__c WHERE Codigo_Sucursal__c <> NULL];
	
	public static Map<String, Sucursal__c> codigoSucursalMap = new Map<String, Sucursal__c>();
	
	static {
		for (Sucursal__c sucursal : sucursales) {
			codigoSucursalMap.put(sucursal.Codigo_Sucursal__c, sucursal);
		}
	}
}