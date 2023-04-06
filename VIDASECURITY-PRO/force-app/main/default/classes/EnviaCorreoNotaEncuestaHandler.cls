public class EnviaCorreoNotaEncuestaHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

		Id emailSalidaId;

		for(OrgWideEmailAddress owa : [select id, Address from OrgWideEmailAddress]) {
			if(owa.Address.contains('sfvida')) {
				emailSalidaId = owa.id;
			}
		}

		for( SurveyTaker__c st : (SurveyTaker__c[])Trigger.New ) {

			if (st.Taken__c == 'true') {

				Survey__c encuesta = [select id, Name, Envia_Correo_por_calificacion__c, Umbral_Calificacion_Aviso__c, OwnerId from Survey__c where Id =: st.Survey__c];

				if( encuesta.Envia_Correo_por_calificacion__c ) {

					Map<ID, SurveyQuestionResponse__c> mRespuestas = new Map<ID, SurveyQuestionResponse__c>([SELECT Id, Response__c FROM SurveyQuestionResponse__c where SurveyTaker__c =: st.Id]);
					Boolean EnviarCorreo = false;

					for (SurveyQuestionResponse__c resp : mRespuestas.values()) {
						try{
							if (integer.valueOf(resp.Response__c) <= encuesta.Umbral_Calificacion_Aviso__c ) {
								EnviarCorreo = true;
								System.debug('Respuesta: ' + integer.valueOf(resp.Response__c));
								break;
							}
						}
						catch (Exception e){
							System.debug('Respuesta: ' + resp.Response__c);
							EnviarCorreo = false;
						}
					}

					if (EnviarCorreo && emailSalidaId != null) {
						Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
						mail.setOrgWideEmailAddressId(emailSalidaId);
						mail.setTargetObjectId(encuesta.OwnerId);
						mail.setSaveAsActivity(false);
						mail.setSubject('Encuesta "' + encuesta.Name + '": Calificación Inferior a ' + encuesta.Umbral_Calificacion_Aviso__c);
						mail.setPlainTextBody('Puede revisar el detalle de esta encuesta en el siguiente link: https://' + ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To') + '/' + st.Id);
						emails.add(mail);
					}
				}

				System.debug('Final, envia correo: ' + emails.size());
				Messaging.SendEmailResult[] res = Messaging.sendEmail(emails);
			}
		}
	}
}