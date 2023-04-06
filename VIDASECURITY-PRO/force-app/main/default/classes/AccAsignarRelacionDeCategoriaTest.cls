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
private class AccAsignarRelacionDeCategoriaTest {

    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignarRelacionDeCategoriaTest.testExecute')){return;}
        /**********************************************************************************/
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idCiudadSucursal = (Id)ciudadSucursal.get().get('Id');
        Test.startTest();
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Categoria_del_Cliente__c',idCategoria).set('Sucursal_Asignada__c',idCiudadSucursal).save();
        Test.stopTest();
    }

    static testMethod void testExecuteNull(){
        if(!TestVerificationService.ShouldExecute('AccAsignarRelacionDeCategoriaTest.testExecuteNull')){return;}
        /**********************************************************************************/
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idCiudadSucursal = (Id)ciudadSucursal.get().get('Id');
        Id idCiudadB = (Id)ciudad.get().get('Id');

        Test.startTest();
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Categoria_del_Cliente__c',idCategoria).set('Sucursal_Asignada__c',idCiudadSucursal);
        Account accountNew = (Account)account.get();
        accountNew.Categoria_del_Cliente__c = null;
        Account accountOld = (Account)account.get();
        List<Id> ciudadIds = new List<Id>();
        List<Id> categoriaIds = new List<Id>();
        Id idCategoria2 = AccAsignarRelacionDeCategoria.getCategoriaID( accountNew, accountOld, categoriaIds );
        categoriaIds.add(idCategoria2);
        idCategoria2 = AccAsignarRelacionDeCategoria.getCategoriaID( accountNew, accountOld, categoriaIds );
        accountNew.Ciudad_particular_B__c = idCiudadB;
        Id idCiudad = AccAsignarRelacionDeCategoria.getCiudadID( accountNew, accountOld, ciudadIds);
        //ciudadIds.add(idCiudad);
        idCiudad = AccAsignarRelacionDeCategoria.getCiudadID( accountNew, accountOld, ciudadIds);
        Account oAccount = AccAsignarRelacionDeCategoria.getAccountEje( accountNew,  accountOld,  ciudadIds );
        Test.stopTest();
    }

    static testMethod void testExecuteError(){
        if(!TestVerificationService.ShouldExecute('AccAsignarRelacionDeCategoriaTest.testExecuteNull')){return;}
        /**********************************************************************************/
		CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
		SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal();
		CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().setSucursal(sucursal).setCiudad(ciudad).save();
		
		CategoriaDeClienteFabricate categoriaCliente = (CategoriaDeClienteFabricate)Fabricate.categoria_cliente().save();
		RelacionDeCategoriaFabricate relacion_categoria = (RelacionDeCategoriaFabricate)Fabricate.relacion_categoria().setSucursal(sucursal).setCategoriaDeCliente(categoriaCliente).save();
        Id idCategoria = (Id)categoriaCliente.get().get('Id');
        Id idCiudadSucursal = (Id)ciudadSucursal.get().get('Id');
        Id idCiudadB = (Id)ciudad.get().get('Id');

        Test.startTest();
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Categoria_del_Cliente__c',idCategoria).set('Sucursal_Asignada__c',idCiudadSucursal);
        Account accountNew = (Account)account.get();
        accountNew.Categoria_del_Cliente__c = null;
        Account accountOld = (Account)account.get();
        Ciudad_de_Sucursal__c oCiudadSucursal = (Ciudad_de_Sucursal__c)ciudadSucursal.get();
        Relacion_de_Categoria__c oRelacionCategoria = (Relacion_de_Categoria__c)relacion_categoria.get();

        List<Id> ciudadIds = new List<Id>();
        List<Id> categoriaIds = new List<Id>();
        Id idCategoria2 = AccAsignarRelacionDeCategoria.getCategoriaID( accountNew, accountOld, categoriaIds );
        categoriaIds.add(idCategoria2);
        idCategoria2 = AccAsignarRelacionDeCategoria.getCategoriaID( accountNew, accountOld, categoriaIds );
        Id idCiudad = AccAsignarRelacionDeCategoria.getCiudadID( accountNew, accountOld, ciudadIds);
        idCiudad = AccAsignarRelacionDeCategoria.getCiudadID( accountNew, accountOld, ciudadIds);
        Account oAccount = AccAsignarRelacionDeCategoria.getAccountEje( accountNew,  accountOld,  ciudadIds );
        Map<Id, Categoria_de_Cliente__c> categoriaClienteMap = new Map<Id, Categoria_de_Cliente__c>();
        Map<Id, Ciudad_de_Sucursal__c> ciudadSucursalMap = new Map<Id, Ciudad_de_Sucursal__c>();
        Map<Id, Ciudad__c> ciudadMap = new Map<Id, Ciudad__c>();
        Map<Id, Map<Id, Relacion_de_Categoria__c>> relacionMap = new Map<Id, Map<Id, Relacion_de_Categoria__c>>();
        try{
            AccAsignarRelacionDeCategoria.asignarRelacion( accountNew,  accountOld, categoriaClienteMap, ciudadSucursalMap, ciudadMap, relacionMap);
        }catch(Exception ex ){
            System.debug('##1. Error: ' + ex.getMessage());
        }
        try{
            accountNew.Ciudad_Particular_B__c = idCiudadB;
            ciudadSucursalMap.put(idCiudadB,oCiudadSucursal);
            AccAsignarRelacionDeCategoria.asignarRelacion( accountNew,  accountOld, categoriaClienteMap, ciudadSucursalMap, ciudadMap, relacionMap);
        }catch(Exception ex ){
            System.debug('##2. Error: ' + ex.getMessage());
        }
        try{
            accountNew.Categoria_del_Cliente__c = idCiudadB;
            Map<Id, Relacion_de_Categoria__c> mapRelacion = new Map<Id, Relacion_de_Categoria__c>();
            mapRelacion.put(idCategoria, oRelacionCategoria );
            relacionMap.put(idCiudadSucursal, mapRelacion);
            AccAsignarRelacionDeCategoria.asignarRelacion( accountNew,  accountOld, categoriaClienteMap, ciudadSucursalMap, ciudadMap, relacionMap);
        }catch(Exception ex ){
            System.debug('##3. Error: ' + ex.getMessage());
        }
        Test.stopTest();
    }
}