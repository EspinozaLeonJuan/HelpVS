@isTest
public class CLS_ParticipanteCampanaFile_Test {
    
    @isTest static void Upload() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new WS_ValueWebCalloutMock());
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);
        Con.NombreArchivo = 'Audio';
        Con.Audio = Blob.valueOf('Unit Test Attachment Body');
        Test.stopTest();
        Savepoint sp = Database.setSavepoint();	
        Database.rollback(sp);
        Con.Upload();
        
    }
    
    @isTest static void UploadNoAudio() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);      
        Con.Upload();        
        Test.stopTest();
    }
    
    @isTest static void UploadNoAudio2() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);
        Blob b = null;
        Con.Audio = blob.valueOf('');
        Con.NombreArchivo = 'Prueba';
        Con.Upload();        
        Test.stopTest();
    }
    
    
   @isTest static void Subida2AudioSinLargo() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);
        Blob b = null;
        Con.Audio = blob.valueOf('');
        Con.NombreArchivo = 'Prueba';
        Con.Upload2();        
        Test.stopTest();
   }
    
   @isTest static void Subida2NoAudio() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);
        Con.NombreArchivo = 'Prueba';
        Con.Upload2();        
        Test.stopTest();
   }    
    
   @isTest static void Subida2Audio() {
        Test.startTest();
        Account account = Factory.cuenta.buildInsert();
        Contact contact = Factory.contacto.buildInsert(new Map<String,Object>{'AccountId' => account.Id});
        
        Campana_Vida_Security__c cam = new Campana_Vida_Security__c();
        cam.Name = 'Prueba de campaña';
        insert cam;
        
        Participantes_de_Campa_a__c p = new Participantes_de_Campa_a__c();
        p.Name = 'Prueba de participante';
        p.Campa_a_Vida_Security__c = cam.Id;
        p.Contacto__c = contact.Id;
        
        insert p;
        
        PageReference pageRef = Page.SEC_VF_ParticipanteCampana;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController controller = new ApexPages.StandardController(p);        
        CLS_ParticipanteCampanaFile Con = new CLS_ParticipanteCampanaFile(controller);
        Con.Audio = blob.valueOf('a');
        Con.NombreArchivo = 'Prueba';
        Con.Upload2();        
        Test.stopTest();
    }    
}