@IsTest
public class EvitaEliminaciondeCasoTest {
	 @testsetup
    static void makeData(){
        Id p = [select id from profile where name='Ejecutivo Calidad LGN'].id;
        
         User user = new User(alias = 'test1234', email='test123@noemail.com',
                emailencodingkey='UTF-8', lastname='Testing1',RUT_Usuario__c= '111111-1', languagelocalekey='en_US',
                localesidkey='en_US', profileid = p, country='United States',IsActive =true,
                timezonesidkey='America/Los_Angeles', username='tester@noemail1.com');
        insert user;
        
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        Contact contacto = Factory.buildContactSF();
        Id id = '012i0000000xqP8AAI';
        
        string rutCuenta = '88888888';
    	string dvCuenta = '8';
    	string mailCuenta = 'mail@cuenta.cl';
   
        Case caso = new Case();
        caso.Canal__c = 'Asistencia Agente'; 
        caso.Tipo_de_Contacto__c = 'Familiar';
        caso.Linea_Negocio__c = 'Hipotecaria';
        caso.Negocio__c = 'RRVV';
        caso.Concepto__c = 'Concepto';
        caso.Description = 'Descripción';
        caso.Detalle_Solicitud__c = 'Detalle Solicitud';
        caso.Account = cuenta;
        caso.AccountId = cuenta.Id;
        caso.Correo_electronico_Solicitante__c = mailCuenta;
        caso.Nombre_Solicitante__c = 'Nombre';
        caso.RUT_Solicitante__c = rutCuenta;
        caso.Telefono_Solicitante__c = '1234567890';
        caso.RecordTypeId = '012i0000000xqP8AAI';
        insert caso;
        
    }
    @isTest
    static void DelCase(){
        Case acc = [Select Id from Case WHERE Concepto__c = 'Concepto'];
        User u1 = [Select Id from User WHERE username = 'tester@noemail1.com'];
        //System.runAs(u1){
        Test.startTest();
            Delete acc;
       Test.stopTest();
        //}
    }
}