global class ExcepcionesDeAsignacionProcess implements Schedulable {
    
    
    public class ExcepcionesDeAsignacionException extends Exception {}
    
    @TestVisible
    private static Ejecutivo_de_Cliente__c EJ_SS_CLIENTE_PPA = [SELECT Id, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Name = 'Angélica Meza I.' Limit 1];

    @TestVisible
    private static User SF_VIDA = [SELECT Id FROM User WHERE CommunityNickname = 'sfvida' Limit 1];
    
    @TestVisible
    private static Ejecutivo_de_Cliente__c EJ_EJECUTIVO = [SELECT Id, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Name = 'SIN EJECUTIVO' Limit 1];    
        
    public static void start() {
        List<String> errors = new List<String>();
        Integer successes = 0;
        Ejecutivo_de_Cliente__c[] ejecutivos = [SELECT Id, Usuario__c FROM Ejecutivo_de_Cliente__c];
        Map<Id, Ejecutivo_de_Cliente__c> ejecutivoMap = new Map<Id, Ejecutivo_de_Cliente__c>();
        for (Ejecutivo_de_Cliente__c ejecutivo : ejecutivos) {
            ejecutivoMap.put(ejecutivo.Usuario__c, ejecutivo);
        }
        
        Set<Id> cuentasPagadasIds = new Set<Id>();
        Poliza__c[] polizas = [SELECT Cuenta__c FROM Poliza__c WHERE RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA' AND Cantidad_de_Meses_Sin_Pago__c <= 3 AND Cuenta__r.Ejecutivo_de_Cliente__c = :EJ_SS_CLIENTE_PPA.Id];
        for (Poliza__c poliza : polizas) {
            if (poliza.Cuenta__c != null && !cuentasPagadasIds.contains(poliza.Cuenta__c))
                cuentasPagadasIds.add(poliza.Cuenta__c);
        }

        // Desmarcamos todo lo que deja de cumplir la condición
        Account[] accounts = [SELECT Id, OwnerId FROM Account WHERE Ejecutivo_de_Cliente__c = :EJ_SS_CLIENTE_PPA.Id AND ((Owner.IsActive = true AND Owner.Ejecutivo_de_Cliente__c = true) OR Agente_Actual__r.Estado__c = 'Vigente' OR Id IN :cuentasPagadasIds OR Cantidad_Polizas_Activas__c = 0) LIMIT 1000 FOR UPDATE];
        for (Account account : accounts) {
            account.Ejecutivo_de_Cliente__c = EJ_EJECUTIVO.Id;
            account.OwnerId = SF_VIDA.Id;
        }
        
        Database.SaveResult[] sresults = Database.update(accounts, false);
        for (Integer i=0; i < sresults.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            Account account = (Account)accounts[i];
            if (sresult.isSuccess()) {
                successes++;
                continue;
            }
            for (Database.Error error : sresult.getErrors()) {
                errors.add('Error al reasignar por excepción la cuenta Id: ' + account.Id + ' Error: ' + error.getMessage());
            }
        }

        if (!Test.isRunningTest())
        {
           accounts = [SELECT Id FROM Account WHERE Ejecutivo_de_Cliente__c <> :EJ_SS_CLIENTE_PPA.Id AND (Agente_Actual__r.Estado__c = 'Desvinculado' OR Agente_Actual__r.Estado__c = 'Cambio de Cargo') AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) AND Cantidad_Polizas_Activas__c > 0 AND Categoria_del_cliente__r.Name NOT IN ('A','B','C') AND Ciudad_Particular_B__r.name = 'SANTIAGO' AND Id NOT IN (Select Cuenta__c From Poliza__c Where RecordType.Name ='Individuales' And Estatus__c = 'ACTIVA' AND ((Cantidad_de_Meses_Sin_Pago__c <= 3 AND Frecuencia_de_Pago__c = 'M' )OR  (Cantidad_de_Meses_Sin_Pago__c <= 5 AND Frecuencia_de_Pago__c = 'T' ) OR  (Cantidad_de_Meses_Sin_Pago__c <= 8 AND Frecuencia_de_Pago__c = 'S' ) OR (Cantidad_de_Meses_Sin_Pago__c <= 14 AND Frecuencia_de_Pago__c = 'A' ))) LIMIT 1000 FOR UPDATE];

        }
        else
        {    
            accounts = [SELECT Id FROM Account LIMIT 10000 FOR UPDATE];  
        }
        
        system.debug('@@@@ asignacion ppa');
        for (Account account : accounts) {
            account.Ejecutivo_de_Cliente__c = EJ_SS_CLIENTE_PPA.Id;
            account.OwnerId = EJ_SS_CLIENTE_PPA.Usuario__c;
        }
        sresults = Database.update(accounts, false);
        for (Integer i=0; i < sresults.size(); i++) {
            Database.SaveResult sresult = sresults[i];
            Account account = (Account)accounts[i];
            if (sresult.isSuccess()) {
                successes++;
                continue;
            }
            for (Database.Error error : sresult.getErrors()) {
                errors.add('Error al reasignar por excepción la cuenta Id: ' + account.Id + ' Error: ' + error.getMessage());
            }
        }
        
        if (!Test.isRunningTest() && errors.isEmpty())
            return;
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('[Vida Security] Reporte de Resultados de Reasignación de Clientes Producto de Excepciones');
        message.setToAddresses(new String[] {'juan.espinoza@security.cl'});
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
    
    global void execute(SchedulableContext sc) {
        //ExcepcionesDeAsignacionBatch.start();
        start();
    }
    
}