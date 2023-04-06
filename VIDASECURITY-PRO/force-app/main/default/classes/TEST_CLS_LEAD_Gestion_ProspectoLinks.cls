/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-04-2022
 * @last modified by  : Juan Espinoza León
**/
@IsTest
public with sharing class TEST_CLS_LEAD_Gestion_ProspectoLinks {
    public TEST_CLS_LEAD_Gestion_ProspectoLinks() {

    }

    private static String parameters_update_custom_fields = '[{"key":"f_tipo_mailing","value":"APV con cargo"},{"key":"f_nombre_producto_campagna","value":"jabon+ccuu"},{"key":"f_numero_poliza_campagna","value":""},{"key":"f_fecha_inicio_vigencia_poliza_campagna","value":""},{"key":"f_periodicidad_pago_poliza_campagna","value":""},{"key":"f_medio_pago_poliza_campagna","value":""},{"key":"f_capital_fallecimiento_poliza_campagna","value":""},{"key":"f_prima_poliza_campagna","value":""},{"key":"f_simulacion_1","value":""},{"key":"f_simulacion_2","value":""},{"key":"f_simulacion_3","value":""},{"key":"f_simulacion_4","value":""},{"key":"f_simulacion_5","value":""},{"key":"f_simulacion_6","value":""},{"key":"f_supuesto_simulacion_1","value":""},{"key":"f_supuesto_simulacion_2","value":""},{"key":"f_supuesto_simulacion_3","value":""},{"key":"f_ultimo_producto_contratado","value":""},{"key":"f_numero_ultima_poliza_contratada","value":""},{"key":"f_fecha_inicio_vigencia_ultima_poliza_cont","value":""},{"key":"f_periodicidad_pago_ultima_poliza_contr","value":""},{"key":"f_medio_pago_ultima_poliza_contr","value":""},{"key":"f_capital_fallecimiento_ultima_poliza_cont","value":""},{"key":"f_prima_ultima_poliza_contratada","value":""},{"key":"f_aumento_potencial_de_prima","value":""},{"key":"f_producto_recomendado","value":""},{"key":"f_capital_recomendado","value":""},{"key":"f_cobertura_recomendada","value":""},{"key":"f_prima_producto_cobertura_recomendada","value":""},{"key":"f_supuestos_1","value":""},{"key":"f_supuestos_2","value":""},{"key":"f_supuestos_3","value":""},{"key":"f_deposito_esporadico_o_convenido_ultimos","value":false},{"key":"f_periodo_1","value":""},{"key":"f_monto_total_deposito_esporadico_1","value":""},{"key":"f_monto_promedio_deposito_esporadico_1","value":""},{"key":"f_periodo_2","value":""},{"key":"f_monto_total_deposito_esporadico_2","value":""},{"key":"f_monto_promedio_deposito_esporadico_2","value":""},{"key":"f_periodo_3","value":""},{"key":"f_monto_total_deposito_esporadico_3","value":""},{"key":"f_monto_promedio_deposito_esporadico_3","value":""},{"key":"f_informacion_adicional_1","value":""},{"key":"f_informacion_adicional_2","value":""},{"key":"f_informacion_adicional_3","value":""},{"key":"f_informacion_adicional_4","value":""},{"key":"f_informacion_adicional_5","value":""},{"key":"f_informacion_adicional_6","value":""},{"key":"f_informacion_adicional_7","value":""},{"key":"f_informacion_adicional_8","value":""}]';


    private static String parameters_update_fields = '[{"key":"f_firstName","value":"PATRICIO"},{"key":"f_middleName","value":null},{"key":"f_lastName","value":"GONZALEZ"},{"key":"f_saludation","value":null},{"key":"f_fechaNacimiento","value":null},{"key":"f_cargo","value":"Ingeniero en Computacion"},{"key":"f_renta","value":null},{"key":"f_status","value":"Abierto"},{"key":"f_subEstado","value":"No Contactado"},{"key":"f_email","value":"juanespinozaleon@ibm.com"},{"key":"f_telefono_1","value":"84436809"},{"key":"f_telefono_2","value":null},{"key":"f_telefono_3","value":null},{"key":"f_telefono_4","value":null},{"key":"f_telefono_5","value":null},{"key":"f_telefono_6","value":null},{"key":"f_telefono_7","value":null},{"key":"f_telefono_8","value":null},{"key":"f_direccion","value":"SUECIA"},{"key":"f_comuna","value":null},{"key":"f_ciudad","value":null},{"key":"f_region","value":null},{"key":"f_reprogramacion","value":null},{"key":"f_aceptaContactoFuturo","value":null},{"key":"f_agenteVenta","value":null},{"key":"f_ejecutivoPostVenta","value":null},{"key":"f_perfilAsignacion","value":"Agente"},{"key":"f_fechaEntrevista","value":null},{"key":"f_tipoLink","value":"Bases Propias"},{"key":"f_horaEntrevista","value":null},{"key":"f_tipoBase","value":"Bases Normales"},{"key":"f_fechaConcertacion","value":null},{"key":"f_nombreBase","value":"kkk"},{"key":"f_origen","value":"Otro"},{"key":"f_observacion","value":null}]';

	private static String Lead_RecordTypeId  = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Prospecto Links').getRecordTypeId();


    @IsTest
    public static void update_custom_fields(){

        system.debug('Lead_RecordTypeId  '+Lead_RecordTypeId);
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.RecordTypeId = Lead_RecordTypeId;
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
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;
        Test.startTest();
        CLS_LEAD_Gestion_ProspectoLinks.update_custom_fields(lead.Id, parameters_update_custom_fields);
        Test.stopTest();
    }

    @IsTest
    public static void update_fields(){

        system.debug('Lead_RecordTypeId  '+Lead_RecordTypeId);
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.RecordTypeId = Lead_RecordTypeId;
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
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;
        Test.startTest();
        CLS_LEAD_Gestion_ProspectoLinks.update_fields(lead.Id, parameters_update_fields);
        Test.stopTest();
    }


    @IsTest
    public static void update_onwer(){

        system.debug('Lead_RecordTypeId  '+Lead_RecordTypeId);
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.RecordTypeId = Lead_RecordTypeId;
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
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;

        Test.startTest();
        CLS_LEAD_Gestion_ProspectoLinks.update_owner(lead.Id, lead.OwnerId);
        Test.stopTest();
    }


    @IsTest
    public static void create_task_call(){

        system.debug('Lead_RecordTypeId  '+Lead_RecordTypeId);
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.RecordTypeId = Lead_RecordTypeId;
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
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;

        Test.startTest();
        CLS_LEAD_Gestion_ProspectoLinks.create_task_call(lead.Id, '947338647');
        Test.stopTest();
    }

    @IsTest
    public static void create_task_Reprogramacion(){

        system.debug('Lead_RecordTypeId  '+Lead_RecordTypeId);
        Account c = Factory.buildAccount('Cuenta personal');
        insert c;
        Poliza__c p = new Poliza__c();
        p.Cuenta__c = c.Id;
        p.Name = '234500';
        insert p;

        Lead lead = new Lead();
        lead.Poliza__c = p.Id;
        lead.RecordTypeId = Lead_RecordTypeId;
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
        lead.Nombre_Base__c = 'Bases Normales';
        lead.Tipo_Base__c = 'Bases Normales';
        lead.Tipo_Link__c = 'Bases Normales';
//  lead.SP_Codigo_WS_Prima_Nuevo_Producto__c = '';
        insert lead;

        Test.startTest();

        CLS_LEAD_Gestion_ProspectoLinks.create_task_Reprogramacion(lead.Id, Datetime.now());
        Test.stopTest();
    }

}