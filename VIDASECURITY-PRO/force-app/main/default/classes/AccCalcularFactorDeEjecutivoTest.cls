/**
* VASS
* @author           Javier Tibamoza
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    09/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccCalcularFactorDeEjecutivoTest {

    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccCalcularFactorDeEjecutivoTest.testExecute')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idUserEjecutivo = (Id)ejecutivo.get().get('Id');
        Test.startTest();
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('OwnerId',idUserEjecutivo).set('Categoria_del_Cliente__c',idCategoria).save();
        
        Test.stopTest();
    }

    static testMethod void testGetOldEjecutivoIds(){
        if(!TestVerificationService.ShouldExecute('AccCalcularFactorDeEjecutivoTest.testExecute')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        UserFabricate ejecutivo2 = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.dos.ejecutivo.cliente@security.cl').set('CommunityNickname','udosnik').set('RUT_Usuario__c','33333333-3').save();
        CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idUserEjecutivo = (Id)ejecutivo.get().get('Id');
        Id idUserEjecutivo2 = (Id)ejecutivo2.get().get('Id');
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('OwnerId',idUserEjecutivo).set('Categoria_del_Cliente__c',idCategoria).save();
        Account oNewCuenta = (Account)account.get();
        Account oOldCuenta = (Account)account.get();
        oNewCuenta.OwnerId = idUserEjecutivo;
        oOldCuenta.OwnerId = idUserEjecutivo2;
        Set<Id> ejecutivoClienteIds = new Set<Id>();
        List<Id> ejecutivoIds = new List<Id>();
        ejecutivoClienteIds.add(oNewCuenta.OwnerId);
        ejecutivoClienteIds.add(oOldCuenta.OwnerId);
        Test.startTest();
        ejecutivoIds = AccCalcularFactorDeEjecutivo.getOldEjecutivoIds(null, oOldCuenta, ejecutivoClienteIds, ejecutivoIds );
        
        AccCalcularFactorDeEjecutivo.execute(ejecutivoIds);
        Test.stopTest();
    }
    static testMethod void testGetNewEjecutivoIds(){
        if(!TestVerificationService.ShouldExecute('AccCalcularFactorDeEjecutivoTest.testExecute')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        UserFabricate ejecutivo2 = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.dos.ejecutivo.cliente@security.cl').set('CommunityNickname','udosnik').set('RUT_Usuario__c','33333333-3').save();
        CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idUserEjecutivo = (Id)ejecutivo.get().get('Id');
        Id idUserEjecutivo2 = (Id)ejecutivo2.get().get('Id');
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('OwnerId',idUserEjecutivo).set('Categoria_del_Cliente__c',idCategoria).save();
        Account oNewCuenta = (Account)account.get();
        Account oOldCuenta = (Account)account.get();
        oNewCuenta.OwnerId = idUserEjecutivo;
        oOldCuenta.OwnerId = idUserEjecutivo2;
        Set<Id> ejecutivoClienteIds = new Set<Id>();
        List<Id> ejecutivoIds = new List<Id>();
        ejecutivoClienteIds.add(oNewCuenta.OwnerId);
        ejecutivoClienteIds.add(oOldCuenta.OwnerId);
        Test.startTest();
        ejecutivoIds = AccCalcularFactorDeEjecutivo.getNewEjecutivoIds(oNewCuenta,null , ejecutivoClienteIds, ejecutivoIds );
        
        AccCalcularFactorDeEjecutivo.execute(ejecutivoIds);
        Test.stopTest();
    }
}