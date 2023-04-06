// Caso 00005525 -(Garantía) Enviar mails de fidelización 
public class NotificacionCarteraDesatendidaProcess implements Schedulable {
    
    
    private static final Integer MONTHS_LIMIT_RULE = -6;
    private static final String EMAIL_TEMPLATE = 'Carta_Recordatoria_Ejecutiva_Automatica';
    private static final String GENERIC_EMAIL_SENDER = 'sfvida@security.cl';

    public void execute(SchedulableContext sc) {

        //create date criteria  
        Date dateMonthsAgo = Date.today().addMonths(MONTHS_LIMIT_RULE);

       // System.debug('dateMonthsAgo: ' + dateMonthsAgo);

        //query to get accounts following date criteria
        Account[] accounts = [SELECT Id, Owner.Email, PersonContactId, OwnerId, PersonEmail FROM Account 
                            WHERE Fecha_Ultima_Actividad__c <= :dateMonthsAgo 
                            AND Owner.IsActive = true 
                            AND Owner.Ejecutivo_de_Cliente__c = true
                            AND Owner.Ausente__c = false    
                            AND Cantidad_Polizas_Activas__c > 0];

        //creating a owner.email lista
        Set<String> ownerEmails = new Set<String>();
        //first add generic email, to optimize number of querys to OrgWideEmailAddress later
        ownerEmails.add(GENERIC_EMAIL_SENDER);
        for (Account account : accounts){       
            //Just for testing purpose
            if (!ownerEmails.contains(account.Owner.Email))
                ownerEmails.add(account.Owner.Email);

           // System.debug('account.Owner.Email: ' + account.Owner.Email);
        }

        //System.debug('ownerEmails lenght: ' + ownerEmails.size());

        //get email Addresses that are contain in ownerEmails List
        OrgWideEmailAddress[] fromAddresses = [select id, Address, DisplayName 
                                                FROM OrgWideEmailAddress WHERE Address IN :ownerEmails];

        //System.debug('fromAddresses lenght: ' + fromAddresses.size());

        //create a map ownerEmail(Address) / orgWideEmailAddress
        Map<String,OrgWideEmailAddress> mapFromAddresses =   new Map<String,OrgWideEmailAddress>();
        for (OrgWideEmailAddress fromAddress : fromAddresses){
            mapFromAddresses.put(fromAddress.Address, fromAddress);
          //  System.debug('fromAddress: ' + fromAddress.Address);
        }

        //get email template
        EmailTemplate[] emailTemplates = [SELECT Id, Body FROM EmailTemplate 
                                WHERE DeveloperName = :EMAIL_TEMPLATE AND IsActive = true LIMIT 1];
                                System.assertEquals(1, emailTemplates.size(), 'La plantilla de correo llamada ' + EMAIL_TEMPLATE + ' no existe o está inactiva');
                                EmailTemplate emailTemplate = emailTemplates[0];

        //System.debug('emailTemplate: ' + emailTemplate);
        //email List
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        Integer emailsToSend = 4000; // Este valor no se encuentra en la clase Limits, solo está disponible via REST API y como este es un proceso programado no rtenemos Session Id para conseguirlo. Usar la Partner API se descarta por motivos de seguridad.

        
        //create email list to send
        List<Task> tasks = new List<Task>();
        for (Account account : accounts) {
                        if (messages.size() == emailsToSend)
            break;
            Task task = new Task(Status='Completada', OwnerId = account.OwnerId, WhatId = account.Id, ActivityDate = Date.today(), Fecha_de_cierre__c = Date.today(), Subject = 'Correo Electrónico', Description = emailTemplate.Body, WhoId = account.PersonContactId);
            tasks.add(task);

            //preparing email for each account
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(account.PersonContactId );
            message.setWhatId(account.Id);
            message.setTemplateId(emailTemplate.Id);
            OrgWideEmailAddress orgWideEmailAddress;
            if (mapFromAddresses.containsKey(account.Owner.Email)){
                orgWideEmailAddress = mapFromAddresses.get(account.Owner.Email);
            }
            else{
                orgWideEmailAddress = mapFromAddresses.get(GENERIC_EMAIL_SENDER);
            }
            message.setOrgWideEmailAddressId(orgWideEmailAddress.Id);
            message.setSaveAsActivity(false);
            messages.add(message);
        }
        insert tasks;
        //System.debug('estoy imprimiendo tasks'+ tasks);
        //System.debug('estoy imprimiendo messages'+ messages);

        //saving memory
        Messaging.reserveSingleEmailCapacity(messages.size());

        if (!Test.isRunningTest()) {
            Messaging.SendEmailResult[] emailResults = Messaging.sendEmail(messages);
            for (Messaging.SendEmailResult emailResult : emailResults) { 
                System.debug('emailResult: ' + emailResult.isSuccess());
            }   
        }



    }
}