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
public class PolizaBeforeInsertTriggerHandler extends TriggerHandlerBase{
	/**
	* @description: 
	*/
	public PolizaBeforeInsertTriggerHandler(){

	}
    /**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##PolizaBeforeInsertTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('PolizaBeforeInsertTriggerHandler','mainEntry') ){
			process((List<Poliza__c>)tp.newList);
		}
	}
	/**
	* @description: 
	*/
	public void processQueueable( List<Poliza__c> newList ){
		process( newList );
	}
	/**
	* @description: 
	*/
	private void process(List<Poliza__c> lstNewPolizas) {
		Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		Id recordTypeContactAgente = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId();
		Id idCorredor = null;
		Id idEmpresa = null;
		String rutEmpresa = '';
		String codAgente = '';
		//Set's
		Set<Id> idsCorredores = new Set<Id>();
		Set<Id> idsEmpresas = new Set<Id>();
		Set<String> rutsCorredores = new Set<String>();
		Set<String> codigos = new Set<String>();
		Set<String> rutsEmpresas = new Set<String>();
		//Map's
		Map<String, Corredor__c> mapCorredores = new Map<String, Corredor__c>();
		Map<String, Contact> agenteMap = new Map<String, Contact>();
		Map<String, Account> mapEmpresas = new Map<String, Account>();
		//Primer Ciclo
		for( Poliza__c oPol : lstNewPolizas ){
			idCorredor = null;
			idEmpresa = null;
			codAgente = '';
			rutEmpresa = '';
			//Asigna el campo Frecuencia_de_Pago__c de la Poliza
			PolizaAsignaFrecuencia.execute( oPol, recordTypeIndividuales );
			//Asigna la Categoria a la Poliza
			PolizaAsignaCategoria.execute( oPol, null );
			//Rut de Correderos
			rutsCorredores.add( PolizaAsignaCorredores.getRutCorredor( oPol, null, true, rutsCorredores ) );
			//Ids Corredores
			idCorredor = PolizaAsignaCorredores.getCorredor( oPol, null, true, idsCorredores );
			if( idCorredor != null ){
				idsCorredores.add( idCorredor );
			}
			//Codigos de Agentes
			codAgente = PolizaAsignaAgente.getCorredor( oPol, codigos );
			if( codAgente != null && codAgente != '' ){
				codigos.add( codAgente );
			}
			//Id's de Empresas(Account)
			idEmpresa = PolizaAsignaEmpresa.getIdEmpresas( oPol, null, true, idsEmpresas );
			if( idEmpresa != null  ){
				idsEmpresas.add( idEmpresa );
			}
			//Rut's Empresas
			rutEmpresa = PolizaAsignaEmpresa.getRutEmpresas( oPol, rutsEmpresas );
			if( rutEmpresa != null && rutEmpresa != '' ){
				rutsEmpresas.add( rutEmpresa );
			}
		}
		//Querys
		List<Corredor__c> corredores = [SELECT Id, Rut__c FROM Corredor__c WHERE Rut__c IN: rutsCorredores];
		Map<Id, Corredor__c> mapCorredoresById = new Map<ID, Corredor__c>([SELECT Id, Rut__c From Corredor__c Where Id IN: idsCorredores]);
		List<Contact> agentes = [SELECT Id, Codigo_Agente__c FROM Contact WHERE Codigo_Agente__c IN: codigos AND Codigo_agente__c != null AND RecordTypeId =: recordTypeContactAgente ];
		List<Account> empresas = [SELECT Id, Rut__c From Account WHERE Rut__c IN: rutsEmpresas and RecordType.Name = 'Cuenta Corporativa'];
		Map<Id, Account> mapCuentasById = new Map<ID, Account>([SELECT Id, Rut__c From Account WHERE Id IN: idsEmpresas and RecordType.Name = 'Cuenta Corporativa']);
		//Arma Map's
		for( Contact agente : agentes ){
			agenteMap.put( agente.Codigo_Agente__c, agente );
		}

		for( Corredor__c corredor : corredores ){
			if(!mapCorredores.containsKey(corredor.Rut__c.toUpperCase())){
				mapCorredores.put(corredor.Rut__c.toUpperCase(), corredor);
			}
		}

		for(Account empresa: empresas){
			if(!mapEmpresas.containsKey(empresa.Rut__c.toUpperCase())){
				mapEmpresas.put(empresa.Rut__c.toUpperCase(), empresa);
			}
		}
		//Segundo Ciclo
		for( Poliza__c oPol : lstNewPolizas ){
			//Asigna Corredores a la Poliza
			PolizaAsignaCorredores.execute( oPol, null, true, mapCorredoresById, mapCorredores );
			//Asigna Agente a la Poliza
			PolizaAsignaAgente.execute( oPol, agenteMap );
			//Asigna RUT_Empresa__c y Cuenta__c
			PolizaAsignaEmpresa.execute( oPol, null, true, mapCuentasById, mapEmpresas );
		}
	}
}