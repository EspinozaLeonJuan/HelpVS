/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 09-21-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class TEST_WSP_COL_Reembolso_GetBusinessHour {

    @isTest
    private static void testGetBusinessHours()
    {
        Test.startTest();

        List<WSP_COL_Reembolso_GetBusinessHour.Output> result = WSP_COL_Reembolso_GetBusinessHour.processInput();
        System.assertNotEquals(Null, Result, 'Expected bussiness hours');
        Test.stopTest();

    }
}