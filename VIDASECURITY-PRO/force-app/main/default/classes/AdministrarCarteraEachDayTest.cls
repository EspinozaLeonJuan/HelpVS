@isTest
private class AdministrarCarteraEachDayTest {
    static testMethod void testGeneral3(){
        Set<Id> accountsIdsCartera = new Set<Id>();
        Integer option = 1;
        Test.startTest();
        Date date_next_2 =  Date.Today();
        Account acc_2 = new Account(name= 'acc1',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=3,Date_Next_Notification__c=date_next_2);
        insert acc_2;
        Account acc2_2 = new Account(name= 'acc2',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=10,Date_Next_Notification__c=date_next_2);
        insert acc2_2;
        Account acc3_2 = new Account(name= 'acc3',ownerId='005i0000000ij3TAAQ',isCartera__c=true,Option_Cartera__c=11,Date_Next_Notification__c=date_next_2);
        insert acc3_2;
        Poliza__c poli_2 = new Poliza__c(Con_o_Sin_Ahorro__c='Con Ahorro',Cuenta__c=acc_2.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='APV');
        insert poli_2;
        Poliza__c poli2_2 = new Poliza__c(Con_o_Sin_Ahorro__c='Con Ahorro',Cuenta__c=acc2_2.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli2_2;
        Poliza__c poli3_2 = new Poliza__c(Con_o_Sin_Ahorro__c='Sin Ahorro',Cuenta__c=acc3_2.Id,Estatus__c = 'ACTIVA',RecordTypeId ='012i0000001I5MeAAK',Tipo_Producto__c='Seguro de Salud');
        insert poli3_2;
        accountsIdsCartera.add(acc_2.id);
        accountsIdsCartera.add(acc2_2.id);
        accountsIdsCartera.add(acc3_2.id);
            secondProccess2(accountsIdsCartera,3 );
        
        
        
    Test.stopTest();
    }
	
 @future
  static void secondProccess2(Set<Id> accountsIdsCartera, Integer option)
  {
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
      
    EmailTemplate newTemplate = new EmailTemplate(name='Plantilla A Con Ahorro',DeveloperName='Plantilla_A_Con_Ahorro', subject='aea', TemplateType='Custom',FolderId='005i0000000ij3TAAQ',IsActive = true);
    upsert newTemplate;
    EmailTemplate newTemplate2 = new EmailTemplate(name='Plantilla B APV',DeveloperName='Plantilla_B_APV', subject='aea', TemplateType='Custom',FolderId='005i0000000ij3TAAQ',IsActive = true);
    upsert newTemplate2;
          AdministrarCarteraEachDay.execute( accountsIdsCartera, 3, map_ids );
          AdministrarCarteraEachDay.execute( accountsIdsCartera, 10, map_ids );
  }
}