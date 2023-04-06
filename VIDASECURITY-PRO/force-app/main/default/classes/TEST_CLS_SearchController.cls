/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 01-14-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_SearchController {

    @IsTest
    public static void searchTest(){
        Account accuntRecord = createAccountRecord();
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Phone');
        fields.add('Rating');
        List<String> searchResultsIds = new List<String>();
        searchResultsIds.add(accuntRecord.Id);
        Test.startTest();
        Test.setFixedSearchResults(searchResultsIds);
        CLS_SearchController.search('Account', fields, 'Salesforce');
        Test.stopTest();
    }

    @IsTest
    public static void searchTest1(){
        Account accuntRecord = createAccountRecord();
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Phone');
        fields.add('Rating');
        List<String> searchResultsIds = new List<String>();
        searchResultsIds.add(accuntRecord.Id);
        Test.startTest();
        Test.setFixedSearchResults(searchResultsIds);
        CLS_SearchController.search('Account', fields, '');
        Test.stopTest();
    }

    @IsTest
    public static void getRecentlyCreatedRecordTest(){
        Account accuntRecord = createAccountRecord();
        List<String> fields = new List<String>();
        fields.add('Name');
        fields.add('Phone');
        fields.add('Rating');
        String accountId = accuntRecord.Id;
        Test.startTest();
        SObject account = CLS_SearchController.getRecentlyCreatedRecord( accountId , fields, 'Account');
        String fetchedAccountId = (String)account.get('Id');
        System.assertEquals( fetchedAccountId , accountId , 'Id is not matching' );
        Test.stopTest();
    }

    private static Account createAccountRecord(){
        Account acc = new Account();
        acc.Name = 'Salesforce.com';
        acc.Rating = 'Hot';
        acc.Industry = 'Technology';
        acc.Description = 'This is a test account';
        acc.BillingCity = 'San Francisco';
        acc.BillingState = 'CA';
        acc.BillingPostalCode = '94105';
        acc.BillingCountry = 'USA';
        acc.Phone = '4158889999';
        acc.Type = 'Customer';
        insert acc;
        return acc;
    }
}