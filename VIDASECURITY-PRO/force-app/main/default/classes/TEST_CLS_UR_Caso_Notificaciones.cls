/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-24-2022
 * @last modified by  : Juan Espinoza León
**/
@istest
public class TEST_CLS_UR_Caso_Notificaciones {
	static testMethod void EnviarCorreo_Test() {

		TriggerHandler.disable();

        Test.startTest();
        String ESTADO = '1';

        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;

        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;

        String AccountId = cuenta.Id;
        system.debug('@@@@ CASO TEST EnviarCorreo RecordTypeId => ' + RecordTypeId);
        system.debug('@@@@ CASO TEST EnviarCorreo AccountId => ' + AccountId);

        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'JUAN';
        CONTACTO_PRI.LastName = 'ESPINOZA LEON';
        CONTACTO_PRI.Email = 'juanespinozaleon@ibm.com';
        insert CONTACTO_PRI;

        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').recordtypeid;

        CUENTA_PRI.FirstName = 'JUAN';
        CUENTA_PRI.LastName = 'ESPINOZA LEON';
        CUENTA_PRI.PersonEmail = 'juanespinozaleon@ibm.com';
        CUENTA_PRI.Rut_contacto__pc = '15045517';
        CUENTA_PRI.DV_contacto__pc = '0';
        insert CUENTA_PRI;

        Case CASO_PRI = New Case();
        CASO_PRI.AccountId = CUENTA_PRI.ID;
        CASO_PRI.RecordTypeId = RecordTypeId;
        CASO_PRI.Contactid = CONTACTO_PRI.Id;
        CASO_PRI.CASO_Asunto_Notificaci_n__c = 'Asunto TEST';
        CASO_PRI.CASO_Mensaje_Notificaci_n__c ='Mensaje TEST';
        CASO_PRI.Tipo_de_Solicitante__c = 'Contratante';
        CASO_PRI.Canal__c = 'Asistencia Agente';
        CASO_PRI.Negocio__c = 'RRVV';
        CASO_PRI.Tipo_de_Cliente__c = 'Cliente Normal';
        insert CASO_PRI;

        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
        CTR_UR_Caso_GeneraPDF clsPDF = new CTR_UR_Caso_GeneraPDF();
        clsPDF.NumeroPolizaPDF = '12310333';
        List<String> ccEmails = new List<String>();
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = '2';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = '3';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');

        clsPDF.IdCaso = CASO_PRI.Id;
        clsPDF.AsuntoCasoPDF = 'Asunto Test';
        clsPDF.ComentarioCasoPDF = 'Comentario';


        clsPDF.cargaPDF();
        Test.stopTest();

		TriggerHandler.enable();
    }

    static testMethod void EnviarCorreoCobranzasVida_Test() {
        TriggerHandler.disable();

        Test.startTest();
        String ESTADO = '1';

         String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;

        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;

        String AccountId = cuenta.Id; system.debug('@@@@ CASO TEST EnviarCorreo RecordTypeId => ' + RecordTypeId);
        system.debug('@@@@ CASO TEST EnviarCorreo AccountId => ' + AccountId);


        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'JUAN';
        CONTACTO_PRI.LastName = 'ESPINOZA LEON';
        CONTACTO_PRI.Email = 'juan.espinoza@ext-security.cl';
        insert CONTACTO_PRI;

        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'JUAN';
        CUENTA_PRI.LastName = 'ESPINOZA LEON';
        CUENTA_PRI.PersonEmail = 'juan.espinoza@ext-security.cl';
        CUENTA_PRI.Rut_contacto__pc = '15045517';
        CUENTA_PRI.DV_contacto__pc = '0';
        insert CUENTA_PRI;

        Case CASO_PRI = New Case();
        CASO_PRI.AccountId = CUENTA_PRI.ID;
        CASO_PRI.RecordTypeId = RecordTypeId;
        CASO_PRI.Contactid = CONTACTO_PRI.Id;
        CASO_PRI.CASO_Asunto_Notificaci_n__c = 'Asunto TEST';
        CASO_PRI.CASO_Mensaje_Notificaci_n__c ='Mensaje TEST';
        CASO_PRI.Tipo_de_Solicitante__c = 'Contratante';
        CASO_PRI.Canal__c = 'Cobranzas Vida';
        CASO_PRI.Origin = 'Cobranzas Vida';
        CASO_PRI.Negocio__c = 'RRVV';
        CASO_PRI.Tipo_de_Cliente__c = 'Cliente Normal';
        CASO_PRI.Correo_electronico_Solicitante__c = 'juan.espinoza@ext-security.cl';
        CASO_PRI.Correo_electronico_alternativo__c = 'juan.espinoza@ext-security.cl';
        insert CASO_PRI;

        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);
		//Test.startTest();
        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
        CTR_UR_Caso_GeneraPDF clsPDF = new CTR_UR_Caso_GeneraPDF();
        clsPDF.NumeroPolizaPDF = '12310333';
        List<String> ccEmails = new List<String>();

