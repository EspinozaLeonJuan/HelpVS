public class AdministrarCarteraEachDay {
    public static void execute( Set<Id> accountsIds, Integer option, Map<Integer,Set<Id>> map_ids ) {
      Integer optionNew = option + 1;
      Set<Id> accountsIdsNews = new Set<Id>();
      Set<Id> acc_con_ahorro = new Set<Id>();
      Set<Id> acc_sin_ahorro = new Set<Id>();
      /* Map<Id, List<Poliza__c>> map_con_ahorro = new Map<Id,List<Poliza__c>>();
      Map<Id, List<Poliza__c>> map_sin_ahorro = new Map<Id,List<Poliza__c>>(); */
  
      if ( !accountsIds.isEmpty() ) {
        for ( Account accItem : [SELECT id FROM account WHERE Id IN:accountsIds AND ( OwnerId = '005i0000000ij3TAAQ' OR OwnerId = '0050H00000B7a0LQAR' ) ]) {
          accountsIdsNews.add(accItem.Id);
        }
      }
  
      if ( !accountsIdsNews.isEmpty() ) {
        List<EmailUtils.Target> targets = new List<EmailUtils.Target>();
        List<Id> whatIds = new List<Id>();
        List<Id> EmailTemplatesId = new List<Id>();
        switch on option {
          when 1,3,5,7,9 {  // send email comunicación 1 : Invitación al cliente a la autoatención
            String emailTemplateAId_1 = null;
            String emailTemplateAId_2 = null;
            Map<String,Id> mapTemplateA = new Map<String,Id>();
            List<EmailTemplate> emailTemplateA = new List<EmailTemplate>([SELECT Id, Name FROM EmailTemplate WHERE Name LIKE '%Plantilla A %' AND IsActive = true ]);
            for ( EmailTemplate itemTemplate : emailTemplateA ) {
              mapTemplateA.put(itemTemplate.Name, itemTemplate.Id);
            }
            emailTemplateAId_1 = mapTemplateA.get('Plantilla A Con Ahorro');
            emailTemplateAId_2 = mapTemplateA.get('Plantilla A Sin Ahorro');
  
            for ( Poliza__c itemPoliza : [SELECT id, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:accountsIdsNews ]) {
              if( itemPoliza.Con_o_Sin_Ahorro__c == 'Con Ahorro' && !acc_con_ahorro.contains( itemPoliza.Cuenta__r.Id ) ) {
                acc_con_ahorro.add( itemPoliza.Cuenta__r.Id );
              } else if ( itemPoliza.Con_o_Sin_Ahorro__c == 'Sin Ahorro' && !acc_sin_ahorro.contains( itemPoliza.Cuenta__r.Id) ){
                acc_sin_ahorro.add( itemPoliza.Cuenta__r.Id );
              }
            }
  
            for ( Account acc : [SELECT Id, PersonEmail, PersonContactId FROM Account WHERE Id IN:accountsIdsNews]) {
              if ( acc_con_ahorro.contains(acc.Id) && emailTemplateAId_1 != null && acc.PersonContactId != null ){ EmailUtils.Target target = new EmailUtils.Target(); target.recipientId = acc.PersonContactId; targets.add(target); whatIds.add(acc.Id); EmailTemplatesId.add(emailTemplateAId_1); 
              
              } else if ( acc_sin_ahorro.contains(acc.Id) && emailTemplateAId_2 != null && acc.PersonContactId != null ) { EmailUtils.Target target = new EmailUtils.Target(); target.recipientId = acc.PersonContactId; targets.add(target); whatIds.add(acc.Id); EmailTemplatesId.add(emailTemplateAId_2);
              }
            } 
            if ( !targets.isEmpty() && !whatIds.isEmpty() && !EmailTemplatesId.isEmpty() && ( targets.size() == whatIds.size() ) && ( whatIds.size() == EmailTemplatesId.size() )  ) { EmailResult[] result =  EmailUtils.sendEmails(targets, whatIds, EmailTemplatesId);
            }
            if( !Test.isRunningTest() ){ AccountScheduleCarteraIterate updateJob = new AccountScheduleCarteraIterate( optionNew, map_ids ); }
          }	
          when 2,4,6,8,10 {	// send email comunicación 2 : Recordatorio de los beneficios del producto
            String emailTemplateBId = null;
            Map<String,Id> mapTemplateB = new Map<String,Id>();
            List<EmailTemplate> emailTemplateB = new List<EmailTemplate>([SELECT Id, Name FROM EmailTemplate WHERE Name LIKE '%Plantilla B %' AND IsActive = true ]);
            if ( !emailTemplateB.isEmpty() ) {
              for ( EmailTemplate itemTemplate : emailTemplateB ) {
                mapTemplateB.put(itemTemplate.Name, itemTemplate.Id);
              }
              for ( Poliza__c itemPoliza : [SELECT id, Cuenta__c, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId, Tipo_Producto__c FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:accountsIdsNews ]) {
                emailTemplateBId = null;
                emailTemplateBId = mapTemplateB.get('Plantilla B ' + itemPoliza.Tipo_Producto__c);
                if ( emailTemplateBId != null && itemPoliza.Cuenta__r.PersonContactId != null ) { EmailUtils.Target target = new EmailUtils.Target(); target.recipientId = itemPoliza.Cuenta__r.PersonContactId; targets.add(target); whatIds.add(itemPoliza.Id); EmailTemplatesId.add(emailTemplateBId);
                }
              }
              if ( !targets.isEmpty() && !whatIds.isEmpty() && !EmailTemplatesId.isEmpty() && ( targets.size() == whatIds.size() ) && ( whatIds.size() == EmailTemplatesId.size() )  ) { EmailResult[] result =  EmailUtils.sendEmails(targets, whatIds, EmailTemplatesId);
              }
            }
            if( !Test.isRunningTest() ){ AccountScheduleCarteraIterate updateJob = new AccountScheduleCarteraIterate( optionNew, map_ids ); }
          }
          when else {		  // default block, optional
              // code block 4
          }
        }
      }
    }
}