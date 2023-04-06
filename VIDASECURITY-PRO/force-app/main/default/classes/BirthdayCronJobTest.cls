@IsTest
public class BirthdayCronJobTest {

	static testmethod void test() {
              
        Integer testMonth = date.today().month();
        Integer testDay = date.today().day();
        
        BirthdayCronJob BCJ = new BirthdayCronJob();        
        BCJ.sendMail();
               
        Account testAccount = new Account();
        testAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();
        testAccount.FirstName = 'Test';
        testAccount.LastName = 'Cuenta';
        testAccount.Rut__c = '88888888';
        testAccount.DV__c = '8';
        testAccount.PersonEmail = 'testcuenta@test.com';
        testAccount.Recibe_Correos_Cumpleanos__c = true;
        testAccount.Declarado_Fallecido__c = false;
        testAccount.Siniestro_Vida__c = false;
        testAccount.PersonBirthdate = date.today();        
        insert testAccount;
        
        Poliza__c polizaTest = new Poliza__c();
        polizaTest.Cuenta__c = testAccount.Id;
        polizaTest.Estatus__c = 'ACTIVA';
        polizaTest.Name = '8888';
        polizaTest.CurrencyIsoCode = 'CLP';
        insert polizaTest;
        
        testAccount.Resetear_Sistema_de_Correo_de_Cumplea_os__c = false;
        update testAccount;       
        BCJ.sendMail();

        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobId = System.schedule('testBasicScheduledApex', CRON_EXP, new BirthdayCronJob());
        
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
        				  FROM CronTrigger
        				  WHERE id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);       
        System.assertEquals(0, ct.TimesTriggered);        
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
	}
}