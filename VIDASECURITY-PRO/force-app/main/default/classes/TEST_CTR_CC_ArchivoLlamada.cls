/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 11-03-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   11-03-2020   Juan Espinoza Leon   Initial Version
**/
@IsTest public with sharing class TEST_CTR_CC_ArchivoLlamada {
    public TEST_CTR_CC_ArchivoLlamada() {

    }

    @isTest static void getDatosPersona()
    {
        Test.startTest();
        Account cuenta = Factory.buildAccount('Cuenta Corporativa');
		insert cuenta;
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Contacto Vida';		
		insert caso;
        ApexPages.currentPage().getParameters().put('Id', caso.Id);
        CTR_CC_ArchivoLlamada llamada = new CTR_CC_ArchivoLlamada();
        llamada.Redirect();
        Test.stopTest();
    }
}