        ESTADO = 'En Revisión';//'2';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = 'Cerrado';//'2';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = 'Rechazado';//3;
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');

        clsPDF.IdCaso = CASO_PRI.Id;
        clsPDF.AsuntoCasoPDF = 'Asunto Test';
        clsPDF.ComentarioCasoPDF = 'Comentario';
        clsPDF.cargaPDF();
        Test.stopTest();
        TriggerHandler.enable();
    }

    static testMethod void EnviarCorreoProduccionIndividuales_Test() {
        TriggerHandler.disable();

        Test.startTest();
        String ESTADO = '1';

        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;

        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'JUAN';
        CONTACTO_PRI.LastName = 'ESPINOZA LEON';
        CONTACTO_PRI.Email = 'juan.espinoza@ext-security.cl';
        insert CONTACTO_PRI;

        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').recordtypeid;
        CUENTA_PRI.FirstName = 'JUAN';
        CUENTA_PRI.LastName = 'ESPINOZA LEON';
        CUENTA_PRI.PersonEmail = 'juan.espinoza@ext-security.cl';
        CUENTA_PRI.Rut_contacto__pc = '15045517';
        CUENTA_PRI.DV_contacto__pc = '0';
        insert CUENTA_PRI;

        Case CASO_PRI = New Case();
        CASO_PRI.AccountId = CUENTA_PRI.ID;
        CASO_PRI.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;
        CASO_PRI.Contactid = CONTACTO_PRI.Id;
        CASO_PRI.CASO_Asunto_Notificaci_n__c = 'Asunto TEST';
        CASO_PRI.CASO_Mensaje_Notificaci_n__c ='Mensaje TEST';
        CASO_PRI.Tipo_de_Solicitante__c = 'Contratante';
        CASO_PRI.Canal__c = 'Producción Individuales';
        CASO_PRI.Origin = 'Producción Individuales';
        CASO_PRI.Negocio__c = 'Seguros Individuales';
        CASO_PRI.Tipo_de_Cliente__c = 'Cliente Normal';
        CASO_PRI.Correo_electronico_Solicitante__c = 'juan.espinoza@ext-security.cl';
        CASO_PRI.Correo_electronico_alternativo__c = 'juan.espinoza@ext-security.cl';
        insert CASO_PRI;

        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
        CTR_UR_Caso_GeneraPDF clsPDF = new CTR_UR_Caso_GeneraPDF();
        clsPDF.NumeroPolizaPDF = '12310333';
        List<String> ccEmails = new List<String>();

        ESTADO = 'En Revisión';//'2';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = 'Cerrado';//'2';
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');
        ESTADO = 'Rechazado';//3;
        notificacion.EnviaNotificacion(CASO_PRI.Id,ESTADO, ccEmails, 'comentario');

        clsPDF.IdCaso = CASO_PRI.Id;
        clsPDF.AsuntoCasoPDF = 'Asunto Test';
        clsPDF.ComentarioCasoPDF = 'Comentario';
        clsPDF.cargaPDF();
        Test.stopTest();
        TriggerHandler.enable();
    }

    static testMethod void EnviarCorreoIndividuales_Test() {
        TriggerHandler.disable();

        Test.startTest();

        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;

        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'JUAN';
        CONTACTO_PRI.LastName = 'ESPINOZA LEON';
        CONTACTO_PRI.Email = 'juespinoza@security.cl';
        insert CONTACTO_PRI;

        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').recordtypeid;
        CUENTA_PRI.FirstName = 'JUAN';
        CUENTA_PRI.LastName = 'ESPINOZA LEON';
        CUENTA_PRI.PersonEmail = 'juespinoza@security.cl';
        CUENTA_PRI.Rut_contacto__pc = '15045517';
        CUENTA_PRI.DV_contacto__pc = '0';
        insert CUENTA_PRI;

        Case CASO_PRI = New Case();
        CASO_PRI.AccountId = CUENTA_PRI.ID;
        CASO_PRI.RecordTypeId = RecordTypeId;
        CASO_PRI.Contactid = CONTACTO_PRI.Id;
        CASO_PRI.CASO_Asunto_Notificaci_n__c = 'Asunto TEST';
        CASO_PRI.CASO_Mensaje_Notificaci_n__c ='Mensaje TEST';
        CASO_PRI.Tipo_de_Solicitante__c = 'Contratante';
        CASO_PRI.Canal__c = 'Asistencia Agente';
        CASO_PRI.Negocio__c = 'RRVV';
        CASO_PRI.Tipo_de_Cliente__c = 'Cliente Normal';
        insert CASO_PRI;

        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
        List<String> ccEmails = new List<String>();
        notificacion.EnviaNotificacion_Individual(CASO_PRI.Id,'En Revisión', 'Sobreprima', ccEmails, 'comentario');

        notificacion.EnviaNotificacion_Individual(CASO_PRI.Id, 'Cerrado', 'Sobreprima', ccEmails, 'comentario');

        Test.stopTest();
    }

    static testMethod void enviarEmail_Individuales_Test() {
        TriggerHandler.disable();
        Test.startTest();

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();
         List<String> ccEmails = new List<String>();
        notificacion.enviarEmail_Individuales(null, ccEmails, 'comentario');

        Test.stopTest();
        TriggerHandler.enable();
    }


    static testMethod void GeneraAdjunto_Test() {

        Test.startTest();

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();

        notificacion.GeneraAdjunto('Sobreprima','');
        notificacion.GeneraAdjunto('Exclusion','');
        Test.stopTest();
    }

     static testMethod void EnviarCorreo_RescateWeb_Test() {
        TriggerHandler.disable();

        Test.startTest();
        String ESTADO = '1';

        String RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;

        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'JUAN';
        CONTACTO_PRI.LastName = 'ESPINOZA LEON';
        CONTACTO_PRI.Email = 'juan.espinoza@ext-security.cl';
        insert CONTACTO_PRI;

        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').recordtypeid;
        CUENTA_PRI.FirstName = 'JUAN';
        CUENTA_PRI.LastName = 'ESPINOZA LEON';
        CUENTA_PRI.PersonEmail = 'juan.espinoza@ext-security.cl';
        CUENTA_PRI.Rut_contacto__pc = '15045517';
        CUENTA_PRI.DV_contacto__pc = '0';
        insert CUENTA_PRI;

        Case CASO_PRI = New Case();
        CASO_PRI.AccountId = CUENTA_PRI.ID;
        CASO_PRI.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Solicitudes').recordtypeid;
        CASO_PRI.Contactid = CONTACTO_PRI.Id;
        CASO_PRI.CASO_Asunto_Notificaci_n__c = 'Asunto TEST';
        CASO_PRI.CASO_Mensaje_Notificaci_n__c ='Mensaje TEST';
        CASO_PRI.Tipo_de_Solicitante__c = 'Contratante';
        CASO_PRI.Canal__c = 'Producción Individuales';
        CASO_PRI.Origin = 'Producción Individuales';
        CASO_PRI.Negocio__c = 'Seguros Individuales';
        CASO_PRI.Tipo_de_Cliente__c = 'Cliente Normal';
        CASO_PRI.Correo_electronico_Solicitante__c = 'juan.espinoza@ext-security.cl';
        CASO_PRI.Correo_electronico_alternativo__c = 'juan.espinoza@ext-security.cl';
        insert CASO_PRI;

        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);

        CLS_UR_Caso_Notificaciones notificacion = new CLS_UR_Caso_Notificaciones();

        notificacion.EnviaNotificacion_RescateWeb(CASO_PRI.Id);

        Test.stopTest();
        TriggerHandler.enable();
    }

}