public class ActualizaFrecuenciaPagoDePolizaHandler implements TriggerHandler.HandlerInterface {
	
    public void handle() {
        Id recordTypeIndividuales = Schema.SObjectType.Poliza__c.getRecordTypeInfosByName().get('Individuales').getRecordTypeId();
		for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
            if(poliza.RecordTypeId == recordTypeIndividuales){
                if(poliza.Frecuencia_de_Pago__c == 'Mensual'){
                    poliza.Frecuencia_de_Pago__c = 'M';
                }
                else if(poliza.Frecuencia_de_Pago__c == 'Trimestral'){
                    poliza.Frecuencia_de_Pago__c = 'T';
                }
                else if(poliza.Frecuencia_de_Pago__c == 'Semestral'){
                    poliza.Frecuencia_de_Pago__c = 'S';
                }
                else if(poliza.Frecuencia_de_Pago__c == 'Anual'){
                    poliza.Frecuencia_de_Pago__c = 'A';
                }
                else if(poliza.Frecuencia_de_Pago__c == 'Única'){
                    poliza.Frecuencia_de_Pago__c = 'U';
                }
            }
		}
	}
}