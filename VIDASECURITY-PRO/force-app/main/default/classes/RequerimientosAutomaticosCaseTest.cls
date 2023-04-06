/*******************************************************************************************
 *  NOMBRE                 : RequerimientosAutomaticosCaseTest
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS COBRANZA - PRODUCCIÓN INDIVIDUALES TEST
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 10/12/2018 - I. SALAZAR       - Creación Clase
 * *****************************************************************************************/
@isTest
public class RequerimientosAutomaticosCaseTest {
    
	static {
		TriggerHandler.enable(RequerimientosAutomaticosCaseHandler.class);
	}
    
	static testMethod void TestCasoNuevoIndividuales() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Atención', cuenta);
		caso.Origin = 'Producción Individuales';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }
    
	static testMethod void TestCasoNuevoCobranza() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Atención', cuenta);
		caso.Origin = 'Cobranzas Vida';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }
    
	static testMethod void TestCasoNuevoRecepcion() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Atención', cuenta);
		caso.Origin = 'Recepción Pagos';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }    
}