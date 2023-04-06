/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-15-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_BAK_Gestion_Seguro_Covid {

    private static String  Account_RecordTypeId_Empresarial  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta Corporativa').getRecordTypeId();
    private static String  Contact_RecordTypeId_Contratante  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contratante').getRecordTypeId();
    private static String  Contact_RecordTypeId_Corredor  = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Corredor').getRecordTypeId();
    private static String  Account_RecordTypeId_Personal  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Cuenta personal').getRecordTypeId();

    @Istest
    static void actualizaContactos()
    {

        Account cuentaEmp = new Account();
        cuentaEmp.RUT__c = '2';
        cuentaEmp.DV__c = '7';
        cuentaEmp.Name = 'E';
        cuentaEmp.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaEmp;
        
        Account cuentaPer = new Account();
        cuentaPer.RUT__c = '6';
        cuentaPer.DV__c = 'K';
        cuentaPer.FirstName = 'Nombre';
        cuentaPer.LastName = 'Cuenta';
        cuentaPer.Rut_contacto__pc = '6';
        cuentaPer.DV_contacto__pc = 'K';
        cuentaPer.RecordTypeId =  Account_RecordTypeId_Personal;
        insert cuentaPer;

        Contact contacto = new Contact();
        contacto.FirstName = 'CFN';
        contacto.LastName = 'CLN';
        contacto.Email = 'correo1@contactos.cl';
        contacto.Rut__c =  '6-K';
        contacto.AccountId = cuentaEmp.Id;
        contacto.Es_Seguro_COVID__c = true;
        contacto.Activo_Seguro_COVID__c = false;
        contacto.Es_Anonimo__c = true;
        contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
        insert contacto;

        Account cuentaAnom = new Account();
        cuentaAnom.RUT__c = '99999998';
        cuentaAnom.DV__c = '0';
        cuentaAnom.Name = 'Anom';
        cuentaAnom.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaAnom;

        Account cuentaAnomCol = new Account();
        cuentaAnomCol.RUT__c = '99999994';
        cuentaAnomCol.DV__c = '8';
        cuentaAnomCol.Name = 'AnomCol';
        cuentaAnomCol.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaAnomCol;       
        
        Corredor__c corredora = new Corredor__c();
        corredora.RUT__c = '7';
        corredora.DV__c = '8';
        corredora.Name = 'EC';
        insert corredora;

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact> wContacts = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact>();

        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '2-7';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '6-K';
        contact.TipoContacto = 'Corredor';
        contact.EmailContacto = 'correo1@contactos.cl';
        contact.RutEmpresaCorredora = '7-8';

        wContacts.add(contact);

        contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '2-7';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '1-9';
        contact.TipoContacto = 'Corredor';
        contact.EmailContacto = 'correo21@contactos.cl';
        contact.RutEmpresaCorredora = '7-8';

        wContacts.add(contact);


        contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '2-7';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '3-5';
        contact.TipoContacto = 'Contratante';
        contact.EmailContacto = 'correo3@contactos.cl';
        contact.RutEmpresaCorredora = '';

        wContacts.add(contact);


        contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '5-1';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '4-3';
        contact.TipoContacto = 'Corredor';
        contact.EmailContacto = 'correo4@contactos.cl';
        contact.RutEmpresaCorredora = '';

        wContacts.add(contact);
        
        contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '6-K';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '7-8';
        contact.TipoContacto = 'Corredor';
        contact.EmailContacto = 'correo5@contactos.cl';
        contact.RutEmpresaCorredora = '';

        wContacts.add(contact);
        
        contact = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Contact();
        contact.RutEmpresa = '6-K';
        contact.NombreContacto = 'NC';
        contact.ApellidoContacto = 'AC';
        contact.RutContacto = '9-4';
        contact.TipoContacto = 'Contratante';
        contact.EmailContacto = 'correo6@contactos.cl';
        contact.RutEmpresaCorredora = '';

        wContacts.add(contact);

        Test.startTest();
        CLS_BAK_Gestion_Seguro_Covid.actualizaContactos(wContacts);
        Test.stopTest();
    }

    @Istest
    static void retornaCuentasEnvioCorreo()
    {
        Account cuentaEmp = new Account();
        cuentaEmp.RUT__c = '2';
        cuentaEmp.DV__c = '7';
        cuentaEmp.Name = 'E';
        cuentaEmp.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaEmp;
        List<String> rutEmpresas = new List<String>();
        String rut = cuentaEmp.RUT__c+'-'+cuentaEmp.DV__c;
        rutEmpresas.add(rut);

        Test.startTest();
        CLS_BAK_Gestion_Seguro_Covid.retornaCuentasEnvioCorreo(rutEmpresas);
        Test.stopTest();

    }

    @Istest
    static void ejecutaEnvioMasivo()
    {
        Account cuentaAnomCol = new Account();
        cuentaAnomCol.RUT__c = '99999994';
        cuentaAnomCol.DV__c = '8';
        cuentaAnomCol.Name = 'AnomCol';
        cuentaAnomCol.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaAnomCol;
        
        Account cuentaEmp = new Account();
        cuentaEmp.RUT__c = '2';
        cuentaEmp.DV__c = '7';
        cuentaEmp.Name = 'E';
        cuentaEmp.RecordTypeId =  Account_RecordTypeId_Empresarial;
        insert cuentaEmp;

        Contact contacto = new Contact();
        contacto.FirstName = 'CFN';
        contacto.LastName = 'CLN';
        contacto.Email = 'correo@cotnactos.cl';
        contacto.Rut__c =  '4-3';
        contacto.AccountId = cuentaEmp.Id;
        contacto.Es_Seguro_COVID__c = true;
        contacto.Activo_Seguro_COVID__c = false;
        contacto.Es_Anonimo__c = true;
        contacto.RecordTypeId = Contact_RecordTypeId_Corredor;
        insert contacto;

        List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa> empresas = new List<CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa>();
        CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa empresa = new CLS_BAK_Gestion_Seguro_Covid.Wrapper_Empresa();
        String rut = cuentaEmp.RUT__c+'-'+cuentaEmp.DV__c;
        empresa.NombreEmpresa = 'E';
        empresa.RutEmpresa = rut;
        empresa.ExisteEmpresa = false;
        empresas.add(empresa);
        Test.startTest();
        CLS_BAK_Gestion_Seguro_Covid.ejecutaEnvioMasivo(empresas);
        Test.stopTest();
    }

}