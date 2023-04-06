@isTest
public class ActualizaEnvioEncuestaTest {
	
	static {
		TriggerHandler.enable(ActualizaEnvioEncuestaHandler.class);
			}
	
    static TestMethod void Test() {
        Factory.crearAccountAnonimo();
        Account cuenta = Factory.buildAccount('Cuenta personal');
        insert cuenta;
        Case caso = Factory.buildCasoSF('Consultas', cuenta);
        insert caso;
        caso.Fecha_de_EPA_Contact_Center_Caso__c = Date.Today();
        update caso;
        
        Account[] cuentaUpdate = [select Fecha_de_Envio_de_Encuesta__c, Pendiente_Envio_Encuesta__c from Account where Id =:cuenta.Id];
        
        if (cuentaUpdate.size() > 0) {
            System.assertEquals(cuentaUpdate[0].Fecha_de_Envio_de_Encuesta__c, caso.Fecha_de_EPA_Contact_Center_Caso__c);
            System.assertEquals(cuentaUpdate[0].Pendiente_Envio_Encuesta__c, false);
        }
        else
            System.assert(false, 'No se encontró la cuenta');
    }
}