@isTest
private class AssignAccountCasoSFTest {

    static testMethod void assignAccountCasosTriggerTest() {
        Account account = new Account();
        account.Name = 'Test account';
        account.Rut__c = '16355278';
        account.DV__C = '7';
        insert account;
        Contact contact = new Contact();
        contact.LastName = 'Test';
        contact.AccountId = account.Id;
        insert contact;
        Case caso = new Case();
        caso.Contact = contact;
        caso.AccountId = account.Id;
        Test.startTest();
        insert caso;
        Test.stopTest();
            }
}