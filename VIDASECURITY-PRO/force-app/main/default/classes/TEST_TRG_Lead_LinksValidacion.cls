/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 03-03-2022
 * @last modified by  : Juan Espinoza León
**/

@IsTest
private class TEST_TRG_Lead_LinksValidacion {
     @isTest
    static void testParse() {
        Test.startTest();

        Account ac = new Account(
            Name = 'Pruebas',
            Rut__c = '200448685',
            Coberturas__c = 'Vida;Catastrófico',
            RecordTypeId = ComercialConstants.accountComercial
        );
        Insert ac;

        String recordTypeId_Lead_Links =  Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').recordtypeid;

        Lead le = new Lead(
            FirstName = 'prueba',
            LastName = 'test',
            Status = 'Abierto',
            PROSP_Carga_RUT__c = '200448685',
            Tipo_Base__c = 'Bases Normales',
            Nombre_Base__c = 'Bases Normales',
            Tipo_Link__c = 'Bases Normales'
        );
        Insert le;

        le.Status = 'Habilitado';
        update le;

        Test.stopTest();
    }
}