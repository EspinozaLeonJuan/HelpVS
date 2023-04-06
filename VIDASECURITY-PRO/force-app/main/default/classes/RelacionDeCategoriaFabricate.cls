@isTest
public class RelacionDeCategoriaFabricate extends AbstractFabricate {

	public override Sobject default() {
		return new Relacion_de_Categoria__c(
			Categoria_de_Ejecutivo__c = 'Prime'
		);
	}

	public RelacionDeCategoriaFabricate setCategoriaDeCliente(CategoriaDeClienteFabricate categoria){
		return (RelacionDeCategoriaFabricate) set('Categoria_de_Cliente__c', categoria);
	}

	public RelacionDeCategoriaFabricate setSucursal(SucursalFabricate sucursal){
		return (RelacionDeCategoriaFabricate) set('Sucursal__c', sucursal);
	}

}