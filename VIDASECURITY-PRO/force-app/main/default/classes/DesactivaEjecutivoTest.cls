@IsTest
private class DesactivaEjecutivoTest {
	
	static {
		TriggerHandler.enable(new Type[] {
			DesactivaEjecutivoHandler.class,
			AsignaFechaSinEjecutivoHandler.class,
			DesvinculaAgenteHandler.class
					});
	}
    	
	@TestSetup
	static void init() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('Categoria_de_Cliente__c', 'D').set('OwnerId', ejecutivo).save();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
	}
	
	static testMethod void desactivaEjecutivoTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'OwnerId'});
		System.assertEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha sin ejecutivo no debe estar asignada');
		Id ejecutivoId = (Id)account.get().get('OwnerId');
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().load(new String[] {'IsActive'}, 'Id', ejecutivoId);
		System.assertEquals(true, ejecutivo.get().get('IsActive'), 'El ejecutivo no está activo');
		Test.startTest();
		ejecutivo.set('IsActive', false).save();
		Test.stopTest();
		account.load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'OwnerId'});
		System.assertNotEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha sin ejecutivo debe estar asignada');
					}
					
	static testMethod void reactivaEjecutivoTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'OwnerId'});
		System.assertEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha sin ejecutivo no debe estar asignada');
		Id ejecutivoId = (Id)account.get().get('OwnerId');
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().load(new String[] {'IsActive'}, 'Id', ejecutivoId);
		System.assertEquals(true, ejecutivo.get().get('IsActive'), 'El ejecutivo no está activo');
		ejecutivo.set('IsActive', false).save();
		Test.startTest();
		ejecutivo.set('IsActive', true).save();
				Test.stopTest();
		account.load(new String[] {'Fecha_Sin_Asignacion_Ejecutivo__c', 'OwnerId'});
		System.assertEquals(null, account.get().get('Fecha_Sin_Asignacion_Ejecutivo__c'), 'La fecha sin ejecutivo debe estar asignada');
					}
    
}