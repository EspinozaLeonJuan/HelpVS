public with sharing class RecordatorioBloqueoService {

    public static Filial__c[] getFilialesBloqueadas() {

        Filial__c[] filialesBloqueadas = 
            [SELECT Id, Rut_Empresa__c, Dv_Empresa__c, Rut_Filial__c, Razon_Social__c, 
                    Numero_Poliza__c, Fecha_Bloqueo_de_Beneficios__c, Poliza__r.Corredor__c
            FROM    Filial__c 
            WHERE   Estado_Beneficio__c =: 'BLOQUEADO' 
            AND     Fecha_Bloqueo_de_Beneficios__c < TODAY]; 

		return filialesBloqueadas;
    }

    public static Filial__c[] getFilialesBloqueadas(Id corredorId) {

        Filial__c[] filialesBloqueadas = 
            [SELECT Id, Rut_Empresa__c, Dv_Empresa__c, Rut_Filial__c, Razon_Social__c, 
                    Numero_Poliza__c, Fecha_Bloqueo_de_Beneficios__c, Poliza__r.Corredor__c
            FROM    Filial__c 
            WHERE   Estado_Beneficio__c =: 'BLOQUEADO' 
            AND     Fecha_Bloqueo_de_Beneficios__c < TODAY
            AND     Poliza__r.Corredor__c =: corredorId]; 

		return filialesBloqueadas;
    }

    public static void notificarRecordatorioBloqueo(Id[] corredorIds) {
		if (corredorIds.isEmpty())
			throw new CobranzaException('No hay corredores para notificar');

		EmailResult[] results = CobranzaService.sendEmails(corredorIds, 'Recordatorio de Bloqueo');

        List<Id> sentIds = new List<Id>	();
        Map<Id, String> failMap = new Map<Id, String>();

        if (!Test.isRunningTest()){
            for (EmailResult result : results) {
                if (!result.isSuccess())
                    System.debug('No se pudo enviar email al siguiente Id de corredor: ' + String.valueOf(result.whatId));
            }
        }
	}
}