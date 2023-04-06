@IsTest
private class AsignacionMasivaEjecutivosTest {
	public static UserFabricate usuarioAdmin;
	public static UserFabricate usuarioPostVenta;
    public static UserFabricate usuarioPostVenta2;
    public static CiudadFabricate ciudad;
    public static SucursalFabricate sucursal;
    public static CiudadSucursalFabricate ciudad_sucursal;
    public static CategoriaDeClienteFabricate categoria_cliente ;
    public static RelacionDeCategoriaFabricate relacion_categoria;
        
	
	static {

        ciudad = (CiudadFabricate)Fabricate.ciudad().save();
        sucursal = (SucursalFabricate)Fabricate.sucursal().save();
        ciudad_sucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
        categoria_cliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
        relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoria_cliente).save();
		usuarioAdmin = (UserFabricate)Fabricate.usuario().admin().set('RUT_Usuario__c', '12345678-k').set('CommunityNickname', 'am').set('Username', 'admin@vs.com.fabricate').save();
        usuarioPostVenta = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 50).set('Username', 'postventa4@vidasecurity.cl.fabricate').set('CommunityNickname', 'postventa4').set('RUT_Usuario__c', '13231897-3').set('Ejecutivo_de_Cliente__c', true).set('Omitir_asignacion_AMAC__c',false).save();
        Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 1.0005).set('RUT_Usuario__c', '13231897-2').save();
        Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 100).set('Username', 'postventa2@vidasecurity.cl.fabricate').set('CommunityNickname', 'postventa2').set('RUT_Usuario__c', '13057161-1').save();
        Fabricate.usuario().ejecutivoDeCliente().set('Codigo_Sucursal__c', '00001').set('Categoria_de_Ejecutivo__c', 'Prime').set('Factor_de_Ejecutivo__c', 50).set('Username', 'postventa3@vidasecurity.cl.fabricate').set('CommunityNickname', 'postventa3').save();
        
	}

    static testMethod void carteraDesvinculada(){
    	PageReference pageRef = Page.Asignacion_de_Cartera;
		Test.setCurrentPage(pageRef);
        List<User> usuariosPostVenta;
    	AsignacionMasivaEjecutivosControlador controlador = new AsignacionMasivaEjecutivosControlador();
    	ContactFabricate agente = (ContactFabricate) Fabricate.contacto().agente().set('Estado__c', 'Desvinculado').save();
    	AccountFabricate cuenta = (AccountFabricate) Fabricate.cuenta().personal().setCiudad(ciudad).setCategoriaCliente(categoria_cliente).setAgenteActual(agente).setPropietario(usuarioAdmin).setRelacionDeCategoria(relacion_categoria).setCiudadSucursal(ciudad_sucursal).save();
    	ApexPages.currentPage().getParameters().put('ownerId', (Id)usuarioPostVenta.get().get('Id'));
        ApexPages.currentPage().getParameters().put('accountId', (Id)cuenta.get().get('Id'));
        PolizaFabricate poliza = (PolizaFabricate) Fabricate.poliza().individual().valorPoliza().valorPrima().activa().setCuenta(cuenta).save();
        Id idCuenta = (Id)cuenta.get().get('Id');
	   	Test.startTest();  	
        controlador.getItems();
    	controlador.cambioFiltro();
        //controlador.cuentas;
        AsignacionDeEjecutivo asignacion = controlador.mapUsuariosPorCuenta.get(idCuenta);
        Account[] accounts = (Account[])controlador.controladorLista.getRecords();
        System.assertNotEquals(null, accounts, 'No hay cuentas');
    	Account cuentaAModificar = accounts[0];
    	        usuariosPostVenta = controlador.mapUsuariosPorCuenta.get(idCuenta).getPropietarios();
        cuentaAModificar.OwnerId = usuariosPostVenta.get(1).Id;
    	controlador.getPageNumber();
        controlador.next();
    	controlador.previous();
    	controlador.first();
    	controlador.last();       
    	controlador.asignar();
        controlador.exportar();
        Test.stopTest();
        controlador.asignarMasivamente();
        controlador.irAPagina();
        controlador.proponerAsignacion();
        controlador.establecerSucursal();
        controlador.addInfo('Info');
        Account cuentaResult = [Select Id, OwnerId From Account];
        System.assert(usuariosPostVenta.get(1).Id == cuentaResult.OwnerId, 'No fue asignado correctamente el propietario POSTVENTA');
        System.assert(controlador.getPaginas().size() == 1, 'El numero de paginas debia ser 1 y fue ' + controlador.getPaginas().size());
        System.assert(controlador.controladorLista.getRecords().size() == 1, 'El total de registros debia ser 1 y fue ' + controlador.controladorLista.getRecords().size());
    }

    static testMethod void carteraVinculada(){
    	PageReference pageRef = Page.Asignacion_de_Cartera;
		Test.setCurrentPage(pageRef);
    	AsignacionMasivaEjecutivosControlador controlador = new AsignacionMasivaEjecutivosControlador();
    	ContactFabricate agente = (ContactFabricate) Fabricate.contacto().agente().set('Estado__c', 'Desvinculado').save();
    	AccountFabricate cuenta = (AccountFabricate) Fabricate.cuenta().personal().setAgenteActual(agente).setPropietario(usuarioPostVenta).save();
    	PolizaFabricate poliza = (PolizaFabricate) Fabricate.poliza().individual().valorPoliza().valorPrima().activa().setCuenta(cuenta).save();
    	agente.set('Estado__c', 'Vigente');
    	agente.updates();
	   	Test.startTest();  	
    	controlador.filtro = 'Cuenta_Vinculada';
    	controlador.cambioFiltro();
        Test.stopTest();
        System.assert(controlador.getPaginas().size() == 1, 'El numero de paginas debia ser 1 y fue ' + controlador.getPaginas().size());
        System.assert(controlador.controladorLista.getRecords().size() == 1, 'El total de registros debia ser 1 y fue ' + controlador.controladorLista.getRecords().size());
    }
}