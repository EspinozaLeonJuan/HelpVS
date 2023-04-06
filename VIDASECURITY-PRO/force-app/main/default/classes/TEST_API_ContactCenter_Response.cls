/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 10-15-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   10-15-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@IsTest
public with sharing class TEST_API_ContactCenter_Response {
    public TEST_API_ContactCenter_Response() {

    }

    @isTest static void Upload_Test_01()
    {
        Test.startTest();
        API_ContactCenter_Response response = new API_ContactCenter_Response();
        Test.stopTest();
    }
    
}