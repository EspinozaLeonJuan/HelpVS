public with sharing class EBV_resertContador {
    public class contadorInput{
        @InvocableVariable(required=true)
        public String contadorin;
    }
    public class ContadorOutput{
        @InvocableVariable(required=true)
        Public String contadorOut;
    }
    
    @InvocableMethod(label='ResertContador')
    Public static List<ContadorOutput> reserContador(List<contadorInput> continptut){
        List<ContadorOutput> contOut= new List<ContadorOutput>();
        Set<String> contador = new Set<String>();
        String contadores;        
        
        for(contadorInput contadorInput :continptut){
            contadores = contadorInput.contadorin;
        }
        
        contadores = '0';
        ContadorOutput contad = new ContadorOutput();
        contad.contadorOut = contadores;
        contOut.add(contad);
        
        return contOut;
    }

}