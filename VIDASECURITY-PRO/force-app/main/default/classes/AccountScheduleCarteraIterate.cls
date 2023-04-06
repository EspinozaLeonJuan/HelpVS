public class AccountScheduleCarteraIterate implements Schedulable{

  private Set<Id> accountsIdsCartera = new Set<Id>();
  private Integer option = 2;
  private Map<Integer,Set<Id>> map_ids = new Map<Integer,Set<Id>>();

  public AccountScheduleCarteraIterate( Integer option, Map<Integer,Set<Id>> map_ids ) { 
    if( !map_ids.isEmpty() ) {
      this.map_ids = map_ids;
      List<Integer> addNumber = new List<Integer>{2,2,2,2,2,2,4,8}; // PRO
      List<Account> accountsUpdate = new List<Account>();
      for( Integer i = option; i < 11; i++) {
        if ( map_ids.containsKey(i) ) {
          this.option = i;
          this.accountsIdsCartera = map_ids.get(i);
          break;
        }
      }
      if( !this.accountsIdsCartera.isEmpty() ){
        String jobName = 'Account Cartera Huerfana Iterate';
        ID idJobSchedule = null;
        List<Account> accountsCartera = [select Id, isCartera__c, Option_Cartera__c, Date_Next_Notification__c from Account where id IN:accountsIdsCartera AND isCartera__c = true ]; 
        if ( !accountsCartera.isEmpty() ) {
          
          idJobSchedule = system.schedule( jobName + ' cod: ' + this.option + ' ' + Datetime.now().addMinutes( 2 ).format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 2 ).format('s m H d M \'?\' yyyy') , this );

          if ( this.option >= 2 ){
            Date date_next_2 =  Date.Today().addMonths( this.option == 10 ? addNumber[ this.option - 4 ] : addNumber[ this.option - 2 ] );
            for ( Account item: accountsCartera){
              item.Option_Cartera__c = this.option + 1;
              item.Date_Next_Notification__c = date_next_2;
              accountsUpdate.add(item);
            } 
            update accountsUpdate;
          }

        }
      } else if( option == 11 ) {
        this.accountsIdsCartera = map_ids.get(10);
        this.option = option - 2;
        List<Account> accountsCartera = [select Id, isCartera__c, Option_Cartera__c, Date_Next_Notification__c from Account where id IN:accountsIdsCartera AND isCartera__c = true ]; 
        if ( !accountsCartera.isEmpty() ) {
          Date date_next_2 =  Date.Today().addMonths( addNumber[ this.option - 3 ] );
          for ( Account item: accountsCartera){
            item.Option_Cartera__c = this.option;
            item.Date_Next_Notification__c = date_next_2;
            accountsUpdate.add(item);
          } 
          update accountsUpdate;
        }
      }
    }
  }

  public void execute(SchedulableContext SC) {
    //Queueable
    AdministrarCarteraEachDay.execute( accountsIdsCartera, option, map_ids );
  }
}