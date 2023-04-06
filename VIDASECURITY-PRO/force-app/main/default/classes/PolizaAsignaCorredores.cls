public class PolizaAsignaCorredores {

    public static string getRutCorredor( Poliza__c polizaNew, Poliza__c polizaOld, Boolean isInsert, Set<String> rutsCorredores ){
		if( String.isNotBlank( polizaNew.Rut_Corredor__c ) && !rutsCorredores.contains( polizaNew.Rut_Corredor__c ) ){
			return polizaNew.Rut_Corredor__c.toUpperCase();
		}
		return '';
	}

	public static Id getCorredor( Poliza__c polizaNew, Poliza__c polizaOld, Boolean isInsert, Set<Id> idsCorredores ){
		if( ( isInsert && polizaNew.Corredor__c != null ) || ( polizaOld != null && polizaOld.Corredor__c != polizaNew.Corredor__c && polizaNew.Corredor__c != null ) ){
			if( !idsCorredores.contains( polizaNew.Corredor__c ) ){
				return polizaNew.Corredor__c;
			}
		}
		return null;
	}

	public static void execute( Poliza__c polizaNew, Poliza__c polizaOld, Boolean isInsert, Map<Id, Corredor__c> mapCorredoresById, Map<String, Corredor__c> mapCorredores ) {
		if( ( isInsert && polizaNew.Corredor__c != null) || ( polizaOld != null && polizaOld.Corredor__c != polizaNew.Corredor__c && polizaNew.Corredor__c != null ) ){
			if( mapCorredoresById.containsKey( polizaNew.Corredor__c)){
				polizaNew.Rut_Corredor__c = mapCorredoresById.get( polizaNew.Corredor__c).Rut__c;
			}
		}

		if( String.isNotBlank( polizaNew.Rut_Corredor__c ) && mapCorredores.containsKey( polizaNew.Rut_Corredor__c.toUpperCase() ) ){
			polizaNew.Corredor__c =  mapCorredores.get( polizaNew.Rut_Corredor__c.toUpperCase() ).Id;
		}
	}
}