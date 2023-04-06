global with sharing class BatchOpportunityDaysToClose implements Database.Batchable<Sobject>, Database.AllowsCallouts, Database.Stateful {
  private List<string> errorCollection {get; set;}
  global BatchOpportunityDaysToClose() {
		errorCollection = new List<String>();
	  system.debug('Pasa BatchOpportunityDaysToClose');
  }

  global Database.QueryLocator start(Database.BatchableContext BC) {
    String query = 'SELECT Id, Name, AccountId, Account.Name, RecordType.Id, Account.IsPersonAccount, Account.Rut_contacto__pc, Account.DV_contacto__pc, Account.Rut__c, Account.DV__c, RecordType.Name, Days_To_Close__c, Tipo_Cotizaci_n__c, OwnerId FROM Opportunity ' +
                   'WHERE RecordType.Id = \'0126S000001UbVLQA0\' AND ' +
                   '( ( Tipo_Cotizaci_n__c = \'Renta Gold (Provada)\' AND (Days_To_Close__c = 7 OR Days_To_Close__c = 12 ) ) OR ' +
                   '( Tipo_Cotizaci_n__c = \'Life Max\' AND ( Days_To_Close__c = 14 OR Days_To_Close__c = 25 ) ) )';
    system.debug('@@@ query : ' + query );
    return Database.getQueryLocator(query);
  }

  global void execute(Database.BatchableContext BC, List<Sobject> scope) {
    try {
      system.debug('@@@ scope : ' + (Opportunity[])scope);

      List<EmailUtils.Target> targets = new List<EmailUtils.Target>();
      List<Id> whatIds = new List<Id>();
      List<String> HtmlBody = new List<String>();
      Map<Id,List<Opportunity>> map_opp = new Map<Id,List<Opportunity>>();

      for(Opportunity item : (Opportunity[])scope){
        if ( map_opp.containsKey(item.OwnerId) ) {
          List<Opportunity> list_opp = map_opp.get(item.OwnerId);
          list_opp.add(item);
          map_opp.put(item.OwnerId, list_opp);
        } else {
          List<Opportunity> list_opp = new List<Opportunity>();
          list_opp.add(item);
          map_opp.put(item.OwnerId, list_opp);
        }
      } 

      CustomNotificationType notificationType = 
      [SELECT Id, DeveloperName 
       FROM CustomNotificationType 
       WHERE DeveloperName='Cotizaciones_Alto_Patrimonio'];

      if ( !map_opp.isEmpty() ) {
        for( Id index : map_opp.keySet() ) {
          String body = '';
          for( Opportunity opp : map_opp.get(index) ) {
            String rut = opp.Account.IsPersonAccount ? (opp.Account.Rut_contacto__pc + '-' + opp.Account.DV_contacto__pc) : opp.Account.Rut__c + '-' + opp.Account.DV__c;
            body += '<tr><td><a href="https://vidasecurity.my.salesforce.com/' + opp.Id +'" target="_blank"> ' + opp.Name + '</a></td>';
            body += '<td> ' + opp.Days_To_Close__c.intValue() + '</td>'; 
            body += '<td> ' + opp.Tipo_Cotizaci_n__c + '</td>'; 
            body += '<td><a href="https://vidasecurity.my.salesforce.com/' + opp.AccountId +'" target="_blank"> ' + opp.Account.Name + '</a></td>';
            body += '<td> ' + rut + '</td></tr>';
            
            if ( notificationType != null ) {
              try {
                Set<String> key_set_map = new Set<String>();
                Messaging.CustomNotification notification = new Messaging.CustomNotification();
                //List<Messaging.CustomNotification> messages = new List<Messaging.CustomNotification>();
                notification.setTitle('Oportunidad próxima a la Fecha Cierre');
                notification.setBody('La Oportunidad: '+ opp.Name +' con el RUT: '+ rut +' está a '+ opp.Days_To_Close__c.intValue() +' días de su Fecha Cierre.');
                notification.setNotificationTypeId(notificationType.Id);
                notification.setTargetId(opp.Id);
                key_set_map.add(index);
                notification.send(key_set_map);
              }
              catch (Exception e) {
                  System.debug('Problem sending notification: ' + e.getMessage());
              }
            }
          }
          EmailUtils.Target target = new EmailUtils.Target(); 
          List<String> list_cc = new List<String>();
          list_cc.add('0056S00000FIdGnQAL');
          target.recipientId = index;
          target.cc = list_cc;
          targets.add(target);
          HtmlBody.add(body);
        }
        if ( !targets.isEmpty() && !HtmlBody.isEmpty() && ( targets.size() == HtmlBody.size() ) ) {
          EmailResult[] result =  EmailUtils.sendEmails(targets, whatIds, HtmlBody);
        }
      }
    } catch (Exception e) {
      String errorMsg = e.getTypeName() + ' - ' + e.getMessage() + ' - ' + e.getStackTraceString();
      system.debug('@@@ errorMsg : ' + errorMsg);
    }
  }
    
  global void finish(Database.BatchableContext bc) {
    system.debug('@@@ Finish ');
  }
  
  global static void start() {
    BatchOpportunityDaysToClose batch = new BatchOpportunityDaysToClose();
    system.debug('@@@ batch : ' + batch);
    Database.executeBatch(batch, 50);
  }
}