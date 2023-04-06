/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_ValidarDocs {
    @TestSetup
    static void makeData(){
        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4'; //'0Mj8L000000CaSBSA0';
        ms.MessagingEndUserId = '0PA6S0000006wvbWAA';//'0PA8L000000GnBOWA0';
        ms.RUT_Titular_Reembolso__c = '12345678-0';
        ms.Poliza_Titular_Reembolso__c = '282758';
        ms.RUT_Dependiente_Reembolso__c = '12345678-0';
        ms.Valor_Tipo_de_Gasto_Reembolso__c = 1;
        ms.StartTime = Datetime.now();
        ms.Status = 'Ended';
        insert ms;


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
        cd1.LinkedEntityId = ms.Id;
        cd1.ContentDocumentId = documents[1].Id;
        Insert cd1;


    }


    @isTest
    Public static void SendDoc(){
        List<WSP_COL_Reembolso_ValidarDocs.Input> inpuList = new List<WSP_COL_Reembolso_ValidarDocs.Input>();
        List<WSP_COL_Reembolso_ValidarDocs.Output> output = new List<WSP_COL_Reembolso_ValidarDocs.Output>();
        WSP_COL_Reembolso_ValidarDocs.Input inpu = new WSP_COL_Reembolso_ValidarDocs.Input();
        List<MessagingSession> MessagingSe =[Select Id,CreatedById From MessagingSession ];

        inpu.idMessage = MessagingSe[0].Id;
        inpuList.add(inpu);

        Test.startTest();
		//Test.setMock(HttpCalloutMock.class, new EBV_GestorDocumentalMock());
		output = WSP_COL_Reembolso_ValidarDocs.ValidarDoc(inpuList);
		Test.stopTest();
    }
}