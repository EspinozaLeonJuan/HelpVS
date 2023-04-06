@isTest
private class AssignAccountTest {

    static testMethod void assignAccountTriggerTest() {
    	Account account = new Account();
    	account.Name = 'Test account';
        account.Rut__c = '16355278';
        account.DV__C = '7';
    	insert account;
    	Contact contact = new Contact();
    	contact.LastName = 'Test';
    	contact.AccountId = account.Id;
    	insert contact;
    	Caso_Vida_Security__c caso = new Caso_Vida_Security__c();
    	caso.Nombre_del_Contacto__c = contact.Id;
    	Test.startTest();
    	insert caso;
    	Test.stopTest();
            }
}