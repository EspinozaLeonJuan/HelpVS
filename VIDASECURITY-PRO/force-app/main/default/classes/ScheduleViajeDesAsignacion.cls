public class ScheduleViajeDesAsignacion {

  public static Id getPolizaId( Poliza__c polizaOld, Poliza__c polizaNew ){
    if( ( polizaOld.IsViajeComunicacion__c == true && polizaNew.IsViajeComunicacion__c == false ) ||
        ( polizaOld.Estatus__c == 'ACTIVA' &&  polizaNew.Estatus__c != 'ACTIVA' && polizaNew.IsViajeComunicacion__c == true ) ||
        ( polizaOld.Nombre_de_Producto__c == 'PROYEXXIÓN' &&  polizaNew.Nombre_de_Producto__c != 'PROYEXXIÓN' && polizaNew.IsViajeComunicacion__c == true ) ||
        ( polizaOld.Fecha_Inicio_de_Poliza__c >= Date.newInstance(2021, 4, 1) &&  polizaNew.Fecha_Inicio_de_Poliza__c < Date.newInstance(2021, 4, 1) && polizaNew.IsViajeComunicacion__c == true ) ){
      return polizaNew.Id;
    }
    return null;
  }

  public static void execute( Poliza__c polizaNew, Set<Id> idPolizas ) {
    if( !idPolizas.isEmpty() && idPolizas.contains( polizaNew.Id ) ) {
      polizaNew.IsViajeComunicacion__c = false;
      polizaNew.Option_Viaje_Comunicaciones__c = null;
      polizaNew.Date_Next_Notification_Comunicacion__c = null;
    }
  }

}