global class ScheduleViajeComunicacionesTask implements Schedulable {
  global void execute(SchedulableContext SC) {

    List<String> list_productos = new List<String>{'PROYEXXIÓN'};
    List<Poliza__c> polizas_task = new List<Poliza__c>();
    List<Poliza__c> poliza_update = new List<Poliza__c>();
    Set<Id> poliza_update_AlgunaVezAlDia = new Set<Id>();
    Set<Id> poliza_update_ids_true = new Set<Id>();
    Date myDate = Date.newInstance(2021, 4, 1);

    for ( Poliza__c itemPoliza : [SELECT id, Name, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.OwnerId, Cuenta__r.PersonContactId, Cantidad_de_Meses_Sin_Pago__c, isViajeTaskCreated__c, AlgunaVezAlDia__c FROM Poliza__c 
                                  WHERE Estatus__c = 'ACTIVA' AND 
                                  IsViajeComunicacion__c = true AND 
                                  Option_Viaje_Comunicaciones__c <> null AND 
                                  Date_Next_Notification_Comunicacion__c <> null AND
                                  RecordType.Name ='PF' AND 
                                  Nombre_de_Producto__c IN:list_productos AND 
                                  Fecha_Inicio_de_Poliza__c >= :myDate ]) {
      
      if ( itemPoliza.Cantidad_de_Meses_Sin_Pago__c > 2 && itemPoliza.isViajeTaskCreated__c == false ) {
        polizas_task.add(itemPoliza);
        poliza_update_ids_true.add(itemPoliza.Id);
      } else if ( itemPoliza.AlgunaVezAlDia__c != true && itemPoliza.Cantidad_de_Meses_Sin_Pago__c <= 1 && itemPoliza.isViajeTaskCreated__c == true ) {
        poliza_update_AlgunaVezAlDia.add(itemPoliza.Id); // AlgunaVezAlDia__c = true
      } else if ( itemPoliza.AlgunaVezAlDia__c == true && itemPoliza.Cantidad_de_Meses_Sin_Pago__c > 2 && itemPoliza.isViajeTaskCreated__c == true ) {
        poliza_update.add(itemPoliza);                  // AlgunaVezAlDia__c = false ; isViajeTaskCreated__c = false
      } 
    }
    if( !polizas_task.isEmpty() ){
      List<Task> lista_polizas_task = new List<Task>();
      for ( Poliza__c item : polizas_task ) {
        Task t = new Task();
        t.ActivityDate = Date.Today();
        t.IsReminderSet = true;
        t.OwnerId = item.Cuenta__r.OwnerId;
        t.Priority = 'Normal';
        t.RecordTypeId = '0126S000001YdctQAC';
        t.ReminderDateTime = DateTime.newInstance(Date.Today().Year(), Date.Today().Month(), Date.Today().Day(), 9, 0, 0);
        t.Status = 'No iniciada';
        t.Subject = 'Recuperar Pagos PROYEXXIÓN - Póliza : ' + item.Name;
        t.WhatId = item.Cuenta__r.Id;
        t.WhoId = item.Cuenta__r.PersonContactId;
        lista_polizas_task.add(t);
      }
      if( !lista_polizas_task.isEmpty() ) {
        insert lista_polizas_task;
      }
    }
    if ( !poliza_update_ids_true.isEmpty() ) {
      List<Poliza__c> list_poliza_true = new List<Poliza__c>();
      for ( Poliza__c p : [ SELECT Id, isViajeTaskCreated__c FROM Poliza__c WHERE  Id IN:poliza_update_ids_true ] ) {
        p.isViajeTaskCreated__c = true;
        list_poliza_true.add(p);
      }
      if( !list_poliza_true.isEmpty() ) {
        update list_poliza_true;
      }
    }
    if( !poliza_update.isEmpty() ){
      List<Poliza__c> list_poliza_false = new List<Poliza__c>();
      for ( Poliza__c item : poliza_update ) {
        item.isViajeTaskCreated__c = false;
        item.AlgunaVezAlDia__c = false;
        list_poliza_false.add(item);
      }
      if( !list_poliza_false.isEmpty() ) {
        update list_poliza_false;
      }
    }
    if ( !poliza_update_AlgunaVezAlDia.isEmpty() ) {
      List<Poliza__c> list_AlgunaVezAlDia = new List<Poliza__c>();
      for ( Poliza__c p : [ SELECT Id, isViajeTaskCreated__c, AlgunaVezAlDia__c FROM Poliza__c WHERE  Id IN:poliza_update_AlgunaVezAlDia ] ) {
        p.AlgunaVezAlDia__c = true;
        list_AlgunaVezAlDia.add(p);
      }
      if( !list_AlgunaVezAlDia.isEmpty() ) {
        update list_AlgunaVezAlDia;
      }
    }
  }
}