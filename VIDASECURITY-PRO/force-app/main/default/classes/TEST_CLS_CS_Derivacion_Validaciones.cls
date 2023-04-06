/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-06-2021   Juan Espinoza León   Initial Version
**/
@IsTest
public class TEST_CLS_CS_Derivacion_Validaciones {
    public TEST_CLS_CS_Derivacion_Validaciones() {

    }
    
        
    @isTest static void Es_DerivacionPermitida_Test_01()
    {
        Test.startTest(); 
            
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '17702700';
        a.DV_contacto__pc = '6';
        insert a;
        
        system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);
        
        Case caso1 = new Case();
        caso1.Tipo_de_Solicitante__c = 'Contratante';
        caso1.Canal__c = 'Asistencia Agente';
        caso1.Negocio__c = 'RRVV';
        //caso1.Account = a;
        caso1.AccountId = a.Id;
        caso1.ContactId = a.PersonContactId;
        caso1.Tipo_de_Cliente__c = 'Cliente Normal';
        caso1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;
        insert caso1;
        
        system.debug('@@@@ CASO ATENCION TEST => ' + caso1);
        
        Case caso2 = new Case();
        caso2.ParentId = caso1.Id;
        caso2.Tipo_de_Solicitante__c = 'Contratante';
        caso2.Canal__c = 'Asistencia Agente';
        caso2.Negocio__c = 'RRVV';
        caso2.CASO_Categoria__c = 'Endoso RRVV';
        caso2.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
        caso2.AccountId = a.Id;
        caso2.ContactId = a.PersonContactId;
        caso2.Tipo_de_Cliente__c = 'Cliente Normal';
        
        caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
        caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
        insert caso2;            
        
        system.debug('@@@@ CASO SOLICITUD TEST => ' + caso2);
        CLS_CS_Derivacion_Validaciones.Es_DerivacionPermitida(caso2.Id);
       
       
        Test.stopTest();
    }
    
    @isTest static void Es_DerivacionOptativa_Test01()
    {
        Test.startTest(); 
            
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '17702700';
        a.DV_contacto__pc = '6';
        insert a;
        
        system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);
        
        Case caso1 = new Case();
        caso1.Tipo_de_Solicitante__c = 'Contratante';
        caso1.Canal__c = 'Asistencia Agente';
        caso1.Negocio__c = 'RRVV';
        //caso1.Account = a;
        caso1.AccountId = a.Id;
        caso1.ContactId = a.PersonContactId;
        caso1.Tipo_de_Cliente__c = 'Cliente Normal';
        caso1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;
        insert caso1;
        
        system.debug('@@@@ CASO ATENCION TEST => ' + caso1);
        
        Case caso2 = new Case();
        caso2.ParentId = caso1.Id;
        caso2.Tipo_de_Solicitante__c = 'Contratante';
        caso2.Canal__c = 'Asistencia Agente';
        caso2.Negocio__c = 'RRVV';
        caso2.CASO_Categoria__c = 'Endoso RRVV';
        caso2.Detalle_Solicitud__c = 'Solicitud periodo garantizado';
        caso2.AccountId = a.Id;
        caso2.ContactId = a.PersonContactId;
        caso2.Tipo_de_Cliente__c = 'Cliente Normal';
        
        caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
        caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
        insert caso2;            
        
        system.debug('@@@@ CASO SOLICITUD TEST => ' + caso2);
        CLS_CS_Derivacion_Validaciones.Es_DerivacionOptativa(caso2.Id);       
       
        Test.stopTest();
    }
}