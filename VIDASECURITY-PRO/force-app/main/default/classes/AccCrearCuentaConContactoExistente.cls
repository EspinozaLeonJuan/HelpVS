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
public class AccCrearCuentaConContactoExistente {
    private static final Log log = new Log(CrearCuentaConContactoExistenteHandler.class);
    
    //JG - metodo para obtener rut de contacto
    public static string getRutContacto( Account accountNew, Account accountOld, Set<String> rutsContactos ){
		if (accountNew.IsPersonAccount && accountNew.rut_contacto__pc != null  && !rutsContactos.contains( accountNew.Rut_contacto__pc )){
			return accountNew.Rut_contacto__pc;
		}
		return '';
	}

    public static contact getMapContact(Contact contactNew, Contact contactOld, Map<String, Contact> mapContactos){
        if (!mapContactos.containsKey(contactNew.rut_contacto__c) && !mapContactos.containsKey(contactNew.Id)){
            return contactNew; 
        }
        return null; 
    }

    public static Account getMapAccount(Account accountNew, Account accountOld, Map<String, Account> mapCuentas){
        if (!mapCuentas.containsKey(accountNew.rut__c)  && !mapCuentas.containsKey(accountNew.Id) ){
            return accountNew;
        }
        return null; 
    }

     public static Contact getmapContactAccAnonymous(Boolean IsPersonAccount, Account accountNew, Account accountOld, Map<String, Account> mapCuentas,Map<String, Contact> mapContactos,List<Account> cuentaAnonima ){
        if( IsPersonAccount && accountNew.rut_contacto__pc != null ){
            if( mapCuentas.containsKey(accountNew.Rut_contacto__pc) ){
                return null;
            }
            if( mapContactos.containsKey(accountNew.Rut_Contacto__pc)) {
                Contact contactoCuenta = mapContactos.get(accountNew.Rut_Contacto__pc);
                if(  cuentaAnonima.size() > 0 && contactoCuenta.AccountId == cuentaAnonima[0].Id ){
                    return contactoCuenta;
                }
            }
        }
        return null; 
    }
}