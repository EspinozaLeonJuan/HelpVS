@isTest
public class CLS_CierreCampanaPrimaTest {  
    
	static testMethod void ParticipanteConFechaPago() {
     	Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(5);
        insert poliza;
        
        //Creación de Campaña
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        //Creación de Participante
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        p.Poliza__c = poliza.Id;
        p.Mandato_Final__c = 'PAT';
        insert p;
        CLS_CierreCampanaPrima process = new CLS_CierreCampanaPrima();
        process.execute(null);
        Test.stopTest();
	}
    
    static testMethod void cierreCampanaPrimaTest() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        insert poliza;
        
        //Creación de Campaña
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        //Creación de Participante
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        p.Poliza__c = poliza.Id;
        p.Mandato_Final__c = 'PAT';
        insert p;
        CLS_CierreCampanaPrima process = new CLS_CierreCampanaPrima();
        process.execute(null);
        Test.stopTest();
    }
    
	static testMethod void ParticipanteConFechaPagoMenor() {
     	Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});     
   
		//Creación de Póliza
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Name = '123456';
        poliza.N_Poliza__c = 123456;
        poliza.Nombre_de_Producto__c = 'DOMINIUM MAX 3.0';
        poliza.Codigo_de_Producto__c = '9750';
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	    poliza.RecordTypeId = recordTypeIndividuales;
        Date hoy = Date.today();
        poliza.Fecha_Ultimo_Pago__c = hoy.addDays(-10);
        insert poliza;
        
        //Creación de Campaña
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        //Creación de Participante
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        p.Poliza__c = poliza.Id;
        p.Mandato_Final__c = 'PAT';
        insert p;
        CLS_CierreCampanaPrima process = new CLS_CierreCampanaPrima();
        process.execute(null);
        Test.stopTest();
	}    
}