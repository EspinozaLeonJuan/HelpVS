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
private class AccAsignaFechaSinEjecutivoTest {

    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignaFechaSinEjecutivoTest.testExecute')){return;}
        /**********************************************************************************/
		Fabricate.contacto().supervisor().save();
		ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
		AccountGeneration account = (AccountGeneration)Fabricate.cuentaTest().generico('Winder', 'Ojeda', '16355278', '7', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Codigo_Agente__c','123456').save();
        Test.startTest();
	    account.set('Agente_Actual__c', null).set('Codigo_Agente__c', null).save();
        Test.stopTest();
    }

    static testMethod void testGetAccountListDates(){
        ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
        Id idAgente = (Id)agente.get().get('Id');
        Account accountNew = new Account();
        accountNew.Agente_Actual__c = idAgente;
        Account accountOld = new Account();
        accountOld.Agente_Actual__c = idAgente;
        Test.startTest();
        Account account = AccAsignaFechaSinEjecutivo.getAccountListDates( accountNew,  accountOld );
        Test.stopTest();
    }

    static testMethod void testGetAgentID(){
        ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
        ContactFabricate agente2 = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '33333333-3').set('Codigo_Agente__c', '654321').set('Estado__c', 'Vigente').save();
        Id idAgente = (Id)agente.get().get('Id');
        Id idAgente2 = (Id)agente2.get().get('Id');
        Account accountNew = new Account();
        accountNew.Agente_Actual__c = idAgente;
        Account accountOld = new Account();
        accountOld.Agente_Actual__c = idAgente2;
        Set<Id> ownerIds = new Set<Id>();
        Set<Id> agenteIds = new Set<Id>();
        Test.startTest();
        Id idAgente3 = AccAsignaFechaSinEjecutivo.getAgentID( accountNew,  accountOld, ownerIds, agenteIds );
        ownerIds.add( idAgente3 );
        idAgente = AccAsignaFechaSinEjecutivo.getAgentID( accountNew,  accountOld, ownerIds, agenteIds );
        Test.stopTest();
    }

    static testMethod void testInsertDateAccount(){
        UserFabricate ejecutivo = (UserFabricate) Fabricate.usuario().ejecutivoDeCliente().set('Username', 'user.ejecutivo.cliente@security.cl').set('Ejecutivo_de_Cliente__c',false).save();
        ContactFabricate agente = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '22222222-2').set('Codigo_Agente__c', '123456').set('Estado__c', 'Vigente').save();
        ContactFabricate agente2 = (ContactFabricate)Fabricate.contacto().agente().set('Rut_Supervisor__c', '33333333-3').set('Codigo_Agente__c', '654321').set('Estado__c', 'Desvinculado').save();
        Id idAgente = (Id)agente.get().get('Id');
        Id idAgente2 = (Id)agente2.get().get('Id');
        Id idUser = (Id)ejecutivo.get().get('Id');
        Contact oAgente = (Contact)agente.get();
        Contact oAgente2 = (Contact)agente2.get();
        Account accountNew = new Account();
        accountNew.Agente_Actual__c = idAgente;
        accountNew.OwnerId = Userinfo.getUserId();
        Account accountOld = new Account();
        accountOld.Agente_Actual__c = idAgente2;
        Map<Id, Contact> agenteMap = new Map<Id, Contact>();
        agenteMap.put( accountNew.Agente_Actual__c, oAgente );
        User oUser = [ SELECT Id, Username, Email FROM User WHERE Id =: Userinfo.getUserId() ];
        Map<Id, User> ejecutivoMap = new Map<Id, User>();
        ejecutivoMap.put( Userinfo.getUserId(), oUser );
        Test.startTest();
        AccAsignaFechaSinEjecutivo.insertDateAccount( accountNew,  accountOld, agenteMap, ejecutivoMap );
        accountNew.Agente_Actual__c = null;
        accountNew.OwnerId = idUser;
        AccAsignaFechaSinEjecutivo.insertDateAccount( accountNew,  accountOld, agenteMap, ejecutivoMap );
        Test.stopTest();
    }
}