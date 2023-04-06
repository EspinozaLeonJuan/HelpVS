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
public class AccountQueueable implements Queueable, Database.AllowsCallouts{
    
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
    private Integer option = 1;

    public AccountQueueable(Boolean blInsert, List<Account> lAccount, List<Account> lCuentas, List<Case> lCases, List<Participantes_de_Campa_a__c> lParticipantes, List<Task> lTareas, List<Id> ejecutivoIds, Set<Id> accountsIdsAMAC, Set<Id> accountsIdsCartera, Set<Id> accountsIds ) {
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

    public void execute(QueueableContext context) {
        //CallOut
        if ( !lCuentas.isEmpty() ) { AccACSEL.execute( lCuentas ); }
        //Insert o Update
        if ( !accountsIdsCartera.isEmpty() ) {
          AccountSchedulableCartera updateJob = new AccountSchedulableCartera( accountsIdsCartera, option );
        }
        if ( !accountsIdsAMAC.isEmpty() ) { CreaParticipantesAMAC.execute( accountsIdsAMAC); }
        if ( !lCases.isEmpty() ) { AccReasignarCasoPorCreacionCuenta.execute( lAccount, lCases ); }
        if ( !lParticipantes.isEmpty() ) { AccActualizaPropietarioParticipantes.execute( lParticipantes ); }
        if ( !lTareas.isEmpty() ) { AccActualizaPropietarioTareas.execute( lTareas ); }
        if ( !ejecutivoIds.isEmpty() ) { AccCalcularFactorDeEjecutivo.execute( ejecutivoIds ); }
        if ( !accountsIds.isEmpty() ) { UpdateAccountAMAC.execute(accountsIds); }
    }
}