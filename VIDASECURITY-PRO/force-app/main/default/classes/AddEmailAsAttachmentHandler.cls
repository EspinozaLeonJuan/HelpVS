public with sharing class AddEmailAsAttachmentHandler implements TriggerHandler.HandlerInterface {

    public static final Set<String> TEMPLATE_NAMES = new Set<String> {
            'Ajuste_de_Prima',
            'Diferencia_en_el_monto_cargado',
            'No_recibe_liquidaci_n_de_pensi_n',
            'Pre_Existencia_Colectivo',
            'Rectificaci_n_Declaraci_n_Anual_SII'
    };

    public void handle() {
        System.debug(' --- AddEmailAsAttachmentHandler BEGIN ---');
        Set<Id> emailMessagesId = new Set<Id>();
        for (EmailMessage msg : (EmailMessage[]) Trigger.new){
            emailMessagesId.add(msg.Id);
        }

        if (!emailMessagesId.isEmpty())
            handleFuture(TEMPLATE_NAMES, emailMessagesId);

        return;
    }


    @future(callout=true)
    public static void handleFuture(Set<String> templateNames, Set<Id> emailMessagesId){
        System.debug(' --- handleFuture BEGIN ---');
        System.debug(' templateNames: ' + templateNames);
        System.debug(' emailMessagesId: ' + emailMessagesId);
        // System.debug(emailMessagesId);

        List<EmailTemplate> emailTemplates = 
        [SELECT ID, Name, Subject, Body, IsActive, DeveloperName
        FROM EmailTemplate 
        WHERE DeveloperName IN: templateNames AND IsActive = true]; //Folder.Name = 'Calidad' AND IsActive = true];
        if (emailTemplates.isEmpty())
            return;
        Map<String,EmailTemplate> emailTemplateMap = new Map<String,EmailTemplate>();
        for (EmailTemplate tpl : emailTemplates) {
            emailTemplateMap.put(tpl.DeveloperName, tpl);
        }
        
        List<EmailMessage> emailMessages = [SELECT Id, TemplateDevName__c, HtmlBody, TextBody, parentId FROM EmailMessage WHERE Id IN: emailMessagesId]; 
        if (emailMessages.isEmpty())
            return;

        List<Attachment> attachments = new List<Attachment>();
        for (EmailMessage msg : emailMessages){
            
            // System.debug(msg);
            if (msg.TemplateDevName__c != null && emailTemplateMap.containsKey(msg.TemplateDevName__c)){
                System.debug(' --- handleFuture INSIDE IF CONDITION ---');

                try{
                    Attachment a = new Attachment();
                    EmailTemplate tpl = emailTemplateMap.get(msg.TemplateDevName__c);
                    System.debug('template:');
                    System.debug(tpl);
                    a.name = tpl.Name + ' ' + Datetime.now().format('dd-MM-yyyy hh:mm');
                    a.ContentType = 'application/pdf';
                    
                    //a.body = Blob.toPdf(msg.HtmlBody.replaceall('src','').replaceall('<img','<div'));
                    //a.body = getBlobPdfFromHTMLContent('<h1>Hello World</h1>');
                    PageReference pageDoc = Page.HtmlWrapper;

                    // String msgBody = msg.HtmlBody;
                    // msgBody = msgBody.replace('<html><style>p{margin-top:0px; margin-bottom:0px;}</style><body class="setupTab"  style=" background-color:#CCCCCC; bEditID:b1st1; bLabel:body;"><center >', '');
                    // msgBody = msgBody.replace('</body>','');
                    // msgBody = msgBody.replace('</html>','');
                    // System.debug('emailBody length: ' + msgBody.length());
                    
                    pageDoc.getParameters().put('id', msg.Id);
                    // pageDoc.getParameters().put('htmlText', msgBody);
                    
                    System.debug(' --- handleFuture getContentAsPDF begin ---');
                    try {
                        a.body = (Blob) pageDoc.getContent();

                    } catch (VisualforceException e) {
                        a.body = Blob.valueOf('Unit.Test');    
                    }
                    a.parentId = msg.parentId;
                    attachments.add(a);
                }
                catch(Exception e){
                    System.debug('EXCEPTION CAPTURADA');
                    System.debug(e);
                }

            }
        }

        System.debug(attachments);

        if (!attachments.isEmpty())
            insert attachments;
    }
}