@IsTest
public class CreaParticipantesAMACTest {
    static testMethod void CrearParticipante() {
        
        
        Id recordIdAgente = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Agente').getRecordTypeId();
        //String idAgente = [SELECT Codigo_agente__c FROM Contact WHERE RecordTypeId = :recordIdAgente AND Estado__c = 'Desvinculado' LIMIT 1].Codigo_agente__c;
        Test.startTest();
        Contact agente = new Contact();
        agente.Codigo_agente__c = '9999999';
        agente.FirstName = 'Agente';
        agente.LastName = 'Individual';
        agente.RecordTypeId = recordIdAgente;
        agente.Estado__c = 'Desvinculado';
        agente.Cargo_Agente__c = 'Agente';
        
        insert agente;
        
        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'CARLOS';
        CUENTA_PRI.LastName = 'ESPINOZA P';
        CUENTA_PRI.PersonEmail = 'cespinoza@microsystem.cl';
        CUENTA_PRI.Rut_contacto__pc = '16790926';
        CUENTA_PRI.DV_contacto__pc = '4';
        CUENTA_PRI.Fecha_Ultimo_Cambio_Propietario__c = Date.today();
        CUENTA_PRI.OwnerId = '005i0000001O3jkAAC';
        CUENTA_PRI.Codigo_Agente__c = '9999999';
        CUENTA_PRI.Agente_Actual__c = agente.Id;
        CUENTA_PRI.Agente_Original__c = agente.Id;
        insert CUENTA_PRI;
        
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
  		Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = CUENTA_PRI.Id;        
        poliza.RecordTypeId = recordTypeIndividuales;
        poliza.N_Poliza__c = 12345678;
        poliza.Name = '12345678';
        poliza.Estatus__c = 'ACTIVA';        
        insert poliza;
        
		Campana_Vida_Security__c campaing = new Campana_Vida_Security__c();
        campaing.Name = 'Campaña AMAC';
        insert campaing;

    Set<Id> ids = new Set<Id>{CUENTA_PRI.id};
    Set<Id> ids_get = new Set<Id>();
    List<Account> accounts = new List<Account>{CUENTA_PRI};    
    ids_get = AccountTriggerHelper.getAccountsId(CUENTA_PRI, CUENTA_PRI, ids);
    CreaParticipantesAMAC.execute( ids );
		Test.stopTest();        
    }
}