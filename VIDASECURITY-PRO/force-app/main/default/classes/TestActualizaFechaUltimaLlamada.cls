@isTest
public class TestActualizaFechaUltimaLlamada {
	/****
	* Deprecated por test ActualizaFechaUltimaLlamadaTest
	*
	static testMethod void Test() {
        
        Account a = new Account();
        a.FirstName = 'A';
        a.LastName = 'B';
        a.Rut__c = '15315161';
        a.Rut__pc = '15315161';
        a.Rut_contacto__pc = '15315161';
        a.DV__c = 'K';
        a.DV_contacto__pc = 'K';
        
        insert a;
        
        Task t = new Task();
        t.Subject = 'Llamada';
        t.Status = 'Completada';
        t.Fecha_de_Llamada__c = Date.today();
        t.WhatId = a.Id;
        t.ActivityDate = Date.today();
        insert t;
        
        Account a2 = [select id, Fecha_ltima_Llamada__c from Account where id =: a.Id limit 1];
        
        Test.startTest();
        System.assertNotEquals(a2.Fecha_ltima_Llamada__c, null);
        system.debug(a2.Fecha_ltima_Llamada__c);
        Test.stopTest();
    }
    */
}