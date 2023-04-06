@IsTest
private class AsignaFechaUltimaActividadTest {
    	
	
	@TestSetup
	static void init() {
		UserFabricate owner = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().setPropietario(owner).save();
		Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'ACTIVA').save();
		Fabricate.tarea().setCuenta(account).set('OwnerId', owner.get().Id).set('Status', 'Completada').save();
			}

	static testMethod void asignaFechaTest() {
		Fabricate.config().setDiasFechaUltimaActividad(1).save();
		Test.startTest();
		AsignaFechaUltimaActividadBatch batch = new AsignaFechaUltimaActividadBatch();
		batch.execute(null);
		
		Test.stopTest();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c'});
		System.assertEquals(Date.today(), account.get().get('Fecha_Ultima_Actividad__c'), 'La fecha asignada no es la correcta');
        	}
        	
	static testMethod void ejecutaDesactivadoTest() {
		Fabricate.config().setDiasFechaUltimaActividad(0).save();
		Test.startTest();
		AsignaFechaUltimaActividadBatch batch = new AsignaFechaUltimaActividadBatch();
		batch.execute(null);
				Test.stopTest();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Fecha_Ultima_Actividad__c'});
		System.assertEquals(null, account.get().get('Fecha_Ultima_Actividad__c'), 'La fecha asignada no es la correcta');
        	}
        	}