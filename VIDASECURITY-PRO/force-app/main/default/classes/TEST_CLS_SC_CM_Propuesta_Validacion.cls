/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 01-27-2022
 * @last modified by  : Juan Espinoza León
**/
@isTest
public class TEST_CLS_SC_CM_Propuesta_Validacion {

    public static String CRON_EXP = '0 0 0 24 6 ? 2022';

    public TEST_CLS_SC_CM_Propuesta_Validacion() {

    }

    @isTest static void Execute(){

        Account cuenta = new Account();
        cuenta.Name = 'Name';
        cuenta.RUT__c = '2';
        cuenta.DV__c = '7';
        insert cuenta;

        String RecordTypeId_Campaign  = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaña - Salud Protegida').getRecordTypeId();

        Campaign cmp = new Campaign();
        cmp.Name = 'TST CMP';
        cmp.RecordTypeId = RecordTypeId_Campaign;
        cmp.IsActive = true;
        cmp.Status = 'En curso';
        cmp.EndDate = Date.today().addDays(-1);
        cmp.Type = 'Salud Protegida';
        insert cmp;

        String RecordTypeId_Lead  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto - Salud Protegida').getRecordTypeId();

        Lead lead = new Lead();
        lead.PROSP_Carga_RUT__C = '2';
        lead.DV__C = '7';
        lead.Cobertura__c = '';
        lead.Capital_Remanente_Asegurado__c = 0;
        lead.PROSPE_Carga_Fecha_Inicio_Vigencia__c = Date.Today();
        lead.Prima_Nuevo_Producto__c = 0;
        lead.Prima_Poliza__c = null;
        lead.Prima_Final_Poliza_Original__c = 0;
        lead.Exclusiones__c = '';
        lead.PROSPE_Carga_Fecha_Nacimiento__c = Date.Today();
        lead.FirstName = 'A';
        lead.LastName = 'B';
        //lead.Sub_Estado__c = 'Asegurado';
        lead.Status = 'Abierto';
        lead.RecordTypeId = RecordTypeId_Lead;
        lead.Actualizacion_Datos_Poliza__c = true;
        insert lead;

        lead.Status = 'Contrata';
        update lead;


        String Opportunity_RecordTypeId  = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Venta - Oncológico').getRecordTypeId();

        Opportunity o = new Opportunity();
        o.RecordTypeId = Opportunity_RecordTypeId;
        o.Type = 'Propuesta';
        o.OPOR_N_Propuesta__c = '9999999';
        o.OPOR_Tipo_Folio__c = '19';
        o.OPOR_Codigo_Ramo__c = '7300';
        o.OPOR_Codigo_Plan__c = '001';
        o.OPOR_Codigo_Producto__c = 'MD01';
        o.OPOR_Revision_Plan__c = '001';
        o.OPOR_Codigo_Moneda__c = 'UF';
        o.OPOR_Porcentaje_Riesgo__c = 0;
        o.OPOR_Usuario__c = '12';
        o.LeadSource = 'TEST';
        o.OPOR_Codigo_Sucursal__c = '000016';
        o.OPOR_Codigo_Canal__c = '20';
        o.OPOR_Estado_Propuesta__c = 'ING';
        o.Codigo_Periodo_Pago__c = 'M';
        o.OPOR_ID_Campa_a_SF__c = '01';

        o.StageName = 'Venta - Aprobada';
        o.CloseDate = Date.today();
        o.Name = 'Propuesta N° ' + o.OPOR_N_Propuesta__c;

        //Asociando datos forma de pago
        o.OPOR_Codigo_Banco__c = null;
        o.OPOR_Codigo_Tarjeta__c = null;
        o.OPOR_N_Cuenta__c = null;
        o.OPOR_Id_Poliza_Asociada__c = '500000';
        o.OPOR_Tipo_Forma_Pago__c = 'P';
        o.OPOR_Fecha_Vencimiento__c = Date.today();
        o.StageName = 'Venta - Aprobada';
        o.OPOR_WS_Actualiza_Datos_Prospecto__c = true;

        Insert o;

        /*String  Poliza_RecordTypeId  = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

        Poliza__c poliza = new Poliza__c();
        poliza.Name = '9999999';
        poliza.Intermediario__c = '';
        poliza.Cuenta__c = cuenta.Id;
        poliza.Fecha_Inicio_de_Vigencia__c = Date.Today();
        poliza.Forma_de_Pago__c = 'TC';
        poliza.Fecha_Inicio_de_Poliza__c  = Date.Today();
        poliza.Rut_Asegurado__c = '1';
        poliza.Codigo_de_Producto__c = '7400';
        poliza.Estatus__c = 'ACTIVA';
        poliza.Rut_Asegurado__c = '2';

        insert poliza;*/

        Test.startTest();

        String jobId = System.schedule('ScheduledApexTest',
        CRON_EXP,
        new CLS_SC_CM_Propuesta_Validacion());

        test.stopTest();
    }
}