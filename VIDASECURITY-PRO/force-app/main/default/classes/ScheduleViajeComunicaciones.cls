public class ScheduleViajeComunicaciones implements Schedulable{

  private Set<Id> accountsIdsComunication = new Set<Id>();
  private Integer option = 1;
  private Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();

  public ScheduleViajeComunicaciones( Integer option, Map<Integer,Set<Id>> map_ids ) { 
    if( !map_ids.isEmpty() ) {
      this.map_ids = map_ids;
      List<Integer> addNumber = new List<Integer>{2,2,2,2,2,2,4,8}; // PRO
      List<Poliza__c> polizasUpdate = new List<Poliza__c>();
      for( Integer i = option; i < 11; i++) {
        if ( map_ids.containsKey(i) ) {
          this.option = i;
          this.accountsIdsComunication = map_ids.get(i);
          break;
        }
      }
      if( !this.accountsIdsComunication.isEmpty() ){
        String jobName = 'Schedule Viaje Comunicaciones Iterate';
        ID idJobSchedule = null;
        List<Poliza__c> polizasComunication = new List<Poliza__c>([SELECT Id, IsViajeComunicacion__c, Option_Viaje_Comunicaciones__c, Date_Next_Notification_Comunicacion__c FROM Poliza__c WHERE Cuenta__c IN:accountsIdsComunication AND IsViajeComunicacion__c = true ]); 
        if ( !polizasComunication.isEmpty() ) {
          
          idJobSchedule = system.schedule( jobName + ' cod: ' + this.option + ' ' + Datetime.now().addMinutes( 2 ).format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 2 ).format('s m H d M \'?\' yyyy') , this );
          Date date_next_1 = Date.Today().addDays( 5 );
          if ( this.option >= 2 ){
            date_next_1 = Date.Today().addMonths( this.option == 10 ? addNumber[ this.option - 4 ] : addNumber[ this.option - 2 ] );
          } 
          for ( Poliza__c item: polizasComunication){
            item.Option_Viaje_Comunicaciones__c = this.option + 1;
            item.Date_Next_Notification_Comunicacion__c = date_next_1;
            polizasUpdate.add(item);
          } 
          if ( !polizasUpdate.isEmpty() ) { update polizasUpdate; }
        }
      } else if( option == 11 ) {
        this.accountsIdsComunication = map_ids.get(10);
        this.option = option - 2;
        List<Poliza__c> polizasComunication = new List<Poliza__c>([SELECT Id, IsViajeComunicacion__c, Option_Viaje_Comunicaciones__c, Date_Next_Notification_Comunicacion__c FROM Poliza__c WHERE Cuenta__c IN:accountsIdsComunication AND IsViajeComunicacion__c = true ]); 
        if ( !polizasComunication.isEmpty() ) {
          Date date_next_2 =  Date.Today().addMonths( addNumber[ this.option - 3 ] );
          for ( Poliza__c item: polizasComunication){
            item.Option_Viaje_Comunicaciones__c = this.option;
            item.Date_Next_Notification_Comunicacion__c = date_next_2;
            polizasUpdate.add(item);
          } 
          if ( !polizasUpdate.isEmpty() ) { update polizasUpdate; }
        }
      }
    }
  }

  public void execute(SchedulableContext SC) {
    //Queueable
    AdministrarViajeComunicaciones.execute( accountsIdsComunication, option, map_ids );
  }
}