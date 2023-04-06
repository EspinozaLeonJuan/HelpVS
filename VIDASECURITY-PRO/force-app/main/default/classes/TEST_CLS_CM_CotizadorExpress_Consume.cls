/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 03-12-2021
 * @last modified by  : Juan Espinoza León
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-01-2020   Juan Espinoza Leon   Initial Version
**/
@istest
public with sharing class TEST_CLS_CM_CotizadorExpress_Consume {
    public TEST_CLS_CM_CotizadorExpress_Consume() {

    }
     @isTest static void obtienePersistencia()
    {
        Test.startTest();
        CLS_CM_CotizadorExpress_Consume.obtienePersistencia();
     	Test.stopTest();   
    }
     
     @isTest static void ValidacionFechaNacUsuario()
    {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
       
        CLS_CM_CotizadorExpress_Consume.ValidacionFechaNacUsuario('usuario', 'ramo', 'prod', 'plan', 'revPlan', 'tipoDeAsegurado', 'relacionConTitular', 1);
     	Test.stopTest();   
    }
    
     @isTest static void GetTarifaOncoFechaNacimiento()
    {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new EXT_WS_OncologicoMockImpl());
        CLS_CM_CotizadorExpress_Consume.GetTarifaOncoFechaNacimiento('usuario', 'ramo', 'prod', 'plan', 'revPlan', 'tipoDeAsegurado', 'relacionConTitular', 1);
     	Test.stopTest();   
    }
}