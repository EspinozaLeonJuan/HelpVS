@isTest
public  class EBV_GetBusinessHour_Test 
{
    @isTest
    private static void testGetBusinessHours()
    {
        Test.startTest(); 

        List<EBV_GetBusinessHour.Output> result = EBV_GetBusinessHour.processInput();
        System.assertNotEquals(Null, Result, 'Expected bussiness hours');
        Test.stopTest();
     
    }
}