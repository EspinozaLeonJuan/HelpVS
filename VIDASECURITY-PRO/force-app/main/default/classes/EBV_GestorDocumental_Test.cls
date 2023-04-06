@isTest
public class EBV_GestorDocumental_Test {
    @TestSetup
    static void makeData(){
        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4';
        ms.MessagingEndUserId = '0PA6S0000006wvbWAA';
        ms.Status = 'Ended';        
        Insert ms;
        
        MessagingSession ms1 = new MessagingSession();
        ms1.CreatedDate = date.today();
        ms1.MessagingChannelId = '0Mj6S000000XZFXSA4';
        ms1.MessagingEndUserId = '0PA6S0000006wxNWAQ';
        ms1.Status = 'Ended';        
        Insert ms1;
        
        List<MessagingSession> MessagingSe =[Select Id,CreatedById From MessagingSession ];
        
        ContentVersion contentVersion_1 = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.JPG',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = false 
        );
        ContentVersion contentVersion_2 = new ContentVersion(
          Title = 'Penguins',
          PathOnClient = 'Penguins.JPG',
          VersionData = Blob.valueOf('Test Content'),
          IsMajorVersion = false
        );
        
        insert contentVersion_1;
        insert contentVersion_2;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId , FileType FROM ContentDocument];
        
    	ContentDocumentLink cd = new ContentDocumentLink();
        cd.LinkedEntityId = ms.Id;
        cd.ContentDocumentId = documents[0].Id;
        Insert cd;
        ContentDocumentLink cd1 = new ContentDocumentLink();
        cd1.LinkedEntityId = ms1.Id;
        cd1.ContentDocumentId = documents[1].Id;
        Insert cd1;

    
    }
    
    @isTest
    Public static void SendDoc(){
        List<EBV_GestorDocumental.Input> inpuList = new List<EBV_GestorDocumental.Input>();
        List<EBV_GestorDocumental.Output> output = new List<EBV_GestorDocumental.Output>();
        EBV_GestorDocumental.Input inpu = new EBV_GestorDocumental.Input();
        List<MessagingSession> MessagingSe =[Select Id,CreatedById From MessagingSession ];
        
        inpu.numR = '20128221';
        inpu.remitt = 'AMBUL20214441122';
        inpu.idMessaging = MessagingSe[0].Id;
        inpu.token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6ImFkbWluIiwibmJmIjoxNjQ5OTAyOTM2LCJleHAiOjE2NDk5MDQ3MzYsImlhdCI6MTY0OTkwMjkzNiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo0OTIyMCIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NDkyMjAifQ.n_KyOv3_iSvji9CSoNk8xJ66V8M_TZ3mOD8arpoKw-E';
        inpuList.add(inpu);
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GestorDocumentalMock());
		output = EBV_GestorDocumental.EnviarDocumentos(inpuList);
		Test.stopTest();
    }
    @isTest
    Public static void SendDocError(){
        List<EBV_GestorDocumental.Input> inpuList = new List<EBV_GestorDocumental.Input>();
        List<EBV_GestorDocumental.Output> output = new List<EBV_GestorDocumental.Output>();
        EBV_GestorDocumental.Input inpu = new EBV_GestorDocumental.Input();
        List<MessagingSession> MessagingSe =[Select Id,CreatedById From MessagingSession ];
        
        inpu.numR = '20128221';
        inpu.remitt = 'AMBUL20214441122';
        inpu.idMessaging = MessagingSe[1].Id;
        inpuList.add(inpu);
        
        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new EBV_GestorDocumentalMock());
		output = EBV_GestorDocumental.EnviarDocumentos(inpuList);
		Test.stopTest();
    }
}