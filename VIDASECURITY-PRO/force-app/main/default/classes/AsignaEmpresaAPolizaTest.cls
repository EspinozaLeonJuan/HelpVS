@isTest
private class AsignaEmpresaAPolizaTest {

    static {
        TriggerHandler.enable(AsignaEmpresaAPolizaHandler.class);
    }

    @isTest static void insertAsignandoEmpresaAPoliza() {
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        Test.stopTest();

        List<Poliza__c> polizaEncontrada = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Cuenta__c = :cuentaCorporativa.Id];
        System.assertEquals(1, polizaEncontrada.size());
        System.assertNotEquals(null, polizaEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa.Id, polizaEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa.RUT__c, polizaEncontrada[0].Rut_Empresa__c);
    }

    @isTest static void insertAsignandoRutEmpresaAPoliza() {
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuentaCorporativa.Id, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        Test.stopTest();

        List<Poliza__c> polizaEncontrada = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Rut_Empresa__c = :cuentaCorporativa.RUT__c];
        System.assertEquals(1, polizaEncontrada.size());
        System.assertNotEquals(null, polizaEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa.Id, polizaEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa.RUT__c, polizaEncontrada[0].Rut_Empresa__c);
    }

    @isTest static void updateAsignandoEmpresaAPoliza() {
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Account cuentaCorporativa2 = new Account(Name='Cuenta Corporativa 2', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '11111111');
        insert cuentaCorporativa2;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        List<Poliza__c> polizaEncontrada = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Cuenta__c = :cuentaCorporativa.Id];
        Poliza__c polizaUpdated = polizaEncontrada[0];
        polizaUpdated.Rut_Empresa__c = cuentaCorporativa2.RUT__c;
        update polizaUpdated;
        Test.stopTest();

        List<Poliza__c> polizaEncontradaUpdated = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Cuenta__c = :cuentaCorporativa2.Id];
        System.assertEquals(1, polizaEncontradaUpdated.size());
        System.assertNotEquals(null, polizaEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa2.Id, polizaEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa2.RUT__c, polizaEncontradaUpdated[0].Rut_Empresa__c);
    }

    @isTest static void updateAsignandoRutEmpresaAPoliza() {
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Account cuentaCorporativa2 = new Account(Name='Cuenta Corporativa 2', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '11111111');
        insert cuentaCorporativa2;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuentaCorporativa.Id, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        List<Poliza__c> polizaEncontrada = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Rut_Empresa__c = :cuentaCorporativa.RUT__c];
        Poliza__c polizaUpdated = polizaEncontrada[0];
        polizaUpdated.Cuenta__c = cuentaCorporativa2.Id;
        update polizaUpdated;
        Test.stopTest();

        List<Poliza__c> polizaEncontradaUpdated = [Select Rut_Empresa__c, Cuenta__c From Poliza__c Where Rut_Empresa__c = :cuentaCorporativa2.RUT__c];
        System.assertEquals(1, polizaEncontradaUpdated.size());
        System.assertNotEquals(null, polizaEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa2.Id, polizaEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaCorporativa2.RUT__c, polizaEncontradaUpdated[0].Rut_Empresa__c);
    }
}