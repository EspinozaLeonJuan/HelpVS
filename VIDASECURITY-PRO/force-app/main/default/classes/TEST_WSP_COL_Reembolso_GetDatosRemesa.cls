/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public class TEST_WSP_COL_Reembolso_GetDatosRemesa {

    @isTest
	public static void getremi() {

        Account cuenta = new Account();
        cuenta.RUT__C = '12345678';
        cuenta.DV__c = '0';
        cuenta.FirstName = 'AA';
        cuenta.LastName = 'BB';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').RecordTypeId;
        insert cuenta;

        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4'; //'0Mj8L000000CaSBSA0';
        ms.MessagingEndUserId = '0PA6S0000006wvbWAA';//'0PA8L000000GnBOWA0';
        ms.RUT_Titular_Reembolso__c = '12345678-0';
        ms.Poliza_Titular_Reembolso__c = '282758';
        ms.RUT_Dependiente_Reembolso__c = '12345678-0';
        ms.Valor_Tipo_de_Gasto_Reembolso__c = 1;
        ms.Status = 'Ended';
        insert ms;

		List<WSP_COL_Reembolso_GetDatosRemesa.Input> inpuList = new List<WSP_COL_Reembolso_GetDatosRemesa.Input>();
        List<WSP_COL_Reembolso_GetDatosRemesa.Output> output = new List<WSP_COL_Reembolso_GetDatosRemesa.Output>();
        WSP_COL_Reembolso_GetDatosRemesa.Input input = new WSP_COL_Reembolso_GetDatosRemesa.Input();

		Integer response;
        input.idMessage =  ms.Id;
        inpuList.add(input);

        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_COL_Response_Poliza_VS());
		output = WSP_COL_Reembolso_GetDatosRemesa.getDatosRemesa(inpuList);
		Test.stopTest();
    }

}