/**
***********************************************************************************************************************/
public class AccountSchedulableCartera implements Schedulable{

  private Set<Id> accountsIdsCartera;
  private Integer option = 0;
  
  
  public AccountSchedulableCartera( Set<Id> accountsIdsCartera, Integer option ) { 
    List<Account> accountsUpdate = new List<Account>();
    List<Account> accountsCartera = new List<Account>();
    Set<Id> accountsIdsNews = new Set<Id>();
    Boolean optionCondition = false;
    if (  option > 1 ) { optionCondition = true; } 
    if ( !accountsIdsCartera.isEmpty() ) {
      for ( Account accItem : [SELECT id FROM account WHERE Id IN:accountsIdsCartera AND ( OwnerId = '005i0000000ij3TAAQ' OR OwnerId = '0050H00000B7a0LQAR' ) AND isCartera__c =: optionCondition  ]) {
        accountsIdsNews.add(accItem.Id);
      }
    }
    
    if ( !accountsIdsNews.isEmpty() ){
      
      this.option = option;
      String jobName = 'Account Cartera Huerfana';
      string allstring = null;
      ID idJobSchedule = null;
      List<String> list_productos = new List<String>{'Seguro de Salud','Seguro de Vida','APV','Flexibles'};
      Set<Id> accountsIdsNews_Final = new Set<Id>();


      for ( Poliza__c itemPoliza : [SELECT id, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:accountsIdsNews AND RecordType.Name ='Individuales' AND Tipo_Producto__c IN:list_productos ]) {
        if( ( itemPoliza.Con_o_Sin_Ahorro__c == 'Con Ahorro' || itemPoliza.Con_o_Sin_Ahorro__c == 'Sin Ahorro' ) && !accountsIdsNews_Final.contains( itemPoliza.Cuenta__r.Id ) ) {
          accountsIdsNews_Final.add( itemPoliza.Cuenta__r.Id );
        } 
      }
      this.accountsIdsCartera = accountsIdsNews_Final;

      List<List<String>> expression =  new List<List<String>>{
        new List<String>{ Datetime.now().addMinutes( 2 ).format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addMinutes( 2 ).format('s m H d M \'?\' yyyy') }
        //new List<String>{ Datetime.now().addDays( 5 ).format('yyyy-MM-dd HH:mm:ss.SS'), Datetime.now().addDays( 5 ).format('s m H d M \'?\' yyyy') } // 
      };
      if ( this.option == 1 && !accountsIdsNews_Final.isEmpty() ){
        idJobSchedule = system.schedule( jobName + ' cod: ' + this.option + ' ' + expression[ this.option - 1 ][0], expression[ this.option - 1 ][1] , this );
        allstring = string.valueOf(idJobSchedule);
        for ( Account item: [SELECT Id, isCartera__c, Option_Cartera__c FROM Account WHERE Id IN:accountsIdsNews_Final ]){
          item.isCartera__c = true;
          item.Option_Cartera__c = this.option;
          accountsUpdate.add(item);
        } 
        update accountsUpdate;
      } else if ( this.option == 2 && !accountsIdsNews_Final.isEmpty() ){
        Date date_next_1 =  Date.Today().addDays( 5 );
        for ( Account item: [SELECT Id, isCartera__c, Option_Cartera__c FROM Account WHERE Id IN:accountsIdsNews_Final ]){
          item.Option_Cartera__c = this.option;
          item.Date_Next_Notification__c = date_next_1;
          accountsUpdate.add(item);
        } 
        update accountsUpdate;
      }
      List<Account> acc_delete = new List<Account>(); 
      Set<Id> ids_delete = new Set<Id>();
      for ( Id ids : accountsIdsCartera ) {
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

  public void execute(SchedulableContext SC) {
    //Queueable
    AccountQueueableCartera job = new AccountQueueableCartera( this.accountsIdsCartera, this.option );
    ID jobID = System.enqueueJob(job);
  }
}