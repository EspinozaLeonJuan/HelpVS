public class TransferirCuentaController {
	
	private static final Integer ACCOUNT_LIMIT = 50;
	private static final RecordTypeInfo INDIVIDUALES = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales');
	
	public String rut {get; set;}
	public Id transferirA {get; set;}
	public user ejecutivoA {get; set;}
	public List<Account> accounts {get; set;}
	public Account account {get; set;}
	public Boolean resultado {get; set;}
	private Id individualesId {get; set;}
	private Map<Id, User> userMap;
	
	public TransferirCuentaController() {
		System.assertNotEquals(null, INDIVIDUALES, 'El tipo de registro Individuales no existe en póliza');
		this.individualesId = INDIVIDUALES.getRecordTypeId();
		this.resultado = false;
		this.userMap = new Map<Id, User>([SELECT Id, Name FROM User WHERE IsActive = true AND Ejecutivo_de_Cliente__c = true]);
	}
	
	public System.PageReference buscar() {
		if (String.isBlank(rut))
			return addError('El rut de la cuenta es obligatorio.');
		if (transferirA == null)
			return addError('El ejecutivo de destino es obligatorio');
			
		this.ejecutivoA = userMap.get(transferirA);
		System.assertNotEquals(null, this.ejecutivoA, 'El ejecutivo seleccionado no existe, no está marcado como ejecutivo de cliente o está desactivado');
		String rutX = rut + '%';
		this.accounts = [SELECT Id, Owner.IsActive, Cliente_Fidelizado__c, Owner.Ejecutivo_de_Cliente__c, Name, CreatedDate, Owner.Name, OwnerId, Rut_con_dv__c FROM Account WHERE Rut_con_dv__c LIKE :rutX];
		if (this.accounts.size() == 0)
			return addError('La cuenta con rut ' + rut + ' no se encuentra registrada en el sistema.');
			if (this.accounts.size() > ACCOUNT_LIMIT)
			return addError('Su búsqueda a retornado más de ' + ACCOUNT_LIMIT + ' cuentas. Por favor ingrese el rut completo para limitar los valores buscados.');
		if (this.accounts.size() == 1)
			this.account = accounts[0];
		if (this.account != null && this.account.Owner.IsActive && this.account.Cliente_Fidelizado__c && this.account.Owner.Ejecutivo_de_Cliente__c) {
			this.account = null;
			this.accounts = null;
			return addError('No es posible transferir esta cuenta pues el cliente se encuentra fidelizado con el ejecutivo actualmente asignado.');
		}
		if (this.account != null && this.account.OwnerId == transferirA) {
			this.account = null;
			this.accounts = null;
			return addError('El ejecutivo ' + ejecutivoA.Name + ' ya se encuentra asignado a esta cuenta.');
		}
						return null;
	}
	
	public System.PageReference seleccionar() {
		String accountId = System.currentPageReference().getParameters().get('accountId');
		System.assertNotEquals(null, accountId, 'El id de la cuenta no corresponde');
		this.account = [SELECT Id, Owner.IsActive, Cliente_Fidelizado__c, Owner.Ejecutivo_de_Cliente__c, OwnerId, Name, Owner.name FROM Account WHERE Id = :accountId];
		this.accounts = new List<Account> {account};
		return null;
	}
			
	public System.PageReference transferir() {
		this.resultado = true;
		if (this.account == null)
			return addError('No se ha seleccionado una cuenta para transferir');
			if (this.account.Cliente_Fidelizado__c && this.account.Owner.IsActive && this.account.Owner.Ejecutivo_de_Cliente__c)
			return addError('No es posible transferir esta cuenta pues el cliente se encuentra fidelizado con el ejecutivo ' + account.Owner.Name);
				if (this.transferirA == null)
			return addError('No se ha seleccionado un usuario para asignar.');
		Integer polizas = [SELECT COUNT() FROM Poliza__c WHERE Cuenta__c = :account.Id AND RecordType.Name = 'Individuales'];
		if (polizas == 0)
			return addError('La cuenta ' + this.account.Name + ' no posee pólizas de individuales');
		Integer activas = [SELECT COUNT() FROM Poliza__c WHERE Cuenta__c = :account.Id AND RecordType.Name = 'Individuales' AND Estatus__c = 'ACTIVA'];
		if (activas == 0)
		return addError('La cuenta ' + this.account.Name + ' posee ' + polizas + ' pólizas de individuales, pero ninguna de ellas está activa.');
			
		//this.resultado = true;
		String accountName = this.account.Name;
	try {
		this.account = [SELECT Id FROM Account WHERE Id = :this.account.Id FOR UPDATE];
			this.account.OwnerId = transferirA;
			update account;
		} catch (System.Dmlexception dml) {
			for (Integer i=0; i < dml.getNumDml(); i++) {
				String campos = dml.getDMLFieldNames(i).isEmpty() ? '' : (': ' + dml.getDMLFieldNames(i));
				addError('Error al asignar la cuenta ' + accountName + ' al ejecutivo ' + this.ejecutivoA.Name + ', el error encontrado es: ' + dml.getDMLMessage(i) + campos);
			}
			return null;
		} catch (Exception e) {
			return addError('Error al asignar la cuenta ' + accountName + ' al ejecutivo ' + this.ejecutivoA.Name + ', el error encontrado es: ' + e.getMessage());
		}
		return addInfo('Cuenta ' + accountName + ' transferida satisfactoriamente al ejecutivo ' + this.ejecutivoA.Name);
	}
	
	public System.PageReference cancelar() {
		this.accounts = null;
		this.account = null;
		this.resultado = false;
		return null;
	}
	
	public System.PageReference volverAForm() {
		this.accounts = null;
		this.account = null;
		this.rut = null;
		this.resultado = false;
		return null;
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