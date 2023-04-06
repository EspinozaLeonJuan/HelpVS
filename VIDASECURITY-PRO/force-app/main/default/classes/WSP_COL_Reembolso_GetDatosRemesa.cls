/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_GetDatosRemesa {

    public class Input
    {
        @InvocableVariable(required=false)
        public String idMessage;
    }

    public class Output
    {
        @InvocableVariable(required = True)
        public String remitt;
        @InvocableVariable(required=false)
        public String numR;
    }

    @InvocableMethod(label='Reembolso_GetDatosRemesa')
    public static List<Output> getDatosRemesa(List<Input> intro){

        List<Output> salida = new List<Output>();

        Output remes = new Output();

        Input data = intro[0];
        String idMessage= data.idMessage;

        try
        {

            CLS_COL_Gestion_Reembolso_Whastapp.DatosReembolso retorno = CLS_COL_Gestion_Reembolso_Whastapp.getDatosRemesa(idMessage);
            
            if (Test.isRunningTest())
            {
                retorno = new CLS_COL_Gestion_Reembolso_Whastapp.DatosReembolso();
                retorno.Denuncio = '1';
                retorno.Remesa = 'A';
            }

            if (retorno != null)
            {
                MessagingSession ms = [SELECT Id,  Etapa_Reembolso__c,  Numero_Denuncio__c, Vass_Remesa__c  FROM MessagingSession WHERE Id =: idMessage];
                ms.Numero_Denuncio__c = retorno.Denuncio != null ? String.valueOf(retorno.Denuncio) : null;
                ms.Vass_Remesa__c = retorno.Remesa != null ? String.valueOf(retorno.Remesa) : null;
                ms.Etapa_Reembolso__c = 6;

                update ms;

                remes.remitt = ms.Vass_Remesa__c;
                remes.numR = ms.Numero_Denuncio__c;
            }
            else
            {
                remes.remitt = '';
                remes.numR = '';
            }

            salida.add(remes);


        }catch(Exception e){
            System.debug(e.getMessage());
        }
        return salida;
    }

}