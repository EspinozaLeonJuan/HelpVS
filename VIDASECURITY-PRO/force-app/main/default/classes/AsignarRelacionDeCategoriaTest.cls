@IsTest
private class AsignarRelacionDeCategoriaTest {
	
	static {
		TriggerHandler.enable(AsignarRelacionDeCategoriaHandler.class);
	} 

	@TestSetup
	static void init() {
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudad_sucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		
		CategoriaDeClienteFabricate categoria_cliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoria_cliente).save();
	}
	
	static testMethod void asignarTest() {
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad().load();
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().load();
		Test.startTest();
		AccountFabricate cuenta = (AccountFabricate) Fabricate.cuenta().personal().setCategoriaCliente(categoriaCliente).setCiudad(ciudad).save();
		Test.stopTest();
		cuenta.load(new String[] {'Relacion_de_Categoria__c', 'Sucursal_Asignada__c'});
		System.assertNotEquals(null, cuenta.get('Sucursal_Asignada__c'), 'La sucursal no fue asignada');
		System.assertNotEquals(null, cuenta.get('Relacion_de_Categoria__c'), 'La relacion de categoria no fue asignada');
	}
    }