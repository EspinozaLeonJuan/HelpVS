global class BAT_NotificacionValeVista implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {   
    public String IdCarga;
    private Integer successes;
    private Integer successesEmail;
    private List<String> errors { get; set; }
    private static final Integer LIMIT_MESSAGES = 2000;
    private static final String EMAIL_ORIGEN = 'contactovida@security.cl';
	private OrgWideEmailAddress fromAddress;
    
    global BAT_NotificacionValeVista(string idCarga) {
        this.IdCarga = idCarga;      
        this.successes = 0;
        this.errors = new List<String>();
        this.successesEmail = 0;
        
        OrgWideEmailAddress[] fromAddresses = [select id, Address, DisplayName FROM OrgWideEmailAddress WHERE Address = :EMAIL_ORIGEN];
		fromAddress = null;
		if (!fromAddresses.isEmpty())
			fromAddress = fromAddresses[0];
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {       
        String query = 'SELECT Id, Name, RUT__c, Monto__c, Fecha_Vale_Vista__c, Empresa__c, Tipo__c, Notificado__c, Carga_Vale_Vista__c, Email__c, Cuenta__c, Resultado__c, Tms_Notificacion__c, Es_Notificable__c FROM Registro_Vale_Vista__c WHERE Carga_Vale_Vista__c = \'' + IdCarga + '\' AND Es_Notificable__c = true';
        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        List <Registro_Vale_Vista__c> lstvv2 = new List<Registro_Vale_Vista__c>();
        Registro_Vale_Vista__c[] lstvv = new Registro_Vale_Vista__c[]{};
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        EmailTemplate template = null;
        Set<Id> accountIds = new Set<Id>();
        
        system.debug('@@@@ scope ' + scope);
        
        for (sObject sObj : scope) {
            Registro_Vale_Vista__c vvcObj = (Registro_Vale_Vista__c)sObj;
            accountIds.add(vvcObj.Cuenta__c);
        }
        
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, PersonContactId FROM Account WHERE Id IN :accountIds]);
        TriggerHandler.disable();
        for (sObject sObj : scope) {
            Registro_Vale_Vista__c vvcObj = (Registro_Vale_Vista__c)sObj;
            
            if (vvcObj.Empresa__c == 'VIDA')
            {
                template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Vale_Viste_Pendiente_Vida' LIMIT 1];
            }            
            else
            {
                template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Vale_Vista_Pendiente_SBS' LIMIT 1];
            }
            
            Account account = accountMap.get(vvcObj.Cuenta__c);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
      		if (fromAddress != null)
				message.setOrgWideEmailAddressId(fromAddress.Id);
            message.setTargetObjectId(account.PersonContactId);
            message.setWhatId(vvcObj.Id);
            message.setTemplateId(template.Id);
            message.setSaveAsActivity(true);
            messages.add(message);
            lstvv.add(vvcObj);
        }
        
        Messaging.reserveSingleEmailCapacity(messages.size());

        try 
        {
            
            Messaging.SendEmailResult[] emailResults = new  Messaging.SendEmailResult[1];
            
            if (!Test.isRunningTest())
            {
            	emailResults = Messaging.sendEmail(messages, false);    
            } 
           
            system.debug('@@@@ emailResults: ' + emailResults);
            Integer cont = 0;
            
            for (Messaging.SendEmailResult emailResult : emailResults) {
                Boolean exito = true;
                if (!Test.isRunningTest())
                {
                    exito = emailResult.isSuccess();    
                    System.debug('emailResult: ' + emailResult.isSuccess());
                } 
                
                if (exito) {
                    lstvv[cont].Notificado__c = true;
                    lstvv[cont].Tms_Notificacion__c = Date.today();
                    successesEmail++;
                } else {
                    lstvv[cont].Notificado__c = false;
                    lstvv[cont].Tms_Notificacion__c = Date.today();
                }
                cont++;                
            }
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
         
        Database.SaveResult[] sresults = Database.update(lstvv, false);
        system.debug('@@@@ sresults: ' + sresults);        
        for (Integer i=0; i < sresults.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            system.debug('@@@@ sresult ' + sresults[i]);
            Registro_Vale_Vista__c vvcObj = lstvv[i];
            system.debug('Vale Vista dentro del for: ' + vvcObj);
            if (sresult.isSuccess()) {
                successes++;
                continue;
            }
            
            if (errors.size() >= LIMIT_MESSAGES)
                continue;
            
            for (Database.Error error : sresult.getErrors()) {
                String message = 'Error al actualizar el registro de vale vista: ' + vvcObj.Id + ' - ' + error.getMessage();
                errors.add(message);
            }
        }
        if (!Test.isRunningTest())
        {
        	Carga_Vale_Vista__c carga = [SELECT Id, Total_Registros_Ok__c FROM Carga_Vale_Vista__c WHERE Id = :IdCarga FOR UPDATE];
        	carga.Total_Registros_Notificados__c = successesEmail;
        	upsert carga;    
        }        
    }

    global void finish(Database.BatchableContext bc) {
        system.debug('@@@@ inicio envio correo');
        system.debug('@@@@ errors ' + errors);
        system.debug('@@@@ successes ' + successes);
        if (!Test.isRunningTest() && errors.isEmpty())
            return;
        
        try {
            system.debug('@@@@ errors ' + errors);
            system.debug('@@@@ successes ' + successes);
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('[Vida Security] Reporte de Resultados de Notificaciones Vale Vista por Cobrar');
            message.setToAddresses(new String[] {'juan.espinoza@ext-security.cl'});
            String body = 'Se han procesado ' + successes + ' registros.\n';
            
            if (!errors.isEmpty()) {
                body += 'Se han producido los siguientes errores:\n';
                for (String error : errors)
                    body += error + '\n';
            }
            message.setPlainTextBody(body);
            message.setSaveAsActivity(false);
            
            if (!Test.isRunningTest())
                Messaging.sendEmail(new Messaging.Email[] {message});
        } catch (Exception e) {
            system.debug('@@@@ finish Exception: ' + e.getMessage());
        }
    }

}