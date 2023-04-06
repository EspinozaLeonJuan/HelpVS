public class CalculoCategoriaClienteHandler implements TriggerHandler.HandlerInterface {

	public void handle() {
		Set<String> setCuentas = new Set<String>();

		Id tipoRegistroIndividual = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();

		if(tipoRegistroIndividual==null) return;

		List<Poliza__c> polizas = Trigger.isDelete ? (Poliza__c[])Trigger.old : (Poliza__c[])Trigger.new;

		for (Poliza__c poliza : polizas) {
			Poliza__c oldPoliza  = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);
			if (poliza.RecordTypeId == tipoRegistroIndividual && poliza.Estatus__c == 'ACTIVA' && poliza.Prima_Total__c != null && poliza.Valor_Poliza__c != null && (oldPoliza == null || oldPoliza.Estatus__c != poliza.Estatus__c || oldPoliza.RecordTypeId != poliza.RecordTypeId || oldPoliza.Prima_Total__c != poliza.Prima_Total__c || oldPoliza.Valor_Poliza__c != poliza.Valor_Poliza__c))
				setCuentas.add(poliza.Cuenta__c);
		}
		System.debug('Número de cuentas a procesar: ' + setCuentas.size());
List<String> errors = null;
		if (!setCuentas.isEmpty())
			errors = CategoriaClienteUtils.asignarCategoriaDeCliente(setCuentas);
			if (errors != null)
				System.assertEquals(0, errors.size(), String.valueOf(errors));
	}


}