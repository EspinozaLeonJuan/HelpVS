@isTest
public class TEST_ActualizaPropietarioTarea {
	
    static testMethod void test(){
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Administrador del sistema' LIMIT 1];
        Test.startTest();
        User u1 = new User();
        u1.LastName = 'Aaaa';
        u1.FirstName='Aaa';
        u1.Alias = 'Aaaaa';
        u1.Email = 'aaa.aaa@vidatest12.com';
        u1.Username = 'aaa.aaa@vidatest12.com';
        u1.ProfileId = profileId.id;
        u1.TimeZoneSidKey = 'GMT';
        u1.LanguageLocaleKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LocaleSidKey = 'en_US';
        u1.RUT_Usuario__c = '12321';
                           
        User u2 = new User();
        u2.LastName = 'Bbbb';
        u2.FirstName='Bbb';
        u2.Alias = 'Bbbbb';
        u2.Email = 'bbb.bbb@vidatest12.com';
        u2.Username = 'bbb.bbb@vidatest12.com';
        u2.ProfileId = profileId.id;
        u2.TimeZoneSidKey = 'GMT';
        u2.LanguageLocaleKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.LocaleSidKey = 'en_US';
        u2.RUT_Usuario__c = '32123';
        
        List<User> users = new List<User>();
        users.add(u1);
        users.add(u2);
        insert users;
        
        Account a1 = new Account();
        a1.FirstName = 'Cccc';
        a1.LastName = 'Cccc';
        a1.Rut__c = '15315161';
        a1.Rut__pc = '15315161';
        a1.Rut_contacto__pc = '15315161';
        a1.DV__c = 'K';
        a1.DV_contacto__pc = 'K';
        a1.OwnerId = u1.Id;
        
        insert a1;
        
        Task t1 = new Task();
        t1.Subject = 'Llamada2';
        t1.Status = 'Abierta';
        t1.WhatId = a1.Id;
        t1.ActivityDate = Date.today();
        t1.OwnerId = u1.Id;
        
        Task t2 = new Task();
        t2.Subject = 'Llamada1';
        t2.Status = 'Abierta';
        t2.WhatId = a1.Id;
        t2.ActivityDate = Date.today();
        t2.OwnerId = u1.Id;
        
        Task t3 = new Task();
        t3.Subject = 'Llamada2';
        t3.Status = 'Abierta';
        t3.WhatId = a1.Id;
        t3.ActivityDate = Date.today();
        t3.OwnerId = u1.Id;
        
        List<Task> tasks = new List<Task>();
        tasks.add(t1);
        tasks.add(t2);
        tasks.add(t3);
        insert tasks;
        
        a1.OwnerId = u2.Id;
        update a1;
        List<Id> ids = new List<Id>();
        ids.add(a1.Id);
        ActualizaPropietarioTarea.ActualizaPropietarioTarea(ids);
        
        List<Task> tareas = [SELECT Id, OwnerId FROM Task WHERE WhatId =: a1.Id]; 
        for(Task t : tareas){
			System.assertEquals(t.OwnerId, u2.Id);
        }
        
        Test.stopTest();
        
	}
    
}