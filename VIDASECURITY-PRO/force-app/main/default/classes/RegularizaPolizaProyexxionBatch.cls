global with sharing class RegularizaPolizaProyexxionBatch implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
  private List<string> errorCollection {get; set;}
  global RegularizaPolizaProyexxionBatch() {
		errorCollection = new List<String>();
	  system.debug('Pasa RegularizaPolizaProyexxionBatch');
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    Date myDate = Date.newInstance(2021, 4, 1);
    List<String> list_productos = new List<String>{'PROYEXXIÓN'}; 
    String query ='SELECT id, RecordTypeId FROM Poliza__c ' +
                  'WHERE RecordType.Name <> \'PF\' AND ' +
                  'Nombre_de_Producto__c IN:list_productos LIMIT 500 ';
    system.debug('@@@ query : ' + query );
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Sobject> scope) {
    try {
      system.debug('@@@ scope : ' + (Poliza__c[])scope);
      List<Poliza__c> list_pol_update = new List<Poliza__c>();

      for( Poliza__c item : (Poliza__c[])scope ){
        item.RecordTypeId = '012i0000001IVdVAAW';
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
    RegularizaPolizaProyexxionBatch batch = new RegularizaPolizaProyexxionBatch();
    system.debug('@@@ batch : ' + batch);
    Database.executeBatch(batch, 50);
  }
}