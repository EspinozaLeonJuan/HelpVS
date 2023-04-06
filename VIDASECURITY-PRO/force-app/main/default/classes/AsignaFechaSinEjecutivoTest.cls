@IsTest
private class AsignaFechaSinEjecutivoTest {
	
	static {
		TriggerHandler.enable(new Type[] {
		AsignaAgenteActualACuentaHandler.class
		});
			}
	
@TestSetup
	static void init() {
		Fabricate.contacto().supervisor().save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('Codigo_Agente__c', '123456').set('Agente_Actual__c', agente).save();
			}
			
static testMethod void borraAgenteVigenteTest() {
	AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[]{'Agente_Actual__c'});
	System.assertNotEquals(null, account.get().get('Agente_Actual__c'), 'El agente actual no fue especificado.');
	TriggerHandler.enable(AsignaFechaSinEjecutivoHandler.class);
	Test.startTest();
	account.set('Agente_Actual__c', null).set('Codigo_Agente__c', null).save();
	Test.stopTest();
	account.load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'Agente_Actual__c', 'OwnerId'}, 'Id', account.get().Id);
	Id ownerId = (Id)account.get().get('OwnerId');
	User ejecutivo = [SELECT Id, Ejecutivo_de_Cliente__c, Username, IsActive FROM User WHERE Id = :ownerId];
	System.assert(ejecutivo.IsActive, 'El ejecutivo actual está desactivado');
	System.assertNotEquals(true, ejecutivo.Ejecutivo_de_Cliente__c, 'El propietario actual es ejecutivo de cliente');
	System.assert(!ejecutivo.Username.contains('sfvida@security.cl'), 'La cuenta está asignada a un ejecutivo especial.');
	System.assertEquals(null, account.get().get('Agente_Actual__c'), 'El agente actual no fue borrado.');
	System.assertNotEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'No fue asignada la fecha sin ejecutivo');
	}
	
	static testMethod void cambiaAgenteVigenteTest() {
	AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load();
	ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123457').set('Estado__c', 'Vigente').set('RUT__c', '5555555-5').set('FirstName', 'John').set('LastName', 'Doe').save();
	Test.startTest();
	account.set('Agente_Actual__c', agente).save();
	Test.stopTest();
	account.load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c'});
	System.assertEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha no fue borrada.');
	}
	    }