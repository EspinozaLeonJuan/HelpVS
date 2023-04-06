@isTest
private class ActualizaCategoriaDePolizaTest {
	
	public static Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	
	static {
		TriggerHandler.enable(new Type[] {
			AsignaCategoriaDePolizaHandler.class
		});
	}
	
	@TestSetup
	static void init() {
		//TODO: Esto solo por rapidez, pero se debe mover a un fabricate
		List<Categoria_de_Poliza__c> categorias = new List<Categoria_de_Poliza__c>();
		categorias.add(new Categoria_de_Poliza__c(Name = 'A', Peso__c = 2.25, Prima_Desde__c = 40, Prima_Hasta__c = null, Valor_Poliza_Desde__c = 800, Valor_Poliza_Hasta__c = null));
		categorias.add(new Categoria_de_Poliza__c(Name = 'B', Peso__c = 2.25, Prima_Desde__c = 20, Prima_Hasta__c = 40, Valor_Poliza_Desde__c = 200, Valor_Poliza_Hasta__c = 800));
		categorias.add(new Categoria_de_Poliza__c(Name = 'C', Peso__c = 1.3846, Prima_Desde__c = 4.5, Prima_Hasta__c = 20, Valor_Poliza_Desde__c = 75, Valor_Poliza_Hasta__c = 200));
		categorias.add(new Categoria_de_Poliza__c(Name = 'D', Peso__c = 1, Prima_Desde__c = 0, Prima_Hasta__c = 4.5, Valor_Poliza_Desde__c = 0, Valor_Poliza_Hasta__c = 75));
		insert categorias;
	}

	static testMethod void actualizaCategoriaTest() {
		AccountFabricate cuenta = Fabricate.cuenta().personal();
		PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
		poliza.set('Prima_Total__c', 40);
		poliza.set('Valor_Poliza__c', 800);
		poliza.set('Estatus__c', 'ACTIVA');
		poliza.set('RecordTypeId', tipoRegistroIndividual);
		poliza.save();
		Test.startTest();
		Categoria_de_Poliza__c categoria = [SELECT Id FROM Categoria_de_Poliza__c WHERE Name = 'A'];
		categoria.Prima_Desde__c = 50;
		categoria.Valor_Poliza_Desde__c = 900;
		update categoria;
		ActualizarCategoriaDePolizaController controller = new ActualizarCategoriaDePolizaController(null);
		controller.actualizar();
		Test.stopTest();
		poliza.load(new String[] {'Categoria_de_Poliza__c'});
		System.assertNotEquals(null, poliza.get().get('Categoria_de_Poliza__c'), 'La categoria de poliza no fue recalculada');
		Id categoriaPolizaId = (Id)poliza.get().get('Categoria_de_Poliza__c');
		categoria = [SELECT Id, Name FROM Categoria_de_Poliza__c WHERE Id = :categoriaPolizaId];
		//System.assertEquals('B', categoria.Name, 'La categoria de poliza no es B');
    }

}