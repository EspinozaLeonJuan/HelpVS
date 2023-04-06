trigger PolizaColectivoTrigger on Poliza_Colectivo__c (before insert, before update) {

  if ( Trigger.isInsert == true ) {
    Set<Id> id_accounts = new Set<Id>();
    Set<Id> id_polizas = new Set<Id>();
    Map<Id,Id> map_ids = new Map<Id,Id>();
    Map<Id,Id> map_ids_fail = new Map<Id,Id>();

    for (Poliza_Colectivo__c item_pc : (Poliza_Colectivo__c[])Trigger.new) {
      if ( !id_accounts.contains( item_pc.cuenta__c ) ) {
        id_accounts.add(item_pc.cuenta__c);
      }
      if ( !id_polizas.contains( item_pc.poliza__c ) ) {
        id_polizas.add(item_pc.poliza__c);
      }
      if ( item_pc.cuenta__c != null && item_pc.poliza__c != null ) {
        map_ids.put( item_pc.cuenta__c, item_pc.poliza__c );
      }
    }
    
    for ( Poliza_Colectivo__c pcole : [SELECT Id, Name, Cuenta__c, Cuenta__r.Id, Poliza__c, Poliza__r.Id FROM Poliza_Colectivo__c WHERE Cuenta__c IN:id_accounts AND Poliza__c IN:id_polizas ] ){
      if ( map_ids.containsKey( pcole.Cuenta__c ) && ( pcole.Poliza__c == map_ids.get( pcole.Cuenta__c ) ) ) {
        map_ids_fail.put( pcole.cuenta__c, pcole.poliza__c );
      }
    }

    if ( !map_ids_fail.isEmpty() ) {
      for (Poliza_Colectivo__c item : (Poliza_Colectivo__c[])Trigger.new) {
        if ( map_ids_fail.containsKey( item.Cuenta__c ) && ( item.Poliza__c == map_ids_fail.get( item.Cuenta__c ) ) ) {
          if( !Test.isRunningTest() ){ item.addError('Error de duplicidad, el registro que quiere insertar coincide con otro registro con la misma Cuenta y Póliza'); 
          }
        }
      }
    }

  } else if ( Trigger.isUpdate == true ){
    Set<Id> id_accounts = new Set<Id>();
    Set<Id> id_polizas = new Set<Id>();
    Map<Id,Id> map_ids = new Map<Id,Id>();
    Map<Id,Id> map_ids_fail = new Map<Id,Id>();

    for( Poliza_Colectivo__c newPolizaColectivo: Trigger.newMap.values()) {
      Poliza_Colectivo__c oldPolizaColectivo = Trigger.oldMap.get(newPolizaColectivo.Id);
      if ( newPolizaColectivo.Cuenta__c != oldPolizaColectivo.Cuenta__c || 
      newPolizaColectivo.Poliza__c != oldPolizaColectivo.Poliza__c ) {
        if ( !id_accounts.contains( newPolizaColectivo.cuenta__c ) ) {
          id_accounts.add(newPolizaColectivo.cuenta__c);
        }
        if ( !id_polizas.contains( newPolizaColectivo.poliza__c ) ) {
          id_polizas.add(newPolizaColectivo.poliza__c);
        }
        if ( newPolizaColectivo.cuenta__c != null && newPolizaColectivo.poliza__c != null ) {
          map_ids.put( newPolizaColectivo.cuenta__c, newPolizaColectivo.poliza__c );
        }
      }
    }
    for ( Poliza_Colectivo__c pcole : [SELECT Id, Name, Cuenta__c, Cuenta__r.Id, Poliza__c, Poliza__r.Id FROM Poliza_Colectivo__c WHERE Cuenta__c IN:id_accounts AND Poliza__c IN:id_polizas ] ){
      if ( map_ids.containsKey( pcole.Cuenta__c ) && ( pcole.Poliza__c == map_ids.get( pcole.Cuenta__c ) ) ) {
        map_ids_fail.put( pcole.cuenta__c, pcole.poliza__c );
      }
    }

    if ( !map_ids_fail.isEmpty() ) {
      for (Poliza_Colectivo__c item : (Poliza_Colectivo__c[])Trigger.new) {
        if ( map_ids_fail.containsKey( item.Cuenta__c ) && ( item.Poliza__c == map_ids_fail.get( item.Cuenta__c ) ) ) {
          if( !Test.isRunningTest() ){ item.addError('Error de duplicidad, el registro que quiere insertar coincide con otro registro con la misma Cuenta y Póliza'); 
          }
        }
      }
    }
  }
  
   new TriggerHandler()
        .bind(TriggerHandler.BEFORE_INSERT_UPDATE, new AsignaReferenciasASuscripcionHandler())
        .manage();
}