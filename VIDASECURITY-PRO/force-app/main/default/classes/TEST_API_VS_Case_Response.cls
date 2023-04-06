@IsTest
public with sharing class TEST_API_VS_Case_Response {
    @isTest static void inic()
    {
        Test.startTest();
        API_VS_Case_Response apc_1 = new API_VS_Case_Response();
        API_VS_Case_Response apc_2 = new API_VS_Case_Response('1','1');
        API_VS_Case_Response apc_3 = new API_VS_Case_Response('1','2','3','4');
        Test.stopTest();
    }
}