@isTest
public class CategoriaPolizaGeneration extends AbstractFabricate{
	  public static final String POLIZAS_INDIV_RT_NAME = 'Individuales';
    public override Sobject default() {
        return new Categoria_de_Poliza__c(
            Name = '5016169' );
    }
    public CategoriaPolizaGeneration individual() {
        return (CategoriaPolizaGeneration) this
            .set('Name', 'B')
            .set('Peso__c', 2.25) 
            .set('Prima_Desde__c', 20)
            .set('Prima_Hasta__c',40)
            .set('Valor_Poliza_Desde__c', 5)
            .set('Valor_Poliza_Hasta__c', 8000);
    }

}