@isTest
public class ActualizaFechaUltimaLlamadaTest {
	
	static {
		TriggerHandler.enable(ActualizaFechaUltimaLlamadaHandler.class);
			}
	
	static testMethod void Test() {
        Test.startTest();
        Account a = new Account();
        a.FirstName = 'A';
        a.LastName = 'B';
        a.Rut__c = '15315161';
        a.Rut__pc = '15315161';
        a.Rut_contacto__pc = '15315161';
        a.DV__c = 'K';
        a.DV_contacto__pc = 'K';
        a.Fecha_ltima_Llamada__c = Date.today().addDays(-10);
        
        insert a;
        
        Task t = new Task();
        t.Subject = 'Llamada2';
        t.Status = 'Completada';
        t.Fecha_de_Llamada__c = Date.today().addDays(-3);
        t.WhatId = a.Id;
        t.ActivityDate = Date.today();
        
        Task t1 = new Task();
        t1.Subject = 'Llamada1';
        t1.Status = 'Completada';
        t1.Fecha_de_Llamada__c = Date.today().addDays(-1);
        t1.WhatId = a.Id;
        t1.ActivityDate = Date.today();
        
        Task t2 = new Task();
        t2.Subject = 'Llamada2';
        t2.Status = 'Completada';
        t2.Fecha_de_Llamada__c = Date.today().addDays(-7);
        t2.WhatId = a.Id;
        t2.ActivityDate = Date.today();
        
        Task t3 = new Task();
        t3.Subject = 'Llamada2';
        t3.Status = 'Completada';
        t3.Fecha_de_Llamada__c = Date.today().addDays(-15);
        t3.WhatId = a.Id;
        t3.ActivityDate = Date.today();
        
        Task[] tasks = new List<Task>();
        tasks.add(t);
        tasks.add(t1);
        tasks.add(t2);
        tasks.add(t3);
        insert tasks;
        
        Account a2 = [select id, Fecha_ltima_Llamada__c from Account where id =: a.Id limit 1];
        
        
        System.assertEquals(a2.Fecha_ltima_Llamada__c, Date.today().addDays(-1));
        Test.stopTest();
    }
}