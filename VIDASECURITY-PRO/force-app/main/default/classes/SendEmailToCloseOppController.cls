public with sharing class SendEmailToCloseOppController {
    
    @AuraEnabled
    public static String sendEmail(String oppId){

        Opportunity opp = [select id, name, (select id, Email_Suscriptor__c, Name from Quotes where Status = 'Tarificacion') 
                                                                    from Opportunity where Id = :oppId]; 
                            
        if(opp.quotes.size() == 0) return '2';

        List<Messaging.SingleEmailMessage> mailsToSend = new List<Messaging.SingleEmailMessage>();
        messaging.SingleEmailMessage singleMail;
        List<String> subsEmail;
        String body = '';
        String subject;

        for(Quote qItem : opp.quotes){
            subsEmail = new List<String>();
            //subsEmail.add('alvaro.rojas@vasslatam.com');
            if(qItem.Email_Suscriptor__c != null || qItem.Email_Suscriptor__c != '') subsEmail.add(qItem.Email_Suscriptor__c);
            
            if(subsEmail.isEmpty()) continue;
            singleMail = new messaging.SingleEmailMessage();
            singleMail.setUseSignature(false);
            singleMail.setSaveAsActivity(false);
            singleMail.setReplyTo('example@example.com');
            singleMail.setToAddresses(subsEmail);

            subject = 'Oportunidad ' + opp.Name + ' declinada';
            singleMail.setSubject(subject);

            body = 'Estimado Suscriptor (a) ,te informamos que la oportunidad ' + opp.Name + ' debe cerrarse ';
            body += '\npor lo que debe cerrar el presupuesto ' + qItem.Name  + ' asociado a esta.';
            singleMail.setPlainTextBody(body);

            mailsToSend.add(singleMail);
        } 

        if(mailsToSend.isEmpty()){
            return '1';
        } else {
            Messaging.sendEmail(mailsToSend);
            return '0';
        }
    }
}