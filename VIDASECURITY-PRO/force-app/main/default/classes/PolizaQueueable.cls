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
public class PolizaQueueable implements Queueable{
    private String typeQueueable;
    private Boolean blInsert;
    private Id recordTypeIndividuales;
    private Id recordId;
    private Id idCampana;
    private List<Id> polizaIds;
    private Set<Id> accountIds;
    private Set<Id> accountIds2 = new Set<Id>();
    private Set<Id> polizaIds2 = new Set<Id>();
    private Set<String> setCuentas;
    private List<Participantes_de_Campa_a__c> members;
    private List<Poliza__c> lstPoliza;
    private Map<Id, Account> accMap = new Map<Id, Account>();
    private List<Poliza__c> newList = new List<Poliza__c>();
    private Map<Id, Poliza__c> oldMap = new Map<Id, Poliza__c>();
    private Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();

    public PolizaQueueable(String typeQueueable, List<Poliza__c> newList, Map<Id, Poliza__c> oldMap,  Map<Id, Poliza__c> newMap ) {
        this.typeQueueable = typeQueueable;
        this.newList = newList;
        if(oldMap != null){
            this.oldMap = oldMap;
        }else{
            this.oldMap = new Map<Id, Poliza__c>();
        }
        this.newMap = newMap;
        this.blInsert = false;
        this.polizaIds =  new List<Id>();
    }
    
    public PolizaQueueable(String typeQueueable, Boolean blInsert, Set<String> setCuentas, Set<Id> accountIds, List<Id> polizaIds, Id recordTypeIndividuales, Id recordId, Id idCampana, Set<Id> accountIds2, Set<Id> polizaIds2, Map<Id, Account> accMap, List<Participantes_de_Campa_a__c> members, List<Poliza__c> lstPoliza, Map<Id, Poliza__c> oldMap,  Map<Id, Poliza__c> newMap) {
        this.typeQueueable = typeQueueable;
        this.blInsert = blInsert;
        if( blInsert == null ){
            blInsert = false;
        }
        //Solo Insert
        if( blInsert ){
            this.lstPoliza = lstPoliza;
        }
        if(oldMap != null){
            this.oldMap = oldMap;
        }else{
            this.oldMap = new Map<Id, Poliza__c>();
        }
        this.newMap = newMap;
        //Solo Update
        if( !blInsert ){
            this.accountIds2 = accountIds2;
            this.polizaIds2 = polizaIds2;
            this.accMap = accMap;
            this.members = members; 
            this.recordTypeIndividuales = recordTypeIndividuales;
            this.recordId = recordId;
            this.idCampana = idCampana;
        }
        //Insert y Update
        this.setCuentas = setCuentas;
        this.accountIds = accountIds;
        this.polizaIds = polizaIds;
    }

    public void execute(QueueableContext context) {
        if( this.typeQueueable == 'LOGIC' ){
            if (blInsert == null)
            	blInsert = false;
            if (polizaIds == null)
                polizaIds = new List<Id>(); 
            //Solo Insert
            if(blInsert){
                //Crea Campaña Bienvenida
                PolizaCampanaBienvenida.execute(this.lstPoliza, this.newMap);
                //Asigna Oportunidad a la Poliza
                PolizaOportunidades.execute(this.lstPoliza);
            }
            //Solo Update
            if(!blInsert){
                //actualizar members2
                PolizaParticipanteCobranzaPV.updateMembers2(this.recordTypeIndividuales, this.recordId, this.idCampana, this.accountIds2, this.polizaIds2, this.accMap, this.members, this.newMap );
            }
            //Insert y Update
            //Asigna Categoria al Cliente
            List<String> errors = CategoriaClienteUtils.asignarCategoriaDeCliente( setCuentas );
            //Calculo de Peso de la Cuenta
            PolizaAsignaPesoCuenta.updatePesoCuenta( accountIds );
            //Calculo Factor del Ejecutivo
            PolizaAsignaFactorEjecutivo.process(polizaIds,this.newMap,this.oldMap);
        }else if( this.typeQueueable == 'AfterUpdate' ){
            PolizaAfterUpdateTriggerHandler clsHandler = new PolizaAfterUpdateTriggerHandler();
            clsHandler.processQueueable( this.newList, this.oldMap,  this.newMap );
        }else if( this.typeQueueable == 'AfterInsert' ){
            PolizaAfterInsertTriggerHandler clsHandler = new PolizaAfterInsertTriggerHandler();
            clsHandler.processQueueable( this.newList, this.newMap );
        }else if( this.typeQueueable == 'BeforeInsert' ){
            PolizaBeforeInsertTriggerHandler clsHandler = new PolizaBeforeInsertTriggerHandler();
            clsHandler.processQueueable( this.newList );
        }else if( this.typeQueueable == 'BeforeUpdate' ){
            PolizaBeforeUpdateTriggerHandler clsHandler = new PolizaBeforeUpdateTriggerHandler();
            clsHandler.processQueueable( this.newList, this.oldMap );
        }
    }
}