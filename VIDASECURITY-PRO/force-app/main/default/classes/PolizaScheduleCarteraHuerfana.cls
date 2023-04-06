global class PolizaScheduleCarteraHuerfana implements Schedulable {
  global void execute(SchedulableContext SC) {

      List<Account> list_acc = new List<Account>([SELECT Id, Option_Cartera__c, Date_Next_Notification__c FROM Account WHERE isCartera__c = true AND Option_Cartera__c <> null AND Date_Next_Notification__c <> null AND ( OwnerId = '005i0000000ij3TAAQ' OR OwnerId = '0050H00000B7a0LQAR' ) ]);
      
      Set<Id> ids_acc = new Set<Id>();
      List<String> list_productos = new List<String>{'Seguro de Salud','Seguro de Vida','APV','Flexibles'};
      List<Poliza__c> poliza_task_sin_ahorro = new List<Poliza__c>();
      List<Poliza__c> poliza_task_con_ahorro = new List<Poliza__c>();
      List<Poliza__c> poliza_update = new List<Poliza__c>();
      Set<Id> poliza_update_AlgunaVezAlDia = new Set<Id>();
      Set<Id> poliza_update_ids_true = new Set<Id>();
      
      for(Account item : list_acc ) {
        ids_acc.add(item.Id);
      }

    for ( Poliza__c itemPoliza : [SELECT id, Name, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.OwnerId, Cuenta__r.PersonContactId, Cantidad_de_Meses_Sin_Pago__c, isCarteraTaskCreated__c, AlgunaVezAlDia__c FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:ids_acc AND RecordType.Name ='Individuales' AND Tipo_Producto__c IN:list_productos AND ( Con_o_Sin_Ahorro__c = 'Con Ahorro' OR Con_o_Sin_Ahorro__c = 'Sin Ahorro' ) ]) {
      
      if ( itemPoliza.Cantidad_de_Meses_Sin_Pago__c > 2 && itemPoliza.isCarteraTaskCreated__c == false ) {
        if ( itemPoliza.Con_o_Sin_Ahorro__c == 'Sin Ahorro' ) {
          poliza_task_sin_ahorro.add(itemPoliza);
          poliza_update_ids_true.add(itemPoliza.Id);
        } else if ( itemPoliza.Cantidad_de_Meses_Sin_Pago__c >= 4 ) {
          poliza_task_con_ahorro.add(itemPoliza);
          poliza_update_ids_true.add(itemPoliza.Id);
        }
      } else if ( itemPoliza.AlgunaVezAlDia__c != true && itemPoliza.Cantidad_de_Meses_Sin_Pago__c <= 1 && itemPoliza.isCarteraTaskCreated__c == true ) {
        poliza_update_AlgunaVezAlDia.add(itemPoliza.Id); // AlgunaVezAlDia__c = true
      } else if ( itemPoliza.AlgunaVezAlDia__c == true && itemPoliza.Cantidad_de_Meses_Sin_Pago__c > 2 && itemPoliza.isCarteraTaskCreated__c == true ) {
        poliza_update.add(itemPoliza);                  // AlgunaVezAlDia__c = false ; isCarteraTaskCreated__c = false
      } 
    }
    if( !poliza_task_sin_ahorro.isEmpty() ){
      List<Task> list_task_sin_ahorro = new List<Task>();
      for ( Poliza__c item : poliza_task_sin_ahorro ) {
        Task t = new Task();
        t.ActivityDate = Date.Today();
        t.IsReminderSet = true;
        t.OwnerId = item.Cuenta__r.OwnerId;
        t.Priority = 'Normal';
        t.RecordTypeId = '0126S000001YdctQAC';
        t.ReminderDateTime = DateTime.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().Day(), 8, 0, 0);
        t.Status = 'No iniciada';
        t.Subject = 'Recuperar Pagos Cartera Huérfana - Póliza sin ahorro : ' + item.Name;
        t.WhatId = item.Cuenta__r.Id;
        t.WhoId = item.Cuenta__r.PersonContactId;
        list_task_sin_ahorro.add(t);
      }
      if( !list_task_sin_ahorro.isEmpty() ) {
        insert list_task_sin_ahorro;
      }
    }
    if( !poliza_task_con_ahorro.isEmpty() ){
      List<Task> list_task_con_ahorro = new List<Task>();
      for ( Poliza__c item : poliza_task_con_ahorro ) {
        Task t = new Task();
        t.ActivityDate = Date.Today();
        t.IsReminderSet = true;
        t.OwnerId = item.Cuenta__r.OwnerId;
        t.Priority = 'Normal';
        t.RecordTypeId = '0126S000001YdctQAC';
        t.ReminderDateTime = DateTime.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().Day(), 8, 0, 0);
        t.Status = 'No iniciada';
        t.Subject = 'Recuperar Pagos Cartera Huérfana - Póliza con ahorro : ' + item.Name;
        t.WhatId = item.Cuenta__r.Id;
        t.WhoId = item.Cuenta__r.PersonContactId;
        list_task_con_ahorro.add(t);
      }
      if( !list_task_con_ahorro.isEmpty() ) {
        insert list_task_con_ahorro;
      }
    }
    if ( !poliza_update_ids_true.isEmpty() ) {
      List<Poliza__c> list_poliza_true = new List<Poliza__c>();
      for ( Poliza__c p : [ SELECT Id, isCarteraTaskCreated__c FROM Poliza__c WHERE  Id IN:poliza_update_ids_true ] ) {
        p.isCarteraTaskCreated__c = true;
        list_poliza_true.add(p);
      }
      if( !list_poliza_true.isEmpty() ) {
        update list_poliza_true;
      }
    }
    if( !poliza_update.isEmpty() ){
      List<Poliza__c> list_poliza_false = new List<Poliza__c>();
      for ( Poliza__c item : poliza_update ) {
        item.isCarteraTaskCreated__c = false;
        item.AlgunaVezAlDia__c = false;
        list_poliza_false.add(item);
      }
      if( !list_poliza_false.isEmpty() ) {
        update list_poliza_false;
      }
    }
    if ( !poliza_update_AlgunaVezAlDia.isEmpty() ) {
      List<Poliza__c> list_AlgunaVezAlDia = new List<Poliza__c>();
      for ( Poliza__c p : [ SELECT Id, isCarteraTaskCreated__c, AlgunaVezAlDia__c FROM Poliza__c WHERE  Id IN:poliza_update_AlgunaVezAlDia ] ) {
        p.AlgunaVezAlDia__c = true;
        list_AlgunaVezAlDia.add(p);
      }
      if( !list_AlgunaVezAlDia.isEmpty() ) {
        update list_AlgunaVezAlDia;
      }
    }
  }
}