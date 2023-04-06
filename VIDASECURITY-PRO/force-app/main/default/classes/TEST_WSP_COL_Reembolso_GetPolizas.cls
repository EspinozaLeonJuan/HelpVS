/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_GetPolizas {

    @isTest
	public static void getPoli() {

        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4'; //'0Mj8L000000CaSBSA0';
        ms.MessagingEndUserId = '0PA6S0000006wvbWAA';//'0PA8L000000GnBOWA0';
        ms.Status = 'Ended';
        insert ms;

		List<WSP_COL_Reembolso_GetPolizas.Input> inpuList = new List<WSP_COL_Reembolso_GetPolizas.Input>();
        List<WSP_COL_Reembolso_GetPolizas.Output> output = new List<WSP_COL_Reembolso_GetPolizas.Output>();
        WSP_COL_Reembolso_GetPolizas.Input input = new WSP_COL_Reembolso_GetPolizas.Input();

		Integer response;
        input.idMessage = ms.Id;
        input.rut = '14595270';
        inpuList.add(input);

        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Poliza_VS());
		output = WSP_COL_Reembolso_GetPolizas.getPoliza(inpuList);
		Test.stopTest();
    }
}