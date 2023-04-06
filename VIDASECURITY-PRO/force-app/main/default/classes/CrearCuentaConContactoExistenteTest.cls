@isTest
public class CrearCuentaConContactoExistenteTest {
	
	static {
		TriggerHandler.enable(CrearCuentaConContactoExistenteHandler.class);
	}
	
    static TestMethod void Test() {
        Factory.crearAccountAnonimo();
        Account cAnonimo = [select id from Account where Rut__c = '99999998' limit 1];
        
        Contact contacto = Factory.buildContact(cAnonimo);
        contacto.Rut_contacto__c = '11111111';
        contacto.DV_contacto__c = '1';
        insert contacto;
        
        Account cuentaNueva = Factory.buildAccount('Cuenta personal');
        cuentaNueva.Rut__c = '11111111';
        cuentaNueva.Rut_contacto__pc = '11111111';
        cuentaNueva.DV__c = '1';
        cuentaNueva.DV_contacto__pc = '1';
        insert cuentaNueva;
        //aqui se elimina el contacto antiguo y solo queda el nuevo
        
        Contact[] contactoNuevo = [select Rut_contacto__c, AccountId from Contact where Rut_contacto__c =: cuentaNueva.Rut_contacto__pc];
        
        System.assertEquals(contactoNuevo.size(), 1); // solo debería existir un contacto con ese rut
        System.assertEquals(contactoNuevo[0].AccountId, cuentaNueva.Id); // la cuenta del contacto tiene que ser la nueva cuenta creada
    }
}