@isTest
public class RespuestaTieneAdjuntoTest {
	
	static {
		TriggerHandler.enable(RespuestaTieneAdjuntoHandler.class);
	}
	
    static TestMethod void Test() {
        Test.startTest();
        Factory.crearAccountAnonimo();
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        Case caso = Factory.buildCasoSF('Consultas', cuenta);
        insert caso;
        Caso_Cat__c casocat = new Caso_Cat__c();
        casocat.Caso__c = caso.Id;
        insert casocat;
        Respuesta__c resp = new Respuesta__c();
        resp.Caso_Cat__c = casocat.Id;
		insert resp;
        
        Attachment att = new Attachment();
        att.ParentId = resp.Id;
        att.Body = blob.valueOf('Ym9keQ=='); //body
        att.name = 'test.tst';
        insert att;
        
        Respuesta__c respTrigger = [select Tiene_attachement__c from Respuesta__c where Id =: resp.Id limit 1];
        
        System.assert(respTrigger.Tiene_attachement__c, true);
        delete respTrigger;
        System.assert(respTrigger.Tiene_attachement__c, true);
        undelete respTrigger;
        System.assert(respTrigger.Tiene_attachement__c, true);
        Test.stopTest();
    }
}