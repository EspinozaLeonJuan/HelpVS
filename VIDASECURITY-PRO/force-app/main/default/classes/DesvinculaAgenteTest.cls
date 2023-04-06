@IsTest
private class DesvinculaAgenteTest {
	
    	
	static {
		TriggerHandler.enable(new Type[] {
		AsignaAgenteActualACuentaHandler.class,
		DesvinculaAgenteHandler.class
				});
			}
	
@TestSetup
	static void init() {
		Fabricate.contacto().supervisor().save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('Codigo_Agente__c', '123456').set('Agente_Actual__c', agente).save();
		account.load(new String[] {'OwnerId'});
		Id ownerId = (Id)account.get('OwnerId');
		User ejecutivo = [SELECT Id, IsActive, Ejecutivo_de_Cliente__c FROM User WHERE Id = :ownerId];
		System.assertEquals(false, ejecutivo.Ejecutivo_de_Cliente__c, 'Es un ejecutivo de cliente y no debería serlo porque la idea es que la cuenta solo esté enganchada al agente!');
			}
    			
	static testMethod void desvinculaAgenteVigenteTest() {
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().load(new String[]{}, 'Codigo_Agente__c', '123456');
		Id agenteId = (Id)agente.get().get('Id');
		Test.startTest();
		agente.set('Estado__c', 'Desvinculado').save();
		Test.stopTest();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'Agente_Actual__c', 'OwnerId'});
		Id ownerId = (Id)account.get('OwnerId');
		User ejecutivo = [SELECT Id, IsActive, Ejecutivo_de_Cliente__c FROM User WHERE Id = :ownerId];
		System.assertEquals(false, ejecutivo.Ejecutivo_de_Cliente__c, 'Es un ejecutivo de cliente!');
	System.assertNotEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha no fue asignada');
	}
			
	static testMethod void eliminaAgenteVigenteTest() {
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().load(new String[]{}, 'Codigo_Agente__c', '123456');
		System.Dmlexception dml = null;
		Test.startTest();
		try {
			delete agente.get();
		} catch (System.Dmlexception e) {
			dml = e;
					}
		Test.stopTest();
		System.assertNotEquals(null, dml, 'Debe lanzar una excepción');
	}
			
    			
	static testMethod void revinculaAgenteVigenteTest() {
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().load(new String[]{}, 'Codigo_Agente__c', '123456');
		agente.set('Estado__c', 'Desvinculado').save();
		Test.startTest();
		agente.set('Estado__c', 'Vigente').save();
		Test.stopTest();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'Agente_Actual__c', 'OwnerId'});
		System.assertEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha fue asignada');
	}
}