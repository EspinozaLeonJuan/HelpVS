/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-10-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_ValidaRUTDependiente {

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

    @InvocableMethod(label='Reembolso_ValidaRUTDependiente')
    public static List<Output> validaRUTDependiente (List<Input> intro){

       	List<Output> statusRut = new List<Output>();

        Output status = new Output();
        boolean formatOK = true;

        Input data = intro[0];
        String vrut = data.rut;
        String idMessage = data.idMessage;

         //Cleaning '-' and '.'
  		String cleanRUT = vrut
                .replace('.','')
                .replace('-','');

            //size RUT input
       	Integer sizeRUT = cleanRUT.length();

        String rut, dv;

        if(sizeRUT == 9)
        {
            rut = cleanRUT.substring(0, 8);
            dv = cleanRUT.substring(8, 9);
        }
        else if(sizeRUT == 8)
        {
            rut = cleanRUT.substring(0, 7);
            dv = cleanRUT.substring(7, 8);
        }
        else
        {
            formatOK = false;
        }

        if (formatOK == true)
        {
            system.debug('@@@@ rut Dependiente --> '+rut);

            List<Account> cuentas = [SELECT RUT__c , DV__c, RUT_con_DV__c, FirstName, LastName FROM Account WHERE RUT__c =: rut ];

            system.debug('@@@@ cuenta --> '+cuentas.size());

            MessagingSession ms = [SELECT Id, Tipo_de_Gasto_Reembolso__c, Valor_Tipo_de_Gasto_Reembolso__c, RUT_Titular_Reembolso__c, Poliza_Titular_Reembolso__c, RUT_Dependiente_Reembolso__c, Nombre_Titular_Reembolso__c, Nombre_Dependiente_Reembolso__c, Etapa_Reembolso__c, Apellido_Dependiente_Reembolso__c, Apellido_Titular_Reembolso__c, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c
            FROM MessagingSession WHERE Id =: idMessage];

            if (cuentas.size() > 0)
            {
                ms.RUT_Dependiente_Reembolso__c = cuentas[0].RUT_con_DV__c;
                ms.Nombre_Dependiente_Reembolso__c = cuentas[0].FirstName;
                ms.Apellido_Dependiente_Reembolso__c = cuentas[0].LastName;
            }
            else
            {
                ms.RUT_Dependiente_Reembolso__c = rut+'-'+dv;
            }

            ms.Etapa_Reembolso__c = 4;
            update ms;

            status.outRut = cuentas.size() > 0 ? true : false;
            statusRut.add(status);
        }

      	status.outRut = formatOK;
       	statusRut.add(status);

  	return statusRut;

    }

}