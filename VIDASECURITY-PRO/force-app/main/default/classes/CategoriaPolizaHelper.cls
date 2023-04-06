public class CategoriaPolizaHelper {

    public static List<Categoria_de_Poliza__c> categorias;
	
    static {
        if( categorias == null ){
            categorias =  [
                SELECT Id, Name, Peso__c, Prima_Desde__c, Prima_Hasta__c, Valor_Poliza_Desde__c, Valor_Poliza_Hasta__c 
                FROM Categoria_de_Poliza__c 
                ORDER BY Prima_Desde__c DESC, Valor_Poliza_Desde__c DESC];
        }
    }
}