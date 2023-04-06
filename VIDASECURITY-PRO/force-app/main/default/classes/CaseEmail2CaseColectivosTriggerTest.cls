@isTest
public class CaseEmail2CaseColectivosTriggerTest {
	static testMethod void TestContactoNuevo() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Servicios Colectivos';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }
    
	static testMethod void TestContactoNuevoBCI() {
		Account cuentaAnonimo = Factory.crearAccountAnonimo();
		Account cuenta = Factory.buildAccount('Cuenta personal');
		cuenta.PersonEmail = 'mailcaso@test.cl';
		insert cuenta;

		Test.startTest();
		Case caso = Factory.buildCasoSF('Consultas', cuenta);
		caso.Origin = 'Servicios BCI';
		caso.SuppliedEmail = 'mailcaso@test.cl';
		caso.SuppliedName = 'NombreCaso';
		caso.AccountId = null;
		caso.RUT_Solicitante__c = null; // No debe ir el rut del solicitante.
		insert caso;
		Test.stopTest();
    }    
}