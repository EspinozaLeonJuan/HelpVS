/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 06-28-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   06-28-2021   Juan Espinoza León   Initial Version
**/
@isTest(seeAllData = true)
public with sharing class TEST_CLS_INV_SP_Act_Prospecto_Poliza {
    public TEST_CLS_INV_SP_Act_Prospecto_Poliza() {
 
    }

    @isTest static public void Execute()
    {
        Test.startTest();
        TriggerHandler.disable();
        Account cuenta = new Account();
        cuenta.Name = 'Name';
        cuenta.RUT__c = '2';
        cuenta.DV__c = '7';
        insert cuenta;

        String RecordTypeId_Lead = [SELECT Id FROM RecordType WHERE Name = 'Prospecto - Salud Protegida'].Id;

        Lead prospecto = new Lead();
        prospecto.FirstName = 'Name';
        prospecto.LastName = 'LastName';
        prospecto.DV__c = '9';
        prospecto.RecordTypeId = RecordTypeId_Lead;
        prospecto.PROSP_Carga_RUT__c = '1';
        insert prospecto;   

        Poliza__c poliza = new Poliza__c();
        poliza.Name = '1';
        poliza.Intermediario__c = '';
        poliza.Cuenta__c = cuenta.Id;
        poliza.Fecha_Inicio_de_Vigencia__c = Date.Today();
        poliza.Forma_de_Pago__c = 'TC';
        poliza.Fecha_Inicio_de_Poliza__c  = Date.Today();
        poliza.Rut_Asegurado__c = '1';
        poliza.Codigo_de_Producto__c = '7400';
        insert poliza;

        String[] ruts = new String[1];
        ruts[0] = '1';
        CLS_INV_SP_ActualizaProspecto_Poliza.ActualizaDatos(ruts);
        TriggerHandler.enable();
        test.stopTest();
    }
}