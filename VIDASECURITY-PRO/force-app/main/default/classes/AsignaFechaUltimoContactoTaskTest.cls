@isTest
public class AsignaFechaUltimoContactoTaskTest {
static {
		TriggerHandler.enable(AsignaFechaUltimoContactoTaskHandler.class);
			}
	
	@TestSetup
	static void init() {
		UserFabricate owner = (UserFabricate)Fabricate.usuario().postVenta().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().setPropietario(owner).save();
		Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'ACTIVA').save();
			}

	static testMethod void creaTareaTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'});
		Id ownerId = (Id)account.get().get('OwnerId');
		User postVenta = [SELECT Id FROM User WHERE Id = :ownerId];
		Test.startTest();
		System.runAs(postVenta) {
			Fabricate.tarea().setCuenta(account).set('Status', 'Completada').save();
		}
		Test.stopTest();
		account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c'});
		System.assertEquals(Date.today(), account.get().get('Fecha_Ultima_Actividad__c'), 'La fecha asignada no es la correcta');
        	}
        	
	static testMethod void creaEventoTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'});
		Id ownerId = (Id) account.get().get('OwnerId');
		User postVenta = [SELECT Id FROM User WHERE Id = :ownerId];
		Test.startTest();
		System.runAs(postVenta) {
		//	Fabricate.evento().setCuenta(account).save();
		}
		Test.stopTest();
		account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c'});
		//System.assertEquals(Date.today(), account.get().get('Fecha_Ultima_Actividad__c'), 'La fecha asignada no es la correcta');
        	}
}