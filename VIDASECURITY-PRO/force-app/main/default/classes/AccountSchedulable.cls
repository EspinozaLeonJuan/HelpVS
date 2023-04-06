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
* @version   1.0    17/11/2021     Javier Tibamoza JATC	       Class Created
***********************************************************************************************************************/
public class AccountSchedulable implements Schedulable{

    private static final Log log = new Log(AccountSchedulable.class);
	private static final Integer SLEEP_MINUTES = 3;
	private static Integer queuedTimes = 0;

    private Queueable queue;
    private Boolean noChain;
    private String queueName;

    private Boolean blInsert;
    private List<Account> lAccount;
    private List<Account> lCuentas;
    private List<Case> lCases;
    private List<Participantes_de_Campa_a__c> lParticipantes;
    private List<Task> lTareas;
    private List<Id> ejecutivoIds;
    private Set<Id> accountsIdsAMAC;
    private Set<Id> accountsIdsCartera;
    private Set<Id> accountsIds;

    public AccountSchedulable(Queueable queue, Boolean noChain, Boolean blInsert, List<Account> lAccount, List<Account> lCuentas, List<Case> lCases, List<Participantes_de_Campa_a__c> lParticipantes, List<Task> lTareas, List<Id> ejecutivoIds, Set<Id> accountsIdsAMAC, Set<Id> accountsIdsCartera, Set<Id> accountsIds ) {
        this.blInsert = blInsert;
        this.lAccount = lAccount;
        this.lCuentas = lCuentas;
        this.lCases = lCases;
        this.lParticipantes = lParticipantes;
        this.lTareas = lTareas;
        this.ejecutivoIds = ejecutivoIds;
        this.accountsIdsAMAC = accountsIdsAMAC;
        this.accountsIdsCartera = accountsIdsCartera;
        this.accountsIds = accountsIds;
    }

    public void execute(SchedulableContext SC) {
		//Queueable
        AccountQueueable job = new AccountQueueable(this.blInsert, this.lAccount, this.lCuentas, this.lCases, this.lParticipantes, this.lTareas, this.ejecutivoIds, this.accountsIdsAMAC, this.accountsIdsCartera, this.accountsIds );
		ID jobID = System.enqueueJob(job);
	}

    public void schedule() {
		Decimal frequency = SLEEP_MINUTES;
		String cronexpression = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('s m H d M \'?\' yyyy');
        String jobName = Datetime.now().addMinutes(Integer.valueOf(frequency)).format('\'Async  Account \'dd-MM-yyyy HH:mm:ss.SS');
		if( UtilityClass.validateScheduleName( jobName ) ){
            jobName = jobName + Math.random();
        }
		String jobId = null;
		if( !Test.isRunningTest() ){
            jobID = system.schedule( jobName, cronexpression, this);
        }
	}
}