public class AdministrarViajeComunicaciones {
  public static void execute( Set<Id> accountsIds, Integer option, Map<Integer,Set<Id>> map_ids ) {
    Integer optionNew = option + 1;
    Set<Id> acc_ids = new Set<Id>();

    if ( !accountsIds.isEmpty() ) {
      List<EmailUtils.Target> targets = new List<EmailUtils.Target>();
      List<Id> whatIds = new List<Id>();
      switch on option {
        when 1,3,5,7,9 {  // send email comunicación 1 : Invitación al cliente a la autoatención
          
          EmailTemplate[] templates = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'Plantilla_A_Autoatenci_n' AND IsActive = true ];
          if( !templates.isEmpty() && templates[0] != null ){
            for ( Poliza__c itemPoliza : [SELECT id, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:accountsIds AND Nombre_De_Producto__c = 'PROYEXXIÓN' ]) {
              if( !acc_ids.contains( itemPoliza.Cuenta__r.Id ) && itemPoliza.Cuenta__r.PersonContactId != null ) {
                acc_ids.add( itemPoliza.Cuenta__r.Id ); EmailUtils.Target target = new EmailUtils.Target(); target.recipientId = itemPoliza.Cuenta__r.PersonContactId; targets.add(target); whatIds.add(itemPoliza.Id); 
              } 
            }
            if ( !targets.isEmpty() && !whatIds.isEmpty() && ( targets.size() == whatIds.size() ) ) {
              EmailResult[] result = EmailUtils.sendEmails(targets, whatIds, 'Plantilla_A_Autoatenci_n', true);
            }
          }
          if( !Test.isRunningTest() ){ ScheduleViajeComunicaciones updateJob = new ScheduleViajeComunicaciones( optionNew, map_ids ); }
          
        }	
        when 2,4,6,8,10 {	// send email comunicación 2 : Recordatorio de los beneficios del producto
          
          EmailTemplate[] templates = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = 'Plantilla_B_PROYEXXI_N' AND IsActive = true ];
          if( !templates.isEmpty() && templates[0] != null ){
            for ( Poliza__c itemPoliza : [SELECT id, Con_o_Sin_Ahorro__c, Cuenta__c, Cuenta__r.Id, Cuenta__r.PersonEmail, Cuenta__r.PersonContactId FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND Cuenta__c IN:accountsIds AND Nombre_De_Producto__c = 'PROYEXXIÓN' ]) {
              if( !acc_ids.contains( itemPoliza.Cuenta__r.Id ) && itemPoliza.Cuenta__r.PersonContactId != null ) {
                acc_ids.add( itemPoliza.Cuenta__r.Id ); EmailUtils.Target target = new EmailUtils.Target(); target.recipientId = itemPoliza.Cuenta__r.PersonContactId; targets.add(target); whatIds.add(itemPoliza.Id); 
              } 
            }
            if ( !targets.isEmpty() && !whatIds.isEmpty() && ( targets.size() == whatIds.size() ) ) {
              EmailResult[] result = EmailUtils.sendEmails(targets, whatIds, 'Plantilla_B_PROYEXXI_N', true);
            }
          }
          if( !Test.isRunningTest() ){ ScheduleViajeComunicaciones updateJob = new ScheduleViajeComunicaciones( optionNew, map_ids ); }
        }
        when else {		  // default block, optional
            // code block 4
        }
      }
    }
  }
}