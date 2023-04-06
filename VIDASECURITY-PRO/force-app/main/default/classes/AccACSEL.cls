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
public class AccACSEL {
    
    public static Set<Id> getAccountId( Account oNewAccount, Account oOldAccount, Map<Id, User> mapUsuariosEjecutivosCliente, Set<Id> accountsIds, Id userSFVida ) {
      if( 
          ( 
            mapUsuariosEjecutivosCliente.containsKey( oNewAccount.OwnerId) && 
            (   
              oOldAccount == null || 
              ( oOldAccount !=null && ( oOldAccount.OwnerId != oNewAccount.OwnerId ) ) || 
              ( oOldAccount.Sincronizar_Ejecutivo__c == false && oNewAccount.Sincronizar_Ejecutivo__c == true ) || 
              ( oOldAccount.Sincronizar_Ejecutivo__c == true && oNewAccount.Sincronizar_Ejecutivo__c == true && oNewAccount.ultima_actualizacion_amac__c != null && ( ( oNewAccount.ultima_actualizacion_amac__c.getTime() - oOldAccount.ultima_actualizacion_amac__c.getTime() ) > 60000 ) ) 
            ) 
          ) || 
          oNewAccount.OwnerId == '005i0000004xhHp' 
        ){
          accountsIds.add( oNewAccount.Id );
        }
		return accountsIds;
    }

    public static void execute( List<Account> lCuentas ) {
        List<ACSELAsignacion> asignacionesEfectivas = new List<ACSELAsignacion>();
        for(Account cuenta: lCuentas){
			ACSELAsignacion asignacionEfectiva = new ACSELAsignacion();
			asignacionEfectiva.rut = Integer.valueOf(cuenta.Rut__c == null ? '0' : cuenta.Rut__c);
			asignacionEfectiva.codigoEjecutivo = (cuenta.Ejecutivo_de_Cliente__c == null ? 0 : cuenta.Ejecutivo_de_Cliente__r.Codigo__c == null ? 0 : Integer.valueOf(cuenta.Ejecutivo_de_Cliente__r.Codigo__c));
			asignacionesEfectivas.add(asignacionEfectiva);
		}

		if (!asignacionesEfectivas.isEmpty() && !Test.isRunningTest()){
            ACSELCalloutService.asignaEjecutivos(asignacionesEfectivas);
        }
    }
}