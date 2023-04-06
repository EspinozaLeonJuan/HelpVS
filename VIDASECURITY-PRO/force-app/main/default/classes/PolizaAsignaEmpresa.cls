public class PolizaAsignaEmpresa {
    
	public static Id getIdEmpresas( Poliza__c polizaNew, Poliza__c polizaOld, Boolean isInsert, Set<Id> idsEmpresas ){
		if( ( isInsert && polizaNew.Cuenta__c != null) || ( polizaOld != null && polizaOld.Cuenta__c != polizaNew.Cuenta__c && polizaNew.Cuenta__c != null ) ){
			if( !idsEmpresas.contains( polizaNew.Cuenta__c ) ){
				return polizaNew.Cuenta__c; } } return null;
	}

	public static string getRutEmpresas( Poliza__c polizaNew, Set<String> rutsEmpresas ){
		if( String.isNotBlank( polizaNew.Rut_Empresa__c) && !rutsEmpresas.contains( polizaNew.Rut_Empresa__c ) ){
			return polizaNew.Rut_Empresa__c.toUpperCase(); } return '';
	}

	public static void execute( Poliza__c polizaNew, Poliza__c polizaOld, Boolean isInsert, Map<Id, Account> mapCuentasById, Map<String, Account> mapEmpresas ){
		if( ( isInsert && polizaNew.Cuenta__c != null) || ( polizaOld != null && polizaOld.Cuenta__c != polizaNew.Cuenta__c && polizaNew.Cuenta__c!=null)){
			if( mapCuentasById.containsKey( polizaNew.Cuenta__c ) ){
				polizaNew.RUT_Empresa__c = mapCuentasById.get( polizaNew.Cuenta__c ).Rut__c;
			}
		}
  
		if( String.isNotBlank( polizaNew.Rut_Empresa__c ) && mapEmpresas.containsKey( polizaNew.Rut_Empresa__c.toUpperCase() ) ){
			if ( !mapCuentasById.containsKey( polizaNew.Cuenta__c ) ) { polizaNew.RUT_Empresa__c = null; 
      } else { polizaNew.Cuenta__c = mapEmpresas.get( polizaNew.Rut_Empresa__c.toUpperCase() ).Id;
      }
		}
	}
}