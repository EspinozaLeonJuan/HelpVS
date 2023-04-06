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
* @version   1.0    28/09/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
public class PolizaAfterInsertTriggerHandler extends TriggerHandlerBase{
	/**
	* @description: 
	*/
	public PolizaAfterInsertTriggerHandler(){

	}
    /**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##PolizaAfterInsertTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('PolizaAfterInsertTriggerHandler','mainEntry') ){
			process((List<Poliza__c>)tp.newList, (Map<Id, Poliza__c>)tp.newMap);
		}
	}
	/**
	* @description: 
	*/
	public void processQueueable( List<Poliza__c> newList, Map<Id, Poliza__c> newMap ){
		process( newList, newMap );
	}
	/**
	* @description: 
	*/
	private void process(List<Poliza__c> newList, Map<Id, Poliza__c> newMap) {
		//Set's
		Set<String> setCuentas = new Set<String>();
		Set<Id> accountIds = new Set<Id>();
		//
		List<Id> polizaIds = new List<Id>();
		//
		String sCuenta = '';
		Id idAccount = null;
		Id idPoliza = null;
		//Tipo de Registro
		Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		//Ciclo 1
		for( Poliza__c oPol : newList ){
			sCuenta = PolizaAsignaCategoriaCliente.getCuenta( oPol, null, tipoRegistroIndividual );
			if( sCuenta != '' ){
				setCuentas.add( sCuenta );
			}
			idAccount = PolizaAsignaPesoCuenta.getAccountId(oPol, null, tipoRegistroIndividual, accountIds );
			if( idAccount != null ){
				accountIds.add( idAccount );
			}
			idPoliza = PolizaAsignaFactorEjecutivo.getPolizaId(oPol, null, polizaIds );
			if( idPoliza != null ){
				polizaIds.add( idPoliza );
			}
		}
		//Queueable
		system.debug('Limits.getQueueableJobs() Poliza AI : ' + Limits.getQueueableJobs());
        system.debug('Limits.getQueries() Poliza AI : ' + Limits.getQueries());
        if( !setCuentas.isEmpty() || !accountIds.isEmpty() || !polizaIds.isEmpty() ){
            PolizaQueueable queue = new PolizaQueueable('LOGIC', true, setCuentas, accountIds, polizaIds, tipoRegistroIndividual, null, null, null, null, null, null, newList, null,  newMap );
            PolizaSchedulable scheduleJob = new PolizaSchedulable(queue, false ,'LOGIC', true, setCuentas, accountIds, polizaIds, tipoRegistroIndividual, null, null, null, null, null, null, newList, newMap, null );
            scheduleJob.schedule();
        }
        system.debug('Limits.getQueueableJobs() Poliza2 AI : ' + Limits.getQueueableJobs());
        system.debug('Limits.getQueries() Poliza2 AI : ' + Limits.getQueries());
        
	}
}