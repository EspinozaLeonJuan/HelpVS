@IsTest
private class AsignaCategoriaDePolizaTest {
	
	static {
		TriggerHandler.enable(new Type[] {
			AsignaCategoriaDePolizaHandler.class
		});
	}
	
	@TestSetup
	static void init() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().personal().set('Categoria_de_Cliente__c', 'D').set('OwnerId', ejecutivo).save();
		//TODO: Esto solo por rapidez, pero se debe mover a un fabricate
		List<Categoria_de_Poliza__c> categorias = new List<Categoria_de_Poliza__c>();
		categorias.add(new Categoria_de_Poliza__c(Name = 'A', Peso__c = 2.25, Prima_Desde__c = 40, Prima_Hasta__c = null, Valor_Poliza_Desde__c = 800, Valor_Poliza_Hasta__c = null));
		categorias.add(new Categoria_de_Poliza__c(Name = 'B', Peso__c = 2.25, Prima_Desde__c = 20, Prima_Hasta__c = 40, Valor_Poliza_Desde__c = 200, Valor_Poliza_Hasta__c = 800));
		categorias.add(new Categoria_de_Poliza__c(Name = 'C', Peso__c = 1.3846, Prima_Desde__c = 4.5, Prima_Hasta__c = 20, Valor_Poliza_Desde__c = 75, Valor_Poliza_Hasta__c = 200));
		categorias.add(new Categoria_de_Poliza__c(Name = 'D', Peso__c = 1, Prima_Desde__c = 0, Prima_Hasta__c = 4.5, Valor_Poliza_Desde__c = 0, Valor_Poliza_Hasta__c = 75));
		insert categorias;
	}

	static testMethod void asignaCategoriaDePolizaTest() {
		AccountFabricate account = (AccountFabricate)Fabricate.cuenta().load(new String[] {'OwnerId'});
		Test.startTest();
		PolizaFabricate poliza = (PolizaFabricate)Fabricate.poliza().individual().setCuenta(account).set('Estatus__c', 'Activa').save();
		Test.stopTest();
		poliza.load(new String[] {'Categoria_de_Poliza__c'});
								System.assertNotEquals(null, poliza.get().get('Categoria_de_Poliza__c'), 'La categoria de poliza no fue asignada');
            }

}