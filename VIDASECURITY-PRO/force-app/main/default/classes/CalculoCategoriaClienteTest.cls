@isTest
private class CalculoCategoriaClienteTest {
  public static Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

	static {
        TriggerHandler.enable(CalculoCategoriaClienteHandler.class);
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
    

    @isTest static void clienteCategoriaA() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 40);
        poliza.set('Valor_Poliza__c', 800);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('A', cuentaEncontrada.Categoria_del_Cliente__r.Name);
    }

    @isTest static void clienteCategoriaB() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 20);
        poliza.set('Valor_Poliza__c', 1);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('B', cuentaEncontrada.Categoria_del_Cliente__r.Name);
    }

    @isTest static void clienteCategoriaC() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 7);
        poliza.set('Valor_Poliza__c', 0);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('C', cuentaEncontrada.Categoria_del_Cliente__r.Name);
    }

    @isTest static void clienteCategoriaD() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 0);
        poliza.set('Valor_Poliza__c', 1);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('D', cuentaEncontrada.Categoria_del_Cliente__r.Name);
    }

    @isTest static void clienteCategoriaAPorDefault() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 1500);
        poliza.set('Valor_Poliza__c', 1800);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('A', cuentaEncontrada.Categoria_del_Cliente__r.Name);
    }

    @isTest static void clienteCategoriaDAlQuedarenCero() {
        AccountFabricate cuenta = Fabricate.cuenta().personal();
        cuenta.save();

        Id idCuenta = (Id)cuenta.get().get('Id');
	
        PolizaFabricate poliza = Fabricate.poliza().setCuenta(cuenta);
        poliza.set('Prima_Total__c', 1500);
        poliza.set('Valor_Poliza__c', 1800);
        poliza.set('Estatus__c', 'ACTIVA');
        poliza.set('RecordTypeId', tipoRegistroIndividual);

       	Test.startTest();
       		poliza.save();
       		Id idPoliza = (Id)poliza.get().get('Id');
       		Poliza__c polizaEncontrada = [Select Id From Poliza__c Where Id = :idPoliza];
	        System.assertNotEquals(null, polizaEncontrada);
	        delete polizaEncontrada;
       	Test.stopTest();

        Account cuentaEncontrada = [Select Categoria_del_Cliente__r.Name From Account Where Id = :idCuenta];
        System.assertNotEquals(null, cuentaEncontrada);
        System.assertEquals('D', cuentaEncontrada.Categoria_del_Cliente__r.Name);

    }

}