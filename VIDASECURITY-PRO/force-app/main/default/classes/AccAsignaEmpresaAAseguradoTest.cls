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
* @version   1.0    08/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccAsignaEmpresaAAseguradoTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEmpresaAAseguradoTest.testExecute')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaCorporativa = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        Test.startTest();
        AccountGeneration cuentaPersonal = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true).set('RUT_Empresa__c','482123880').save();
        Test.stopTest();
    }

    static testMethod void testGetCuenta(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEmpresaAAseguradoTest.testGetCuenta')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaCorporativa = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        Test.startTest();
        Account accNew = new Account();
        accNew.Cuenta_Corporativa__c = (Id)cuentaCorporativa.get().get('Id');
        Account accOld = new Account();
        Set<Id> idsEmpresas = new Set<Id>();
        Account cuenta = AccAsignaEmpresaAAsegurado.getCuenta(accNew, accOld, idsEmpresas);        
        Test.stopTest();
    }

    static testMethod void testGetCuentaEmpresa(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEmpresaAAseguradoTest.testGetCuentaEmpresa')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaCorporativa = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        Test.startTest();
        Account accNew = new Account();
        accNew.Cuenta_Corporativa__c = (Id)cuentaCorporativa.get().get('Id');
        accNew.Rut__c = '16355278';
        Account accOld = new Account();
        Set<Id> idsEmpresas = new Set<Id>();
        Map<String, Account> mapCuentasEmpresa = new Map<String, Account>();
        Account cuenta = AccAsignaEmpresaAAsegurado.getCuentaEmpresa(accNew, accOld, mapCuentasEmpresa);        
        mapCuentasEmpresa.put('16355278',cuenta);
        Account cuenta2 = AccAsignaEmpresaAAsegurado.getCuentaEmpresa(accNew, accOld, mapCuentasEmpresa);        
        Test.stopTest();
    }
    
    static testMethod void testUpdateAccount(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEmpresaAAseguradoTest.testUpdateAccount')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaCorporativa = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).save();
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        Test.startTest();
        Id idCuentaCorporativa = (Id)cuentaCorporativa.get().get('Id');
        String rutCuentaCorporativa = (String)cuentaCorporativa.get().get('Rut__c');
        Account accountCorporativa = (Account)cuentaCorporativa.get();
        Account accNew = new Account();
        accNew.Cuenta_Corporativa__c = idCuentaCorporativa;
        accNew.Rut__c = '16355278';
        accNew.RUT_Empresa__c = rutCuentaCorporativa;
        accNew.RecordTypeId = recordTypeCuentaPersonal;
        Account accOld = new Account();
        Set<Id> idsEmpresas = new Set<Id>();
        Map<String, Account> mapCuentasEmpresa = new Map<String, Account>();
        Map<Id, Account> mapCuentasById = new Map<Id, Account>();
        mapCuentasById.put( idCuentaCorporativa, accountCorporativa );
        mapCuentasEmpresa.put( accNew.RUT_Empresa__c.toUpperCase(), accountCorporativa );
        AccAsignaEmpresaAAsegurado.updateAccount(true, accNew, accOld, mapCuentasEmpresa, recordTypeCuentaPersonal, mapCuentasById);        
        
        Test.stopTest();
    }
}