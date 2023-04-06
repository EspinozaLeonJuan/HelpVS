/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 08-11-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   08-11-2020   Juan Espinoza Leon   Initial Version
**/
@isTest
private class CalcularFactorDeEjecutivoTest {

	
	static {
		TriggerHandler.enable(new Type[] {
			CalculoCategoriaClienteHandler.class,
			CalcularFactorDeEjecutivoHandler.class,
			CalcularFactorDeEjecutivoEnCuentaHandler.class
		});
	}
	
	@TestSetup
	static void init() {
		//TODO: Esto solo por rapidez, pero se debe mover a un fabricate
		List<Categoria_de_Cliente__c> categorias = new List<Categoria_de_Cliente__c>();
		categorias.add(new Categoria_de_Cliente__c(Name = 'A', Peso__c = 2.25, Prima_Desde__c = 40, Prima_Hasta__c = null, Valor_Poliza_Desde__c = 800, Valor_Poliza_Hasta__c = null));
		categorias.add(new Categoria_de_Cliente__c(Name = 'B', Peso__c = 2.25, Prima_Desde__c = 20, Prima_Hasta__c = 40, Valor_Poliza_Desde__c = 200, Valor_Poliza_Hasta__c = 800));
		categorias.add(new Categoria_de_Cliente__c(Name = 'C', Peso__c = 1.3846, Prima_Desde__c = 4.5, Prima_Hasta__c = 20, Valor_Poliza_Desde__c = 75, Valor_Poliza_Hasta__c = 200));
		categorias.add(new Categoria_de_Cliente__c(Name = 'D', Peso__c = 1, Prima_Desde__c = 0, Prima_Hasta__c = 4.5, Valor_Poliza_Desde__c = 0, Valor_Poliza_Hasta__c = 75));
		insert categorias;
		
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('OwnerId', ejecutivo).set('PersonEmail', 'factor@security.cl').set('Categoria_del_Cliente__c', categorias[3].Id).save();
	}

	static testMethod void calcularFactorDeEjecutivoTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'}, 'PersonEmail', 'factor@security.cl');
		Test.startTest();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		Test.stopTest();
		account.load(new String[] {'Categoria_del_Cliente__c'});
		System.assertNotEquals(null, account.get('Categoria_del_Cliente__c'), 'La categoria del cliente no fue calculada');
		Id ejecutivoId = (Id)account.get().get('OwnerId');
				User ejecutivo = [SELECT Ejecutivo_de_Cliente__c, Factor_de_Ejecutivo__c FROM User WHERE Id = :ejecutivoId];
				System.assertEquals(true, ejecutivo.Ejecutivo_de_Cliente__c, 'El ejecutivo asignado no es de cliente');
		System.assertNotEquals(null, ejecutivo.Factor_de_Ejecutivo__c, 'El factor de ejecutivo no fue calculado');
            }
           
	static testMethod void noDebeCalcularFactorTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'}, 'PersonEmail', 'factor@security.cl');
		Test.startTest();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().setCuenta(account).set('Estatus__c', 'Incompleta').save();
		Test.stopTest();
		Id ejecutivoId = (Id)account.get().get('OwnerId');
				User ejecutivo = [SELECT Factor_de_Ejecutivo__c FROM User WHERE Id = :ejecutivoId];
		System.assertEquals(1800, ejecutivo.Factor_de_Ejecutivo__c, 'El factor de ejecutivo fue calculado');
            }
            
	static testMethod void borrarCalculoFactorDeEjecutivoTest() {
		// En teoría al borrar o desactivar una póliza el factor debería anularse, pero como ahora el cuociente es a la inversa el ejecutivo debe tener el máximo factor que es 1800, pues está desocupado.
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'}, 'PersonEmail', 'factor@security.cl');
		Id ejecutivoId = (Id)account.get().get('OwnerId');
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().setCuenta(account).set('Estatus__c', 'Activa').save();
		Test.startTest();
		poliza.set('Estatus__c', 'Anulada').save();
		Test.stopTest();
				User ejecutivo = [SELECT Factor_de_Ejecutivo__c FROM User WHERE Id = :ejecutivoId];
		System.assertEquals(1800, ejecutivo.Factor_de_Ejecutivo__c, 'El factor de ejecutivo no fue calculado');
            }
            
	static testMethod void eliminarCuentaTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load('PersonEmail', 'factor@security.cl');
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		Id accountId = account.getId();
		Account a = [SELECT Id FROM Account WHERE Id = :accountId];
		Test.startTest();
		delete a;
		Test.stopTest();
	}
	
	static testMethod void calcularFactorDeEjecutivoEnCuentaTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'}, 'PersonEmail', 'factor@security.cl');
		Id ownerId = (Id)account.get('OwnerId');
		User ejecutivo = [SELECT Id, Ejecutivo_de_Cliente__c FROM User WHERE Id = :ownerId];
		System.assert(ejecutivo.Ejecutivo_de_Cliente__c, 'No es ejecutivo de cliente');
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		Test.startTest();
		account.set('OwnerId', UserInfo.getUserId()).save();
		Test.stopTest();
	}
	
	static testMethod void dummyResultTest() {
		CalcularFactorDeEjecutivoUtils.Result result = new CalcularFactorDeEjecutivoUtils.Result();
		result.addError(null, 'Message');
		result.getMessages();
	}

	 static testMethod void calular_usuarios()
	 {
		 Test.startTest();
		 User user1 = Factory.buildUser();
		 insert user1;
		 User user2 = Factory.buildUser();
		 insert user2;
		 User user3 = Factory.buildUser();
		 insert user3;
		 List<User> users = new List<User>();
		 users.add(user1);
		 users.add(user2);
		 users.add(user3);
		 CalcularFactorDeEjecutivoUtils.calcular(users);
		 Test.stopTest();
	 }
}