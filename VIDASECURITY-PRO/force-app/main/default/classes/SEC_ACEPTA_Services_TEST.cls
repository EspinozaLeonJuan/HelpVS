@IsTest
public class SEC_ACEPTA_Services_TEST {
     
    @isTest(SeeAllData=true)
    static void getData(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new AceptaCalloutMock());
        URL_API_Acepta__c servicio = URL_API_Acepta__c.getOrgDefaults();    
        
        String session_id = '';
        JSONGenerator gen = JSON.createGenerator(true);    
        gen.writeStartObject();
        gen.writeStringField('user_name', servicio.Acepta_User__c);
        gen.writeStringField('user_pin', servicio.Acepta_Password__c);
        gen.writeEndObject();    
        String body = gen.getAsString();
        String point = 'auth/login';        
        Map<String, Object> response = SEC_ACEPTA_Services.doAceptaCommunication(point, body, 'POST');
        
        Test.stopTest();        
        
    }
}