@isTest
private class ComentarioAPrimeraRespuestaTest {
	
	static {
		TriggerHandler.enable(ComentarioAPrimeraRespuestaHandler.class);
	}
	
    static TestMethod void Test() {
        Factory.crearAccountAnonimo();
        Account cuenta = FActory.buildAccount('Cuenta personal');
        insert cuenta;
        Case caso = Factory.buildCasoSF('Consultas', cuenta);
        insert caso;
        Caso_Cat__c casocat = new Caso_Cat__c();
        casocat.Caso__c = caso.Id;
        insert casocat;
        
        Respuesta__c[] respuestas = [select Id from Respuesta__c where Caso_Cat__c =: casocat.Id];
        
        System.assert(respuestas.size() == 1);
    }
}