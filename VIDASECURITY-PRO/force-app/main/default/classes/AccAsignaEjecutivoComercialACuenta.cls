/**
* VASS
* @author           Jessica Gómez
* @email: 			jessica.gomez@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    21/10/2021     Jessica Gómez JMGR	       Class Created
***********************************************************************************************************************/
public class AccAsignaEjecutivoComercialACuenta {

    public static Account getIdEjecutivo( Account cuenta, Account cuentaOld, Set<Id> idsEjecutivos, Id recordTypeCuentaEmpresa){
		if( ( (cuenta.Ejecutivo_Comercial__c != null) ||  (cuentaOld!=null && cuentaOld.Ejecutivo_Comercial__c != cuenta.Ejecutivo_Comercial__c && cuenta.Ejecutivo_Comercial__c != null) ) && cuenta.RecordTypeId == recordTypeCuentaEmpresa){
            if(!idsEjecutivos.contains(cuenta.Ejecutivo_Comercial__c)){
                return cuenta;
            }
        }
		return null;
	}

    public static Account getRutsPorVencer(Account cuenta, Account cuentaOld, Set<String> rutsEjecutivos, Id recordTypeCuentaEmpresa){
        if( String.isNotBlank(cuenta.RUT_Ejecutivo_Comercial__c) && !rutsEjecutivos.contains(cuenta.RUT_Ejecutivo_Comercial__c) && cuenta.RecordTypeId == recordTypeCuentaEmpresa ){
            return cuenta;
        }
        return null;
    }
    
    public static Contact getMapEjecutivo(Contact contacto, Map<String, Contact> mapEjecutivos) {
        if( contacto!= null && contacto.Rut__c != null && mapEjecutivos != null && !mapEjecutivos.containsKey(contacto.Rut__c.toUpperCase())) {
            return contacto; 
        }
        return null;
    }

    public static void updateAccount(Account cuenta, Account cuentaOld, Id recordTypeCuentaEmpresa, Map<Id, Contact> mapContactosById, Map<String, Contact> mapEjecutivos) {
        if( ( ( cuenta.Ejecutivo_Comercial__c != null) ||  (cuentaOld!=null && cuentaOld.Ejecutivo_Comercial__c != cuenta.Ejecutivo_Comercial__c && cuenta.Ejecutivo_Comercial__c != null) && cuenta.RecordTypeId == recordTypeCuentaEmpresa) ){
            if( mapContactosById.containsKey(cuenta.Ejecutivo_Comercial__c) ){
                cuenta.RUT_Ejecutivo_Comercial__c = mapContactosById.get(cuenta.Ejecutivo_Comercial__c).Rut__c;
            }
        }

        if( String.isNotBlank(cuenta.RUT_Ejecutivo_Comercial__c) && mapEjecutivos.containsKey(cuenta.RUT_Ejecutivo_Comercial__c.toUpperCase()) && cuenta.RecordTypeId == recordTypeCuentaEmpresa ){
            cuenta.Ejecutivo_Comercial__c =  mapEjecutivos.get(cuenta.RUT_Ejecutivo_Comercial__c.toUpperCase()).Id;
        }
    }
}