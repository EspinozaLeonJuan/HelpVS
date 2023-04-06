/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 11-17-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PolizaSchedulable implements Schedulable{
    private static final Log log = new Log(PolizaSchedulable.class);
	private static final Integer SLEEP_MINUTES = 5;
	private static Integer queuedTimes = 0;

    private Queueable queue;
    private Boolean noChain;
    private String queueName;
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
	private Map<Id, Poliza__c> newMap = new Map<Id, Poliza__c>();
    private Map<Id, Poliza__c> oldMap = new Map<Id, Poliza__c>();
    private List<Poliza__c> newList;

    public PolizaSchedulable(Queueable queue, Boolean noChain, String typeQueueable, List<Poliza__c> newList, Map<Id, Poliza__c> oldMap,  Map<Id, Poliza__c> newMap) {
        this.queue = queue;
        this.noChain = noChain;
        this.typeQueueable = typeQueueable;
        this.newList = newList;
        if( oldMap == null ){
            this.oldMap = new Map<Id, Poliza__c>();
        }else{
            this.oldMap = oldMap;
        }
        this.newMap = newMap;
    }

    public PolizaSchedulable(Queueable queue, Boolean noChain, String typeQueueable, Boolean blInsert, Set<String> setCuentas, Set<Id> accountIds, List<Id> polizaIds, Id recordTypeIndividuales, Id recordId, Id idCampana, Set<Id> accountIds2, Set<Id> polizaIds2, Map<Id, Account> accMap, List<Participantes_de_Campa_a__c> members, List<Poliza__c> lstPoliza, Map<Id, Poliza__c> newMap, Map<Id, Poliza__c> oldMap) {
        this.queue = queue;
        this.noChain = noChain;
        this.typeQueueable = typeQueueable;
		this.queueName = String.valueOf(this.queue).split(':')[0];
		this.blInsert = blInsert;
		this.newMap = newMap;
        if( oldMap == null ){
            this.oldMap = new Map<Id, Poliza__c>();
        }else{
            this.oldMap = oldMap;
        }
        //Solo Insert
        if( blInsert ){
            this.lstPoliza = lstPoliza;
        }
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
    
	public void execute(SchedulableContext SC) {
		//Queueable
		if( this.typeQueueable == 'LOGIC' ){
            PolizaQueueable job = new PolizaQueueable(this.typeQueueable, this.blInsert, this.setCuentas, this.accountIds, this.polizaIds, this.recordTypeIndividuales, this.recordId, this.idCampana, this.accountIds2, this.polizaIds2, this.accMap, this.members, this.lstPoliza, this.oldMap, this.newMap );
            ID jobID = System.enqueueJob(job);
        }else {
            PolizaQueueable job = new PolizaQueueable(this.typeQueueable, this.newList, this.oldMap,  this.newMap);
            ID jobID = System.enqueueJob(job);
        }
	}
   
    public void schedule() {
		Decimal frequency = SLEEP_MINUTES;
		String cronexpression = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('s m H d M \'?\' yyyy');
		String jobName = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('\'Async Poliza '+ this.typeQueueable +' \'dd-MM-yyyy HH:mm:ss.SS');
        if( UtilityClass.validateScheduleName( jobName ) ){
            jobName = jobName + Math.random();
        }
		String jobId = null;
		if (!Test.isRunningTest()){
            jobID = system.schedule(jobName, cronexpression, this);
        }
	}
}