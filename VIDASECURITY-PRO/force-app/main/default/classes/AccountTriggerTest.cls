/**
* VASS
* @author           Javier Cubillos
* @email: 			javier.cubillos@vasslatam.com
* Project:          
* Description:      
* Changes (Version)
* -------------------------------------
*            No.    Date           Author                           Description      
*            ----   ----------     ---------------------------     -------------    
* @version   1.0    29/11/2021     Javier Cubillos JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccountTriggerTest {
    @testSetup 
    static void testsetup(){
        if(!TestVerificationService.ShouldExecute('AccountTriggerTest.testsetup')){return;}
        /**********************************************************************************/
        UserFabricate ejecutivo1 = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        UserFabricate ejecutivo2 = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente2@security.cl').set('CommunityNickname','rocky11').set('RUT_Usuario__c','10896641-2').save();
        AccountGeneration cuentaCorporativa1 = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).set('Name','Test1').set('Rut__c','77893730').set('DV__c','1').set('RUT_Empresa__c','77893730').save();
        AccountGeneration cuentaCorporativa2 = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).set('Name','Test2').set('Rut__c','96777810').set('DV__c','9').set('RUT_Empresa__c','96777810').save();
        CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad().save();
        SucursalFabricate sucursal = (SucursalFabricate)Fabricate.sucursal().save();
        CiudadSucursalFabricate ciudadSucursal = (CiudadSucursalFabricate)Fabricate.ciudad_sucursal().set('Sucursal__c',(Id)sucursal.get().get('Id')).set('Ciudad__c',(Id)ciudad.get().get('Id')).save();
    }

    static testMethod void testExecuteTriggerInsert(){
        if(!TestVerificationService.ShouldExecute('AccountTriggerTest.testExecuteTriggerInsert')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','8679986').save();
        User oEjecutivo = [SELECT Id FROM User WHERE Username = 'user.ejecutivo.cliente@security.cl' LIMIT 1];
        User oEjecutivo2 = [SELECT Id FROM User WHERE Username = 'user.ejecutivo.cliente2@security.cl' LIMIT 1];
        Ciudad__c oCiudad = [SELECT Id FROM Ciudad__c LIMIT 1];
        Id idRTCuentaCorp = ReflectionUtils.getRecordTypeId(Account.sObjectType, 'Cuenta Corporativa');
        Id idRTCuentaPer = ReflectionUtils.getRecordTypeId(Account.sObjectType, 'Cuenta personal');
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .generico('Winder', 'Ojeda', '16355278', '7', oEjecutivo.Id )
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('Ciudad_particular_B__c',oCiudad.Id)
            //.set('Rut_contacto__pc','8679986')
            .save();
        Test.stopTest();
    }

    static testMethod void testExecuteTriggerUpdate(){
        if(!TestVerificationService.ShouldExecute('AccountTriggerTest.testExecuteTriggerInsert')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','8679986').save();
        User oEjecutivo = [SELECT Id FROM User WHERE Username = 'user.ejecutivo.cliente@security.cl' LIMIT 1];
        User oEjecutivo2 = [SELECT Id FROM User WHERE Username = 'user.ejecutivo.cliente2@security.cl' LIMIT 1];
        Ciudad__c oCiudad = [SELECT Id FROM Ciudad__c LIMIT 1];
        Id idRTCuentaCorp = ReflectionUtils.getRecordTypeId(Account.sObjectType, 'Cuenta Corporativa');
        Id idRTCuentaPer = ReflectionUtils.getRecordTypeId(Account.sObjectType, 'Cuenta personal');
        List<Account> lCuentaCorp = [ SELECT Id FROM Account WHERE RecordTypeId =: idRTCuentaCorp ];
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest()
            .generico('Winder', 'Ojeda', '16355278', '7', oEjecutivo.Id )
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('Cuenta_Corporativa__c',lCuentaCorp[0].Id)
            .save();
        Id idCuenta = (Id)cuenta.get().get('Id');
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
        Account oUpdateAccount = [ SELECT Id, Cuenta_Corporativa__c FROM Account WHERE Id =: idCuenta LIMIT 1];
        oUpdateAccount.Cuenta_Corporativa__c = lCuentaCorp[1].Id;
        oUpdateAccount.RUT_Ejecutivo_Comercial__c = '8679986';
        oUpdateAccount.OwnerId = oEjecutivo2.Id;
        oUpdateAccount.Ciudad_Particular_B__c = oCiudad.Id;
        update oUpdateAccount;
        Test.stopTest();
    }
}