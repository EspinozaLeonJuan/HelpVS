@isTest
public class EnviaCorreoNotaEncuestaTest {
	
	static {
		TriggerHandler.enable(EnviaCorreoNotaEncuestaHandler.class);
	}
	
    static TestMethod void Test() {
        User usuario = Factory.buildUser();
        insert usuario;
        Test.startTest();
        Survey__c encuesta = new Survey__c();
        encuesta.Name = 'Encuesta';
        encuesta.Umbral_Calificacion_Aviso__c = 3;
        encuesta.Envia_Correo_por_calificacion__c = true;
        encuesta.OwnerId = usuario.Id;
        encuesta.Submit_Response__c = 'Prueba';
        insert encuesta;
        
        Survey_Question__c pregunta = new Survey_Question__c();
        pregunta.Survey__c = encuesta.Id;
        pregunta.OrderNumber__c = 1;
        pregunta.Question__c = 'Prueba!';
        insert pregunta;
        
        SurveyTaker__c encuestado = new SurveyTaker__c();
        encuestado.Survey__c = encuesta.Id;
        insert encuestado;
        Boolean EnviarCorreo = false;
        try
        {            
        
            SurveyQuestionResponse__c respuesta = new SurveyQuestionResponse__c();
            respuesta.Response__c = '2';
            respuesta.Survey_Question__c = pregunta.Id;
            respuesta.SurveyTaker__c = encuestado.Id;
            insert respuesta;
            
            encuestado.Taken__c = 'true';
        	update encuestado;
            EnviarCorreo = true;
        }
        catch (Exception e) {
            EnviarCorreo = false;
		}
        

        
        Test.stopTest();
    }
}