@isTest
private class AccountScheduleCarteraIterateTest {
    static testMethod void testGeneral2(){
        Set<Id> accountsIdsCartera = new Set<Id>();
        Integer option = 1;
        Test.startTest();
        Date date_next_2 =  Date.Today();
        Account acc_1 = new Account(name= 'acc1',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=3,Date_Next_Notification__c=date_next_2);
        insert acc_1;
        Account acc2_1 = new Account(name= 'acc2',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=10,Date_Next_Notification__c=date_next_2);
        insert acc2_1;
        Account acc3_1 = new Account(name= 'acc3',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=11,Date_Next_Notification__c=date_next_2);
        insert acc3_1;
        Poliza__c poli_1 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc_1.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli_1;
        Poliza__c poli2_1 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc2_1.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli2_1;
        Poliza__c poli3_1 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc3_1.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli3_1;
        accountsIdsCartera.add(acc_1.id);
        accountsIdsCartera.add(acc2_1.id);
        accountsIdsCartera.add(acc3_1.id);
        
        Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();
        for(Account item : [ SELECT Id, Option_Cartera__c, Date_Next_Notification__c FROM Account WHERE Id IN: accountsIdsCartera ] ) {
          if ( map_ids.containsKey(item.Option_Cartera__c.intValue()) ) {
            Set<Id> ids = map_ids.get(item.Option_Cartera__c.intValue());
            ids.add(item.Id);
            map_ids.put(item.Option_Cartera__c.intValue(), ids);
          } else {
            Set<Id> ids = new Set<Id>();
            ids.add(item.Id);
            map_ids.put(item.Option_Cartera__c.intValue(), ids);
          }
        }
        if( !map_ids.isEmpty() ){
          AccountScheduleCarteraIterate updateJob = new AccountScheduleCarteraIterate( 2, map_ids );
          AccountScheduleCarteraIterate updateJob2 = new AccountScheduleCarteraIterate( 11, map_ids );
        }
        
        Test.stopTest();
    }
}