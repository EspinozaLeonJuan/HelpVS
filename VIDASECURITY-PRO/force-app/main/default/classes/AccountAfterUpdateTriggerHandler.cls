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
* @version   1.0    20/10/2021     Javier Tibamoza JATC	       Ajueste en el Ciclo y se llama a la clase Queueable
***********************************************************************************************************************/
public  class AccountAfterUpdateTriggerHandler extends TriggerHandlerBase{
    /**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##AccountAfterUpdateTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('AccountAfterUpdateTriggerHandler','mainEntry') ){
			process((List<Account>)tp.newList, (Map<Id, Account>)tp.oldMap, (Map<Id, Account>)tp.newMap);
		}
	}
    /**
	* @description: 
	*/
	private void process(List<Account> lstNewAccounts, Map<Id, Account> mapOldAccounts, Map<Id, Account> mapNewAccounts) {
		//List
		List<Integer> rutsCuentas = new List<Integer>();
		List<Id> ejecutivoIds = new List<Id>();
		//Set's
		Set<Id> recordIds = mapNewAccounts.keySet();
		Set<Id> accountsIds = new Set<Id>();
		Set<Id> ejecutivoClienteIds = new Set<Id>();
    Set<Id> accountsIdsAMAC = new Set<Id>();
    Set<Id> accountsIdsCartera = new Set<Id>();
		//ID's
		User oUserSFVida = [SELECT Id FROM User WHERE Username LIKE '%sfvida@security.cl%' LIMIT 1];
		//Map Ususarios Ejecutivo Cliente
		Map<Id, User> mapUsuariosEjecutivosCliente = new Map<Id, User>([SELECT Id FROM User WHERE Ejecutivo_de_Cliente__c = True]);
		//Set ID's Ejecutivos
		ejecutivoClienteIds = mapUsuariosEjecutivosCliente.keySet();
		//Ciclo 1
		for( Account oNewAccount : lstNewAccounts ){
			Account oOldAccount = mapOldAccounts.get(oNewAccount.Id);
			rutsCuentas = AccReasignarCasoPorCreacionCuenta.getRutsCuentas(oNewAccount, rutsCuentas );
			accountsIds = AccACSEL.getAccountId( oNewAccount, oOldAccount, mapUsuariosEjecutivosCliente, accountsIds, oUserSFVida.Id );
			ejecutivoIds = AccCalcularFactorDeEjecutivo.getOldEjecutivoIds( oNewAccount, oOldAccount, ejecutivoClienteIds, ejecutivoIds );
      accountsIdsAMAC = AccountTriggerHelper.getAccountsId(oNewAccount, oOldAccount, accountsIdsAMAC);
      accountsIdsCartera = AccountTriggerHelper.getAccountsIdCartera(oNewAccount, oOldAccount, accountsIdsCartera);
		}
		//Querys
		List<Case> lCasesAReasignar = [
			SELECT Id, Reasignar_a_Rut__c, LastModifiedDate, Account.Rut__c 
			FROM Case 
			WHERE Reasignar_a_Rut__c IN: rutsCuentas 
			AND Reasignar_a_Rut__c != 0 
			AND LastModifiedDate = TODAY FOR UPDATE];
		
		List<Participantes_de_Campa_a__c> lParticipantes = [
			SELECT Id, Cuenta__r.Id, OwnerId, Cuenta__r.OwnerId
			FROM Participantes_de_Campa_a__c 
			WHERE Poliza__r.Estatus__c = 'ACTIVA' 
			AND Estado_Cierre__c != 'Finalizado' 
			AND Estado_Cierre__c != 'Finalizado (Cierre Administrativo)' 
			AND Cuenta__r.Id in: recordIds ];
		
		List<Task> lTareas = [
			SELECT Id, AccountId, OwnerId, Account.OwnerId
			FROM Task 
			WHERE (Status = 'No iniciada' OR Status = 'Abierta' OR Status = 'En curso' OR Status = 'Abierto' OR Status = 'No trabajado') 
			AND AccountId in: recordIds];

    List<Task> lTareasNew = new List<Task>();
    if ( !lTareas.isEmpty() ) {
      for( Task oTaskItem : lTareas ){
        if( oTaskItem.OwnerId != oTaskItem.Account.OwnerId ){
          lTareasNew.add( oTaskItem );
        }
      }
    }
      
		List<Account> lCuentas = [
			SELECT Id, Rut__c, Ejecutivo_de_Cliente__c, Ejecutivo_de_Cliente__r.Codigo__c 
			FROM Account 
			WHERE Id IN: accountsIds ];
    system.debug('Limits.getQueueableJobs() : ' + Limits.getQueueableJobs());
    system.debug('Limits.getQueries() : ' + Limits.getQueries());
		//Queueable --> se quito de la validacion lstNewAccounts pues no es relevante 
    if( !lCuentas.isEmpty() || !lCasesAReasignar.isEmpty() || !lParticipantes.isEmpty() || !lTareasNew.isEmpty() || !ejecutivoIds.isEmpty() || !accountsIdsAMAC.isEmpty() || !accountsIdsCartera.isEmpty() ){
      if( Limits.getQueueableJobs() == 0  ){
        AccountQueueable updateJob = new AccountQueueable(false, lstNewAccounts, lCuentas, lCasesAReasignar, lParticipantes, lTareasNew, ejecutivoIds, accountsIdsAMAC, accountsIdsCartera, accountsIds );
        ID jobID = System.enqueueJob(updateJob);
      }else{
        AccountQueueable queue = new AccountQueueable( false, lstNewAccounts, lCuentas, lCasesAReasignar, lParticipantes, lTareasNew, ejecutivoIds, accountsIdsAMAC, accountsIdsCartera, accountsIds );
        AccountSchedulable scheduleJob = new AccountSchedulable(queue, false , false, lstNewAccounts, lCuentas, lCasesAReasignar, lParticipantes, lTareasNew, ejecutivoIds, accountsIdsAMAC, accountsIdsCartera, accountsIds );
        scheduleJob.schedule();
      }
    }
    system.debug('Limits.getQueueableJobs() 2 : ' + Limits.getQueueableJobs());
    system.debug('Limits.getQueries() 2 : ' + Limits.getQueries());
	}
}