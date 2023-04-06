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
***********************************************************************************************************************/
public class PolizaBeforeUpdateTriggerHandler extends TriggerHandlerBase{
    /**
	* @description: 
	*/
	public PolizaBeforeUpdateTriggerHandler(){

	}
	/**
	* @description: 
	*/
    public override void mainEntry(TriggerParameters tp) {
		System.debug('##PolizaBeforeUpdateTriggerHandler.mainEntry');
		if( !TriggerExecutionControl.hasAlreadyDone('PolizaBeforeUpdateTriggerHandler','mainEntry') ){
			process((List<Poliza__c>)tp.newList, (Map<Id, Poliza__c>)tp.oldMap);
		}
	}
	/**
	* @description: 
	*/
	public void processQueueable( List<Poliza__c> newList, Map<Id, Poliza__c> oldMap ){
		process( newList, oldMap );
	}
    /**
	* @description: 
	*/
	private void process(List<Poliza__c> newList, Map<Id, Poliza__c> oldMap ) {
		//Id's
        Id recordTypeMasivos = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Masivos').getRecordTypeId();
        Id recordTypePf = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('PF').getRecordTypeId();
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		//Set's
    Set<String> CodigosMasivos = new Set<String>{'1170', '0124', '6803', '6801', '6800', '6353', '6350', '0163', '6301', '6300', '0162', '0149', '0148', '0122', '0121', '0120', '6700', '6600', '6500', '6400', '6205', '6204', '6201', '6200', '6100', 'M312', 'M313', 'M302', 'M309', 'M310', 'M311', '6936'};
        Set<String> CodigosPf = new Set<String>{'1150', '9001', '9002', '1140', '1835', '7100', '2130', '1300', '1200', '1250', '2400', '9200', '2120', '7000'}; 
        Set<Id> idsCorredores = new Set<Id>();
		Set<String> rutsCorredores = new Set<String>();
        Set<String> codigos = new Set<String>();
        Set<Id> idsEmpresas = new Set<Id>();
        Set<String> rutsEmpresas = new Set<String>();
        Set<Id> idPolizas = new Set<Id>();
		//Map's
		Map<String, Corredor__c> mapCorredores = new Map<String, Corredor__c>();
        Map<String, Account> mapEmpresas = new Map<String, Account>();
        Map<String, Contact> agenteMap = new Map<String, Contact>();
		//Primer Ciclo
		for( Poliza__c oNewPol : newList ) {
			Poliza__c oOldPol = oldMap.get(oNewPol.Id);
            //Asigna el campo Frecuencia_de_Pago__c de la Poliza
			PolizaAsignaFrecuencia.execute( oNewPol, recordTypeIndividuales );
            //Asigna la Categoria a la Poliza
			PolizaAsignaCategoria.execute( oNewPol, oOldPol );
            //Rut de Correderos
			String asignacorredor = PolizaAsignaCorredores.getRutCorredor(oNewPol, oOldPol, true, rutsCorredores);
            if((!String.isBlank(asignaCorredor)) && (!String.isEmpty(asignaCorredor))){
				rutsCorredores.add(asignacorredor);
			}
			//Ids Corredores
			Id idCorredor = PolizaAsignaCorredores.getCorredor(oNewPol, oOldPol, true, idsCorredores);
            if((!String.isBlank(idCorredor)) && (!String.isEmpty(idCorredor))){
				idsCorredores.add(idCorredor);
			}
            //Codigos de Agentes
			String asignaAgente = PolizaAsignaAgente.getCorredor(oNewPol, codigos);
            if((!String.isBlank(asignaAgente)) && (!String.isEmpty(asignaAgente))){
				codigos.add(asignaAgente);
			}
            //Id's de Empresas(Account)
			Id idEmpresa = PolizaAsignaEmpresa.getIdEmpresas(oNewPol, oOldPol, true, idsEmpresas);
            if((!String.isBlank(idEmpresa)) && (!String.isEmpty(idEmpresa))){
				idsEmpresas.add(idEmpresa);
			}
			//Rut's Empresas
			String rutEmpresa = PolizaAsignaEmpresa.getRutEmpresas(oNewPol, rutsEmpresas);
            if((!String.isBlank(rutEmpresa)) && (!String.isEmpty(rutEmpresa))){
				rutsEmpresas.add(rutEmpresa);
			}
			//Asigna el producto la Poliza
			PolizaAsignaProducto.execute( oNewPol, recordTypeMasivos, recordTypePf, CodigosMasivos, CodigosPf);	 	
      
      if ( oOldPol != null ) {
        // ScheduleViajeDesAsignacion
        Id id_poliza_vc = ScheduleViajeDesAsignacion.getPolizaId( oOldPol, oNewPol);
        if ( id_poliza_vc != null && !idPolizas.contains(id_poliza_vc) ) {
          idPolizas.add(id_poliza_vc);
        }
      }
    }
        //Querys
        List<Corredor__c> corredores = [SELECT Id, Rut__c FROM Corredor__c WHERE Rut__c IN: rutsCorredores];
        Map<Id, Corredor__c> mapCorredoresById = new Map<ID, Corredor__c>([SELECT Id, Rut__c From Corredor__c Where Id IN: idsCorredores]);
        Map<Id, Account> mapCuentasById = new Map<ID, Account>([SELECT Id, Rut__c From Account WHERE Id IN: idsEmpresas and RecordType.Name = 'Cuenta Corporativa']);
        List<Account> empresas = [SELECT Id, Rut__c From Account WHERE Rut__c IN: rutsEmpresas and RecordType.Name = 'Cuenta Corporativa'];
        List<Contact> agentes = [SELECT Id, Codigo_Agente__c FROM Contact WHERE Codigo_Agente__c IN: codigos ];
        //Arma Map's
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
        
        for( Contact agente : agentes ){
			agenteMap.put( agente.Codigo_Agente__c, agente );
		}
        //Segundo Ciclo	
		for( Poliza__c oNewPol : newList ) {
			Poliza__c oOldPol = oldMap.get(oNewPol.Id);
			//Asigna Corredores a la Poliza
			PolizaAsignaCorredores.execute( oNewPol, oOldPol, true, mapCorredoresById, mapCorredores );
            //Asigna RUT_Empresa__c y Cuenta__c
			PolizaAsignaEmpresa.execute( oNewPol, oOldPol, true, mapCuentasById, mapEmpresas );
            //Asigna Agente a la Poliza
			PolizaAsignaAgente.execute( oNewPol, agenteMap );
      //DesAsignar Viaje Comunicacion
      if ( !idPolizas.isEmpty() ) { ScheduleViajeDesAsignacion.execute( oNewPol, idPolizas ); }
		}	
	}
}