/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 07-06-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   07-06-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
@istest
public class TEST_CTR_CM_Predigitador {

    @isTest static void cargaDatosPreDigitador_Test01()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.RUT_Asegurado__c = '15045517-0';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Contrata__c  = 'A';
        cotizador.Tipo_Campagna__c = 'Salud Protegida';
        cotizador.Prima_Nuevo_Producto__c = 0;
		insert cotizador;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'SI');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }

    @isTest static void cargaDatosPreDigitador_Test02()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.RUT_Asegurado__c = '15045517-0';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Contrata__c  = 'C';
        cotizador.Tipo_Campagna__c = 'Salud Protegida';
        cotizador.Prima_Nuevo_Producto__c = 0;
		insert cotizador;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'SI');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }

    @isTest static void cargaDatosPreDigitador_Test03()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Tercero__c = '9869387-4';
        cotizador.RUT_Asegurado__c = '15045517-0';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Contrata__c  = 'T';
        cotizador.Tipo_Campagna__c = 'Salud Protegida';
        cotizador.Prima_Nuevo_Producto__c = 0;
		insert cotizador;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'SI');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }

    @isTest static void cargaDatosPreDigitador_Test04()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Tipo_Campagna__c = 'Televenta - APEG';
		insert cotizador;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'NO');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }

    @isTest static void cargaDatosPreDigitador_Test05()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Tipo_Campagna__c = 'Televenta - Oncológico';
        cotizador.WS_Valor_UF__c = '0.2345';
		insert cotizador;

        Cotizador_Express__c asegurado = new Cotizador_Express__c();
        asegurado.RUT_Contratante__c = '1-9';
        asegurado.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        asegurado.Tipo_Campagna__c = 'Televenta - Oncológico';
        asegurado.ParentId__c = cotizador.Id;
        asegurado.WS_Valor_UF__c = '0.2210';
		insert asegurado;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'NO');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }
  /*   @isTest static void cargaDatosPreDigitador_Test05()
    {
        Test.startTest();
        Cotizador_Express__c cotizador = new Cotizador_Express__c();
        cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.Fecha_Nacimiento__c = Date.newInstance(1986, 4,19);
        cotizador.Tipo_Campagna__c = 'Salud Protegida';
           cotizador.RUT_Contratante__c = '9869387-4';
        cotizador.Contrata__c  = 'T';
        cotizador.Prima_Nuevo_Producto__c = 0;
		insert cotizador;

        ApexPages.currentPage().getParameters().put('CotizacionId', cotizador.Id);
        ApexPages.currentPage().getParameters().put('TOTAL_UF', '0');
        ApexPages.currentPage().getParameters().put('SaludProtegida', 'SI');

        CTR_CM_Predigitador Con = new CTR_CM_Predigitador();

        Con.cargaDatosPreDigitador();

        Test.stopTest();
    }*/
}