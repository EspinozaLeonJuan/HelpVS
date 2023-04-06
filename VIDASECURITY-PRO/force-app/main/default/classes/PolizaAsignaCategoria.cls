public class PolizaAsignaCategoria {

	public static void execute( Poliza__c polizaNew, Poliza__c polizaOld ) {
		if( polizaOld != null &&
			polizaNew.Prima_Total__c == polizaOld.prima_Total__c && 
			polizaNew.Valor_Poliza__c == polizaOld.Valor_Poliza__c && 
			polizaNew.Categoria_de_Poliza__c == polizaOld.Categoria_de_Poliza__c && 
			polizaNew.Categoria_de_Poliza__c != null){
				return;
		}
		Categoria_de_Poliza__c categoria = getCategoriaPoliza( polizaNew.Prima_Total__c, polizaNew.Valor_Poliza__c);
		polizaNew.Categoria_de_Poliza__c = ( categoria != null ? categoria.Id : null);
	}
	@TestVisible
	private static Categoria_de_Poliza__c getCategoriaPoliza(Decimal prima, Decimal poliza) {
		prima = prima == null ? 0 : prima;
		poliza = poliza == null ? 0 : poliza;
		for( Categoria_de_Poliza__c categoria : CategoriaPolizaHelper.categorias ) {
			if( ( prima >= categoria.Prima_Desde__c && categoria.Prima_Hasta__c == null) || 
				( poliza >= categoria.Valor_Poliza_Desde__c && categoria.Valor_Poliza_Hasta__c == null) ||
				( prima >= categoria.Prima_Desde__c && prima < categoria.Prima_Hasta__c) || 
				( poliza >= categoria.Valor_Poliza_Desde__c && poliza < categoria.Valor_Poliza_Hasta__c) ){
					return categoria;
			}
		}
		return null;
	}    
}