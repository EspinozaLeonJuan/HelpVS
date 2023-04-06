@isTest
private class AsignaCorredoresAContactoTest {
    
    static {
        TriggerHandler.enable(AsignaCorredoresAContactoHandler.class);
    }

    @isTest static void insertAsignandoCorredorAContacto() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Test.startTest();
        Contact contacto = new Contact(AccountId = cuenta.Id, Phone = '12345678', FirstName = 'Win', LastName = 'Ojeda', Rut_Corredor__c=corredor.RUT__c);
        insert contacto;
        Test.stopTest();
        List<Contact> contactoEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Empresa_Corredora__c = :corredor.Id];
        System.assertEquals(1, contactoEncontrado.size());
        System.assertNotEquals(null, contactoEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor.Id, contactoEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor.RUT__c, contactoEncontrado[0].Rut_Corredor__c);
    }

    @isTest static void insertAsignandoRutCorredorAContacto() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Test.startTest();
        Contact contacto = new Contact(AccountId = cuenta.Id, Phone = '12345678', FirstName = 'Win', LastName = 'Ojeda', Empresa_Corredora__c=corredor.Id);
        insert contacto;
        Test.stopTest();
        List<Contact> contactoEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Rut_Corredor__c = :corredor.RUT__c];
        System.assertEquals(1, contactoEncontrado.size());
        System.assertNotEquals(null, contactoEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor.Id, contactoEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor.RUT__c, contactoEncontrado[0].Rut_Corredor__c);
    }

    @isTest static void updateAsignandoCorredorAContacto() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Corredor__c corredor2 =  new Corredor__c(RUT__c = '1111111', DV__c = '2',Name = 'Corredor Test');
        insert corredor2;
        
        Test.startTest();
        Contact contacto = new Contact(AccountId = cuenta.Id, Phone = '12345678', FirstName = 'Win', LastName = 'Ojeda', Rut_Corredor__c=corredor.RUT__c);
        insert contacto;
        List<Contact> contactoEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Empresa_Corredora__c = :corredor.Id];
        Contact contactoUpdated = contactoEncontrado[0];
        contactoUpdated.Rut_Corredor__c = corredor2.RUT__c;
        update contactoUpdated;
        Test.stopTest();

        List<Contact> contactoUpdatedEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Empresa_Corredora__c = :corredor2.Id];
        System.assertEquals(1, contactoUpdatedEncontrado.size());
        System.assertNotEquals(null, contactoUpdatedEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor2.Id, contactoUpdatedEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor2.RUT__c, contactoUpdatedEncontrado[0].Rut_Corredor__c);
    }

    @isTest static void updateAsignandoRutCorredorAContacto() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Corredor__c corredor2 =  new Corredor__c(RUT__c = '1111111', DV__c = '2',Name = 'Corredor Test');
        insert corredor2;
        
        Test.startTest();
        Contact contacto = new Contact(AccountId = cuenta.Id, Phone = '12345678', FirstName = 'Win', LastName = 'Ojeda', Empresa_Corredora__c=corredor.Id);
        insert contacto;
        List<Contact> contactoEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Rut_Corredor__c = :corredor.RUT__c];
        Contact contactoUpdated = contactoEncontrado[0];
        contactoUpdated.Empresa_Corredora__c = corredor2.Id;
        update contactoUpdated;
        Test.stopTest();
        
        List<Contact> contactoUpdatedEncontrado = [Select Rut_Corredor__c, Empresa_Corredora__c From Contact Where Rut_Corredor__c = :corredor2.RUT__c];
        System.assertEquals(1, contactoUpdatedEncontrado.size());
        System.assertNotEquals(null, contactoUpdatedEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor2.Id, contactoUpdatedEncontrado[0].Empresa_Corredora__c);
        System.assertEquals(corredor2.RUT__c, contactoUpdatedEncontrado[0].Rut_Corredor__c);
    }
    
}