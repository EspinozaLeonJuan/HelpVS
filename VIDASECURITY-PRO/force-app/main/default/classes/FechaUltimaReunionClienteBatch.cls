global class FechaUltimaReunionClienteBatch implements Database.Batchable<AggregateResult>, Database.Stateful, Database.AllowsCallouts {
    
    private static final Integer LIMIT_MESSAGES = 2000;
    private Integer successes;
    private List<String> errors { get; set; }
    
    global FechaUltimaReunionClienteBatch() {
        this.errors = new List<String>();
        this.successes = 0;
    }
    
    global Iterable<AggregateResult> start(Database.BatchableContext bc) {
        String query = 'SELECT AccountId, MAX(startdatetime) DateEvent FROM Event WHERE Subject = \'Reunión\' AND startdatetime >= LAST_N_MONTHS:12 AND AccountId != NULL GROUP BY AccountId';
        
        return new AggregateResultIterable(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope) {
        List<Account> accounts = new List<Account>();
        for (sObject sObj : scope) {
            AggregateResult ar = (AggregateResult)sObj;
            Date dateEvent = date.valueOf(ar.get('DateEvent'));
            Account a = new Account();
            a.Id = string.valueOf(ar.get('AccountId'));
            a.Fecha_Ultima_Reunion__c = date.newinstance(dateEvent.year(), dateEvent.month(), dateEvent.day());
            if (Test.isRunningTest())
                a.Cliente_Fidelizado__c = true;            
            accounts.add(a);            
        }
        TriggerHandler.disable();
        Database.SaveResult[] sresults = Database.update(accounts, false);
        for (Integer i=0; i < sresults.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            Account account = accounts[i];
            system.debug('Cuenta dentro del for: ' + account);
            if (sresult.isSuccess()) {
                successes++;
                continue;
            }
            
            if (errors.size() >= LIMIT_MESSAGES)
                continue;
            
            for (Database.Error error : sresult.getErrors()) {
                String message = 'Error al actualizar la fecha de último reclamo de cliente ID: ' + account.Id + ' - ' + error.getMessage();
                errors.add(message);
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        if (!Test.isRunningTest() && errors.isEmpty())
            return;
        
        try {
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setSubject('[Vida Security] Reporte de Resultados de Fecha Último Reclamo Cliente');
            message.setToAddresses(new String[] {'isaac.salazar@security.cl'});
            String body = 'Se han procesado ' + successes + ' casos.\n';
            
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