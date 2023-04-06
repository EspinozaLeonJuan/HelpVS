@isTest
private class CreaParticipanteCampanaBienvenidaTest {

    static {
    TriggerHandler.enable(CreaParticipanteCampanaBienvenidaHandler.class);
    }

    static testMethod void TestDefault() {
        ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        Test.startTest();
        insert poliza;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
    }

    static testMethod void TestCuentaPersonal() {
       ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        Test.startTest();
        insert poliza;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
    }

    static testMethod void participanteDuplicadoTest() {
       ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        Test.startTest();
        insert poliza;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
    }

    static testMethod void noAgregaParticipante() {
       ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        Test.startTest();
        insert poliza;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
    }

    static testMethod void siAgregaParticipante() {
       ControlTest.CreaParticipanteCampanaBienvenida = true;
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        Poliza__c poliza = new Poliza__c();
        poliza.Cuenta__c = account.Id;
        poliza.Fecha_Entrega_de_la_Poliza__c = Date.today().addDays(7);
        Test.startTest();
        insert poliza;
        Test.stopTest();
        ControlTest.CreaParticipanteCampanaBienvenida = false;
    }

}