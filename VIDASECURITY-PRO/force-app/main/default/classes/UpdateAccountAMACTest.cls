/**
***********************************************************************************************************************/
@isTest
private class UpdateAccountAMACTest {
    @isTest static void UpdateAccountAMACTest(){
        Test.startTest();
        Account acc_2 = new Account(name= 'acc_2',recordtypeId ='012i0000000UrxnAAC', ultima_actualizacion_amac__c = DateTime.now() , Rut__c ='3781561', DV__c='6');
        insert acc_2;
        if (acc_2.Id != null ) {
            Set<Id> acc_set = new Set<Id>();
            acc_set.add( acc_2.Id );
            UpdateAccountAMAC.execute( acc_set );
            List<Account> acc = new List<Account>([SELECT Id, ultima_actualizacion_amac__c FROM Account WHERE Id = :acc_2.Id LIMIT 1 ]);
            System.assertEquals( TRUE, acc[0].ultima_actualizacion_amac__c == null,'@@@ UpdateAccountAMACTest : La cuenta no fue actualizada correctamente');
        }
        Test.stopTest();
    }
}