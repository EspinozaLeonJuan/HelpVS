/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_ResetContador {
    public class Input
    {
        @InvocableVariable(required=true)
        public String contadorin;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        Public String contadorOut;
    }

    @InvocableMethod(label='Reembolso_ResetContador')
    Public static List<Output> reserContador(List<Input> intro){
        List<Output> contOut= new List<Output>();

        String contadores = intro[0].contadorin;

        contadores = '0';
        Output contad = new Output();
        contad.contadorOut = contadores;
        contOut.add(contad);

        return contOut;
    }
}