@isTest
private class AsignaCorredoresAPolizaTest {
    
    static {
        TriggerHandler.enable(AsignaCorredoresAPolizaHandler.class);
    }

    @isTest static void insertAsignandoCorredorAPoliza() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuenta.id, Corredor__c=corredor.Id, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        Test.stopTest();

        List<Poliza__c> polizaEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Rut_Corredor__c = :corredor.RUT__c];
        System.assertEquals(1, polizaEncontrada.size());
        System.assertNotEquals(null, polizaEncontrada[0].Corredor__c);
        System.assertEquals(corredor.Id, polizaEncontrada[0].Corredor__c);
        System.assertEquals(corredor.RUT__c, polizaEncontrada[0].Rut_Corredor__c);
    }

    @isTest static void insertAsignandoRutCorredorAPoliza() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuenta.id, Rut_Corredor__c=corredor.RUT__c, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        Test.stopTest();

        List<Poliza__c> polizaEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Corredor__c = :corredor.Id];
        System.assertEquals(1, polizaEncontrada.size());
        System.assertNotEquals(null, polizaEncontrada[0].Corredor__c);
        System.assertEquals(corredor.Id, polizaEncontrada[0].Corredor__c);
        System.assertEquals(corredor.RUT__c, polizaEncontrada[0].Rut_Corredor__c);
    }

    @isTest static void updateAsignandoCorredorAPoliza() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Corredor__c corredor2 =  new Corredor__c(RUT__c = '12345678', DV__c = '2',Name = 'Corredor Test 2');
        insert corredor2;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuenta.id, Corredor__c=corredor.Id, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        List<Poliza__c> polizaEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Rut_Corredor__c = :corredor.RUT__c];
        Poliza__c polizaUpdate = polizaEncontrada[0];
        polizaUpdate.Corredor__c = corredor2.Id;
        update polizaUpdate;
        Test.stopTest();

        List<Poliza__c> polizaUpdatedEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Rut_Corredor__c = :corredor2.RUT__c];
        System.assertEquals(1, polizaUpdatedEncontrada.size());
        System.assertNotEquals(null, polizaUpdatedEncontrada[0].Corredor__c);
        System.assertEquals(corredor2.Id, polizaUpdatedEncontrada[0].Corredor__c);
        System.assertEquals(corredor2.RUT__c, polizaUpdatedEncontrada[0].Rut_Corredor__c);
    }

    @isTest static void updateAsignandoRutCorredorAPoliza() {
        Account cuenta = new Account(Name='Cuenta 1');
        insert cuenta;
        Corredor__c corredor =  new Corredor__c(RUT__c = '76316883', DV__c = '2',Name = 'Corredor Test');
        insert corredor;
        Corredor__c corredor2 =  new Corredor__c(RUT__c = '12345678', DV__c = '2',Name = 'Corredor Test 2');
        insert corredor2;
        
        Test.startTest();
        Poliza__c poliza = new Poliza__c(Cuenta__c=cuenta.id, Rut_Corredor__c=corredor.RUT__c, N_Poliza__c=1111111111, Name = '1111111111');
        insert poliza;
        List<Poliza__c> polizaEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Corredor__c = :corredor.Id];
        Poliza__c polizaUpdate = polizaEncontrada[0];
        polizaUpdate.Rut_Corredor__c = corredor2.RUT__c;
        update polizaUpdate;
        Test.stopTest();
        
        List<Poliza__c> polizaUpdatedEncontrada = [Select Rut_Corredor__c, Corredor__c From Poliza__c Where Corredor__c = :corredor2.Id];
        System.assertEquals(1, polizaUpdatedEncontrada.size());
        System.assertNotEquals(null, polizaUpdatedEncontrada[0].Corredor__c);
        System.assertEquals(corredor2.Id, polizaUpdatedEncontrada[0].Corredor__c);
        System.assertEquals(corredor2.RUT__c, polizaUpdatedEncontrada[0].Rut_Corredor__c);
    }
    
}