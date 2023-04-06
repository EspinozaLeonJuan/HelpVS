global class BirthdayCronJob implements Schedulable{

    global void execute(SchedulableContext SC) {
        sendmail();
    }
    
    public List<Id> getBirthdayEmailAddresses(Integer Month, Integer Day){
                
        Account[] accounts = [SELECT Id, PersonContactId
                        	  FROM Account
                        	  WHERE Recibe_Correos_Cumpleanos__c = true AND
                        	  		(Declarado_Fallecido__c != true OR
                        	  		Siniestro_Vida__c != true) AND
                        	  		Cantidad_Polizas_Activas_Todas__c >= 0 AND
                              		PersonEmail != '' AND
                        	  		DAY_IN_MONTH(PersonBirthdate) = : Day AND 
                        	  		CALENDAR_MONTH(PersonBirthdate) = : Month];
        
        List<Id> contactIds = new List<Id>();
        for(Account ac : accounts){
            contactIds.Add(ac.PersonContactId);
        }
        
        return contactIds;
    }
    
    public void sendMail(){
		
        String birthdayEmailTemplateName = 'Saludo_Cumpleanos';
        String emailFrom = 'vidasecurity@security.cl';
        Integer dayOfEvent = date.today().day();
        Integer monthOfEvent = date.today().month();
        
        List<Id> birthdayIdsList = getBirthdayEmailAddresses(monthOfEvent,dayOfEvent);
        
    	EmailTemplate birthdayTemplate = [SELECT Id, DeveloperName
                                          FROM EmailTemplate 
                                          WHERE DeveloperName = :birthdayEmailTemplateName 
                                          LIMIT 1];
        
        OrgWideEmailAddress owea = [SELECT Id 
                            		FROM OrgWideEmailAddress 
                            		WHERE Address = :emailFrom
                            		LIMIT 1];
        
        if(birthdayTemplate != null && owea != null && BirthdayIdsList.isEmpty() == false){
    		
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            for(Id idContact :birthdayIdsList) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTemplateId(birthdayTemplate.Id);
                mail.setOrgWideEmailAddressId(owea.Id);
                mail.setTargetObjectId(idContact);
                mail.setUseSignature(false);
                mail.setSaveAsActivity(false); 
                mails.add(mail);
            }
            
            try {
                Messaging.sendEmail(mails);
            }catch(Exception e){
            	System.Debug(e);
            }
		}
        else{
        	System.Debug('BirthdayCronJob:sendMail(): Either an email template could not be found, or no Accounts has a birthday today');
        }      
	}     
}