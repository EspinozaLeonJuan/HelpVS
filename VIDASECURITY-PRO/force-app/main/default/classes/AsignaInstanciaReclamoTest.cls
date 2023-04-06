@isTest
private class AsignaInstanciaReclamoTest {
	
	static {
		TriggerHandler.enable(AsignaInstanciaReclamoHandler.class);
	}
	
	@TestSetup
	static void init() {
		Reclamos__c reclamo = Reclamos__c.getOrgDefaults();
		reclamo.Dias_de_Reclamos__c = 15;
		upsert reclamo;
	}

	static testMethod void casoDDATest() {
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().reclamoDDA().save();
		Test.stopTest();
		Case caso = (Case)casoFabricate.reload(new String[] {'Instancia_del_Reclamo__c'});
		System.assertEquals('Dda', caso.Instancia_del_Reclamo__c);
			}
			
	static testMethod void casoPrimeraTest() {
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.stopTest();
		Case caso = (Case)casoFabricate.reload(new String[] {'Instancia_del_Reclamo__c'});
		System.assertEquals('Primera', caso.Instancia_del_Reclamo__c);
			}
			
	static testMethod void casoSegundaTest() {
		Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.stopTest();
		Case caso = (Case)casoFabricate.reload(new String[] {'Instancia_del_Reclamo__c'});
		System.assertEquals('Segunda', caso.Instancia_del_Reclamo__c);
			}
			
	static testMethod void casoTerceraTest() {
		Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.stopTest();
		Case caso = (Case)casoFabricate.reload(new String[] {'Instancia_del_Reclamo__c'});
		System.assertEquals('Tercera o Más', caso.Instancia_del_Reclamo__c);
			}
			
				static testMethod void casoPrimeraConAnterioresTest() {
		Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Fabricate.caso().reclamoSucursal('Atención post venta', 'Atención descortés').save();
		Test.startTest();
		AbstractFabricate casoFabricate = Fabricate.caso().reclamoSucursal('Atención post venta', 'Incumplimiento de lo acordado').save();
		Test.stopTest();
		Case caso = (Case)casoFabricate.reload(new String[] {'Instancia_del_Reclamo__c'});
		System.assertEquals('Primera', caso.Instancia_del_Reclamo__c);
			}
}