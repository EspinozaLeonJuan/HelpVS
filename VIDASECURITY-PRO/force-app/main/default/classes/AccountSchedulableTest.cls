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
* @version   1.0    25/11/2021     Javier Tibamoza JATC	       Class Created
***********************************************************************************************************************/
@IsTest
private class AccountSchedulableTest {
    
    static testMethod void testGeneral(){
        if(!TestVerificationService.ShouldExecute('AccountSchedulableTest.testGeneral')){return;}
        /**********************************************************************************/
        String CRON_EXP = '0 0 0 15 3 ? *';
        Boolean blInsert=false;
        List<Account> lAccount = new List<Account>();
        List<Account> lCuentas = new List<Account>();
        List<Case> lCases = new List<Case>();
        List<Participantes_de_Campa_a__c> lParticipantes = new List<Participantes_de_Campa_a__c>();
        List<Task> lTareas = new List<Task>();
        List<Id> ejecutivoIds = new List<Id>();
        Set<Id> accountsIdsAMAC = new Set<Id>();
        Set<Id> accountsIdsCartera = new Set<Id>();
        Set<Id> accountsIds = new Set<Id>();
        AccountQueueable queue = new AccountQueueable(blInsert,lAccount,lCuentas,lCases,lParticipantes,lTareas,ejecutivoIds,accountsIdsAMAC, accountsIdsCartera,accountsIds); 
        Boolean noChain = false;
        Test.startTest();
        AccountSchedulable schAccount = new AccountSchedulable(queue,noChain,blInsert,lAccount,lCuentas,lCases,lParticipantes,lTareas,ejecutivoIds,accountsIdsAMAC, accountsIdsCartera,accountsIds);
        String jobId = System.schedule('AccountSchedulable', CRON_EXP,schAccount);
        Test.stopTest();
    }

    static testMethod void testSchedule(){
        if(!TestVerificationService.ShouldExecute('AccountSchedulableTest.testSchedule')){return;}
        /**********************************************************************************/
        String CRON_EXP = '0 0 0 15 3 ? *';
        Boolean blInsert=false;
        List<Account> lAccount = new List<Account>();
        List<Account> lCuentas = new List<Account>();
        List<Case> lCases = new List<Case>();
        List<Participantes_de_Campa_a__c> lParticipantes = new List<Participantes_de_Campa_a__c>();
        List<Task> lTareas = new List<Task>();
        List<Id> ejecutivoIds = new List<Id>();
        Set<Id> accountsIdsAMAC = new Set<Id>();
        Set<Id> accountsIdsCartera = new Set<Id>();
        Set<Id> accountsIds = new Set<Id>();
        AccountQueueable queue = new AccountQueueable(blInsert,lAccount,lCuentas,lCases,lParticipantes,lTareas,ejecutivoIds,accountsIdsAMAC, accountsIdsCartera,accountsIds); 
        Boolean noChain = false;
        Test.startTest();
        AccountSchedulable schAccount = new AccountSchedulable(queue,noChain,blInsert,lAccount,lCuentas,lCases,lParticipantes,lTareas,ejecutivoIds,accountsIdsAMAC, accountsIdsCartera,accountsIds);
        schAccount.schedule();
        Test.stopTest();
    }
}