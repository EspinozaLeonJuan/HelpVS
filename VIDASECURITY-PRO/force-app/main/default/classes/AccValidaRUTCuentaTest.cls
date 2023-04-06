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
private class AccValidaRUTCuentaTest {

    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccValidaRUTCuentaTest.testExecute')){return;}
        /**********************************************************************************/
        AccountGeneration cuentaOriginal = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111').save();
        Account accNew = (Account)cuentaOriginal.get();
        Account accOld = new Account();
        List<Account_Error_Log__c> records_log = new list<Account_Error_Log__c>();  
        Set<Id> invalid_rut = new Set<Id>();
        Test.startTest();
        try{
            AccValidaRUTCuenta.validaRutCuenta( accNew, accOld, invalid_rut, records_log );
            accNew.Rut_contacto__pc = '123321';
            accNew.DV_contacto__pc = '0';
            accNew.Rut__c = '123321';
            accNew.DV__c = '0';
            AccValidaRUTCuenta.validaRutCuenta( accNew, accOld, invalid_rut, records_log );
            AccValidaRUTCuenta.validaRutCuenta( accNew, accNew, invalid_rut, records_log );
        }catch(Exception ex){ }
        Test.stopTest();
    }
}