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
private class AccAsignaEjecutivoDeClienteTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoDeClienteTest.testExecute')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '16355278', '7', (Id)ejecutivo.get().get('Id') ).set('Omitir_Validaciones_AMAC__c',true);
        Test.startTest();
        account.set('OwnerId', ejecutivo.getId()).save();
        Test.stopTest();
    }

    static testMethod void testExecuteNullOne(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoDeClienteTest.testExecuteNullOne')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Test.startTest();
        Account accountNew = new Account();
        accountNew.OwnerId = (Id)ejecutivo.get().get('Id');
        Account accountOld = new Account();
        Map<Id, Ejecutivo_de_Cliente__c> ejecutivoClienteMap = new Map<Id, Ejecutivo_de_Cliente__c>();
        Set<Id> ownerIds = new Set<Id>();
        Ejecutivo_de_Cliente__c sinAsignar = new Ejecutivo_de_Cliente__c();
        AccAsignaEjecutivoDeCliente.asignarEjecurivoCliente(accountNew, accountOld, ejecutivoClienteMap, sinAsignar);
        AccAsignaEjecutivoDeCliente.getOwnerID(accountNew, accountOld, ownerIds );
        Test.stopTest();
    }

    static testMethod void testExecuteNullTwo(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoDeClienteTest.testExecuteNullTwo')){return;}
        /**********************************************************************************/
		UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').save();
        Test.startTest();
        Account accountNew = new Account();
        accountNew.OwnerId = (Id)ejecutivo.get().get('Id');
        Account accountOld = new Account();
        Map<Id, Ejecutivo_de_Cliente__c> ejecutivoClienteMap = new Map<Id, Ejecutivo_de_Cliente__c>();
        Set<Id> ownerIds = new Set<Id>();
        Ejecutivo_de_Cliente__c sinAsignar = new Ejecutivo_de_Cliente__c(Codigo__c = '0', Name = 'SIN EJECUTIVO', Usuario__c = (Id)ejecutivo.get().get('Id') );
		insert sinAsignar;
        ejecutivoClienteMap.put( accountNew.OwnerId, sinAsignar );
        AccAsignaEjecutivoDeCliente.asignarEjecurivoCliente(accountNew, accountOld, ejecutivoClienteMap, sinAsignar);
        Test.stopTest();
    }
}