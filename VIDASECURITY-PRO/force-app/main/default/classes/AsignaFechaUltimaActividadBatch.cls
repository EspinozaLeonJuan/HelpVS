global class AsignaFechaUltimaActividadBatch  implements Database.Batchable<Sobject>, Database.Stateful, Schedulable {
    
    private static final Integer LIMIT_MESSAGES = 2000;
    private static final Config__c config = Config__c.getOrgDefaults();
    
    public List<String> errors {get; set;}
    private Integer successes;
    private Datetime fromDate;
    
    global AsignaFechaUltimaActividadBatch() {
        this.successes = 0;
        this.errors = new List<String>();
        Integer diasAtras = config == null ? 0 : Integer.valueOf(config.Dias_Fecha_Ultima_Actividad__c == null ? 0 : config.Dias_Fecha_Ultima_Actividad__c);
        this.fromDate = diasAtras == null || diasAtras == 0 ? null : Datetime.now().addDays(-diasAtras);
    } 

    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        if (fromDate == null)
            return Database.getQueryLocator('SELECT Id FROM Account WHERE CreatedDate > TOMORROW'); // hack to disable batch.
        Set<Id> accountIds = new Set<Id>();
        System.debug('fromDate : ' +fromDate);
        Task[] tasks = [SELECT AccountId, OwnerId, Account.OwnerId FROM Task WHERE Status = 'Completada' AND ((ActivityDate > :fromDate.date() AND ActivityDate <= TODAY) OR (Fecha_de_cierre__c  > :fromDate.date() AND Fecha_de_cierre__c <= TODAY AND Fecha_de_cierre__c!=NULL)) ];
        for (Task task : tasks) {
            if (task.AccountId != null && task.Account.OwnerId == task.OwnerId && !accountIds.contains(task.AccountId))
                accountIds.add(task.AccountId);
        }
        Event[] events = [SELECT AccountId, OwnerId, Account.OwnerId FROM Event WHERE ENDDateTime > :fromDate AND EndDateTime <= :Datetime.now()];
        for (Event event : events) {
            if (event.AccountId != null && event.Account.OwnerId == event.OwnerId && !accountIds.contains(event.AccountId))
                accountIds.add(event.AccountId);
        }
        System.debug('Cuentas antes de la query ' + accountIds);

        String query = 'SELECT Id, Fecha_Ultima_Actividad__c, OwnerId FROM Account WHERE Cliente_No_Contactar__c = FALSE AND Cantidad_Polizas_Activas__c > 0 AND Owner.Ejecutivo_de_Cliente__c = true AND (Id IN :accountIds OR Fecha_Ultima_Actividad__c = NULL)';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        Set<Id> accountIds = new Set<Id>();
        for (Account account : (Account[])scope) {
            if (account.Id != null && !accountIds.contains(account.Id))
                accountIds.add(account.Id);
        }
        System.debug('accountIds ' +accountIds );
        Map<Id, Date> taskDateMap = new Map<Id, Date>();
        Task[] tasks = [SELECT AccountId, Subject, ActivityDate, Fecha_de_cierre__c, OwnerId, Account.OwnerId FROM Task WHERE (NOT Subject Like 'Correo electrónico masivo%') AND ( (ActivityDate > :fromDate.date() AND ActivityDate <= TODAY) OR (Fecha_de_cierre__c  > :fromDate.date() AND Fecha_de_cierre__c <= TODAY) OR Account.Fecha_Ultima_Actividad__c = NULL) AND Status = 'Completada' AND AccountId IN :accountIds  ORDER BY AccountId, ActivityDate DESC];
        System.debug('Tareas encontradas ' + tasks);
        for (Task task : tasks) {
            System.debug('(task.ActivityDate != null || task.Fecha_de_cierre__c != null) ' + (task.ActivityDate != null || task.Fecha_de_cierre__c != null));
            System.debug('(task.Account.OwnerId == task.OwnerId) ' + (task.Account.OwnerId == task.OwnerId));

            if ( (task.ActivityDate != null || task.Fecha_de_cierre__c != null) && task.Account.OwnerId == task.OwnerId && !taskDateMap.containsKey(task.AccountId)){
                Date fechaTarea = task.Fecha_de_cierre__c == null ? task.ActivityDate : task.Fecha_de_cierre__c;
                taskDateMap.put(task.AccountId, fechaTarea);
            }
            
            
            }
                    
        Map<Id, Datetime> eventDateMap = new Map<Id, Datetime>();
        Event[] events = [SELECT AccountId, Subject, EndDatetime, OwnerId, Account.OwnerId FROM Event WHERE (NOT Subject Like 'Correo electrónico masivo%') AND ((EndDatetime > :fromDate AND EndDatetime <= :Datetime.now()) OR Account.Fecha_Ultima_Actividad__c = NULL) AND AccountId IN :accountIds  ORDER BY AccountId, EndDatetime DESC];
        System.debug('Eventos encontrados ' + events);
        for (Event event : events) {
            if (event.EndDatetime != null && event.Account.OwnerId == event.OwnerId && !eventDateMap.containsKey(event.AccountId))
            eventDateMap.put(event.AccountId, event.EndDatetime);
        }
                    
        for (Account account : (Account[])scope) {
            Date taskDate = taskDateMap.get(account.Id);
            Datetime eventDatetime = eventDateMap.get(account.Id);
            Date eventDate = eventDatetime == null ? null : eventDatetime.date();
            Date lastDate = (taskDate == null ? eventDate : (eventDate == null ? taskDate : (taskDate < eventDate ? eventDate : taskDate)));
            if(lastDate!=null)
                account.Fecha_Ultima_Actividad__c = lastDate;
        }
        Database.SaveResult[] results = Database.update(scope, false);
        for (Integer i=0; i < results.size(); i++) {
            Database.SaveResult result = results[i];
            Account account = (account)scope[i];
            if (result.isSuccess()) {
                successes++;
            continue;
            }
            for (Database.Error error : result.getErrors()) {
                errors.add('Ocurrió un error al actualizar la cuenta con ID: ' + account.Id + ', ERROR: ' + error.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext BC){
        if (!errors.isEmpty() || Test.isRunningTest())
            sendEmails();
    }
    

    public void sendEmails(){
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('[Vida Security] Reporte de Errores de Actualización de Fecha de Ultima Actividad');
        message.setToAddresses(new String[] {'contacto@gocode.cl'});
        String body = 'Se han calculado ' + successes + ' fechas de última actividad exitosamente.\n';
        if (!errors.isEmpty()) {
            body += 'Se han producido los siguientes errores:\n';
            for (String error : errors)
                body += error + '\n';
                }
        message.setPlainTextBody(body);
        message.setSaveAsActivity(false);
        if (!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.Email[] {message});
    }

    
    global void execute(SchedulableContext sc) {
        AsignaFechaUltimaActividadBatch batch = new AsignaFechaUltimaActividadBatch();
        Database.executeBatch(batch);
    }
}