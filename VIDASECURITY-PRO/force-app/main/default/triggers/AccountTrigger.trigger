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
* @version   1.0    23/11/2021     Javier Tibamoza JATC 	       Class Updated
***********************************************************************************************************************/
trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    Map<String,Switch_new_functions__mdt> mSwitch = UtilityClass.getSwitchNewFunctions();
    if( UtilityClass.validateSwitchNewFunctions('newTriggerFactory', mSwitch ) ) {
        TriggerFactory.createTriggerDispatcher(Account.sObjectType); 
    } else {             
        new TriggerHandler()
        .bind(TriggerHandler.BEFORE_INSERT, new CrearCuentaConContactoExistenteHandler())
        .bind(TriggerHandler.BEFORE_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
            new ValidaRUTCuentaHandler(),
            new AsignaEmpresaAAseguradoHandler(),
            new AsignaEjecutivoComercialACuentaHandler(),
            new AsignaAdminProdACuentaHandler(),
            new AsignaAgenteActualACuentaHandler(),
            new AsignaFechaSinEjecutivoHandler(),
            new AsignaEjecutivoDeClienteHandler(),
            new AsignarRelacionDeCategoriaHandler()
        })
        .bind(TriggerHandler.AFTER_INSERT_UPDATE, new TriggerHandler.HandlerInterface[] {
            new ReasignarCasoPorCreacionCuentaHandler(),
            new ActualizaPropietarioParticipantes(),
            new ActualizaPropietarioTareas(),
            new ACSELHandler()
        })
        .bind(TriggerHandler.AFTER_ALL_EVENTS, new CalcularFactorDeEjecutivoEnCuentaHandler())
        .manage();
    }
}