@isTest
private class ActualizaComentarioSinHTMLTest {
	
	static {
		TriggerHandler.enable(ActualizaComentarioSinHTMLHandler.class);
	}

    static testMethod void myUnitTest() {
        Factory.crearAccountAnonimo();
    	Account cuenta = Factory.buildAccount('Cuenta Corporativa');
        insert cuenta;
        Case casoReclamo = Factory.buildCasoSF('Reclamos', cuenta);
        casoReclamo.AccountId = cuenta.Id; 
        insert casoReclamo;
         
    	Caso_Cat__c c = new Caso_Cat__c();
    	c.Caso__c = casoReclamo.Id;
    	insert c;
    	
        Respuesta__c r = new Respuesta__c();
        r.Caso_Cat__c = c.Id;
        string prueba = 'PruebaHtml';
        string pruebaHtml = '<html><body><form><div><b>'+prueba+'</b></div></form></body></html>';
        r.Comentario_Respuesta__c = pruebaHtml;
        
        Test.startTest();
        insert r;
        Respuesta__c result = [select Comentario_Respuesta_Sin_HTML__c from Respuesta__c where Id = :r.Id LIMIT 1];
		System.assertEquals(result.Comentario_Respuesta_Sin_HTML__c, prueba);
        Test.stopTest();
    }
}