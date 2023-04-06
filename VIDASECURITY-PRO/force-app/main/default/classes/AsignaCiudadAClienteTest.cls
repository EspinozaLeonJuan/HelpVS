@isTest
public class AsignaCiudadAClienteTest {
    
    static {
    TriggerHandler.enable(AsignaCiudadAClienteHandler.class);
    }
    
    static testMethod void ClienteCiudad() {
        Test.startTest();
        Ciudad__c ciudad1 = new Ciudad__c();
        ciudad1.Name = 'PRUEBA';
        
        insert ciudad1;
        
        Ciudad__c[] ciudades = [SELECT Id, Name FROM Ciudad__c];
        Map<String, Ciudad__c> ciudadMap = new Map<String, Ciudad__c>();

        for (Ciudad__c ciudad : ciudades) {
            ciudadMap.put(ciudad.Name, ciudad);
        }  
        
        Account cuenta = Factory.buildAccount('Cuenta personal');
        cuenta.Ciudad_Particular__pc = 'PRUEBA';
        insert cuenta;
        Test.stopTest();
    }
}