public with sharing class EBV_contadorError {
    
	public class tipoGastoInput {
    @InvocableVariable(required=true)
    public String contador;
    }
    
    public class contadorOutput {
        @InvocableVariable(required=true)
        public String contador;
    }

    @InvocableMethod(label='contador')
    public static List<contadorOutput> contadorOpcion(List<tipoGastoInput> cont){
        List<contadorOutput> contadoresOuts = new List<contadorOutput>();
		Set<String> contador = new Set<String>();
        String contadores;        
        for(tipoGastoInput contadorInput :cont){
            contadores = contadorInput.contador;
        }        
        system.debug('Este es el contador'+contadores);
        
        Integer conta = integer.valueOf(contadores);
        conta++;
        contadores = String.valueOf(conta);
        contadorOutput contad = new contadorOutput();
        contad.contador = contadores;
        contadoresOuts.add(contad);
        return contadoresOuts;
    }
}