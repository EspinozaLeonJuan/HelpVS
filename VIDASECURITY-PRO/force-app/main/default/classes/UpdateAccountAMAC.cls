public class UpdateAccountAMAC {
  public static void execute( Set<Id> accountsIds ){
    if ( !accountsIds.isEmpty() ) {
      List<Account> lista_acc = new List<Account>();
      for ( Account item : [ SELECT Id, ultima_actualizacion_amac__c, Sincronizar_Ejecutivo__c FROM Account WHERE Id IN :accountsIds AND ultima_actualizacion_amac__c <> NULL ]) {
        Account acc = new Account();
        acc.Id = item.Id;
        acc.Sincronizar_Ejecutivo__c = false;
        acc.ultima_actualizacion_amac__c = null;
        lista_acc.add(acc);
      }
      try {
        if ( !lista_acc.isEmpty() ) {
          update lista_acc;
          System.debug('@@@ SUCCESS');
        }
      } catch(DmlException e) {
          System.debug('@@@ ERROR : ' + e.getMessage());
      }
    }
  }
}