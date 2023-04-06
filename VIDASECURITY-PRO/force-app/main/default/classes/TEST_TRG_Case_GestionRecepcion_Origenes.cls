/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-16-2022
 * @last modified by  : Juan Espinoza León
**/

@IsTest
public with sharing class TEST_TRG_Case_GestionRecepcion_Origenes {

    private static String  Account_RecordTypeId_Empresarial  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
    private static String  Case_RecordTypeId_Atencion  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Atención').getRecordTypeId();
    private static String  Contact_RecordTypeId_Corredor  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Corredor').getRecordTypeId();

    @Istest
    static void test_1_origen_Seguro_Covid()
    {
        Account cuentaAnom = new Account();
        cuentaAnom.RUT__c = '99999998';
        cuentaAnom.DV__c = '0';
        cuentaAnom.Name = 'Anom';
        cuentaAnom.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaAnom;

        Account cuentaEmp = new Account();
        cuentaEmp.RUT__c = '99999995';
        cuentaEmp.DV__c = '6';
        cuentaEmp.Name = 'E';
        cuentaEmp.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaEmp;

        Contact contacto = new Contact();
        contacto.FirstName = 'CFN';
        contacto.LastName = 'CLN';
        contacto.Email = 'correo1@cotnactos.cl';
        contacto.Rut__c =  '6-K';
        contacto.AccountId = cuentaEmp.Id;
        contacto.Es_Seguro_COVID__c = true;
        contacto.Activo_Seguro_COVID__c = false;
        contacto.Es_Anonimo__c = true;
        contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
        insert contacto;


        Test.startTest();
        Case caso1 = new Case();
        caso1.Origin = 'SEGURO COVID';
        caso1.Canal__c = 'SEGURO COVID';
        caso1.SuppliedEmail = contacto.Email;
        caso1.RecordTypeId = Case_RecordTypeId_Atencion;
        caso1.Subject = 'Asunto';
        insert caso1;


        Case caso2 = new Case();
        caso2.Origin = 'SEGURO COVID';
        caso2.Canal__c = 'SEGURO COVID';
        caso2.SuppliedEmail = contacto.Email;
        caso2.RecordTypeId = Case_RecordTypeId_Atencion;
        caso2.Subject = 'Asunto Rut:99999995-6';
        insert caso2;

        Case caso3 = new Case();
        caso3.Origin = 'SEGURO COVID';
        caso3.Canal__c = 'SEGURO COVID';
        caso3.SuppliedEmail = 'nuevo@contacto.cl';
        caso3.RecordTypeId = Case_RecordTypeId_Atencion;
        caso3.Subject = 'Asunto Rut:99999995-6';
        insert caso3;
        Test.stopTest();

    }
}