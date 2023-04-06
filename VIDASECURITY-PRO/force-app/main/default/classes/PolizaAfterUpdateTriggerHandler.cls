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
* @version   2.0    08/10/2021     Jessica Gómez   JMGR 	       Class Updated
**********************************************************************************************************************/
public class PolizaAfterUpdateTriggerHandler extends TriggerHandlerBase{
    /**
	* @description: 
	*/
	public PolizaAfterUpdateTriggerHandler(){

	}
	/**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##PolizaAfterUpdateTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('PolizaAfterUpdateTriggerHandler','mainEntry') ){
			process((List<Poliza__c>)tp.newList, (Map<Id, Poliza__c>)tp.oldMap, (Map<Id, Poliza__c>)tp.newMap);
		}
	}
	/**
	* @description: 
	*/
	public void processQueueable( List<Poliza__c> newList, Map<Id, Poliza__c> oldMap,  Map<Id, Poliza__c> newMap ){
		process( newList, oldMap, newMap);
	}
    /**
	* @description: 
	*/
	private void process(List<Poliza__c> newList, Map<Id, Poliza__c> oldMap,  Map<Id, Poliza__c> newMap) {
		//Set's
		Set<String> setCuentas = new Set<String>();
		Set<Id> accountIds = new Set<Id>();
        Set<Id> accountIds2 = new Set<Id>();
        Set<Id> polizaIds2 = new Set<Id>();
		//List's
		List<Id> polizaIds = new List<Id>();
		//String's Id's
		String sCuenta = '';
		Id idAccount = null;
		Id idPoliza = null;
        Id idAccount2 = null;
		Id idPoliza2 = null;
		//Tipo de Registro
		Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();        
        Id recordId = Schema.SObjectType.Participantes_de_Campa_a__c.getRecordTypeInfosByName().get('Cobranzas PV').getRecordTypeId();
        //Querys
        Id idCampana = [SELECT Id FROM Campana_Vida_Security__c WHERE Name = 'Campaña Cobranzas PV'].Id;
		//Ciclo 1
		for( Poliza__c oPol : newList ){
            Poliza__c oOldPol = oldMap.get(oPol.Id);
			sCuenta = PolizaAsignaCategoriaCliente.getCuenta( oPol, oOldPol, tipoRegistroIndividual );
			if( sCuenta != '' ){ setCuentas.add( sCuenta );
			}
			idAccount = PolizaAsignaPesoCuenta.getAccountId(oPol, oOldPol, tipoRegistroIndividual, accountIds );
			if( idAccount != null ){ accountIds.add( idAccount );
			}
			idPoliza = PolizaAsignaFactorEjecutivo.getPolizaId(oPol, oOldPol, polizaIds );
			if( idPoliza != null ){ polizaIds.add( idPoliza );
			}
            idAccount2 = PolizaParticipanteCobranzaPV.getAccountId(oPol, accountIds2, tipoRegistroIndividual);
			if( idAccount2 != null ){ accountIds2.add( idAccount2 );
			}
			idPoliza2 = PolizaParticipanteCobranzaPV.getPolizaId(oPol, polizaIds2, tipoRegistroIndividual);
			if( idPoliza2 != null ){ polizaIds2.add( idPoliza2 );
			}            
		}
		//Querys
		Map<Id, Account> accMap = new Map<Id, Account>([SELECT Id, Name, PersonContactId, IsPersonAccount, OwnerId FROM Account WHERE Id IN :accountIds2 AND Owner.Ejecutivo_de_Cliente__c = true]);
         
        List<Participantes_de_Campa_a__c> members = [
			SELECT Contacto__c, Poliza__c, Campa_a_Vida_Security__c, Estado_Cierre__c, Prioridad_en_Campa_a__c, CreatedDate
			FROM Participantes_de_Campa_a__c 
            WHERE Contacto__r.AccountId IN :accountIds 
			AND Poliza__c IN :polizaIds2 
			AND RecordType.Name = 'Cobranzas PV' 
			ORDER BY CreatedDate];
		//Queueable
		system.debug('Limits.getQueueableJobs() Poliza : ' + Limits.getQueueableJobs());
        system.debug('Limits.getQueries() Poliza : ' + Limits.getQueries());
        if( !setCuentas.isEmpty() || !accountIds.isEmpty() || !polizaIds.isEmpty() || !accountIds2.isEmpty() || !polizaIds2.isEmpty() || !accMap.isEmpty() || !members.isEmpty() ){
            PolizaQueueable queue = new PolizaQueueable('LOGIC', false, setCuentas, accountIds, polizaIds, tipoRegistroIndividual, recordId, idCampana, accountIds2, polizaIds2, accMap, members, newList, oldMap, newMap );
            PolizaSchedulable scheduleJob = new PolizaSchedulable(queue, false ,'LOGIC', false, setCuentas, accountIds, polizaIds, tipoRegistroIndividual, recordId, idCampana, accountIds2, polizaIds2, accMap, members, newList, newMap, oldMap );
            scheduleJob.schedule();
        }
        system.debug('Limits.getQueueableJobs() Poliza2 : ' + Limits.getQueueableJobs());
        system.debug('Limits.getQueries() Poliza2 : ' + Limits.getQueries());
	}
}