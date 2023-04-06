@istest public class TEST_BAT_NotificacionValeVista {
   // static String IdCarga {get;set;} 
    public TEST_BAT_NotificacionValeVista() {

    }

    @testSetup 
    static void setup() {

       // Carga_Vale_Vista__c carga = new Carga_Vale_Vista__c();
        //insert carga;

        List<Account> accounts = new List<Account>();
        List<Registro_Vale_Vista__c> vvclist = new List<Registro_Vale_Vista__c>();
        // insert 10 accounts
        for (Integer i=0;i<10;i++) {
            accounts.add(new Account(name='Account '+i, 
                billingcity='San Francisco', billingcountry='USA'));
        }
        insert accounts;

        // find the account just inserted. add contact for each
        for (Account account : [select id from account]) {
            Registro_Vale_Vista__c vvcObj = new Registro_Vale_Vista__c() ;
            vvcObj.RUT__c =  '13005866-3';
            vvcObj.Monto__c = 17400;
            vvcObj.Fecha_Vale_Vista__c = date.newInstance(2019, 4, 28);
            vvcObj.Empresa__c = 'VIDA';
            vvcObj.Tipo__c = 'CADUCADO';
            vvcObj.Email__c = 'juan.espinoza@ext-security.cl';
            vvcObj.Es_Notificable__c = true;
            vvcObj.Resultado__c = 'Carga OK';
            vvcObj.Cuenta__c = account.Id;
            vvcObj.Carga_Vale_Vista__c = 'a1M0H000006bsaOUAQ';
            vvclist.add(vvcObj);
        }
        
        insert vvclist;

       // IdCarga = carga.Id;
    }
    static testmethod void test() {        
        Test.startTest();
        BAT_NotificacionValeVista  batch = new BAT_NotificacionValeVista ('a1M0H000006bsaOUAQ');
        Id batchId = Database.executeBatch(batch);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(10, [select count() from Registro_Vale_Vista__c where Es_Notificable__c = true]);
    }
    
}