public with sharing class EmailUtils {
	
	public class Target {
		public Id recipientId {get; set;}
		public String[] cc {get; set;}
		public String[] bcc {get; set;}
		
		public Target(Id recipientId) {
			this.recipientId = recipientId;
		}
		
		public Target() {
			this(null);
		}

		
		public void addCc(String email) {
			if (this.cc == null)
				this.cc = new List<String>();
			this.cc.add(email);
		}
		
		public void addBcc(String email) {
			if (this.bcc == null)
				this.bcc = new List<String>();
			this.bcc.add(email);
		}
	}
	
	public static void validate(Boolean condition, String message) {
		if (condition)
			throw new EmailException(message);
	}

	
	/**
	* Este método envía emails a los destinatarios en targetIds utilizando la plantilla templateName
	* la posición i-esima del targetIds está directamente relacionada con el objeto ubicado en whatIds en la misma posición
	* Retorna toda la información del mensaje en el objeto EmailResult
	*/
	public static EmailResult[] sendEmails(Id[] targetIds, Id[] whatIds, String templateName) {
		validate(targetIds == null || targetIds.isEmpty(), 'No se han especificado destinatarios de correo');
		List<Target> targets = new List<Target>();
		for (Id targetId : targetIds) {
			targets.add(new Target(targetId));
		}
		return sendEmails(targets, whatIds, templateName);
	}
		
		
		public static EmailResult[] sendEmails(Target[] targets, Id[] whatIds, String templateName) {
		validate(targets == null || targets.isEmpty(), 'No se han especificado destinatarios de correo');
		EmailTemplate[] templates = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = :templateName];
		validate(templates.size() == 0, 'Se especifico el nombre de la plantilla ' + templateName + ' pero no se ha encontrado ninguna. Favor creala.');
		List<EmailResult> emailResults = new List<EmailResult>();
		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		Id[] localTargetIds = new List<Id>();
		Id[] localWhatIds = new List<Id>();
		for (Integer i=0; i < targets.size(); i++) {
			validate(targets[i] == null, 'No se han especificado destinatarios para el envio del correo.');
			validate(targets[i].recipientId == null, 'Debe especificar un destinatario de tipo Para en el correo.');
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			message.setTargetObjectId(targets[i].recipientId);
			if (targets[i].cc != null)
				message.setCcAddresses(targets[i].cc);
			if (targets[i].bcc != null)
				message.setBccAddresses(targets[i].bcc);
			message.setTemplateId(templates[0].Id);
			message.setWhatId(whatIds[i]);
			message.setSaveAsActivity(false);
			messages.add(message);
			localTargetIds.add(targets[i].recipientId);
			localWhatIds.add(whatIds[i]);
		}
		Messaging.reserveSingleEmailCapacity(messages.size());
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
    system.debug('@@@ results : ' + results );
		for (Integer I=0; i < results.size(); i++) {
			emailResults.add(new EmailResult(results[i], localTargetIds[i], localWhatIds[i], templateName));
					}
    system.debug('@@@ emailResults : ' + emailResults );
		return emailResults;
	}

  public static EmailResult[] sendEmails( Target[] targets, Id[] whatIds, List<Id> EmailTemplatesId ) {
    validate(targets == null || targets.isEmpty(), 'No se han especificado destinatarios de correo');
    validate(EmailTemplatesId.size() == 0, 'Se especifico el nombre de la plantilla ' + EmailTemplatesId + ' pero no se ha encontrado ninguna. Favor creala.');
    List<EmailResult> emailResults = new List<EmailResult>();
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    Id[] localTargetIds = new List<Id>();
    Id[] localWhatIds = new List<Id>();
    List<OrgWideEmailAddress> orgEmailAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address='vidasecurity@security.cl' LIMIT 1];
    String orgEmailAddressId = null;
    orgEmailAddressId = !orgEmailAddressList.isEmpty() ? orgEmailAddressList[0].Id : null;
    for (Integer i=0; i < targets.size(); i++) {
      validate(targets[i] == null, 'No se han especificado destinatarios para el envio del correo.');
      validate(targets[i].recipientId == null, 'Debe especificar un destinatario de tipo Para en el correo.');
      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
      message.setTargetObjectId(targets[i].recipientId);
      if (targets[i].cc != null)
        message.setCcAddresses(targets[i].cc);
      if (targets[i].bcc != null)
        message.setBccAddresses(targets[i].bcc);
      message.setOrgWideEmailAddressId(orgEmailAddressId);
      message.setTemplateId(EmailTemplatesId[i]);
      message.setWhatId(whatIds[i]);
      message.setSaveAsActivity(true);
      messages.add(message);
      localTargetIds.add(targets[i].recipientId);
      localWhatIds.add(whatIds[i]);
    }
    Messaging.reserveSingleEmailCapacity(messages.size());
    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
    system.debug('@@@ results : ' + results );
    for (Integer I=0; i < results.size(); i++) {
      emailResults.add(new EmailResult(results[i], localTargetIds[i], localWhatIds[i], EmailTemplatesId[i]));
          }
    system.debug('@@@ emailResults : ' + emailResults );
    return emailResults;
  }

  public static EmailResult[] sendEmails( Target[] targets, Id[] whatIds, List<String> HtmlBody ) {
    validate(targets == null || targets.isEmpty(), 'No se han especificado destinatarios de correo');
    validate(HtmlBody.size() == 0, 'Lista de Bodys vacía');
    List<EmailResult> emailResults = new List<EmailResult>();
    List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
    Id[] localTargetIds = new List<Id>();
    Id[] localWhatIds = new List<Id>();
    List<OrgWideEmailAddress> orgEmailAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address='sfvida@security.cl' LIMIT 1];
    String orgEmailAddressId = null;
    orgEmailAddressId = !orgEmailAddressList.isEmpty() ? orgEmailAddressList[0].Id : null;
    for (Integer i=0; i < targets.size(); i++) {
      validate(targets[i] == null, 'No se han especificado destinatarios para el envio del correo.');
      validate(targets[i].recipientId == null, 'Debe especificar un destinatario de tipo Para en el correo.');
      Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
      message.setTargetObjectId(targets[i].recipientId);
      if (targets[i].cc != null)
        message.setCcAddresses(targets[i].cc);
      if (targets[i].bcc != null)
        message.setBccAddresses(targets[i].bcc);
      message.setOrgWideEmailAddressId(orgEmailAddressId);
      message.setSubject('Oportunidades próximas a la Fecha Cierre');
      message.setHtmlBody('<body><p style="font-family:Calibri"><b>Las siguientes Oportunidades están próximas a la fecha de cierre: </b></p><br><br><table border="1"><caption>Lista de Oportunidades</caption><tr><th>Nombre de la Opp.</th><th>Días para el Cierre</th><th>Tipo cotización</th><th>Nombre de la Cuenta</th><th>Rut de la Cuenta</th></tr>'+HtmlBody[i]+'</table></body>');
      //message.setTemplateId(EmailTemplatesId[i]);
      //message.setWhatId(whatIds[i]);
      message.setSaveAsActivity(false);
      messages.add(message);
      localTargetIds.add(targets[i].recipientId);
      //localWhatIds.add(whatIds[i]);
    }
    Messaging.reserveSingleEmailCapacity(messages.size());
    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
    system.debug('@@@ results : ' + results );
    for (Integer I=0; i < results.size(); i++) {
      emailResults.add(new EmailResult(results[i], localTargetIds[i], null, null));
          }
    system.debug('@@@ emailResults : ' + emailResults );
    return emailResults;
  }

  public static EmailResult[] sendEmails(Target[] targets, Id[] whatIds, String templateName, Boolean save_activity ) {
		validate(targets == null || targets.isEmpty(), 'No se han especificado destinatarios de correo');
		EmailTemplate[] templates = [SELECT Id, Name FROM EmailTemplate WHERE DeveloperName = :templateName];
		validate(templates.size() == 0, 'Se especifico el nombre de la plantilla ' + templateName + ' pero no se ha encontrado ninguna. Favor creala.');
		List<OrgWideEmailAddress> orgEmailAddressList = [SELECT Id FROM OrgWideEmailAddress WHERE Address='vidasecurity@security.cl' LIMIT 1];
    String orgEmailAddressId = null;
    orgEmailAddressId = !orgEmailAddressList.isEmpty() ? orgEmailAddressList[0].Id : null;
    List<EmailResult> emailResults = new List<EmailResult>();
		List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
		Id[] localTargetIds = new List<Id>();
		Id[] localWhatIds = new List<Id>();
		for (Integer i=0; i < targets.size(); i++) {
			validate(targets[i] == null, 'No se han especificado destinatarios para el envio del correo.');
			validate(targets[i].recipientId == null, 'Debe especificar un destinatario de tipo Para en el correo.');
			Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
			message.setTargetObjectId(targets[i].recipientId);
			if (targets[i].cc != null)
				message.setCcAddresses(targets[i].cc);
			if (targets[i].bcc != null)
				message.setBccAddresses(targets[i].bcc);
      message.setOrgWideEmailAddressId(orgEmailAddressId);
			message.setTemplateId(templates[0].Id);
			message.setWhatId(whatIds[i]);
			message.setSaveAsActivity(save_activity);
			messages.add(message);
			localTargetIds.add(targets[i].recipientId);
			localWhatIds.add(whatIds[i]);
		}
		Messaging.reserveSingleEmailCapacity(messages.size());
		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);
    system.debug('@@@ results : ' + results );
		for (Integer I=0; i < results.size(); i++) {
			emailResults.add(new EmailResult(results[i], localTargetIds[i], localWhatIds[i], templateName));
					}
    system.debug('@@@ emailResults : ' + emailResults );
		return emailResults;
	}

	public static Messaging.SendEmailResult sendSingleEmail(String addressTo, String subject, String plainBody) {
		Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
		message.setToAddresses(new String[]{addressTo});
		message.setSubject(subject);
		message.setPlainTextBody(plainBody);
		message.setSaveAsActivity(false);
		message.setSenderDisplayName('Vida Security Cobranza');
		Messaging.reserveSingleEmailCapacity(1);

		Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};

		if (Test.isRunningTest())	
			return null;

		Messaging.SendEmailResult[] results = Messaging.sendEmail(messages,false);

		if (results[0].success) 
			System.debug('The email was sent successfully.');
		else 
			System.debug('The email failed to send: ' + results[0].errors[0].message);

		return results[0];
	}
}