/*
 ************************************************************************************************************
 |  NOMBRE                 : TEST_CLS_CV_ProcesoAsignacionRespUR                                          	|
 |  TIPO                   : APEX TEST CLASS																|
 |  TEST CLASS             : CLS_CV_ProcesoAsignacionResponsableUR                                          |
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Clase de Prueba                                                                |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/25   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
@istest(seeAllData=true)
public class TEST_CLS_CV_ProcesoAsignacionRespUR {
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
			caso2.CASO_Categoria__c = 'Endoso RRVV';
            caso2.Detalle_Solicitud__c = 'Solicitud Nuevo FUN';
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
			caso3.CASO_Categoria__c = 'Endoso RRVV';
            caso3.Detalle_Solicitud__c = 'Solicitud de Endoso';
            caso3.AccountId = a.Id;
            caso3.ContactId = a.PersonContactId;
            caso3.Tipo_de_Cliente__c = 'Cliente Normal';
            caso3.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso3.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
            caso3.OwnerId = [SELECT Id, QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'UR - Producción RRVV' LIMIT 1].QueueId;
            insert caso3;            

            system.debug('@@@@ CASO CONSULTAS TEST MASIVO => ' + caso3);

            Case caso4 = new Case();
            caso4.ParentId = caso1.Id;
            caso4.Tipo_de_Solicitante__c = 'Contratante';
            caso4.Canal__c = 'Asistencia Agente';
            caso4.Negocio__c = 'RRVV';
			caso4.CASO_Categoria__c = 'Beneficio Estatal';
            caso4.Detalle_Solicitud__c = 'Solicitud de Endoso';
            caso4.AccountId = a.Id;
            caso4.ContactId = a.PersonContactId;
            caso4.Tipo_de_Cliente__c = 'Cliente Normal';
            caso4.Tipo_de_Requerimiento__c = 'Solicitudes';
            caso4.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
			caso4.OwnerId = [SELECT Id, QueueId, Queue.Name, SobjectType FROM QueueSobject WHERE Queue.Name = 'UR - Producción RRVV' LIMIT 1].QueueId;            
            insert caso4;            

            CLS_CV_ProcesoAsignacionResponsableUR clsAS = new CLS_CV_ProcesoAsignacionResponsableUR();
			clsAS.AsignarCaso(caso2);     
            clsAS.ReasignarCaso(caso3.Id);
            //clsAS.AsignarCaso(caso4);
            
            Test.stopTest();
       // }catch(system.Exception ex){
         //   system.debug('@@@@ TEST ASIGNACION RESPONSABLE UR => ' + ex.getMessage() + ', Línea => ' + ex.getLineNumber());
       // }

    }
}