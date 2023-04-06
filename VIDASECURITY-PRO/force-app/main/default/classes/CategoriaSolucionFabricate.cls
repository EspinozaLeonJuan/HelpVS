@isTest
public class CategoriaSolucionFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Categoria_Solucion__c(
			Name = 'Categoria 1'
		);
	}

}