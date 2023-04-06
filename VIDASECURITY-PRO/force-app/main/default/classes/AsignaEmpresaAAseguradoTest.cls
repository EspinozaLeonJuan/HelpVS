@isTest
private class AsignaEmpresaAAseguradoTest {
    
    static {
        TriggerHandler.enable(AsignaEmpresaAAseguradoHandler.class);
    }

    @isTest static void insertAsignandoEmpresaAAsegurado() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Test.startTest();
        Account cuentaPersonal = new Account(FirstName= 'Winder', LastName = 'Ojeda',  Rut__c = '123456789',  RecordTypeId = recordTypeCuentaPersonal, RUT_Empresa__c  = '482123880');
        insert cuentaPersonal;
        Test.stopTest();
        List<Account> cuentaPersonalEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where Cuenta_Corporativa__c = :cuentaCorporativa.Id and RecordTypeId = :recordTypeCuentaPersonal];
        System.assertEquals(1, cuentaPersonalEncontrada.size());
        System.assertNotEquals(null, cuentaPersonalEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa.Id, cuentaPersonalEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa.RUT__c, cuentaPersonalEncontrada[0].RUT_Empresa__c);
    }

    @isTest static void insertAsignandoRutEmpresaAAsegurado() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Test.startTest();
        Account cuentaPersonal = new Account(FirstName= 'Winder', LastName = 'Ojeda',  Rut__c = '123456789',  RecordTypeId = recordTypeCuentaPersonal, Cuenta_Corporativa__c  = cuentaCorporativa.Id);
        insert cuentaPersonal;
        Test.stopTest();
        List<Account> cuentaPersonalEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where RUT_Empresa__c = :cuentaCorporativa.RUT__c and RecordTypeId = :recordTypeCuentaPersonal];
        System.assertEquals(1, cuentaPersonalEncontrada.size());
        System.assertNotEquals(null, cuentaPersonalEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa.Id, cuentaPersonalEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa.RUT__c, cuentaPersonalEncontrada[0].RUT_Empresa__c);
    }

    @isTest static void updateAsignandoEmpresaAAsegurado() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Account cuentaCorporativa2 = new Account(Name='Cuenta Corporativa 2', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '111111111');
        insert cuentaCorporativa2;
        Test.startTest();
        Account cuentaPersonal = new Account(FirstName= 'Winder', LastName = 'Ojeda',  Rut__c = '123456789',  RecordTypeId = recordTypeCuentaPersonal, RUT_Empresa__c  = '482123880');
        insert cuentaPersonal;
        List<Account> cuentaPersonalEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where Cuenta_Corporativa__c = :cuentaCorporativa.Id and RecordTypeId = :recordTypeCuentaPersonal];
        Account cuentaPersonalUpdated = cuentaPersonalEncontrada[0];
        cuentaPersonalUpdated.RUT_Empresa__c = cuentaCorporativa2.Rut__c;
        update cuentaPersonalUpdated;
        Test.stopTest();
        List<Account> cuentaPersonalUpdatedEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where Cuenta_Corporativa__c = :cuentaCorporativa2.Id and RecordTypeId = :recordTypeCuentaPersonal];
        System.assertEquals(1, cuentaPersonalUpdatedEncontrada.size());
        System.assertNotEquals(null, cuentaPersonalUpdatedEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa2.Id, cuentaPersonalUpdatedEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa2.RUT__c, cuentaPersonalUpdatedEncontrada[0].RUT_Empresa__c);
    }

    @isTest static void updateAsignandoRutEmpresaAAsegurado() {
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Id recordTypeCuentaCorporativa = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta Corporativa');
        Account cuentaCorporativa = new Account(Name='Cuenta Corporativa', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '482123880');
        insert cuentaCorporativa;
        Account cuentaCorporativa2 = new Account(Name='Cuenta Corporativa 2', RecordTypeId = recordTypeCuentaCorporativa, RUT__c = '111111111');
        insert cuentaCorporativa2;
        Test.startTest();
        Account cuentaPersonal = new Account(FirstName= 'Winder', LastName = 'Ojeda',  Rut__c = '123456789',  RecordTypeId = recordTypeCuentaPersonal, Cuenta_Corporativa__c  = cuentaCorporativa.Id);
        insert cuentaPersonal;
        List<Account> cuentaPersonalEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where RUT_Empresa__c = :cuentaCorporativa.RUT__c and RecordTypeId = :recordTypeCuentaPersonal];
        Account cuentaPersonalUpdated = cuentaPersonalEncontrada[0];
        cuentaPersonalUpdated.Cuenta_Corporativa__c = cuentaCorporativa2.Id;
        update cuentaPersonalUpdated;
        Test.stopTest();
        List<Account> cuentaPersonalUpdatedEncontrada = [Select RUT_Empresa__c, Cuenta_Corporativa__c From Account Where RUT_Empresa__c = :cuentaCorporativa2.RUT__c and RecordTypeId = :recordTypeCuentaPersonal];
        System.assertEquals(1, cuentaPersonalUpdatedEncontrada.size());
        System.assertNotEquals(null, cuentaPersonalUpdatedEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa2.Id, cuentaPersonalUpdatedEncontrada[0].Cuenta_Corporativa__c);
        System.assertEquals(cuentaCorporativa2.RUT__c, cuentaPersonalUpdatedEncontrada[0].RUT_Empresa__c);
    }

    
}