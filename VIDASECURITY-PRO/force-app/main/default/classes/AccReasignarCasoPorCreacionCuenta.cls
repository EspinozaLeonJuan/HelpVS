/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class AccReasignarCasoPorCreacionCuenta {
    
    public static List<Integer> getRutsCuentas(Account oAccount, List<Integer> rutsCuentas) {
        if( oAccount.IsPersonAccount && oAccount.Rut__c != null ){  
            if( Integer.valueOf( oAccount.Rut__c ) != 0){// rut 0 es el valor por defecto de Reasignar_a_Rut__c, por lo mismo se omite
                rutsCuentas.add( Integer.ValueOf(oAccount.Rut__c.replace('.', '') ) );
            }
        }
        return rutsCuentas;
	}

    public static void execute(List<Account> lAccount, List<Case> lCaseAReasignar ) {
        List<Case> lCasesUpdate = new List<Case>();
        for(Account aAccount: lAccount ){
			if( aAccount.IsPersonAccount && aAccount.Rut__c != null){
				if( Integer.valueOf( aAccount.Rut__c) != 0) {
					for( Case oCase : lCaseAReasignar ){
                        if( oCase.Reasignar_a_Rut__c == integer.ValueOf( aAccount.Rut__c )) {
							oCase.AccountId = aAccount.Id;
							oCase.Reasignar_a_Rut__c = null;
							lCasesUpdate.add(oCase);
						}
					}
				}
			}
		}
        if( lCasesUpdate.size() > 0 ){
            update lCasesUpdate;
        }
    }
}