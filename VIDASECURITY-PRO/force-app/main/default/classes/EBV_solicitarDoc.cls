public with sharing class EBV_solicitarDoc {
	public class Input{
        @InvocableVariable(required=true)
        public String Input;
    }
    public class Output{
        @InvocableVariable(required=true)
        Public boolean OutputBol;
    }
    
    @InvocableMethod(label='solicitarDoc')
    Public static List<Output> SolicitarDoc(List<Input> inputcon){
        List<Output> contOut= new List<Output>();
        Set<String> contador = new Set<String>();
        Output contad = new Output();
        String contadores; 
        boolean valido = false;
        
        for(Input respuestaInput :inputcon){
            contadores = respuestaInput.Input;
        }
        if(contadores== '1'){
            valido = true;
        }
        
        
        contad.OutputBol = valido;
        contOut.add(contad);
        
        return contOut;
    }
}