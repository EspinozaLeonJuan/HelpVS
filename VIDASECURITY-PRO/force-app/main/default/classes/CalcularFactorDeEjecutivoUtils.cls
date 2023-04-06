/**
 * @description       : 
 * @author            : Juan Espinoza Leon
 * @group             : 
 * @last modified on  : 08-13-2020
 * @last modified by  : Juan Espinoza Leon
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   08-10-2020   Juan Espinoza Leon   Initial Version
**/
public with sharing class CalcularFactorDeEjecutivoUtils {
	
	public class Error {
		public Id id;
		public String message;
	}
	
	public class Result {
		public Integer successes;
		public List<Error> errors;
		
		public Result() {
			this.successes = 0;
			this.errors = new List<Error>();
		}
		
		public void addError(Id id, String message) {
			Error error = new Error();
			error.id = id;
			error.message = message;
			this.errors.add(error);
		}

		public List<String> getMessages() {
			List<String> messages = new List<String>();
			for (Error error : this.errors) {
				messages.add(error.message);
			}
			return messages;
		}
	}
	
	private static Map<Id, Categoria_de_Cliente__c> categoriaMap;
	
	static {
		categoriaMap = new Map<Id, Categoria_de_Cliente__c>([SELECT Id, Name, Peso__c FROM Categoria_de_Cliente__c]);
	}
	
	public static Result calcular(User[] users) {
		List<Id> ids = new List<Id>();
		for (User ejecutivo : users) {
			ids.add(ejecutivo.Id);
		}
		return calcular(ids);
	}
	
	
	public static Result calcular(Id[] ids) {
		Result r = new Result();
		system.debug('@@@@ l_60 ids.size ('+ids.size()+') --> '+ ids);
		User[] ejecutivos = [SELECT Id FROM User WHERE Ejecutivo_de_Cliente__c = true AND IsActive = true AND ID IN :ids];		
		system.debug('@@@@ l_62 ejecutivos.size ('+ejecutivos.size()+') --> '+ ejecutivos);
		Set<Id> ejecutivoClienteIds = new Set<Id>();
		for (User ejecutivo : ejecutivos) {
			ejecutivoClienteIds.add(ejecutivo.Id);
		}
		if (ejecutivoClienteIds.isEmpty())
		return r;

		system.debug('@@@@ l_70 ejecutivoClienteIds.size ('+ejecutivoClienteIds.size()+') --> '+  ejecutivoClienteIds);

		RecordTypeInfo INDIVIDUAL = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales');
		Id individualId = INDIVIDUAL == null ? null : INDIVIDUAL.getRecordTypeId();

		System.assertNotEquals(null, individualId, 'No se encontró el id del tipo de registro de Individuales');
		Set<Id> accountIds = new Set<Id>();
		for (Account[] accounts : [SELECT Id, Owner.Ejecutivo_de_Cliente__c, Cantidad_Polizas_Activas__c, Categoria_del_Cliente__c FROM Account WHERE OwnerId IN :ejecutivoClienteIds AND Cantidad_Polizas_Activas__c > 0 AND Categoria_del_Cliente__c != null]) {
			system.debug('@@@@ l_78 accounts.size('+accounts.size()+') --> '+ accounts);	
			for (Account account : accounts) {
				system.debug('@@@@ l_80 account --> '+ account);
				if (account.Owner.Ejecutivo_de_Cliente__c == true &&  !accountIds.contains(account.Id))
				{
					accountIds.add(account.Id);
					system.debug('@@@@ l_84 accountIds.size('+accountIds.size()+') --> '+ account.Id);
				}				
			}
		}

		system.debug('@@@@ l_89 total accountIds.size('+accountIds.size()+') --> '+ account.Id);
		//if (Test.isRunningTest())
			//System.assertNotEquals(0, accountIds.size(), 'No hay cuentas para calcular');
		System.debug('Calculando cantidad de pólizas con '+ accountIds.size() + ' cuentas');		
		AggregateResult[] results = [SELECT COUNT(Id) Cantidad, Cuenta__r.OwnerId, Cuenta__r.Categoria_del_Cliente__c FROM Poliza__c WHERE Cuenta__c IN :accountIds AND Estatus__c = 'ACTIVA' AND RecordType.Name = 'Individuales' GROUP BY Cuenta__r.OwnerId, Cuenta__r.Categoria_del_Cliente__c];
		system.debug('@@@@ l_94 results.size() --> '+ results.size()+' --> '+ results);		
		//AggregateResult[] results = [SELECT COUNT(Id) Cantidad, Cuenta__r.OwnerId, Cuenta__r.Categoria_del_Cliente__c FROM Poliza__c WHERE Cuenta__r.OwnerId IN :ids AND Estatus__c = 'ACTIVA' AND RecordTypeId = :individualId AND Cuenta__r.Categoria_del_Cliente__c <> NULL GROUP BY Cuenta__r.OwnerId, Cuenta__r.Categoria_del_Cliente__c];
		Map<Id, Decimal> sumaMap = new Map<Id, Decimal>();
		for (Id ejecutivoId : ejecutivoClienteIds) {
			sumaMap.put(ejecutivoId, 0);
		}
		
		for (AggregateResult result : results) {
			Decimal cantidad = (Decimal)result.get('Cantidad');
			Id ejecutivoActualId = (Id)result.get('OwnerId');
			Id categoriaId = (Id)result.get('Categoria_del_Cliente__c');
			Decimal suma = sumaMap.get(ejecutivoActualId);
			if (!sumaMap.containsKey(ejecutivoActualId))
				suma = 0;
										Categoria_de_Cliente__c categoriaCliente = categoriaMap.get(categoriaId);
										if (categoriaCliente == null) {
											r.addError(ejecutivoActualId, 'La categoria ' + categoriaId + ' no se encuentra definida en la metadata. Favor inclúyala dentro de la metadata de Categoria de Cliente');
											continue;
										}
										Decimal peso = categoriaCliente.Peso__c;
			if (peso != null && cantidad != null)
				suma += (peso*cantidad);
			sumaMap.put(ejecutivoActualId, suma);
		}

		for (User ejecutivo : ejecutivos) {
			Decimal suma = sumaMap.get(ejecutivo.Id);
			if (suma != null)
			ejecutivo.Factor_de_Ejecutivo__c = suma < 1 ? 1800 : (1800/suma);
			system.debug('@@@@ l_123 ejecutivo --> '+ ejecutivo);
		}

		Database.SaveResult[] sresults = Database.update(ejecutivos, false);

		system.debug('@@@@ l_128 total ejecutivos.size('+ejecutivos.size()+') --> '+ ejecutivos);

		for (Integer i=0; i < sresults.size(); i++) {
			Database.SaveResult sresult = sresults[i];
			User ejecutivo = ejecutivos[i];
			if (sresult.isSuccess()) {
				r.successes++;
				continue;
			}
			for (Database.Error error : sresult.getErrors()) {
				r.addError(ejecutivo.Id, 'Error al calcular el factor para ' + ejecutivo.Name + ':' + error.getMessage());
			}
		}
		return r;
	}
	
	@Future
	public static void calcularFuturo(Id[] ids) {
		Result r = calcular(ids);
		sendReport(r);
			}
			
	public static void sendReport(Result r) {
		if (r.errors == null || (!Test.isRunningTest() && r.errors.isEmpty()))
			return;
			String body = 'Se han calculado ' + r.successes + ' exitosamente, pero han ocurrido los siguientes errores:\n';
		for (CalcularFactorDeEjecutivoUtils.Error error : r.errors) {
			body += '[ERROR]: ' + error.message + ', ID: ' + error.id + '\n';
					}
					
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setSubject('[Vida Security] Reporte de Resultados de factores de ejecutivos');
        message.setToAddresses(new String[] {'contacto@gocode.cl'});
        message.setPlainTextBody(body);
        message.setSaveAsActivity(false);
        if (!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.Email[] {message});
            else 
            System.assert(r.errors.isEmpty(), body);
			}
			
	    }