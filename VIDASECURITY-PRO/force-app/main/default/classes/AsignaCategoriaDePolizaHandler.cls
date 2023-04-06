public class AsignaCategoriaDePolizaHandler implements TriggerHandler.HandlerInterface {
	
	public static Categoria_de_Poliza__c[] categorias = [SELECT Id, Name, Peso__c, Prima_Desde__c, Prima_Hasta__c, Valor_Poliza_Desde__c, Valor_Poliza_Hasta__c FROM Categoria_de_Poliza__c ORDER BY Prima_Desde__c DESC, Valor_Poliza_Desde__c DESC];
	
	private Categoria_de_Poliza__c getCategoriaPoliza(Decimal prima, Decimal poliza) {
		for (Categoria_de_Poliza__c categoria : categorias) {
			System.debug('categoria:'+categoria);
			System.debug('Prima: '+ prima + ' Poliza: '+poliza);
			prima = prima == null ? 0 : prima;
			poliza = poliza == null ? 0 : poliza;
			if ((prima >= categoria.Prima_Desde__c && categoria.Prima_Hasta__c == null) || (poliza >= categoria.Valor_Poliza_Desde__c && categoria.Valor_Poliza_Hasta__c == null) ||
			(prima >= categoria.Prima_Desde__c && prima < categoria.Prima_Hasta__c) || (poliza >= categoria.Valor_Poliza_Desde__c && poliza < categoria.Valor_Poliza_Hasta__c))
				return categoria;
		}
		return null;
			}
    
	public void handle() {
		for (Poliza__c poliza : (Poliza__c[])Trigger.new) {
			Poliza__c old = (Poliza__c)(Trigger.isUpdate ? Trigger.oldMap.get(poliza.Id) : null);
			if (old != null && poliza.Prima_Total__c == old.prima_Total__c && poliza.Valor_Poliza__c == old.Valor_Poliza__c && old.Categoria_de_Poliza__c == poliza.Categoria_de_Poliza__c && poliza.Categoria_de_Poliza__c != null)
				continue;
			Categoria_de_Poliza__c categoria = getCategoriaPoliza(poliza.Prima_Total__c, poliza.Valor_Poliza__c);
			if (categoria != null)
			poliza.Categoria_de_Poliza__c = categoria.Id;
			else
			poliza.Categoria_de_Poliza__c = null;
		}
	}
}