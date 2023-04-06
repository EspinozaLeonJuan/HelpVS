/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_SolicitarDoc {
    public class Input
    {
        @InvocableVariable(required=true)
        public String Input;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        public boolean OutputBol;
    }

    @InvocableMethod(label='Reembolso_SolicitarDoc')
    public static List<Output> SolicitarDoc(List<Input> intro)
    {
        List<Output> contOut= new List<Output>();
        Output contad = new Output();
        String contadores = intro[0].Input;
        boolean valido = false;

        if(contadores== '1'){
            valido = true;
        }

        contad.OutputBol = valido;
        contOut.add(contad);

        return contOut;
    }
}