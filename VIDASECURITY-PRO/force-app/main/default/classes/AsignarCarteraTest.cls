@IsTest
private class AsignarCarteraTest {


	static{
		TriggerHandler.enable(new Type[] {AsignarRelacionDeCategoriaHandler.class, CalculoCategoriaClienteHandler.class});
	}
	
	@TestSetup
	static void init() {
		UserFabricate usuarioAdmin = (UserFabricate)Fabricate.usuario().admin().set('RUT_Usuario__c', '12345678-k').set('CommunityNickname', 'am').set('Username', 'admin@vidasecurity.com.fabricate').save();
		Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 1.0005).set('RUT_Usuario__c', '13231897-2').save();
		Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 100).set('Username', 'postventa2@vidasecurity.cl.fabricate').set('CommunityNickname', 'postventa2').set('RUT_Usuario__c', '13057161-1').save();
		Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 50).set('Username', 'postventa3@vidasecurity.cl.fabricate').set('CommunityNickname', 'postventa3').save();
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad().save();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal().save();
		CiudadSucursalFabricate ciudad_sucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		
		CategoriaDeClienteFabricate categoria_cliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoria_cliente).save();
		
		ContactFabricate agente = (ContactFabricate) Fabricate.contacto().agente().set('Estado__c', 'Desvinculado').save();

    	AccountFabricate cuenta = (AccountFabricate) Fabricate.cuenta().personal().setCategoriaCliente(categoria_cliente).setCiudad(ciudad).setAgenteActual(agente).setPropietario(usuarioAdmin).save();
    	PolizaFabricate poliza = (PolizaFabricate) Fabricate.poliza().individual().valorPoliza().valorPrima().activa().setCuenta(cuenta).save();
	}


	static testMethod void obtenerEjecutivos(){
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'Ciudad_Particular_B__c', 'Sucursal_Asignada__c', 'Relacion_de_Categoria__c', 'Categoria_del_Cliente__c'});
		System.assertNotEquals(null, account.get('Ciudad_Particular_B__c'), 'La ciudad particular no fue asignada');
		System.assertNotEquals(null, account.get('Categoria_del_Cliente__c'), 'La categoria del cliente no fue asignada');
		System.assertNotEquals(null, account.get('Sucursal_Asignada__c'), 'La sucursal no fue asignada');
		System.assertNotEquals(null, account.get('Relacion_de_Categoria__c'), 'La relación de categoria no fue asignada');
		Id accountId = account.get().Id;
		Test.startTest();
		Map<Id, AsignacionDeEjecutivo> asignacionMap = AsignarCarteraUtils.obtenerEjecutivos(new Id[] {accountId});
		Test.stopTest();
		System.assert(asignacionMap.containsKey(accountId), 'El mapa de asignación no contiene la cuenta');
		AsignacionDeEjecutivo asignacion = asignacionMap.get(accountId);
		System.assertNotEquals(null, asignacion);
		System.assertEquals(3, asignacion.ejecutivos.size(), 'La lista de ejecutivos post venta no es correcta.');
		System.assertNotEquals(null, asignacion.propietarioActual, 'No se ha asignado el propietario actual.');
		System.assertEquals(4, asignacion.getPropietarios().size(), 'La lista de propietarios es incorrecta');
	}
	
	static testMethod void ProponerAsignacion(){
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load();
		Id accountId = account.get().Id;
		Test.startTest();
		Map<Id, AsignacionDeEjecutivo> asignacionMap = AsignarCarteraUtils.obtenerEjecutivos(new Id[] {accountId});
		AsignarCarteraUtils.proponerAsignacion(asignacionMap);
		Test.stopTest();
		System.assert(asignacionMap.containsKey(accountId), 'El mapa de asignación no contiene la cuenta');
		AsignacionDeEjecutivo asignacion = asignacionMap.get(accountId);
		System.assertNotEquals(null, asignacion);
		System.assertNotEquals(null, asignacion.ejecutivoAsignado, 'No se ha asignado el ejecutivo');
		System.assertEquals('postventa2@vidasecurity.cl.fabricate', asignacion.ejecutivoAsignado.usuario.Username, 'No se ha asignado el ejecutivo correcto');
	}
}