/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 05-18-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   07-14-2021   Juan Espinoza León   Initial Version
**/
@istest
public with sharing class TEST_CTR_AC_Gestion_Alertas {
    public TEST_CTR_AC_Gestion_Alertas() {

    }

    @isTest static void Cierre_PC_Televentas_Vigentes()
    {
        Test.startTest();

        Account cuenta = new Account();
        cuenta.name = 'XXX';
        cuenta.RUT__c = '15045517';
        cuenta.DV__C = '0';
        cuenta.Postergacion_de_Credito__c = false;
        cuenta.Pago_Presencial_RRVV__c = true;
        //cuenta.Cantidad_Polizas_RV_Activas__c = 3;
        //cuenta.Edad_cliente__c = 69;
        Insert cuenta;

        Case case_at = Factory.buildCasoSF('Atención', cuenta);
        insert case_at;

        Case case_re = Factory.buildCasoSF('Reclamos', cuenta);
        insert case_re;

		ApexPages.StandardController standard = new ApexPages.StandardController(cuenta);
		CTR_AC_Gestion_Alertas controller = new CTR_AC_Gestion_Alertas(standard);
        Test.stopTest();
    }
}