/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-18-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_SeleccionTipo {

    public class Input
    {
        @InvocableVariable(required=true)
        public String option;

        @InvocableVariable(required=True)
        public String idMessage;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        public Boolean respuesta;
    }

    @invocableMethod(label='Reembolso_SeleccionTipo')
    public static List<Output> validateOption(List<Input> intro)
    {
        system.debug('@@@@ intro --> ');
        List<Output> output = new List<Output>();
        Output out = new Output();

        Set<String> options = new Set<String>();

        try
        {
            Input data = intro[0];
            String option = data.option;
            String idMessage = data.idMessage;

            system.debug('@@@@ data --> '+ data);
            system.debug('@@@@ option --> '+ option);
            system.debug('@@@@ idMessage --> '+ idMessage);

            Integer tipo = 0;

            if(option == 'Ambulatorio (consulta, exámenes, medicamentos, ópticos)')
            {
                tipo = 1;
            }
            else if (option == 'Dental')
            {
                tipo = 2;
            }

            out.respuesta = tipo == 0 ? false : true;
            output.add(out);

            MessagingSession ms = [SELECT Id, Tipo_de_Gasto_Reembolso__c, Valor_Tipo_de_Gasto_Reembolso__c, RUT_Titular_Reembolso__c, Poliza_Titular_Reembolso__c, RUT_Dependiente_Reembolso__c, Nombre_Titular_Reembolso__c, Nombre_Dependiente_Reembolso__c, Etapa_Reembolso__c, Apellido_Dependiente_Reembolso__c, Apellido_Titular_Reembolso__c, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c
                                   FROM MessagingSession WHERE Id =: idMessage];

            ms.Tipo_de_Gasto_Reembolso__c = option;
            ms.Valor_Tipo_de_Gasto_Reembolso__c = tipo;
            ms.Etapa_Reembolso__c = 1;
            update ms;
        }
        catch(Exception ex)
        {
            system.debug('@@@@ EX --> '+ex.getMessage());
            system.debug('@@@@ EX LN --> '+ex.getLineNumber());
        }

        return output;
    }
}