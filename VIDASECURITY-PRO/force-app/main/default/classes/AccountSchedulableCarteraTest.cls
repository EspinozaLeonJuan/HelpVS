/**
 * Alex Coillo
***********************************************************************************************************************/
@IsTest
private class AccountSchedulableCarteraTest {
    
    static testMethod void testGeneral(){
        Set<Id> accountsIdsCartera = new Set<Id>();
        Integer option = 1;
        Test.startTest();
        Account acc = new Account(name= 'acc1',ownerId='005i0000000ij3TAAQ');
        insert acc;
        Poliza__c poli = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli;
        accountsIdsCartera.add(acc.id);
        AccountQueueableCartera queue = new AccountQueueableCartera(accountsIdsCartera, option);
        AccountSchedulableCartera updateJob = new AccountSchedulableCartera( accountsIdsCartera, option );
        AccountQueueableCartera queue2 = new AccountQueueableCartera(accountsIdsCartera, option);
        AccountSchedulableCartera updateJob2 = new AccountSchedulableCartera( accountsIdsCartera, 3 );
        Test.stopTest();
    }
}