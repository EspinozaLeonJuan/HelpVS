@isTest
private class AsignaFechaTopeTest {

	static CaseFabricate caso {get; set;}

	static {
		TriggerHandler.enable(AsignaFechaTopeHandler.class);
		AccountFabricate cuenta = (AccountFabricate)Fabricate.cuenta().personal().save();
		caso = Fabricate.caso().reclamo().setCuenta(cuenta);
	}

	@isTest static void casoCanalSVSConFecha() {
		Date today = Date.today();
		caso.set('Canal__c', 'SVS');
		caso.set('Fecha_tope_Vida_Security__c', today);
		caso.save();
		Case casoResultado = [Select Id, Canal__c, Fecha_tope_Vida_Security__c From Case Limit 1];
		System.assertEquals('SVS', casoResultado.Canal__c);
		System.assertEquals(today, casoResultado.Fecha_tope_Vida_Security__c);
	}

	@isTest static void casoCanalSVSConFechaVencida() {
		Date today = Date.today();
		caso.set('Canal__c', 'SVS');
		caso.set('Fecha_tope_Vida_Security__c', today.addDays(-1));
		try {
			caso.save();
		} catch (Exception e) {
			System.assertEquals(true, e.getMessage().contains('Favor especifique una fecha de tope mayor o igual a hoy'));
		}

	}

	@isTest static void casoCanalSVSSinFecha() {
		Date today = Date.today();
		caso.set('Canal__c', 'SVS');
		caso.set('Tipo_Operacion__c', 'Información');
		caso.save();
		Case casoResultado = [Select Id, Canal__c, Complejidad_del_Reclamo__c, Fecha_tope_Vida_Security__c From Case Limit 1];
		System.assertEquals('SVS', casoResultado.Canal__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 18), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals('5', casoResultado.Complejidad_del_Reclamo__c);
	}

	@isTest static void casoCanalNOSVS() {
		Date today = Date.today();
		caso.set('Canal__c', 'WEB');
		caso.set('Fecha_tope_Vida_Security__c', today);
		try {
			caso.save();
		} catch (Exception e) {
			System.assertEquals(true, e.getMessage().contains('No puede especificar la fecha si el canal es distinto de SVS'));
		}

	}

	@isTest static void caso5DiasHabiles() {
		Date today = Date.today();
		caso.set('Canal__c', 'Sucursal');
		caso.set('Tipo_Operacion__c', 'Sucursales');
		caso.save();
		Case casoResultado = [Select Id, Tipo_Operacion__c, Complejidad_del_Reclamo__c, Fecha_tope_Vida_Security__c From Case Limit 1];
		System.assertEquals('Sucursales', casoResultado.Tipo_Operacion__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 5), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals('1', casoResultado.Complejidad_del_Reclamo__c);

	}

	@isTest static void caso7DiasHabiles() {
		Date today = Date.today();
		caso.set('Canal__c', 'Sucursal');
		caso.set('Tipo_Operacion__c', 'Información');
		caso.save();
		Case casoResultado = [Select Id, Tipo_Operacion__c, Complejidad_del_Reclamo__c, Fecha_tope_Vida_Security__c From Case Limit 1];
		System.assertEquals('Información', casoResultado.Tipo_Operacion__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 7), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals('2', casoResultado.Complejidad_del_Reclamo__c);

	}

	@isTest static void caso10DiasHabiles() {
		Date today = Date.today();
		caso.set('Canal__c', 'Sucursal');
		caso.set('Tipo_Operacion__c', 'Endosos');
		caso.save();
		Case casoResultado = [Select Id, Tipo_Operacion__c, Complejidad_del_Reclamo__c, Fecha_tope_Vida_Security__c, Fecha_Cierre_Tope__c From Case Limit 1];
		System.assertEquals('Endosos', casoResultado.Tipo_Operacion__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 10), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 18), casoResultado.Fecha_Cierre_Tope__c);
		System.assertEquals('3', casoResultado.Complejidad_del_Reclamo__c);

	}

	@isTest static void casoCanalDDA() {
		Date today = Date.today();
		caso.set('Canal__c', 'DDA');
		caso.set('Tipo_Operacion__c', 'Sucursales');
		caso.save();
		Case casoResultado = [Select Id, Tipo_Operacion__c, Canal__c, Fecha_tope_Vida_Security__c, Fecha_Cierre_Tope__c From Case Limit 1];
		System.assertEquals('DDA', casoResultado.Canal__c);
		System.assertEquals('Sucursales', casoResultado.Tipo_Operacion__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 10), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 10), casoResultado.Fecha_Cierre_Tope__c);

	}

	@isTest static void casoCanalSernac() {
		Date today = Date.today();
		caso.set('Canal__c', 'Sernac');
		caso.set('Tipo_Operacion__c', 'Apertura');
		caso.save();
		Case casoResultado = [Select Id, Tipo_Operacion__c, Complejidad_del_Reclamo__c, Canal__c, Fecha_tope_Vida_Security__c, Fecha_Cierre_Tope__c From Case Limit 1];
		System.assertEquals('Sernac', casoResultado.Canal__c);
		System.assertEquals('Apertura', casoResultado.Tipo_Operacion__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 7), casoResultado.Fecha_tope_Vida_Security__c);
		System.assertEquals(HolidayUtils.addBussinessDays(today, 7), casoResultado.Fecha_Cierre_Tope__c);
		System.assertEquals('4', casoResultado.Complejidad_del_Reclamo__c);

	}

}