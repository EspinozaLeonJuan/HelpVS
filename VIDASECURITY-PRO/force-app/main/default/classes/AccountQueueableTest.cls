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
private class AccountQueueableTest {

    static testMethod void testGeneral(){
        if(!TestVerificationService.ShouldExecute('AccountQueueableTest.testGeneral')){return;}
        /**********************************************************************************/
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').save();
        AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
		
        Test.startTest();
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
        AccountQueueable cuentaQueueable = new AccountQueueable(blInsert,lAccount,lCuentas,lCases,lParticipantes,lTareas,ejecutivoIds,accountsIdsAMAC,accountsIdsCartera,accountsIds); 
	    System.enqueueJob(cuentaQueueable); 
        Test.stopTest();
    }
}