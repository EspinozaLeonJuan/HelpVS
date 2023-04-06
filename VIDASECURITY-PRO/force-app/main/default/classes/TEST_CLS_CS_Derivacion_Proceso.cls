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
@istest(seeAllData=true)
public class TEST_CLS_CS_Derivacion_Proceso {
    public TEST_CLS_CS_Derivacion_Proceso() {

    }
    
    @istest static void EscenarioAsignacionResponsables()
    {
        //try{
            
            Test.startTest();
            TriggerHandler.disable();
          /*  Account a = new Account();
            a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
            a.FirstName = 'H1';
            a.LastName = 'H2';
            a.PersonEmail = 'test@msystem.cl';
            a.Rut_contacto__pc = '16790926';
            a.DV_contacto__pc = '4';
            insert a;*/
        
         //  Factory.crearAccountAnonimo();         
            Account a = Factory.cuenta.buildInsert();        
            
            system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);
            
            Case caso1 = new Case();
            caso1.Tipo_de_Solicitante__c = 'Contratante';
            caso1.Canal__c = 'Asistencia Agente';
            caso1.Negocio__c = 'RRVV';
            caso1.AccountId = a.Id;
            caso1.ContactId = a.PersonContactId;
            caso1.Tipo_de_Cliente__c = 'Cliente Normal';
            caso1.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Atención' AND SobjectType = 'Case'].Id;
            insert caso1;
            
            system.debug('@@@@ CASO ATENCION TEST MASIVO => ' + caso1);
            
            Case caso2 = new Case();
            caso2.ParentId = caso1.Id;
            caso2.Tipo_de_Solicitante__c = 'Contratante';
            caso2.Canal__c = 'Asistencia Agente';
            caso2.Negocio__c = 'RRVV';
			caso2.CASO_Categoria__c = 'Beneficio Estatal';
            caso2.Detalle_Solicitud__c = 'Declaración Ingresos Actualización';
            caso2.AccountId = a.Id;
            caso2.ContactId = a.PersonContactId;
            caso2.Tipo_de_Cliente__c = 'Cliente Normal';
            caso2.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso2.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
			//String Cola = [SELECT Id, QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'UR - Producción RRVV'].QueueId;
            //system.debug('@@@@ COLA RESCATADA => ' + Cola);
            caso2.OwnerId = [SELECT Id, QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'UR - Producción RRVV' LIMIT 1].QueueId;
            insert caso2;     

            system.debug('@@@@ CASO SOLICITUD TEST MASIVO => ' + caso2);
            
            Case caso3 = new Case();
            caso3.ParentId = caso1.Id;
            caso3.Tipo_de_Solicitante__c = 'Contratante';
            caso3.Canal__c = 'Asistencia Agente';
            caso3.Negocio__c = 'RRVV';
			caso3.CASO_Categoria__c = 'Beneficio Estatal';
            caso3.Detalle_Solicitud__c = 'Declaración Ingresos Actualización';
            caso3.AccountId = a.Id;
            caso3.ContactId = a.PersonContactId;
            caso3.Tipo_de_Cliente__c = 'Cliente Normal';
            caso3.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso3.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            caso3.OwnerId = [SELECT Id, QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'UR - Producción RRVV' LIMIT 1].QueueId;
        	caso3.Id_Responsable_UR__c = [SELECT Id FROM Usuario_Backup__c LIMIT 1].Id;
            insert caso3;            

            system.debug('@@@@ CASO CONSULTAS TEST MASIVO => ' + caso3);
            

            CLS_CS_Derivacion_Proceso clsAS = new CLS_CS_Derivacion_Proceso();
			clsAS.AsignarCaso(caso2);     
            clsAS.ReasignarCaso(caso3.Id);
            //clsAS.AsignarCaso(caso4);
            
            Test.stopTest();
       // }catch(system.Exception ex){
         //   system.debug('@@@@ TEST ASIGNACION RESPONSABLE UR => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
       // }

    }
    
    @isTest static void ValidaPropietarioCaso_01()
    {
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '16790926';
        a.DV_contacto__pc = '4';
        insert a;

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
        caso1.OwnerId = [select id from user where Name = 'Manuel Eduardo Poblete López'].Id;
        update caso1;
        CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso1);    
       
        Test.stopTest();
    }
    
    @isTest static void ValidaPropietarioCaso_02()
    {
        Test.startTest();
        
        Account a = new Account();
        a.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        a.FirstName = 'H1';
        a.LastName = 'H2';
        a.PersonEmail = 'test@msystem.cl';
        a.Rut_contacto__pc = '16790926';
        a.DV_contacto__pc = '4';
        insert a;

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
        caso1.OwnerId = '00G0H0000063lQV';
        update caso1;
        CLS_CS_Derivacion_Proceso.ValidaPropietarioCaso(caso1);    
       
        Test.stopTest();
    }
}