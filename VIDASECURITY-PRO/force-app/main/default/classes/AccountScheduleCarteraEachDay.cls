global class AccountScheduleCarteraEachDay implements Schedulable {
  global void execute(SchedulableContext SC) {

    List<Account> list_acc = new List<Account>([SELECT Id, Option_Cartera__c, Date_Next_Notification__c FROM Account WHERE isCartera__c = true AND Option_Cartera__c <> null AND Date_Next_Notification__c <> null AND ( OwnerId = '005i0000000ij3TAAQ' OR OwnerId = '0050H00000B7a0LQAR' ) AND Date_Next_Notification__c <= TODAY ]);
    if ( !list_acc.isEmpty() ){
      Set<Id> ids_acc = new Set<Id>();
      List<String> list_productos = new List<String>{'Seguro de Salud','Seguro de Vida','APV','Flexibles'};
      Set<Id> accountsIdsNews_Final = new Set<Id>();
      List<Account> acc_delete = new List<Account>(); 
      Set<Id> ids_delete = new Set<Id>();
      
      for(Account item : list_acc ) {
        ids_acc.add(item.Id);
      }

      for ( Poliza__c itemPoliza : [SELECT id, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:ids_acc AND RecordType.Name ='Individuales' AND Tipo_Producto__c IN:list_productos ]) {
        if( ( itemPoliza.Con_o_Sin_Ahorro__c == 'Con Ahorro' || itemPoliza.Con_o_Sin_Ahorro__c == 'Sin Ahorro' ) && !accountsIdsNews_Final.contains( itemPoliza.Cuenta__r.Id ) ) {
          accountsIdsNews_Final.add( itemPoliza.Cuenta__r.Id );
        } 
      }
      
      if ( !accountsIdsNews_Final.isEmpty() ) {
        Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();
        for(Account item : [ SELECT Id, Option_Cartera__c, Date_Next_Notification__c FROM Account WHERE Id IN: accountsIdsNews_Final ] ) {
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
        }
      }
      for ( Id ids : ids_acc ) {
        if ( !accountsIdsNews_Final.contains( ids ) ) {
          ids_delete.add(ids);
        }
      }
      if( !ids_delete.isEmpty() ){
        for ( Account item: [SELECT Id, isCartera__c, Option_Cartera__c FROM Account WHERE Id IN:ids_delete ]){
          item.isCartera__c = false;
          item.Option_Cartera__c = null;
          item.Date_Next_Notification__c = null;
          acc_delete.add(item);
        } 
        update acc_delete;
      }
    }
  }
}