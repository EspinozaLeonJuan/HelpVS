@isTest
public class CategoriaDeClienteFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Categoria_de_Cliente__c(
			Name='A',
			Peso__c = 1.85,
			Prima_Desde__c = 0,
			Prima_Hasta__c = 5,
			Valor_Poliza_Desde__c = 200,
			Valor_Poliza_Hasta__c = 800

		);
	}
  	
}