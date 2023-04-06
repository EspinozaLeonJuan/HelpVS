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
private class AccAsignaEjecutivoComercialACuentaTest {
    
    static testMethod void testExecute(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoComercialACuentaTest.testExecute')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','482123880').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contacto.get().get('Id');
        Test.startTest();
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('RUT_Ejecutivo_Comercial__c','482123880')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .set('Ejecutivo_Comercial__c',idContacto)
            .save();
        
        
		Test.stopTest();
    }

    static testMethod void testExecuteOne(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoComercialACuentaTest.testExecute')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','482123880').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contacto.get().get('Id');
        Test.startTest();
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('RUT_Ejecutivo_Comercial__c','482123880')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .save();
		Test.stopTest();
    }

    static testMethod void testExecuteTwo(){
        if(!TestVerificationService.ShouldExecute('AccAsignaEjecutivoComercialACuentaTest.testExecute')){return;}
        /**********************************************************************************/
        ContactFabricate contacto = (ContactFabricate)Fabricate.contacto().set('RUT__c','482123880').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contacto.get().get('Id');
        Test.startTest();
		AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('RUT_Ejecutivo_Comercial__c','482123881')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .save();
		Test.stopTest();
    }

    static testMethod void testExecuteNullOne(){
        Account cuenta = new Account();
        Account cuentaOld = new Account(); 
        Set<String> rutsEjecutivos = new Set<String>();
        Set<Id> idsEjecutivos = new Set<Id>();
        Id recordTypeCuentaEmpresa = null;
        Test.startTest();
        AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('RUT_Ejecutivo_Comercial__c','482123881')
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .save();
		
        
        List<Account>Acc = [SELECT Name, RUT_Ejecutivo_Comercial__c, Omitir_Validaciones_AMAC__c, RUT_Administrador_de_Produccion__c, Codigo_Agente__c,RecordTypeId, Ejecutivo_Comercial__c 
                            FROM Account  
                            WHERE RUT_Ejecutivo_Comercial__c ='482123881'];
        
        AccAsignaEjecutivoComercialACuenta.getIdEjecutivo(Acc[0], cuentaOld, idsEjecutivos, recordTypeCuentaEmpresa);
        AccAsignaEjecutivoComercialACuenta.getRutsPorVencer(Acc[0],cuentaOld,rutsEjecutivos,recordTypeCuentaEmpresa);
        Test.stopTest();
    }
    
    static testMethod void testExecuteNullTwo(){
        Contact contacto = new Contact();
        Map<String, Contact> mapEjecutivos = new Map<String, Contact>();
        AccAsignaEjecutivoComercialACuenta.getMapEjecutivo(contacto, mapEjecutivos);
    }
    
    static testMethod void testExecuteThree(){
        Contact contacto = new Contact();
        ContactFabricate contactos = (ContactFabricate)Fabricate.contacto().set('RUT__c','482123880').set('FirstName','Winder').set('LastName','Ojeda').save();
        Id idContacto = (Id)contactos.get().get('Id');
        
        Map<String, Contact> mapEjecutivos = new Map<String, Contact>();
        
        Account cuentaOld = new Account(); 
        Set<String> rutsEjecutivos = new Set<String>();
        Set<Id> idsEjecutivos = new Set<Id>();
        
        
        AccountGeneration cuentaCorp = (AccountGeneration)Fabricate.cuentaTest().corporativa()
            .set('Name','Cuenta Corporativa')
            .set('RUT_Ejecutivo_Comercial__c','482123881')
            .Set('Ejecutivo_Comercial__c', idContacto)
            .set('Omitir_Validaciones_AMAC__c',true)
            .set('RUT_Administrador_de_Produccion__c','16355278')
            .set('Codigo_Agente__c','123')
            .save();
		
        
        List<Account>Acc = [SELECT Name, RUT_Ejecutivo_Comercial__c, Omitir_Validaciones_AMAC__c, RUT_Administrador_de_Produccion__c, Codigo_Agente__c,RecordTypeId, Ejecutivo_Comercial__c 
                            FROM Account  
                            WHERE RUT_Ejecutivo_Comercial__c = '482123881'];
        
        Id recordTypeCuentaEmpresa = Acc[0].RecordTypeId;
        
        Account ac = AccAsignaEjecutivoComercialACuenta.getIdEjecutivo(Acc[0], cuentaOld, idsEjecutivos, recordTypeCuentaEmpresa);        
       	Contact c = AccAsignaEjecutivoComercialACuenta.getMapEjecutivo(contacto, mapEjecutivos);
        
        if( c != null ){
			mapEjecutivos.put( c.Rut__c.toUpperCase(), c );
		}
        
        if(ac != null){
			idsEjecutivos.add(ac.Ejecutivo_Comercial__c);
		}
        
        Map<Id, Contact> mapContactosById = new Map<ID, Contact>([Select Id, Rut__c From Contact Where Id IN :idsEjecutivos]);
        
        AccAsignaEjecutivoComercialACuenta.updateAccount(Acc[0],null, recordTypeCuentaEmpresa, mapContactosById, mapEjecutivos);
    }
    
}