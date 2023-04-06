/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-20-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class TEST_CLS_COL_Gestion_Documentos_VT {
    @isTest
	public static void getTokenTest() {

		String response;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Token_VT());
		response = CLS_COL_Gestion_Documentos_Valuetech.getToken();
		Test.stopTest();
		System.assert(response != 'ERROR', 'This service call should return a string containing a token.');
    }

    @istest (seealldata=true)
    public static void SendDoc(){
        List<MessagingSession> MessagingSe =[SELECT Id, Name, CreatedDate, StartTime, EndTime, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c FROM MessagingSession ORDER BY CreatedDate DESC];

        Test.startTest();
        CLS_COL_Gestion_Documentos_Valuetech.SendDocuments(MessagingSe[0].Id,  MessagingSe[0].Vass_Remesa__c,  MessagingSe[0].Numero_Denuncio__c,  String.valueOf(MessagingSe[0].StartTime));
        CLS_COL_Gestion_Documentos_Valuetech.SendDocuments(MessagingSe[0].Id);
		Test.stopTest();
    }
}