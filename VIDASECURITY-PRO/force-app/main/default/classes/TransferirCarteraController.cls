public class TransferirCarteraController {
	

	private static final RecordTypeInfo INDIVIDUALES = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales');
	private static final Integer ERROR_LIMIT = 5;
	
	public Id transferirDe {get; set;}
	public Id transferirA {get; set;}
	public Integer cantidad {get; set;}
	public User ejecutivoDe {get; set;}
	public user ejecutivoA {get; set;}
	public Boolean resultado {get; set;}
	private Id individualesId {get; set;}
	
	public TransferirCarteraController() {
		this.cantidad = null;
		this.resultado = false;


		System.assertNotEquals(null, INDIVIDUALES, 'El tipo de registro Individuales no existe en póliza');
		this.individualesId = INDIVIDUALES.getRecordTypeId();
	}
	
	public System.Pagereference obtenerCantidad() {
		if (transferirDe == null)
			return addError('Debe seleccionar un ejecutivo de origen para la transferencia de cartera en "Transferir De"');
		if (transferirA == null)
			return addError('Debe seleccionar un ejecutivo de destino para la transferencia de cartera en "Transferir A"');
		if (transferirA == transferirDe)
			return addError('Debe seleccionar un ejecutivo de origen y de destino de la transferencia diferentes.');
			
		Map<Id, User> userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE Ejecutivo_de_Cliente__c = true and Id IN (:transferirDe, :transferirA)]);
		this.ejecutivoDe = userMap.get(transferirDe);
		this.ejecutivoA = userMap.get(transferirA);
		this.cantidad = [SELECT COUNT() FROM Account WHERE Cliente_Fidelizado__c = false AND OwnerId = :transferirDe AND Id IN (SELECT Cuenta__c FROM Poliza__c WHERE Cuenta__r.OwnerId = :transferirDe AND RecordTypeId = :individualesId AND Estatus__c = 'ACTIVA') LIMIT 50000];
		if (this.cantidad == 50000)
			addWarn('La cantidad de cuentas que tiene el ejecutivo de origen puede que requiera realizar una nueva transferencia. Además, el proceso podría tardar bastante tiempo en ejecutarse.');
		return null;
	}
	
	public System.PageReference Transferir() {
		Integer successes = 0;
		Integer failures = 0;
		// Debemos meter los errores en un mapa para poder después ir a buscar las cuentas con Name debido a que no podemos seleccionar previamente por error de actualización de cuenta personal.
		Map<Id, String> errorMap = new Map<Id, String>();
		//Vamos a intentar hacer un forloop para superar limites
		for (Account[] accounts : [SELECT Id FROM Account WHERE Cliente_Fidelizado__c = false AND OwnerId = :transferirDe AND Id IN (SELECT Cuenta__c FROM Poliza__c WHERE Cuenta__r.OwnerId = :transferirDe AND RecordTypeId = :individualesId AND Estatus__c = 'ACTIVA') LIMIT 50000]) {
			for (Account account : accounts) {
				account.OwnerId = transferirA;
			}
			Database.SaveResult[] sresults = Database.update(accounts, false);
			for (Integer i=0; i < accounts.size(); i++) {
				Database.SaveResult sresult = sresults[i];
				if (sresult.isSuccess()) {
					successes++;
					continue;
				}
				failures++;
				Account account = accounts[i];
				for (Database.Error error : sresult.getErrors()) {
					if (ApexPages.getMessages().size() < ERROR_LIMIT)
					errorMap.put(account.Id, error.getMessage());
										}
			}
		}
		
		Account[] accounts = [SELECT Id, Name FROM Account WHERE Id IN :errorMap.keySet()];
		for (Account account : accounts) {
			String error = errorMap.get(account.Id);
			addError('Ocurrió un error al transferir la cuenta de ' + account.Name + ' al ejecutivo ' + ejecutivoA.Name + ', el error es ' + error);
		}
		this.cantidad = null;
		this.resultado = true;
		if (ApexPages.hasMessages()) {
			String warning = 'Han ocurrido ' + failures + ' errores al intentar realizar la transferencia';
			if (failures > ERROR_LIMIT)
				warning += '. Pero solo mostramos el detalle de ' + ApexPages.getMessages().size();
			warning += '. Por favor solucione estos errores de validación y vuelva a realizar la transferencia.';
			if (successes > 0) 
				warning += ' Por ahora solo hemos podido transferir ' + successes + ' cuentas exitosamente.';
				else
				warning += ' Ningún registro se ha transferido.';
			return addWarn(warning);
		}
		return addInfo('Se a transferido la cartera de ' + ejecutivoDe.Name + ' a ' + ejecutivoA.Name + ' exitosamente. Total de clientes transferidos: ' + successes);
	}
	
	public System.PageReference cancelar() {
		this.cantidad = null;
		return null;
	}
	
	public System.PageReference volverAForm() {
		this.cantidad = null;
		this.resultado = false;
		return null;
	}
	
	public SelectOption[] getTransferirDeOptions() {
		Account[] accounts = [SELECT OwnerId FROM Account WHERE Owner.Ejecutivo_de_Cliente__c = true and Id IN (SELECT Cuenta__c FROM Poliza__c WHERE Estatus__c = 'ACTIVA' AND RecordType.Name = 'Individuales') LIMIT 50000];
		Set<Id> ownerIds = new Set<Id>();
		for (Account account : accounts) {
			if (!ownerIds.contains(account.OwnerId))
			ownerIds.add(account.OwnerId);
		}
		return getOptions([SELECT Id, Name FROM User WHERE Id IN :ownerIds ORDER BY Name], User.Name, User.Id, null);
	}
	
	public SelectOption[] getTransferirAOptions() {
		return getOptions([SELECT Id, Name FROM User WHERE Omitir_asignacion_AMAC__c = false AND IsActive = true AND Ejecutivo_de_Cliente__c = true ORDER BY Name], User.Name, User.Id, null);
	}

	public SelectOption[] getOptions(Sobject[] sobjects, Schema.SObjectField labelField, Schema.SObjectField valueField, String allText) {
		return getOptions(sobjects, labelField.getDescribe().getName(), valueField.getDescribe().getName(), allText);
	}

	public SelectOption[] getOptions(Sobject[] sobjects, String labelField, String valueField, String allText) {
		List<SelectOption> options = new List<SelectOption>();
		if (allText != null)
			options.add(new SelectOption('', allText));
		if (sobjects == null)
			return options;
		List<String> values = new List<String>();
		for (Sobject sobj : sobjects) {
			String label = String.valueOf(sobj.get(labelField));
			String value = String.valueOf(sobj.get(valueField));
			if (value != null && !values.contains(value)) {
				options.add(new SelectOption(value, label));
				values.add(value);
			}
		}
		return options;
	}
	
	private System.PageReference addMessage(ApexPages.Severity severity, String message) {
		ApexPages.addMessage(new ApexPages.Message(severity, message));
		return null;
	}
	
	@TestVisible
	private System.PageReference addError(String message) {
		return addMessage(ApexPages.Severity.ERROR, message);
	}
	
	@TestVisible
	private System.PageReference addInfo(String message) {
		return addMessage(ApexPages.Severity.INFO, message);
	}
	
		@TestVisible
	private System.PageReference addWarn(String message) {
		return addMessage(ApexPages.Severity.WARNING, message);
	}
}