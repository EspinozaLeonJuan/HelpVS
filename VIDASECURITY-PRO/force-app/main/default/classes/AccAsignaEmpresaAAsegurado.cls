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
* @version   1.0    20/10/2021     Jessica Gómez JMGR	       Class Created
***********************************************************************************************************************/
public class AccAsignaEmpresaAAsegurado {

    public static Account getCuenta(Account accNew, Account accOld, Set<Id> idsEmpresas) {
        if( ( ( accNew.Cuenta_Corporativa__c != null ) || ( accOld != null && accOld.Cuenta_Corporativa__c != accNew.Cuenta_Corporativa__c && accNew.Cuenta_Corporativa__c != null ) ) && ( !idsEmpresas.contains( accNew.Cuenta_Corporativa__c ) ) ){
            if( !idsEmpresas.contains( accNew.Cuenta_Corporativa__c ) ){
                return accNew;
            }
        }
        return null;
    }

    public static Account getCuentaEmpresa(Account accNew, Account accOld, Map<String, Account> mapCuentasEmpresa) {
        if( !mapCuentasEmpresa.containsKey(accNew.Rut__c.toUpperCase() ) ) {
            return accNew;
        }
        return null; 
    }

    public static void updateAccount(Boolean isInsert, Account accNew, Account accOld, Map<String, Account> mapCuentasEmpresa, Id recordTypeCuentaPersonal, Map<Id, Account> mapCuentasById) {
        if( ( isInsert && accNew.Cuenta_Corporativa__c != null ) || ( accOld != null && accOld.Cuenta_Corporativa__c != accNew.Cuenta_Corporativa__c && accNew.Cuenta_Corporativa__c != null ) ){
            if( mapCuentasById.containsKey( accNew.Cuenta_Corporativa__c ) ){
                accNew.RUT_Empresa__c = mapCuentasById.get( accNew.Cuenta_Corporativa__c ).Rut__c;
            }       
        }
        if( String.isNotBlank( accNew.RUT_Empresa__c ) && mapCuentasEmpresa.containsKey( accNew.RUT_Empresa__c.toUpperCase() ) && accNew.RecordTypeId == recordTypeCuentaPersonal ){
            accNew.Cuenta_Corporativa__c = mapCuentasEmpresa.get( accNew.RUT_Empresa__c.toUpperCase() ).Id;
        }
    }
}