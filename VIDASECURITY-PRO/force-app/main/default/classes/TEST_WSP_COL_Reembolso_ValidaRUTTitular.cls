/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class TEST_WSP_COL_Reembolso_ValidaRUTTitular {

    static TestMethod void validateRutTest(){

        MessagingSession ms = new MessagingSession();
        ms.CreatedDate = date.today();
        ms.MessagingChannelId = '0Mj6S000000XZFXSA4'; //'0Mj8L000000CaSBSA0';
        ms.MessagingEndUserId = '0PA6S0000006wvbWAA';//'0PA8L000000GnBOWA0';
        ms.Status = 'Ended';
        insert ms;

        Account cuenta = new Account();
        cuenta.RUT__C = '12345678';
        cuenta.DV__c = '0';
        cuenta.FirstName = 'AA';
        cuenta.LastName = 'BB';
        cuenta.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').RecordTypeId;
        insert cuenta;
        Test.startTest();
        WSP_COL_Reembolso_ValidaRUTTitular.Input input = new WSP_COL_Reembolso_ValidaRUTTitular.Input();
        input.rut = '123456780';
        input.idMessage = ms.Id;
        String dv = input.rut.substring(input.rut.length() - 1);
        List<WSP_COL_Reembolso_ValidaRUTTitular.Input> listInput = new List<WSP_COL_Reembolso_ValidaRUTTitular.Input>();
        listInput.add(input);
        String conca = String.valueOf(input.rut) + String.valueOf(dv);
        WSP_COL_Reembolso_ValidaRUTTitular.validaRUTTitular(listInput);
        Test.stopTest();
    }
}