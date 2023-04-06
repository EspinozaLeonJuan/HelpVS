@IsTest
private class ExcepcionesDeAsignacionTest {
    
    
    @TestSetup
    static void init() {
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id = :UserInfo.getUserId()];
        user.Ejecutivo_de_Cliente__c = true;
        update user;
        
        Ejecutivo_de_Cliente__c ejecutivo = new Ejecutivo_de_Cliente__c(Name = 'Angélica Meza I.', Usuario__c = user.Id);
        insert ejecutivo;
        
        User SF_VIDA = [SELECT Id FROM User WHERE CommunityNickname = 'sfvida' Limit 1]; 
        Ejecutivo_de_Cliente__c ejecutivo2 = new Ejecutivo_de_Cliente__c(Name = 'SIN EJECUTIVO', Usuario__c = SF_VIDA.Id);
        insert ejecutivo2;        
               
        Ejecutivo_de_Cliente__c EJ_SS_CLIENTE_PPA = [SELECT Id FROM Ejecutivo_de_Cliente__c WHERE Name = 'Angélica Meza I.' Limit 1];
        Ejecutivo_de_Cliente__c EJ_EJECUTIVO = [SELECT Id, Usuario__c FROM Ejecutivo_de_Cliente__c WHERE Name = 'SIN EJECUTIVO' Limit 1];        
        
        ContactFabricate agente = (ContactFabricate) Fabricate.contacto().agente().set('Estado__c', 'Desvinculado').save();
        UserFabricate userf = (UserFabricate)Fabricate.usuario().admin().save();
        AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().setAgenteActual(agente).setPropietario(userf).save();
        PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').set('Fecha_Ultimo_Pago__c', Date.today().addYears(-2)).set('Valor_Poliza__c', 25).set('Agente_Actual__c', null).save();
        
        Account[] accounts = [SELECT Id, Owner.Ejecutivo_de_Cliente__c FROM Account WHERE 
                              Ejecutivo_de_Cliente__c <> :EJ_SS_CLIENTE_PPA.Id 
                              AND Agente_Actual__r.Estado__c = 'Desvinculado' 
                              //AND (Owner.IsActive = false OR Owner.Ejecutivo_de_Cliente__c = false) 
                              AND Cantidad_Polizas_Activas__c > 0 
                              AND Id NOT IN (Select Cuenta__c From Poliza__c Where RecordType.Name = 'Individuales' And Estatus__c = 'ACTIVA' AND Cantidad_de_Meses_Sin_Pago__c <= 3) 
                              LIMIT 10000];

        System.assertEquals(1, accounts.size(), 'La cuenta no cumple las condiciones de excepción');
        System.assert(!accounts[0].Owner.Ejecutivo_de_Cliente__c, 'El ejecutivo de cliente es true!');
    }
    
    static testMethod void asignaExcepcionesTest() {
        Test.startTest();
        ExcepcionesDeAsignacionProcess process = new ExcepcionesDeAsignacionProcess();
        process.execute(null);
        Test.stopTest();
        //Account account = [SELECT Ejecutivo_de_Cliente__c FROM Account LIMIT 1];
        //System.assertEquals(ExcepcionesDeAsignacionBatch.EJ_SS_CLIENTE_PPA.Id, account.Ejecutivo_de_Cliente__c, 'La cuenta no fue asignada');
        //Ejecutivo_de_Cliente__c EJ_SS_CLIENTE_PPA = [SELECT Id FROM Ejecutivo_de_Cliente__c WHERE Name = 'Angélica Meza I.' Limit 1];
        //System.assertEquals(EJ_SS_CLIENTE_PPA.Id, account.Ejecutivo_de_Cliente__c, 'La cuenta no fue asignada');
    }
    
    
    static testMethod void desasignaExcepcionesTest() {
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id = :UserInfo.getUserId()];
        user.Ejecutivo_de_Cliente__c = true;
        update user;
        Ejecutivo_de_Cliente__c EJ_SS_CLIENTE_PPA = [SELECT Id FROM Ejecutivo_de_Cliente__c WHERE Name = 'Angélica Meza I.' Limit 1];
        Account account = [SELECT Ejecutivo_de_Cliente__c, Id FROM Account LIMIT 1];
        account.Ejecutivo_de_Cliente__c = EJ_SS_CLIENTE_PPA.Id;
        
        update account;
        
        Poliza__c poliza = [SELECT Id, Fecha_Ultimo_Pago__c FROM Poliza__c WHERE Cuenta__c = :account.Id LIMIT 1];
        poliza.Fecha_Ultimo_Pago__c = Date.today();
        update poliza;
        Test.startTest();
        ExcepcionesDeAsignacionProcess process = new ExcepcionesDeAsignacionProcess();
        process.execute(null);
        Test.stopTest();
        //account = [SELECT Ejecutivo_de_Cliente__c FROM Account LIMIT 1];
        //System.assertNotEquals(EJ_SS_CLIENTE_PPA.Id, account.Ejecutivo_de_Cliente__c, 'La cuenta no fue desasignada');
    }
}