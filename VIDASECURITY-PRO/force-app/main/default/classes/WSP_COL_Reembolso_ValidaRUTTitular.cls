/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-10-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_ValidaRUTTitular {

    public class Input
    {
        @InvocableVariable(required=true)
        public String rut;

        @InvocableVariable(required=True)
        public String idMessage;
    }

    public class Output
    {
        @InvocableVariable(required=true)
        public boolean outRut;
    }


    @InvocableMethod(label='Reembolso_ValidaRUTTitular')
    public static List<Output> validaRUTTitular (List<Input> intro){

        List<Output> statusRut = new List<Output>();

        Output status = new Output();
        boolean formatOK = true;
        String rut = '';

        try
        {
            Input data = intro[0];
            String vrut = data.rut;
            String idMessage = data.idMessage;

            //Cleaning '-' and '.'
            String cleanRUT = vrut
                .replace('.','')
                .replace('-','');

            //size RUT input
            Integer sizeRUT = cleanRUT.length();

            //get the last number RUT
            if(sizeRUT == 9)
            {
                rut = cleanRUT.substring(0, 8);
            }
            else if(sizeRUT == 8)
            {
                rut = cleanRUT.substring(0, 7);
            }
            else
            {
                formatOK = false;
                status.outRut = false;
                statusRut.add(status);
            }

            if (formatOK == true)
            {
                List<Account> cuentas = [SELECT RUT__c , DV__c, RUT_con_DV__c, FirstName, LastName FROM Account WHERE RUT__c =: rut ];

                MessagingSession ms = [SELECT Id, Tipo_de_Gasto_Reembolso__c, Valor_Tipo_de_Gasto_Reembolso__c, RUT_Titular_Reembolso__c, Poliza_Titular_Reembolso__c, RUT_Dependiente_Reembolso__c, Nombre_Titular_Reembolso__c, Nombre_Dependiente_Reembolso__c, Etapa_Reembolso__c, Apellido_Dependiente_Reembolso__c, Apellido_Titular_Reembolso__c, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c
                FROM MessagingSession WHERE Id =: idMessage];

                if (cuentas.size() > 0)
                {
                    ms.RUT_Titular_Reembolso__c = cuentas[0].RUT_con_DV__c;
                    ms.Nombre_Titular_Reembolso__c = cuentas[0].FirstName;
                    ms.Apellido_Titular_Reembolso__c = cuentas[0].LastName;
                }

                ms.Etapa_Reembolso__c = 2;
                update ms;

                status.outRut = cuentas.size() > 0 ? true : false;
                statusRut.add(status);
            }
        }
        catch (Exception ex )
        {
            System.debug( '@@@@ WSP_COL_Reembolso_ValidaRUTTitular --> ' + ex);
        }


        return statusRut;
    }
}