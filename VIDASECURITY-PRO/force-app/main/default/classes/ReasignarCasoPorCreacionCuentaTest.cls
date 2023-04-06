@isTest
public class ReasignarCasoPorCreacionCuentaTest {
	static {
		TriggerHandler.enable(ReasignarCasoPorCreacionCuentaHandler.class);
			}
	
    static TestMethod void Prueba(){
        
        
        Factory.crearAccountAnonimo();
        
        Account cuentaOriginal = Factory.buildAccount('Cuenta personal');
        cuentaOriginal.Rut_contacto__pc = '11111111';
        cuentaOriginal.DV_contacto__pc = '1';
        insert cuentaOriginal;
        
        Case caso = Factory.buildCasoSF('Consultas', cuentaOriginal);
        caso.Reasignar_a_Rut__c = 22222222;
        insert caso;
        
        Account cuentaNueva = Factory.buildAccount('Cuenta personal');
        cuentaNueva.Rut_contacto__pc = '22222222';
        cuentaNueva.DV_contacto__pc = '2';
        insert cuentaNueva;
        
        Case casoUpdated = [select AccountID from case where Id =: caso.Id][0];

        System.assertEquals(casoUpdated.AccountId, cuentaNueva.Id);
        
        caso.Reasignar_a_Rut__c = 11111111;
        update caso;
        
        cuentaOriginal.LastName = 'Update';
        update cuentaOriginal;
        
        casoUpdated = [select AccountID from case where Id =: caso.Id][0];
        
        Test.startTest();
        System.assertEquals(casoUpdated.AccountId, cuentaOriginal.Id);
        Test.stopTest();
    }
}