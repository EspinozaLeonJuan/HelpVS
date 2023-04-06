/**
***********************************************************************************************************************/
@isTest
private class CTR_CS_Sincronizar_EjecutivoTest {
    @isTest static void CTR_CS_Sincronizar_EjecutivoTest(){
        Test.startTest();
        Account acc_1 = new Account(name= 'acc_1',recordtypeId ='012i0000000UrxnAAC', Rut__c ='3781561', DV__c='6');
        insert acc_1;
        ApexPages.StandardController standard = new ApexPages.StandardController(acc_1);
		CTR_CS_Sincronizar_Ejecutivo sincro = new CTR_CS_Sincronizar_Ejecutivo(standard);    
        sincro.Id_Account = acc_1.Id;
        sincro.success = false;
        sincro.Msg = '';
        sincro.actualizar_account();
        List<Account> acc = new List<Account>([SELECT Id, Sincronizar_Ejecutivo__c FROM Account WHERE Id = :acc_1.Id LIMIT 1 ]);
        System.assertEquals( TRUE, acc[0].Sincronizar_Ejecutivo__c,'La cuenta no fué actualizada correctamente');
        Test.stopTest();
    }
}