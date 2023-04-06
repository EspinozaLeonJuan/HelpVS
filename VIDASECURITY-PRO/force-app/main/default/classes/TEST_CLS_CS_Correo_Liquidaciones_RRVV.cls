/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-14-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public with sharing class TEST_CLS_CS_Correo_Liquidaciones_RRVV {

    @isTest
    public static void SendEmail()
    {
        TriggerHandler.disable();
        Account a = Factory.cuenta.buildInsert();

        system.debug('@@@@ CUENTA CASO DERIVACION => ' + a);

        Case caso1 = new Case();
        caso1.Tipo_de_Solicitante__c = 'Contratante';
        caso1.Canal__c = 'Asistencia Agente';
        caso1.Negocio__c = 'RRVV';
        caso1.AccountId = a.Id;
        caso1.ContactId = a.PersonContactId;
        caso1.Tipo_de_Cliente__c = 'Cliente Normal';
        String RecordTypeId_Atencion = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Atención').getRecordTypeId();

        caso1.RecordTypeId = RecordTypeId_Atencion;
        insert caso1;

        system.debug('@@@@ CASO ATENCION TEST MASIVO => ' + caso1);

        Case caso2 = new Case();
        caso2.ParentId = caso1.Id;
        caso2.Tipo_de_Solicitante__c = 'Contratante';
        caso2.Canal__c = 'Asistencia Agente';
        caso2.Negocio__c = 'RRVV';
        caso2.Concepto__c = 'Copia de liquidación';
        caso2.AccountId = a.Id;
        caso2.ContactId = a.PersonContactId;
        caso2.Tipo_de_Cliente__c = 'Cliente Normal';
        caso2.Tipo_de_Requerimiento__c = 'Consultas';
        caso2.Meses_Liquidaciones__c = 'Octubre';
        String RecordTypeId_Consultas = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Consultas').getRecordTypeId();
        caso2.RecordTypeId = RecordTypeId_Consultas;
        insert caso2;

        Liquidacion_RRVV__c liq = new Liquidacion_RRVV__c();
        liq.CaseId__c = caso2.Id;
        liq.Base64_1__c = 'JVBERi0xLjcKCjEgMCBvYmogICUgZW50cnkgcG9pbnQKPDwKICAvVHlwZSAvQ2F0YWxvZwog' +
  'IC9QYWdlcyAyIDAgUgo+PgplbmRvYmoKCjIgMCBvYmoKPDwKICAvVHlwZSAvUGFnZXMKICAv' +
  'TWVkaWFCb3ggWyAwIDAgMjAwIDIwMCBdCiAgL0NvdW50IDEKICAvS2lkcyBbIDMgMCBSIF0K' +
  'Pj4KZW5kb2JqCgozIDAgb2JqCjw8CiAgL1R5cGUgL1BhZ2UKICAvUGFyZW50IDIgMCBSCiAg' +
  'L1Jlc291cmNlcyA8PAogICAgL0ZvbnQgPDwKICAgICAgL0YxIDQgMCBSIAogICAgPj4KICA+' +
  'PgogIC9Db250ZW50cyA1IDAgUgo+PgplbmRvYmoKCjQgMCBvYmoKPDwKICAvVHlwZSAvRm9u' +
  'dAogIC9TdWJ0eXBlIC9UeXBlMQogIC9CYXNlRm9udCAvVGltZXMtUm9tYW4KPj4KZW5kb2Jq' +
  'Cgo1IDAgb2JqICAlIHBhZ2UgY29udGVudAo8PAogIC9MZW5ndGggNDQKPj4Kc3RyZWFtCkJU' +
  'CjcwIDUwIFRECi9GMSAxMiBUZgooSGVsbG8sIHdvcmxkISkgVGoKRVQKZW5kc3RyZWFtCmVu' +
  'ZG9iagoKeHJlZgowIDYKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDAwMDEwIDAwMDAwIG4g' +
  'CjAwMDAwMDAwNzkgMDAwMDAgbiAKMDAwMDAwMDE3MyAwMDAwMCBuIAowMDAwMDAwMzAxIDAw' +
  'MDAwIG4gCjAwMDAwMDAzODAgMDAwMDAgbiAKdHJhaWxlcgo8PAogIC9TaXplIDYKICAvUm9v' +
  'dCAxIDAgUgo+PgpzdGFydHhyZWYKNDkyCiUlRU9G';
        liq.RUT__c = '88888888-8';
        liq.Periodo__c = '202210';
        liq.Estado__c = 'Liquidación encontrada';
        insert liq;

        TriggerHandler.enable();
        Test.startTest();

        CLS_CS_Correo_Liquidaciones_RRVV.SendEmail(caso2.Id);

        Test.stopTest();
    }
}