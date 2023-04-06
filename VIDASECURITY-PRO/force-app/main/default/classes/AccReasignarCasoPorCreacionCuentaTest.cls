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
* @version   1.0    10/11/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccReasignarCasoPorCreacionCuentaTest {
    @testSetup static void testSetup() {
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','11111111').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contacto.get().get('Id');
        AccountGeneration cuentaOriginal = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111').save();
        Id idCuentaOriginal = (Id)cuentaOriginal.get().get('Id');
        AccountGeneration cuentaNueva = (AccountGeneration)Fabricate.cuentaTest().generico('name2', 'lastname2', '22222222', '2', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','22222222').save();
        CaseFabricate caso = (CaseFabricate)Fabricate.caso().set('AccountId',idCuentaOriginal).set('Correo_electronico_Solicitante__c','mail@cuenta.cl').set('RUT_Solicitante__c','11111111').set('Reasignar_a_Rut__c' ,22222222).save();
        caso.set('Reasignar_a_Rut__c' ,11111111).save();
    }
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccReasignarCasoPorCreacionCuentaTest.testExecute')){return;}
        /**********************************************************************************/
        List<Account> lAccount = [SELECT Id, IsPersonAccount, Rut__c FROM Account];
        List<Case> lCaseAReasignar = [SELECT Id, Reasignar_a_Rut__c, AccountId FROM Case];
        Test.startTest();
        AccReasignarCasoPorCreacionCuenta.execute( lAccount, lCaseAReasignar );
        Test.stopTest();
    }
}