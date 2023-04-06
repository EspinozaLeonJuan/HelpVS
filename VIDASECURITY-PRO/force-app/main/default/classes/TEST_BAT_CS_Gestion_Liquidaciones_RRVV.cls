/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-13-2022
 * @last modified by  : Juan Espinoza León
**/
@istest
public with sharing class TEST_BAT_CS_Gestion_Liquidaciones_RRVV {
    public TEST_BAT_CS_Gestion_Liquidaciones_RRVV() {

    }

    @istest
    static void go() {

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
        liq.RUT__c = '88888888-8';
        liq.Periodo__c = '202204';
        
        insert liq;

        TriggerHandler.enable();

        Test.startTest();
		Test.setMock(HttpCalloutMock.class, new MOCK_CLS_CS_Servicio_Liquidaciones_RRVV());
        BAT_CS_Gestion_Liquidaciones_RRVV  batch = new BAT_CS_Gestion_Liquidaciones_RRVV (caso2.Id);
        Id batchId = Database.executeBatch(batch);

        Test.stopTest();
    }
}