/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_GetPolizas {

    public class Input
    {
    	@InvocableVariable(required=true)
    	public String rut;

        @InvocableVariable(required=True)
        public String idMessage;
    }

    public class Output
    {
        @InvocableVariable(required=false)
        public Integer poliza;
    }



    @InvocableMethod(label='Reembolso_GetPolizas')
    public static List<Output> getPoliza(List<Input> intro){
        List<Output> polizaOutPut = new List<Output>();

        Output policee = new Output();

        Input data = intro[0];
        String rutp = data.rut;
        String idMessage = data.idMessage;

        system.debug('@@@@ rutp  -->  '+ rutp);
        system.debug('@@@@ idMessage  -->  '+ idMessage);

        policee.poliza = CLS_COL_Gestion_Reembolso_Whastapp.getPoliza(rutp);
        polizaOutPut.add(policee);

        MessagingSession ms = [SELECT Id, Tipo_de_Gasto_Reembolso__c, Valor_Tipo_de_Gasto_Reembolso__c, RUT_Titular_Reembolso__c, Poliza_Titular_Reembolso__c, RUT_Dependiente_Reembolso__c, Nombre_Titular_Reembolso__c, Nombre_Dependiente_Reembolso__c, Etapa_Reembolso__c, Apellido_Dependiente_Reembolso__c, Apellido_Titular_Reembolso__c, Vass_Remesa__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c
        FROM MessagingSession WHERE Id =: idMessage ];

        ms.Poliza_Titular_Reembolso__c =  String.valueOf(policee.poliza);
        ms.Etapa_Reembolso__c = 3;

        update ms;

        return polizaOutPut;
    }
}