@IsTest
private class ActualizaFrecuenciaPagoDePolizaTest {
	
    static {
		TriggerHandler.enable(ActualizaFrecuenciaPagoDePolizaHandler.class);
	}
    
    @isTest 
    static void testMethod1() {
        
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		        
        User user = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id = :UserInfo.getUserId()];
        user.Ejecutivo_de_Cliente__c = true;
        update user;
        
        Account account = Factory.buildAccount('Cuenta personal');
        account.OwnerId = user.Id;
		insert account;
        
        Poliza__c poliza1 = new Poliza__c();
        poliza1.Cuenta__c = account.Id;
        poliza1.RecordTypeId = recordTypeIndividuales;
        poliza1.Frecuencia_de_Pago__c = 'Mensual';
        poliza1.N_Poliza__c = 1516891;
        
        Poliza__c poliza2 = new Poliza__c();
        poliza2.Cuenta__c = account.Id;
        poliza2.RecordTypeId = recordTypeIndividuales;
        poliza2.Frecuencia_de_Pago__c = 'Trimestral';
        poliza2.N_Poliza__c = 1516892;
        
        Poliza__c poliza3 = new Poliza__c();
        poliza3.Cuenta__c = account.Id;
        poliza3.RecordTypeId = recordTypeIndividuales;
        poliza3.Frecuencia_de_Pago__c = 'Semestral';
        poliza3.N_Poliza__c = 1516893;
        
        Poliza__c poliza4 = new Poliza__c();
        poliza4.Cuenta__c = account.Id;
        poliza4.RecordTypeId = recordTypeIndividuales;
        poliza4.Frecuencia_de_Pago__c = 'Anual';
        poliza4.N_Poliza__c = 1516894;
        
        Poliza__c poliza5 = new Poliza__c();
        poliza5.Cuenta__c = account.Id;
        poliza5.RecordTypeId = recordTypeIndividuales;
        poliza5.Frecuencia_de_Pago__c = 'Única';
        poliza5.N_Poliza__c = 1516895;
        
        Poliza__c[] polizas = new List<Poliza__c>();
        polizas.add(poliza1);
        polizas.add(poliza2);
        polizas.add(poliza3);
        polizas.add(poliza4);
        polizas.add(poliza5);
        
      	Test.startTest();
      	insert polizas;
        System.assertEquals('M', [SELECT Frecuencia_de_Pago__c FROM Poliza__c WHERE ID =:poliza1.Id].Frecuencia_de_Pago__c);
        System.assertEquals('T', [SELECT Frecuencia_de_Pago__c FROM Poliza__c WHERE ID =:poliza2.Id].Frecuencia_de_Pago__c);
        System.assertEquals('S', [SELECT Frecuencia_de_Pago__c FROM Poliza__c WHERE ID =:poliza3.Id].Frecuencia_de_Pago__c);
        System.assertEquals('A', [SELECT Frecuencia_de_Pago__c FROM Poliza__c WHERE ID =:poliza4.Id].Frecuencia_de_Pago__c);
        System.assertEquals('U', [SELECT Frecuencia_de_Pago__c FROM Poliza__c WHERE ID =:poliza5.Id].Frecuencia_de_Pago__c);
     	Test.stopTest(); 
    }
}