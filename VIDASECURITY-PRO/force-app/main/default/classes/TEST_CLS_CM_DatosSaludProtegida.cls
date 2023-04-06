/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 05-21-2022
 * @last modified by  : Juan Espinoza León
**/
@istest
public class TEST_CLS_CM_DatosSaludProtegida {

    @isTest static void DatosSaludProtegida()
    {

        String  Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();
        system.debug('Task_RecordTypeId  '+Lead_RecordTypeId);

        Test.startTest();
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.PROSP_Carga_RUT__C = '15045517';
        lead.DV__C = '0';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        //lead.Nombre_de_Producto__c = 'prod';
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today();
        lead.FirstName = 'Juan';
        lead.LastName = 'Espinoza';
        lead.RecordTypeId = Lead_RecordTypeId;
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;
        Cotizador_Express__c cotiza = new Cotizador_Express__c();
        cotiza.Prima_Nuevo_Producto__c = 0;
        cotiza.LeadId__c = lead.Id;
        insert cotiza;

  CLS_CM_DatosSaludProtegida.DatosSaludProtegida(lead.Id);

     	Test.stopTest();
    }
}