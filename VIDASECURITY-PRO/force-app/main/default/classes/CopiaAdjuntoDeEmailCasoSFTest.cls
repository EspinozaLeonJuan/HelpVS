@isTest
private class CopiaAdjuntoDeEmailCasoSFTest {
	
	static {
		TriggerHandler.enable(CopiaAdjuntoDeEmailCasoSFHandler.class);
			}

    static testMethod void myUnitTest() {
        Factory.crearAccountAnonimo();
        ControlTest.CopiaAdjuntoDeEmail = true;
        ControlTest.CreaCasoVidaSecurity = true;
        Account account = Factory.cuenta.buildInsert();

        Case caso = new Case();
        caso.Subject = 'Caso de prueba';
        caso.AccountId = account.Id;
        insert caso;
        EmailMessage message = new EmailMessage();
        message.Incoming = true;
        message.ParentId = caso.Id;
        message.Subject = 'Test message';
        insert message;

        Attachment attachment = new Attachment(ParentId = message.Id, Name = 'test.txt', Body = Blob.valueOf('ABC123'), ContentType = 'text/plain', Description = 'abc abc');

        Test.startTest();
        insert attachment;
        Test.stopTest();
        ControlTest.CreaCasoVidaSecurity = false;
        ControlTest.CopiaAdjuntoDeEmail = false;
    }
}