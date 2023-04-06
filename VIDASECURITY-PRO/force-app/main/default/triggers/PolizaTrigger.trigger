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
* @version   1.0    23/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
trigger PolizaTrigger on Poliza__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Map<String,Switch_new_functions__mdt> mSwitch = UtilityClass.getSwitchNewFunctions();
    if( UtilityClass.validateSwitchNewFunctions('newTriggerFactory', mSwitch ) ) {
        TriggerFactory.createTriggerDispatcher(Poliza__c.sObjectType);  
    }else{
        new TriggerHandler()
            .bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
                new ActualizaFrecuenciaPagoDePolizaHandler(),
                new AsignaCategoriaDePolizaHandler(),
                new AsignaCorredoresAPolizaHandler(),
                new AsignaEmpresaAPolizaHandler(),
                new AsignaAgenteActualAPolizaHandler()
                //new PolizaAsignaProductoHandler() //Before Update
            })
            .bind(TriggerHandler.AFTER_ALL_EVENTS, new TriggerHandler.HandlerInterface[] {
                new CalculoCategoriaClienteHandler(), // Este debe sel el 1º handler porque los de más abajo dependen de este calculo.
                new CalcularPesoDeCuentaHandler(),
                new CalcularFactorDeEjecutivoHandler()
            })
            .bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {       
                new CLS_ParticipanteCobranzaPV()
                //new PolizaCampanaBienvenidaHandler(),
                //new AsignacionDeOportunidad_PolizaHandler()    
                //new CLS_ParticipanteCobranzaTV()
            })
            .manage();
    }
}