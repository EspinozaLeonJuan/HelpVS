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
private class AccCrearCuentaConContactoExistenteTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccCrearCuentaConContactoExistenteTest.testExecute')){return;}
        /**********************************************************************************/
        Test.startTest();
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','11111111').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contacto.get().get('Id');
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111').save();
        Test.stopTest();
    }

    static testMethod void testGetRutContacto(){
        if(!TestVerificationService.ShouldExecute('AccCrearCuentaConContactoExistenteTest.testGetMapContact')){return;}
        /**********************************************************************************/
        Test.startTest();
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111');
        Account accountNew = (Account)cuenta.get();
        Account accountOld = new Account();
        Set<String> rutsContactos = new Set<String>();
        String rutContacto = AccCrearCuentaConContactoExistente.getRutContacto(accountNew, accountOld, rutsContactos );
        rutsContactos.add(rutContacto);
        rutContacto = AccCrearCuentaConContactoExistente.getRutContacto(accountNew, accountOld, rutsContactos );
        Test.stopTest();
    }
    
    static testMethod void testGetMapContact(){
        if(!TestVerificationService.ShouldExecute('AccCrearCuentaConContactoExistenteTest.testGetMapContact')){return;}
        /**********************************************************************************/
        Test.startTest();
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','11111111').set('FirstName','Winder').set('LastName','Ojeda');
        Contact contactNew = (Contact)contacto.get();
        Contact contactOld = new Contact();
        Map<String, Contact> mapContactos = new Map<String, Contact>();
        Contact contacto2 = AccCrearCuentaConContactoExistente.getMapContact(contactNew, contactOld, mapContactos );
        mapContactos.put(contacto2.rut_contacto__c, contacto2 );
        contacto2 = AccCrearCuentaConContactoExistente.getMapContact(contactNew, contactOld, mapContactos );
        Test.stopTest();
    }

    static testMethod void testGetMapAccount(){
        if(!TestVerificationService.ShouldExecute('AccCrearCuentaConContactoExistenteTest.testGetMapAccount')){return;}
        /**********************************************************************************/
        Test.startTest();
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111');
        Account accountNew = (Account)cuenta.get();
        Account accountOld = new Account();
        Map<String, Account> mapCuentas = new Map<String, Account>();
        Account cuenta2 = AccCrearCuentaConContactoExistente.getMapAccount( accountNew, accountOld, mapCuentas);
        mapCuentas.put(cuenta2.rut__c,cuenta2);
        cuenta2 = AccCrearCuentaConContactoExistente.getMapAccount( accountNew, accountOld, mapCuentas);
        Test.stopTest();
    }

    static testMethod void testGetmapContactAccAnonymous(){
        if(!TestVerificationService.ShouldExecute('AccCrearCuentaConContactoExistenteTest.testGetMapAccount')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','11111111').set('FirstName','Winder').set('LastName','Ojeda').save();
        AccountGeneration cuenta = (AccountGeneration)Fabricate.cuentaTest().generico('name1', 'lastname1', '11111111', '1', Userinfo.getUserId() ).set('Omitir_Validaciones_AMAC__c',true).set('Rut_contacto__pc','11111111').save();
        Contact oContact = (Contact)contacto.get();
        Account accountNew = (Account)cuenta.get();
        Account accountOld = new Account();
        Map<String, Account> mapCuentas = new Map<String, Account>();
        Map<String, Contact> mapContactos = new  Map<String, Contact>();
        List<Account> cuentaAnonima = new List<Account>();
        Test.startTest();
        mapContactos.put(accountNew.Rut_contacto__pc, oContact);
        mapCuentas = new Map<String, Account>();
        cuentaAnonima.add(accountNew);
        Contact contacto2 = AccCrearCuentaConContactoExistente.getmapContactAccAnonymous( true, accountNew,  accountOld, mapCuentas, mapContactos, cuentaAnonima );
        if( contacto2 != null ){
            mapCuentas.put(contacto2.RUT__c,accountNew);
            contacto2 = AccCrearCuentaConContactoExistente.getmapContactAccAnonymous( true, accountNew,  accountOld, mapCuentas, mapContactos, cuentaAnonima );
        }
        Test.stopTest();
    }
}