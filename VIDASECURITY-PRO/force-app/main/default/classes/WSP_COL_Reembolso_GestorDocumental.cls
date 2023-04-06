/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-19-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class WSP_COL_Reembolso_GestorDocumental {
    public class Input{
        @InvocableVariable(required=True)
        public String idMessage;
    }

    public class Output {
   	   	@InvocableVariable(required=true)
       	public boolean exito;
        @InvocableVariable(required=true)
       	public Integer IdSolicitud;
  	}

    @InvocableMethod(label='Reembolso_GestorDocumental')
    public static List<Output> GestorDocumental(List<Input> intro){
        List<Output> statusServicio = new List<Output>();
        Integer IdSolicitud = 0;

        try
        {
            Boolean exito = false;
            Input data = intro[0];
            String idMessage = data.idMessage;

            IdSolicitud = CLS_COL_Gestion_Documentos_Valuetech.SendDocuments(idMessage);

            MessagingSession ms = [SELECT Id, Fecha_Envio_VT__c, Id_Solicitud_Valuetech__c, Etapa_Reembolso__c FROM MessagingSession WHERE Id =: idMessage];
            ms.Id_Solicitud_Valuetech__c = String.valueOf(IdSolicitud);
            ms.Etapa_Reembolso__c = 7;
            DateTime dt = DateTime.now();
            ms.Fecha_Envio_VT__c  = DateTime.newInstance(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second());
            //ms.Fecha_Envio_VT__c  = DateTime.newInstanceGMT(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second());
            update ms;
        }
        catch (Exception ex )
        {
            System.debug( '@@@@ WSP_COL_Reembolso_GestorDocumental  -->  ' + ex);
        }

        Output out = new Output();
        out.IdSolicitud = IdSolicitud;
        out.exito = IdSolicitud != 0 ? true : false;
        statusServicio.add(out);

        return statusServicio;
    }
}