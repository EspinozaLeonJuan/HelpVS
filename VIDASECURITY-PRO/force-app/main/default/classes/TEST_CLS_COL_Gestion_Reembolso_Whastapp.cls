/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public  class TEST_CLS_COL_Gestion_Reembolso_Whastapp {

    @isTest
	public static void getTokenTest() {

		String response;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Token_VS());
		response = CLS_COL_Gestion_Reembolso_Whastapp.getToken();
		Test.stopTest();
		System.assert(response != 'ERROR', 'This service call should return a string containing a token.');
    }


    @isTest
	public static void getPolizaTest() {

		Test.startTest();

		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Poliza_VS());
		Integer response = CLS_COL_Gestion_Reembolso_Whastapp.getPoliza('99733837');

        Test.stopTest();
    }

	@TestSetup
    static void makeData(){
        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4';//'0Mj8L000000CaSBSA0';
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
	public static void getDatosRemesaTest() {

		Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Poliza_VS());
        List<MessagingSession> MessagingSe =[SELECT Id, Name, CreatedDate, StartTime, EndTime, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c FROM MessagingSession ORDER BY CreatedDate DESC];
		CLS_COL_Gestion_Reembolso_Whastapp.DatosReembolso response = CLS_COL_Gestion_Reembolso_Whastapp.getDatosRemesa(MessagingSe[0].Id);
        Test.stopTest();
    }





}