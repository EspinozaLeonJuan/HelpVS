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
private class AccAsignaAgenteActualACuentaTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignaAgenteActualACuentaTest.testExecute')){return;}
        /**********************************************************************************/
		ContactFabricate contacto1 = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c','123').save();
     //   ContactFabricate contacto2 = (ContactFabricate)Fabricate.contacto().set('RUT__c','7038521-K').set('DV_contacto__c','K').set('Codigo_Agente__c','321').save();
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','15045517')
            .set('Codigo_Agente__c','123')
            .set('Agente_Original__c',null)
            .set('Agente_Actual__c',(Id)contacto1.get().get('Id') );
        Account oCuentaNew = (Account)cuentaCorp.get();
        Insert oCuentaNew;
        oCuentaNew.Codigo_Agente__c = '321';
        Update oCuentaNew;
        Map<String, Contact> agenteMap = new Map<String, Contact>();
        agenteMap.put('123',(Contact)contacto1.get());
   //     agenteMap.put('321',(Contact)contacto2.get());
        AccAsignaAgenteActualACuenta.InsertAgent(oCuentaNew, agenteMap);
		Test.stopTest();
    }

    static testMethod void testExecuteOne(){
        if(!TestVerificationService.ShouldExecute('AccAsignaAgenteActualACuentaTest.testExecute')){return;}
        /**********************************************************************************/
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c','123').save();
        List<Contact> lContac = [
            SELECT Id , Codigo_Agente__c
            FROM Contact ];
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','222')
            .set('Agente_Original__c',null)
            .save();
		Test.stopTest();
    }

    static testMethod void testExecuteTwo(){
        if(!TestVerificationService.ShouldExecute('AccAsignaAgenteActualACuentaTest.testExecuteTwo')){return;}
        /**********************************************************************************/
		ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','16355278').set('Codigo_Agente__c','123').save();
        List<Contact> lContac = [
            SELECT Id , Codigo_Agente__c
            FROM Contact ];
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .save();
		Test.stopTest();
    }

    static testMethod void testExecuteThree(){
        if(!TestVerificationService.ShouldExecute('AccAsignaAgenteActualACuentaTest.testExecuteThree')){return;}
        /**********************************************************************************/
        Test.startTest();
        SwitchTest.sNameMetadata = 'testClassTrue';
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .save();
		Test.stopTest();
    }
}