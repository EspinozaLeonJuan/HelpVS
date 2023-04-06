public class PolizaAsignaFrecuencia {

    public static void execute( Poliza__c poliza, Id recordTypeIndividuales ) {
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