@isTest
private class CopiaAdjuntoDeCasoSFTest {
	
	static {
		TriggerHandler.enable(CopiaAdjuntoDeCasoSFHandler.class);
	}

    static testMethod void myUnitTest() {
        Factory.crearAccountAnonimo();
        ControlTest.CopiaAdjuntoDeCaso = true;
        ControlTest.CreaCasoVidaSecurity = true;
        Account account = Factory.cuenta.buildInsert();

        Case caso = new Case();
        caso.Subject = 'Caso de prueba';
        caso.AccountId = account.Id;
        insert caso;
        Attachment attachment = new Attachment(ParentId = caso.Id, Name = 'test.txt', Body = Blob.valueOf('ABC123'), ContentType = 'text/plain', Description = 'abc abc');

        Test.startTest();
        insert attachment;
        Test.stopTest();
        ControlTest.CreaCasoVidaSecurity = false;
        ControlTest.CopiaAdjuntoDeCaso = false;
    }
}