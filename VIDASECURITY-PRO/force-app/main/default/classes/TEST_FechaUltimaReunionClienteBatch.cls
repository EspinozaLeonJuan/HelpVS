@isTest
private class TEST_FechaUltimaReunionClienteBatch {
    @TestSetup
    static void makeData(){
        List<Account> accounts = new List<Account>();
        List<Event> events = new List<Event>();
        Id idPersona = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Fabricate.ejecutivoDeCliente().setUsuario(ejecutivo).save();
        
        accounts.add(new Account(FirstName = 'FirstName 1', LastName = 'LastName 1', Rut__c = '8898070', DV__c = '0', Rut_contacto__pc = '8898070', DV_contacto__pc = '0', RecordTypeId = idPersona));
        accounts.add(new Account(FirstName = 'FirstName 2', LastName = 'LastName 2', Rut__c = '21973677', DV__c = '0', Rut_contacto__pc = '21973677', DV_contacto__pc = '0', RecordTypeId = idPersona));
        accounts.add(new Account(FirstName = 'FirstName 3', LastName = 'LastName 3', Rut__c = '24678676', DV__c = '3', Rut_contacto__pc = '24678676', DV_contacto__pc = '3', RecordTypeId = idPersona));
        accounts.add(new Account(FirstName = 'FirstName 4', LastName = 'LastName 4', Rut__c = '18995110', DV__c = '8', Rut_contacto__pc = '18995110', DV_contacto__pc = '8', RecordTypeId = idPersona));
        accounts.add(new Account(FirstName = 'FirstName 5', LastName = 'LastName 5', Rut__c = '14425150', DV__c = '4', Rut_contacto__pc = '14425150', DV_contacto__pc = '4', OwnerId = ejecutivo.getId(), RecordTypeId = idPersona));
        insert accounts;

        for (Account a : accounts) {
            Contact c = [SELECT Id FROM Contact WHERE AccountId = :a.Id LIMIT 1];
            
            Event evento = new Event();
            evento.DurationInMinutes = 90;
            evento.WhatId = a.Id;
            evento.WhoId = c.Id;
            evento.ActivityDateTime = DateTime.now();
            evento.Subject = 'Reunión';
            events.add(evento);
        }
        insert events;
    }
    
    static testmethod void test() {
        Test.startTest();
        FechaUltimaReunionClienteBatch myBatchObject = new FechaUltimaReunionClienteBatch(); 
        Id batchId = Database.executeBatch(myBatchObject);        
        Test.stopTest();
    }
}