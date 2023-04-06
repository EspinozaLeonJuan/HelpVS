global class ScheduleViajeComunicacionesEachDay implements Schedulable {
  global void execute(SchedulableContext SC) {
    Date myDate = Date.newInstance(2021, 4, 1);
    Set<Id> accountsIdsNews_Final = new Set<Id>();
    List<String> list_productos = new List<String>{'PROYEXXIÓN'}; 
    Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();
    
    for ( Poliza__c itemPoliza : [SELECT id, Cuenta__c, Cuenta__r.Id, Option_Viaje_Comunicaciones__c, Date_Next_Notification_Comunicacion__c FROM Poliza__c 
                                  WHERE Estatus__c = 'ACTIVA' AND 
                                  IsViajeComunicacion__c = true AND 
                                  Option_Viaje_Comunicaciones__c <> null AND 
                                  Date_Next_Notification_Comunicacion__c <> null AND
                                  RecordType.Name ='PF' AND 
                                  Nombre_de_Producto__c IN:list_productos AND 
                                  Fecha_Inicio_de_Poliza__c >= :myDate AND 
                                  Date_Next_Notification_Comunicacion__c <= TODAY 
                                  ORDER BY Date_Next_Notification_Comunicacion__c ASC LIMIT 300 ]) {                 
      if( !accountsIdsNews_Final.contains( itemPoliza.Cuenta__r.Id ) ) {
        accountsIdsNews_Final.add( itemPoliza.Cuenta__r.Id );
        if ( map_ids.containsKey(itemPoliza.Option_Viaje_Comunicaciones__c.intValue()) ) {
          Set<Id> ids = map_ids.get(itemPoliza.Option_Viaje_Comunicaciones__c.intValue());
          ids.add(itemPoliza.Cuenta__r.Id);
          map_ids.put(itemPoliza.Option_Viaje_Comunicaciones__c.intValue(), ids);
        } else {
          Set<Id> ids = new Set<Id>();
          ids.add(itemPoliza.Cuenta__r.Id);
          map_ids.put(itemPoliza.Option_Viaje_Comunicaciones__c.intValue(), ids);
        }
      } 
    }
    if( !map_ids.isEmpty() ){
      ScheduleViajeComunicaciones updateJob = new ScheduleViajeComunicaciones( 1, map_ids );
    }
  }
}