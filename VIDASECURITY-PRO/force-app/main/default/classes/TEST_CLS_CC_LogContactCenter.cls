@IsTest
public class TEST_CLS_CC_LogContactCenter {

    @isTest static void InsertLog()
    {
        Test.startTest();        
        CLS_CC_LogContactCenter.InsertLog('88888888-8', 1, '12345', '34444', '454543');       
        Test.stopTest();
    }
    
    @isTest static void InsertLog_a()
    {
        Test.startTest();
        CLS_CC_LogContactCenter.InsertLog('88888888-8', 1, '12345', '34444', '454543', '3232344', '23244553');        
        Test.stopTest();
    }
    
    @isTest static void InsertLog_Account()
    {
        Test.startTest();
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        CLS_CC_LogContactCenter.InsertLog_Account(cuenta.Id, caso.Id, 1, '123456', '123456', caso.CaseNumber, '');
        Test.stopTest();
    }
    
    @isTest static void InsertLog_Lead()
    {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.RUT__c = '15045517-0';
        insert prospecto;
        
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        CLS_CC_LogContactCenter.InsertLog_Lead(prospecto.Id, caso.CaseNumber, 1, '12345', '67890', caso.CaseNumber, '');
        Test.stopTest();
    }
     
    @isTest static void UpdateLog()
    {
        Test.startTest();
        Contact_Center_Log__c log = new Contact_Center_Log__c();
        log.EsCliente__c = false;        
        log.RUT__c = '150455170';
        insert log;
        
        CLS_CC_LogContactCenter.UpdateLog(log.Id, log.RUT__c, log.EsCliente__c);
        Test.stopTest();
    }
    
    @isTest static void UpdateLog_Ok_Account()
    {
        Test.startTest();
        
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        Contact_Center_Log__c log = new Contact_Center_Log__c();
        log.EsCliente__c = false;        
        log.RUT__c = '150455170';
        insert log;
        
        CLS_CC_LogContactCenter.UpdateLog_Ok_Account(log.Id, log.RUT__c, caso.Id, cuenta.Id, 'james bond', caso.CaseNumber);
        Test.stopTest();
    }
    
    @isTest static void UpdateLog_Ok_Lead()
    {
        Test.startTest();
        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.RUT__c = '15045517-0';
        insert prospecto;
        
        Account cuenta = Factory.crearAccountSF();
        Case caso = Factory.buildCasoSF('Atención', cuenta);
        insert caso;
        
        Contact_Center_Log__c log = new Contact_Center_Log__c();
        log.EsCliente__c = false;        
        log.RUT__c = '150455170';
        insert log;
        
        CLS_CC_LogContactCenter.UpdateLog_Ok_Lead(log.Id, log.RUT__c,  caso.Id, prospecto.Id, true, caso.CaseNumber);        
        Test.stopTest();
    }
    
    @isTest static void UpdateLog_Error()
    {
        Test.startTest();
         Contact_Center_Log__c log = new Contact_Center_Log__c();
        log.EsCliente__c = false;        
        log.RUT__c = '150455170';
        insert log;
        
        CLS_CC_LogContactCenter.UpdateLog_Error(log.Id, 'estado', 'excepcion');
        Test.stopTest();
    }
    
}