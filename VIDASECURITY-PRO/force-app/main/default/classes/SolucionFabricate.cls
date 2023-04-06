@isTest
public class SolucionFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Solution(
			SolutionName = 'Solucion 1',
			SolutionNote = 'Note',
			Status = 'Borrrador',
			IsPublishedInPublicKb = true,
			IsPublished = true
		);
	}

	public SolucionFabricate setCategoria(CategoriaSolucionFabricate categoria) {
		return (SolucionFabricate)set('Categoria_Solucion__c', categoria);
	}

}