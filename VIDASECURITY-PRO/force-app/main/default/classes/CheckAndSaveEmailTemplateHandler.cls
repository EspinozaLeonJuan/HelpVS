public with sharing class CheckAndSaveEmailTemplateHandler implements TriggerHandler.HandlerInterface {
    public void handle() {
        System.debug(' --- CheckAndSaveEmailTemplateHandler BEGIN ---');
        for (EmailMessage msg : (EmailMessage[]) Trigger.new){
            String emailBody = msg.htmlBody;

            System.debug(' --- CheckAndSaveEmailTemplateHandler emailBody ---');
            System.debug(msg.htmlBody);

            if (String.isNotEmpty(emailBody))
                msg.TemplateDevName__c = getTemplateDevName(emailBody);
        }
    }

    private String getTemplateDevName(String body){
        String templateDevName;

        //String regex = '(00X)[a-zA-Z0-9]*';
        String regex = 'id="template_id" value="([^"]+)"';
        System.Pattern p = Pattern.compile(regex);
        System.Matcher m = p.matcher(body);

        System.debug(m);
        while (m.find()) {
            System.debug(' --- CheckAndSaveEmailTemplateHandler getTemplateDevName ---');
            System.debug(m.group(1));
            templateDevName = m.group(1);
        }
        System.debug(' --- CheckAndSaveEmailTemplateHandler templateDevName ---');
        System.debug(templateDevName);
        // System.assert(false, 'templateDevName FOUND: ' + templateDevName);
        return templateDevName; 
    }

}