global with sharing class ScheduleViajeComunicacionesBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
  private List<string> errorCollection {get; set;}
  global ScheduleViajeComunicacionesBatch() {
		errorCollection = new List<String>();
	  system.debug('Pasa ScheduleViajeComunicacionesBatch');
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    Date myDate = Date.newInstance(2021, 4, 1);
    List<String> list_productos = new List<String>{'PROYEXXIÓN'}; 
    String query ='SELECT id, Option_Viaje_Comunicaciones__c, Date_Next_Notification_Comunicacion__c FROM Poliza__c ' +
                  'WHERE Estatus__c = \'ACTIVA\' AND ' +
                  'IsViajeComunicacion__c <> true AND ' +
                  'Option_Viaje_Comunicaciones__c = null AND ' +
                  'Date_Next_Notification_Comunicacion__c = null AND ' +
                  'RecordType.Name =\'PF\' AND ' +
                  'Nombre_de_Producto__c IN:list_productos AND ' +
                  'Fecha_Inicio_de_Poliza__c >= :myDate LIMIT 200 ';
    system.debug('@@@ query : ' + query );
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Sobject> scope) {
    try {
      system.debug('@@@ scope : ' + (Poliza__c[])scope);
      List<Poliza__c> list_pol_update = new List<Poliza__c>();

      for( Poliza__c item : (Poliza__c[])scope ){
        item.IsViajeComunicacion__c = true;
        item.Option_Viaje_Comunicaciones__c = 1;
        item.Date_Next_Notification_Comunicacion__c = Date.Today();
        list_pol_update.add(item);
      } 
      if ( !list_pol_update.isEmpty() ) { update list_pol_update; }
      
    } catch (Exception e) {
      String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString();
      system.debug('@@@ errorMsg : ' + errorMsg);
    }
  }
    
  global void finish(Database.BatchableContext bc) {
    system.debug('@@@ Finish ');
  }
  
  global static void start() {
    ScheduleViajeComunicacionesBatch batch = new ScheduleViajeComunicacionesBatch();
    system.debug('@@@ batch : ' + batch);
    Database.executeBatch(batch, 50);
  }
}