@isTest
private class AccountScheduleCarteraEachDayTest {
    static testMethod void testGeneral(){
        Set<Id> accountsIdsCartera = new Set<Id>();
        Integer option = 1;
        Test.startTest();
        Date date_next_2 =  Date.Today();
        Account acc = new Account(name= 'acc1',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=2,Date_Next_Notification__c=date_next_2);
        insert acc;
        Account acc2 = new Account(name= 'acc2',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=2,Date_Next_Notification__c=date_next_2);
        insert acc2;
        Account acc3 = new Account(name= 'acc3',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=11,Date_Next_Notification__c=date_next_2);
        insert acc3;
        Poliza__c poli = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli;
        Poliza__c poli2 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc2.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli2;
        Poliza__c poli3 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc3.Id,Estatus__c = 'ANULADA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli3;
        accountsIdsCartera.add(acc.id);
        AccountScheduleCarteraEachDay m = new AccountScheduleCarteraEachDay();
		String jobID = system.schedule( 'test test' + Datetime.now().format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 1 ).format('s m H d M \'?\' yyyy') , m );
		Test.stopTest();
    }
}