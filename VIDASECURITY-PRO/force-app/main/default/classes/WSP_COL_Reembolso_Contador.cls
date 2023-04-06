/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_Contador {

    public class Input
    {
        @InvocableVariable(required=true)
        public String contador;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        public String contador;
    }

    @InvocableMethod(label='Reembolso_Contador')
    public static List<Output> contadorOpcion(List<Input> intro){
        List<Output> contadoresOuts = new List<Output>();
        String contadores = intro[0].contador;
        system.debug('Este es el contador'+contadores);

        Integer conta = integer.valueOf(contadores);
        conta++;
        contadores = String.valueOf(conta);
        Output contad = new Output();
        contad.contador = contadores;
        contadoresOuts.add(contad);
        return contadoresOuts;
    }
}