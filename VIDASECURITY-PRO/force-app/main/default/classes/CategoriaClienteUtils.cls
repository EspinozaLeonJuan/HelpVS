public with sharing class CategoriaClienteUtils {
	
	public static List<String> asignarCategoriaDeCliente(Set<String> cuentas){
		System.debug('Asignando categoria de clientes para: ' + cuentas);
		List<String> errors = new List<String>();

		Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

		if(tipoRegistroIndividual==null) { errors.add('No se encontró el tipo de registro de Individuales'); return errors;
		}

		List<Categoria_de_Cliente__c> categoriasCliente = [Select Id, Name, Prima_Desde__c, Prima_Hasta__c, Valor_Poliza_Desde__c, Valor_Poliza_Hasta__c From Categoria_de_Cliente__c Order by Prima_Desde__c desc];
		if (categoriasCliente.isEmpty())
		errors.add('No se encontraron categorias de cliente');

		Map<String, Decimal> mapPolizasPorCuenta = new Map<String, Decimal>();
		Map<String, Decimal> mapPrimasPorCuenta = new Map<String, Decimal>();

		List<AggregateResult> resultados = [SELECT Cuenta__c, SUM(Valor_Poliza__c) valorPoliza,  SUM(Prima_Total__c) primaTotal FROM Poliza__c WHERE Cuenta__c IN :cuentas and Estatus__c = 'ACTIVA' and RecordTypeId = :tipoRegistroIndividual GROUP BY Cuenta__c];
		System.debug('Se encontraron ' + resultados.size() + ' resultados');

		for(AggregateResult res : resultados ) {
			Decimal totalPoliza = res.get('valorPoliza') != null ? (Decimal)res.get('valorPoliza') : 0.0d;
			Decimal totalPrima = res.get('primaTotal') != null ? (Decimal)res.get('primaTotal') : 0.0d;
			String cuenta = (String)res.get('Cuenta__c');
			mapPrimasPorCuenta.put(cuenta, totalPrima);
			mapPolizasPorCuenta.put(cuenta, totalPoliza);
		}

		Map<Id, Account> mapCuentas = new Map<Id, Account>([Select Id, Categoria_del_Cliente__c From Account Where Id In :cuentas]);
		
		if(mapCuentas.isEmpty()) { errors.add('No existen cuentas con los ids especificados: ' + cuentas); return errors;
		}

		Map<Id, Account> cuentasToUpdate = new Map<Id, Account>();

		for (Account cuenta : mapCuentas.values()) {
			Decimal totalPrimaCuenta = mapPrimasPorCuenta.containsKey(cuenta.Id) ? mapPrimasPorCuenta.get(cuenta.Id) : 0.0d  ;
			Decimal totalPolizaCuenta = mapPolizasPorCuenta.containsKey(cuenta.Id) ? mapPolizasPorCuenta.get(cuenta.Id) :  0.0d ;
	
			for(Categoria_de_Cliente__c categoriaCliente: categoriasCliente){
				System.debug('categoriaCliente: '+ categoriaCliente);
				System.debug('totalPrimaCuenta >= categoriaCliente.Prima_Desde__c: '  + (totalPrimaCuenta >= categoriaCliente.Prima_Desde__c));
				System.debug('totalPolizaCuenta >= categoriaCliente.Valor_Poliza_Desde__c: '  + (totalPolizaCuenta >= categoriaCliente.Valor_Poliza_Desde__c));

				if( totalPrimaCuenta >= categoriaCliente.Prima_Desde__c  || totalPolizaCuenta >= categoriaCliente.Valor_Poliza_Desde__c){
					System.debug('categoriaCliente.Id: '  + categoriaCliente.Id + ' categoriaCliente.Name:'+ categoriaCliente.Name + ' cuenta.Categoria_del_Cliente__c = ' + cuenta.Categoria_del_Cliente__c);
					if ( cuenta.Categoria_del_Cliente__c != categoriaCliente.Id ) { cuenta.Categoria_del_Cliente__c = categoriaCliente.Id; if(!cuentasToUpdate.containsKey(cuenta.Id)) { cuentasToUpdate.put(cuenta.Id, cuenta); } }	break;
				}
			}
		}
		System.debug('Actualizando ' + cuentasToUpdate);
    if(cuentasToUpdate.isEmpty()) {return errors;} Account[] accounts = new List<Account>(cuentasToUpdate.values()); Database.SaveResult[] sresults = Database.update(accounts, false);
    
		for (Integer i=0; i < sresults.size(); i++) { Database.SaveResult sresult = sresults[i]; Account account = accounts[i];
			System.debug('Cuenta dentro del for: ' + account);
			if (sresult.isSuccess()) {System.debug('Actualización exitosa!'); continue; } for (Database.Error error : sresult.GetErrors()) { String message = 'Ocurrió un error al actualizar la categoría de la cuenta Id: ' + account.Id + ', error: ' + error.getMessage(); System.debug(message); errors.add(message); } } return errors;
	}
}