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
* @version   1.0    20/10/2021     Javier Tibamoza JATC 	       Class Created
***********************************************************************************************************************/
@isTest(seealldata=false)
private class AccACSELTest {

    static testMethod void testAccACSEL(){
        if(!TestVerificationService.ShouldExecute('AccACSELTest.testAccACSEL')){return;}
        /**********************************************************************************/
        UserFabricate usuarioPostVenta = (UserFabricate)Fabricate.usuario().postVenta().set('Ejecutivo_de_Cliente__c', true).save();
		Test.startTest();
        Set<Id> accountsIds = new Set<Id>();
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest().corporativa().set('OwnerId', (Id)usuarioPostVenta.get().get('Id')).set('Omitir_Validaciones_AMAC__c',true).save();
        List<Account> lCuentas =[SELECT Rut__c, Ejecutivo_de_Cliente__c, OwnerId From Account WHERE OwnerId = :(Id)usuarioPostVenta.get().get('Id')];
        User oUserSFVida = [SELECT Id FROM User WHERE Username LIKE '%sfvida@security.cl%' LIMIT 1];
        
        Map<Id, User> mapUsuariosEjecutivosCliente = new Map<Id, User>([SELECT Id FROM User WHERE Ejecutivo_de_Cliente__c = True]);
        
        accountsIds = AccACSEL.getAccountId( lCuentas[0], null, mapUsuariosEjecutivosCliente, accountsIds, oUserSFVida.Id );
        
        AccACSEL.execute(lCuentas);
        Test.stopTest();
    }
}