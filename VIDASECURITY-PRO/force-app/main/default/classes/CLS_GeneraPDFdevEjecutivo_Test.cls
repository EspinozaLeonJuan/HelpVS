@isTest
public class CLS_GeneraPDFdevEjecutivo_Test {
    
    static testMethod void EnviarCorreo() {
        Test.startTest();
        
        String ESTADO = '1';
        
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
        String AccountId = '001f000000wYWV3AAO'; //[SELECT Id FROM Account Where Name ='Carlos Espinoza'].Id;
        system.debug('@@@@ CASO TEST EnviarCorreo RecordTypeId => ' + RecordTypeId);
        system.debug('@@@@ CASO TEST EnviarCorreo AccountId => ' + AccountId);
        
        
        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'CARLOS';
        CONTACTO_PRI.LastName = 'ESPINOZA P';
        CONTACTO_PRI.Email = 'cespinoza@microsystem.cl';
        insert CONTACTO_PRI;
        
        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'CARLOS';
        CUENTA_PRI.LastName = 'ESPINOZA P';
        CUENTA_PRI.PersonEmail = 'cespinoza@microsystem.cl';
        CUENTA_PRI.Rut_contacto__pc = '16790926';
        CUENTA_PRI.DV_contacto__pc = '4';        
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
        
        CLS_generaPDFdevejecutivo clsPDF = new CLS_generaPDFdevejecutivo();
        clsPDF.NPOLI_PDF2 = '12310333';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        ESTADO = '2';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        ESTADO = '3';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        
        clsPDF.IDCAS_PDF = CASO_PRI.Id;
        clsPDF.ASUNT_PDF = 'Asunto Test';
        clsPDF.COMEN_PDF = 'Comentario';
        clsPDF.cargaPDF();
        Test.stopTest();
    }
    
    static testMethod void EnviarCorreoCobranzasVida() {
        Test.startTest();
        
        String ESTADO = '1';
        
        String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Solicitudes' AND SobjectType = 'Case'].Id;
        String AccountId = '001f000000wYWV3AAO'; //[SELECT Id FROM Account Where Name ='Carlos Espinoza'].Id;
        system.debug('@@@@ CASO TEST EnviarCorreo RecordTypeId => ' + RecordTypeId);
        system.debug('@@@@ CASO TEST EnviarCorreo AccountId => ' + AccountId);
        
        
        Contact CONTACTO_PRI = new Contact();
        CONTACTO_PRI.FirstName = 'CARLOS';
        CONTACTO_PRI.LastName = 'ESPINOZA P';
        CONTACTO_PRI.Email = 'cespinoza@microsystem.cl';
        insert CONTACTO_PRI;
        
        Account CUENTA_PRI = new Account();
        CUENTA_PRI.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Cuenta personal'].Id;
        CUENTA_PRI.FirstName = 'CARLOS';
        CUENTA_PRI.LastName = 'ESPINOZA P';
        CUENTA_PRI.PersonEmail = 'cespinoza@microsystem.cl';
        CUENTA_PRI.Rut_contacto__pc = '16790926';
        CUENTA_PRI.DV_contacto__pc = '4';        
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
        CASO_PRI.Correo_electronico_Solicitante__c = 'cespinoza@microsystem.cl';
        CASO_PRI.Correo_electronico_alternativo__c = 'cespinoza@microsystem.cl';
        insert CASO_PRI;
        
        system.debug('@@@@ CASO TEST CasoID => ' + CASO_PRI.Id);
        
        CLS_generaPDFdevejecutivo clsPDF = new CLS_generaPDFdevejecutivo();
        clsPDF.NPOLI_PDF2 = '12310333';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        ESTADO = '2';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        ESTADO = '3';
        clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
        
        clsPDF.IDCAS_PDF = CASO_PRI.Id;
        clsPDF.ASUNT_PDF = 'Asunto Test';
        clsPDF.COMEN_PDF = 'Comentario';
        clsPDF.cargaPDF();
        Test.stopTest();
    }    
    
}