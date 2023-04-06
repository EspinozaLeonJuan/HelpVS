/**
 * Alex Coillo
***********************************************************************************************************************/
@IsTest
private class AccountQueueableCarteraTest {

    static testMethod void testGeneral(){
      Test.startTest();
      Set<Id> accountsIdsCartera = new Set<Id>();
      Integer option = 1;
      AccountQueueableCartera cuentaQueueable = new AccountQueueableCartera(accountsIdsCartera, option); 
      System.enqueueJob(cuentaQueueable); 
      Test.stopTest();
    }
}