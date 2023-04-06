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
* @version   1.0    01/12/2021     Javier Cubillos JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccountTriggerHelperTest {

    @testSetup 
    static void testsetup(){
        if(!TestVerificationService.ShouldExecute('AccountTriggerHelperTest.testsetup')){return;}
        /**********************************************************************************/
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration cuentaCorporativa1 = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).set('Name','Test1').set('Rut__c','77893730').set('DV__c','1').set('RUT_Empresa__c','77893730').save();
        AccountGeneration cuentaCorporativa2 = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('Omitir_Validaciones_AMAC__c',true).set('Name','Test2').set('Rut__c','96777810').set('DV__c','9').set('RUT_Empresa__c','96777810').save();
    }

    static testMethod void testGets(){
        if(!TestVerificationService.ShouldExecute('AccountTriggerHelperTest.testGets')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','8679986').save();
        CiudadFabricate ciudad = (CiudadFabricate)Fabricate.ciudad();
        Id idRTCuentaCorp = ReflectionUtils.getRecordTypeId(Account.sObjectType, 'Cuenta Corporativa');
        Id recordTypeCuentaPersonal = ReflectionUtils.getRecordTypeId(Schema.Account.sObjectType, 'Cuenta personal');
        List<Account> lCuentaCorp = [ SELECT Id FROM Account WHERE RecordTypeId =: idRTCuentaCorp ];
        Account a = new Account();
        a.rut__c = '123456';
        a.RecordTypeId = recordTypeCuentaPersonal;
        Account accOld = new Account();
        Map<String, Account> mapCuentas = new Map<String, Account>();
        mapCuentas = AccountTriggerHelper.getMapCuentas( a, accOld, mapCuentas );
        Set<Id> idsEmpresas = new Set<Id>();
        a.Cuenta_Corporativa__c = lCuentaCorp[0].Id;
        idsEmpresas = AccountTriggerHelper.getIdsEmpresas( a, idsEmpresas );
        a.RUT_Empresa__c = '654321';
        Set<String> rutsEmpresas = new Set<String>();
        rutsEmpresas = AccountTriggerHelper.getRutsEmpresas( a, rutsEmpresas, recordTypeCuentaPersonal );
        Set<Id> idsEjecutivos = new Set<Id>();
        a.Ejecutivo_Comercial__c = (Id)contacto.get().get('Id');
        idsEjecutivos = AccountTriggerHelper.getIdsEjecutivos( a, accOld, idsEjecutivos, idRTCuentaCorp );
        Set<String> rutsEjecutivos = new Set<String>();
        a.RUT_Ejecutivo_Comercial__c = '8679986';
        rutsEjecutivos = AccountTriggerHelper.getRutsEjecutivos( a, accOld, rutsEjecutivos, idRTCuentaCorp );
        Set<Id> idsAdmins = new Set<Id>();
        a.Administrador_de_Produccion__c = (Id)contacto.get().get('Id');
        idsAdmins = AccountTriggerHelper.getIdsAdmins( a, accOld, idsAdmins, idRTCuentaCorp );
        Set<String> rutsAdmins = new Set<String>();
        a.RUT_Administrador_de_Produccion__c = '8679986';
        rutsAdmins = AccountTriggerHelper.getRutsAdmins( a, accOld, rutsAdmins, idRTCuentaCorp );
        List<Id> ciudadIds = new List<Id>();
        a.Ciudad_particular_B__c = (Id)ciudad.get().get('Id');
        ciudadIds = AccountTriggerHelper.getCiudadIds( a, accOld, ciudadIds );
        List<Account> accountsCategoria = new List<Account>();
        accountsCategoria = AccountTriggerHelper.getAccountsCategoria( a, accOld, accountsCategoria, ciudadIds );
        List<Id> categoriaIds = new List<Id>();
        categoriaIds = AccountTriggerHelper.getCategoriaIds( a, accOld, categoriaIds );
        Set<Id> ownerIdsAgent = new Set<Id>();
        ownerIdsAgent = AccountTriggerHelper.getOwnerIdsAgent( a, accOld, ownerIdsAgent );
        Set<String> codigos = new Set<String>();
        codigos = AccountTriggerHelper.getCodigos( a, ownerIdsAgent, codigos  );
        Set<Id> ownerIds = new Set<Id>();
        ownerIds = AccountTriggerHelper.getOwnerIds( a, ownerIdsAgent, ownerIds );
        Set<Id> agenteIds = new Set<Id>();
        agenteIds = AccountTriggerHelper.getAgenteIds( a, agenteIds );
        Set<String> rutsContacto = new Set<String>();
        rutsContacto = AccountTriggerHelper.getRutsContacto( a, accOld, rutsContacto );
        Set<Id> accountsId = new Set<Id>();
        accountsId = AccountTriggerHelper.getAccountsId( a, accOld, accountsId );
        Set<Id> accountsIdCartera = new Set<Id>();
        accountsIdCartera = AccountTriggerHelper.getAccountsIdCartera( a, accOld, accountsIdCartera );
    }
}