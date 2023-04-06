global class ExcepcionesDeAsignacionBatch implements  Database.Batchable<Sobject>, Database.Stateful {
    
    public class ExcepcionesDeAsignacionException extends Exception {}
    
    // Excepción de asignación para EJ SS CLIENTE / PPA
    @TestVisible
    private static Ejecutivo_de_Cliente__c EJ_SS_CLIENTE_PPA = [SELECT Id FROM Ejecutivo_de_Cliente__c WHERE Name = 'EJ SS CLIENTE / PPA' Limit 1];
    
    private static final Integer LIMIT_MESSAGES = 50;
    
    public List<String> errors {get; set;}
    private Integer successes;

    global ExcepcionesDeAsignacionBatch() {
        this.successes = 0;
        this.errors = new List<String>();
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Account WHERE (Agente_Actual__c = NULL OR Agente_Actual__r.Estado__c = \'Desvinculado\') AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) AND Id IN (Select Cuenta__c From Poliza__c Where RecordType.Name = \'Individuales\' And Estatus__c = \'ACTIVA\') AND Id NOT IN (Select Cuenta__c From Poliza__c Where RecordType.Name = \'Individuales\' And Estatus__c = \'ACTIVA\' AND (Cantidad_de_Meses_Sin_Pago__c <= 18 OR Valor_Poliza__c >= 30))';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Sobject> scope) {
        Set<Id> accountIds = new Set<Id>();
        for (Account account : (Account[])scope) {
            accountIds.add(account.Id);
        }
        Account[] accounts = [SELECT Id FROM Account WHERE Id IN :accountIds FOR UPDATE];
        for (Account account : accounts) {
            account.Ejecutivo_de_Cliente__c = EJ_SS_CLIENTE_PPA.Id;
        }
        Database.SaveResult[] sresults = Database.update(accounts, false);
        for (Integer i=0; i < sresults.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            Account account = (Account)scope[i];
            if (sresult.isSuccess()) {
                successes++;
                continue;
            }
            for (Database.Error error : sresult.getErrors()) {
                errors.add('Error al reasignar por excepción la cuenta Id: ' + account.Id + ' Error: ' + error.getMessage());
            }
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        if (!Test.isRunningTest() && errors.isEmpty())
            return;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('[Vida Security] Reporte de Resultados de Reasignación de Clientes Producto de Excepciones');
        message.setToAddresses(new String[] {'contacto@gocode.cl'});
        String body = 'Se han asignado ' + successes + ' clientes exitosamente producto de excepciones encontradas.\n';
        if (!errors.isEmpty()) {
            body += 'Se han producido los siguientes errores:\n';
            for (String error : errors)
                body += error + '\n';
                }
        message.setPlainTextBody(body);
        message.setSaveAsActivity(false);
        if (!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.Email[] {message});
            else if (!errors.isEmpty())
            throw new ExcepcionesDeAsignacionException(String.valueOf(errors));
    }
    
    public static void start() {
        ExcepcionesDeAsignacionBatch batch = new ExcepcionesDeAsignacionBatch();
        Database.executeBatch(batch, 50);
    }
}