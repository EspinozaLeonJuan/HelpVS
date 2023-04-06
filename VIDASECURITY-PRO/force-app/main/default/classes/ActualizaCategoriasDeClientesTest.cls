@isTest
private class ActualizaCategoriasDeClientesTest {
	
	public static Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
	
	static {
		TriggerHandler.enable(new Type[] {
			CalculoCategoriaClienteHandler.class
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
	}

	static testMethod void actualizaCategoriaTest() {
		UserFabricate ejecutivo = (UserFabricate)Fabricate.usuario().ejecutivoDeCliente().save();
		AccountFabricate cuenta = Fabricate.cuenta().personal().setPropietario(ejecutivo);
		PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
		poliza.set('Prima_Total__c', 40);
		poliza.set('Valor_Poliza__c', 800);
		poliza.set('Estatus__c', 'ACTIVA');
		poliza.set('RecordTypeId', tipoRegistroIndividual);
		poliza.save();
		Test.startTest();
		Categoria_de_Cliente__c categoria = [SELECT Id FROM Categoria_de_Cliente__c WHERE Name = 'A'];
		categoria.Prima_Desde__c = 50;
		categoria.Valor_Poliza_Desde__c = 900;
		update categoria;
		categoria = [SELECT Id FROM Categoria_de_Cliente__c WHERE Name = 'B'];
		ActualizarCategoriaDeClientesController controller = new ActualizarCategoriaDeClientesController(null);
		controller.actualizar();
		Test.stopTest();
		cuenta.load(new String[] {'Categoria_del_Cliente__c'});
		System.assertEquals(categoria.Id, cuenta.get().get('Categoria_del_Cliente__c'), 'La categoria de cliente no fue recalculada');
    }
    
    static testMethod void sendEmailsTest() {
    	ActualizaCategoriasDeClientesBatch b = new ActualizaCategoriasDeClientesBatch(null);
    	b.errors.add('foo');
    	b.sendEmails();

    }
}