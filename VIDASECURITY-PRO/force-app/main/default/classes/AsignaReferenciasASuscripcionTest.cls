@isTest
private class AsignaReferenciasASuscripcionTest {
    
    static {
        TriggerHandler.enable(AsignaReferenciasASuscripcionHandler.class);
        TriggerHandler.enable(AsignaEmpresaAPolizaHandler.class);
    }

    @isTest static void insertAsignandoReferenciasASuscripcion() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

        Account cuentaPersonal = new Account(FirstName='Winder', LastName='Ojeda', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '482123880');
        insert cuentaPersonal;

        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123881');
        insert cuentaCorporativa;

        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, Name = '1111111111');
        insert poliza;

        Test.startTest();
        Poliza_Colectivo__c suscripcion = new Poliza_Colectivo__c(N_Poliza__c=poliza.Name, Rut_Asegurado__c = cuentaPersonal.Rut__c);
        insert suscripcion;
        Test.stopTest();
        List<Poliza_Colectivo__c> suscripcionEncontrada = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                            Where Cuenta__c = :cuentaPersonal.Id and Poliza__c = :poliza.Id];
        System.assertEquals(1, suscripcionEncontrada.size());
        System.assertNotEquals(null, suscripcionEncontrada[0].Cuenta__c);
        System.assertNotEquals(null, suscripcionEncontrada[0].Poliza__c);
        System.assertEquals(cuentaPersonal.Id, suscripcionEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaPersonal.RUT__c, suscripcionEncontrada[0].Rut_Asegurado__c);
        System.assertEquals(poliza.Id, suscripcionEncontrada[0].Poliza__c);
        System.assertEquals(poliza.Name, suscripcionEncontrada[0].N_Poliza__c);
    }

    @isTest static void insertAsignandoCamposNegocioASuscripcion() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

        Account cuentaPersonal = new Account(FirstName='Winder', LastName='Ojeda', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '482123880');
        insert cuentaPersonal;

        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123881');
        insert cuentaCorporativa;

        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, Name = '1111111111');
        insert poliza;

        Test.startTest();
        Poliza_Colectivo__c suscripcion = new Poliza_Colectivo__c(Poliza__c=poliza.Id, Cuenta__c = cuentaPersonal.Id);
        insert suscripcion;
        Test.stopTest();

        List<Poliza_Colectivo__c> suscripcionEncontrada = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                        where Rut_Asegurado__c = :cuentaPersonal.RUT__c and     N_Poliza__c = :poliza.Name];
        System.assertEquals(1, suscripcionEncontrada.size());
        System.assertNotEquals(null, suscripcionEncontrada[0].Cuenta__c);
        System.assertNotEquals(null, suscripcionEncontrada[0].Poliza__c);
        System.assertEquals(cuentaPersonal.Id, suscripcionEncontrada[0].Cuenta__c);
        System.assertEquals(cuentaPersonal.RUT__c, suscripcionEncontrada[0].Rut_Asegurado__c);
        System.assertEquals(poliza.Id, suscripcionEncontrada[0].Poliza__c);
        System.assertEquals(poliza.Name, suscripcionEncontrada[0].N_Poliza__c);
    }


    @isTest static void updateAsignandoReferenciasASuscripcion() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

        Account cuentaPersonal = new Account(FirstName='Winder', LastName='Ojeda', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '482123880');
        insert cuentaPersonal;

        Account cuentaPersonal2 = new Account(FirstName='Alejandro', LastName='Gutierrez', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '111111111');
        insert cuentaPersonal2;

        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123881');
        insert cuentaCorporativa;

        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c,  Name = '1111111111');
        insert poliza;

        Poliza__c poliza2 = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, Name = '2222222222');
        insert poliza2;

        Test.startTest();
        Poliza_Colectivo__c suscripcion = new Poliza_Colectivo__c(N_Poliza__c=poliza.Name, Rut_Asegurado__c = cuentaPersonal.Rut__c);
        insert suscripcion;
        List<Poliza_Colectivo__c> suscripcionEncontrada = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                            Where Cuenta__c = :cuentaPersonal.Id and Poliza__c = :poliza.Id];

        Poliza_Colectivo__c suscripcionUpdated = suscripcionEncontrada[0];
        suscripcionUpdated.N_Poliza__c = poliza2.Name;
        suscripcionUpdated.Rut_Asegurado__c = cuentaPersonal2.Rut__c;
        update suscripcionUpdated;
        Test.stopTest();

        List<Poliza_Colectivo__c> suscripcionEncontradaUpdated = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                            Where Cuenta__c = :cuentaPersonal2.Id and Poliza__c = :poliza2.Id];
        System.assertEquals(1, suscripcionEncontradaUpdated.size());
        System.assertNotEquals(null, suscripcionEncontradaUpdated[0].Cuenta__c);
        System.assertNotEquals(null, suscripcionEncontradaUpdated[0].Poliza__c);
        System.assertEquals(cuentaPersonal2.Id, suscripcionEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaPersonal2.RUT__c, suscripcionEncontradaUpdated[0].Rut_Asegurado__c);
        System.assertEquals(poliza2.Id, suscripcionEncontradaUpdated[0].Poliza__c);
        System.assertEquals(poliza2.Name, suscripcionEncontradaUpdated[0].N_Poliza__c);
    }


    @isTest static void updateAsignandoCamposNegocioASuscripcion() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');

        Account cuentaPersonal = new Account(FirstName='Winder', LastName='Ojeda', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '482123880');
        insert cuentaPersonal;

        Account cuentaPersonal2 = new Account(FirstName='Alejandro', LastName='Gutierrez', RecordTypeId = recordTypeCuentaPersonal, RUT__c = '111111111');
        insert cuentaPersonal2;

        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123881');
        insert cuentaCorporativa;

        Poliza__c poliza = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c,  Name = '1111111111');
        insert poliza;

        Poliza__c poliza2 = new Poliza__c(Rut_Empresa__c=cuentaCorporativa.RUT__c, Name = '2222222222');
        insert poliza2;

        Test.startTest();
        Poliza_Colectivo__c suscripcion = new Poliza_Colectivo__c(Poliza__c=poliza.Id, Cuenta__c = cuentaPersonal.Id);
        insert suscripcion;
        List<Poliza_Colectivo__c> suscripcionEncontrada = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                            Where Rut_Asegurado__c = :cuentaPersonal.RUT__c and N_Poliza__c = :poliza.Name];

        Poliza_Colectivo__c suscripcionUpdated = suscripcionEncontrada[0];
        suscripcionUpdated.Poliza__c = poliza2.Id;
        suscripcionUpdated.Cuenta__c = cuentaPersonal2.Id;
        update suscripcionUpdated;
        Test.stopTest();

        List<Poliza_Colectivo__c> suscripcionEncontradaUpdated = [Select Rut_Asegurado__c, N_Poliza__c, Poliza__c, Cuenta__c From Poliza_Colectivo__c 
                                                            Where Rut_Asegurado__c = :cuentaPersonal2.Rut__c and N_Poliza__c = :poliza2.Name];
        System.assertEquals(1, suscripcionEncontradaUpdated.size());
        System.assertNotEquals(null, suscripcionEncontradaUpdated[0].Cuenta__c);
        System.assertNotEquals(null, suscripcionEncontradaUpdated[0].Poliza__c);
        System.assertEquals(cuentaPersonal2.Id, suscripcionEncontradaUpdated[0].Cuenta__c);
        System.assertEquals(cuentaPersonal2.RUT__c, suscripcionEncontradaUpdated[0].Rut_Asegurado__c);
        System.assertEquals(poliza2.Id, suscripcionEncontradaUpdated[0].Poliza__c);
        System.assertEquals(poliza2.Name, suscripcionEncontradaUpdated[0].N_Poliza__c);
    }
    
}