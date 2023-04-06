@isTest
private class AddEmailAsAttachmentHandlerTest {

    static {
		TriggerHandler.enable(AddEmailAsAttachmentHandler.class);
        TriggerHandler.enable(CheckAndSaveEmailTemplateHandler.class);
	}

    @IsTest
    static void testHandler() { 
        AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().corporativa();
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('AccountId', cuenta).save();
        Id contactId = (Id)contacto.get().get('Id');

        CaseFabricate caso = (CaseFabricate)Fabricate.caso().setCuenta(cuenta).save(); //.set('Correo_electronico_Solicitante__c', 'esteban.lopez@gocode.cl');
        Id caseId = (Id)caso.get().get('Id');

        EmailTemplate[] templates = [SELECT Id, Name, Subject FROM EmailTemplate WHERE DeveloperName = :'Ajuste_de_Prima'];
        System.assert(templates.size() > 0, 'No se encontró la plantlla para la prueba');

        EmailMessage msg = new EmailMessage();
        msg.Subject = templates[0].subject;
        msg.textBody = '<div style="display:none;" id="template_id" value="Ajuste_de_Prima"></div>';
        msg.HtmlBody = 'THE HTMl BODY' + msg.textBody;
        msg.parentId = caseId;
    
		Test.startTest();
        insert msg;
        ApexPages.StandardController standardController = new ApexPages.StandardController(msg);
        HtmlWrapperController controller = new HtmlWrapperController(standardController);
		Test.stopTest();
        EmailMessage msgResult = [SELECT Id,TemplateDevName__c FROM EmailMessage WHERE Id =: msg.Id];
        List<Attachment> attachmentResult = [SELECT Id FROM Attachment Where ParentId =: caseId];
        System.assert(attachmentResult.size() > 0);
        System.assert(msgResult.TemplateDevName__c != null);
    }
}