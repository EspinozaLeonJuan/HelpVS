/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-05-2022
 * @last modified by  : Juan Espinoza León
**/
public with sharing class CLS_LWC_Gestion_Reembolso_Whastapp {
    public class Wrapper_Reembolso
    {
        @auraEnabled public Datetime HoraInicio {get;set;}
        @auraEnabled public Datetime HoraTermino {get;set;}
        @auraEnabled public String Estado {get;set;}
        @auraEnabled public String Remesa {get;set;}
        @auraEnabled public String NumeroDenuncio {get;set;}
        @auraEnabled public String IdSolicitud {get;set;}
        @auraEnabled public Datetime FechaEnvio {get;set;}
    }

    @AuraEnabled
    public static List<Wrapper_Reembolso> uploadFile(String jsonData) {
        system.debug('@@@@ jsonData '+jsonData);
        String data = JSON.deserializeUntyped(jsonData).toString();
        system.debug('@@@@ DATA '+data);
        List<String> lstCSVLines = data.split('\n');

        List<String> listIn = new List<String>();

        List<Wrapper_Reembolso> listOut = new List<Wrapper_Reembolso>();

        List<String> csvRowData;

        //carga listado de remesas a analizar
        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            csvRowData = getDataLine(lstCSVLines[i]);
            listIn.add(csvRowData[0].trim());
            system.debug('@@@@ data --> '+csvRowData[0].trim());
        }

        List<MessagingSession> listMsj = [SELECT Id, Name, CreatedDate, StartTime, EndTime, Status, AgentType, CaseId,  Origin, Contacto__c, OwnerId, Vass_Apellido_CargaTitular__c, Vass_Asunto__c, Vass_Comentario__c, Vass_Denuncio_OK__c, Vass_Negocio__c, Vass_Nombre_Carga_Titular__c, Vass_Nombre_Completo_Carga_Titular__c, Vass_Nro_Poliza__c, Vass_PolizaColectivo__c, Vass_Poliza__c, Vass_Prestacion__c, Vass_RUT_CargaTitular__c, Vass_Remesa__c, consultas_asegurados_colectivos__c,  Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c FROM MessagingSession WHERE Vass_Remesa__c IN : listIn];

        Wrapper_Reembolso value;

        for(MessagingSession ms : listMsj)
        {
            value = new Wrapper_Reembolso();
            value.HoraInicio = ms.StartTime;
            value.HoraTermino = ms.EndTime;
            value.Estado = ms.Status;
            value.Remesa = ms.Vass_Remesa__c;
            value.NumeroDenuncio = ms.Numero_Denuncio__c;
            value.IdSolicitud = ms.Id_Solicitud_Valuetech__c;
            value.FechaEnvio = ms.Fecha_Envio_VT__c;
            listOut.add(value);
        }

        return listOut;
    }

    public static List<String> getDataLine(String csvLine)
    {
        String prevLine = csvLine;
        Integer startIndex;
        Integer endIndex;

        system.debug('@@@@ csvLine --> '+csvLine);
        system.debug('@@@@ csvLine.indexOf() --> '+csvLine.indexOf('"'));
        while(csvLine.indexOf('"') > -1){

            if(startIndex == null){
                startIndex = csvLine.indexOf('"');
                csvLine = csvLine.substring(0, startIndex) + ':quotes:' + csvLine.substring(startIndex+1, csvLine.length());
            }else{
                if(endIndex == null){
                    endIndex = csvLine.indexOf('"');
                    csvLine = csvLine.substring(0, endIndex) + ':quotes:' + csvLine.substring(endIndex+1, csvLine.length());
                }
            }

            if(startIndex != null && endIndex != null){
                String sub = csvLine.substring(startIndex, endIndex);
                sub = sub.replaceAll(',', ':comma:');
                csvLine = csvLine.substring(0, startIndex) + sub + csvLine.substring(endIndex, csvLine.length());
                startIndex = null;
                endIndex = null;
            }
        }

        List<String> csvRowData = new List<String>();
        for(String column : csvLine.split(',')){
            column = column.replaceAll(':quotes:', '').replaceAll(':comma:', ',');
            csvRowData.add(column);
        }

        return csvRowData;
    }


    @AuraEnabled
    public static void proccessFile(String jsonData) {
        system.debug('@@@@ jsonData '+jsonData);
        String data = JSON.deserializeUntyped(jsonData).toString();
        system.debug('@@@@ DATA '+data);
        List<String> lstCSVLines = data.split('\n');

        List<String> listIn = new List<String>();

        List<Wrapper_Reembolso> listOut = new List<Wrapper_Reembolso>();

        List<String> csvRowData;

        //carga listado de remesas a analizar
        for(Integer i = 1; i < lstCSVLines.size(); i++)
        {
            csvRowData = getDataLine(lstCSVLines[i]);
            listIn.add(csvRowData[0].trim());
            system.debug('@@@@ data --> '+csvRowData[0].trim());
        }

        List<MessagingSession> listMsj = [SELECT Id, Name, CreatedDate, StartTime, EndTime, Status, AgentType, CaseId,  Origin, Contacto__c, OwnerId, Vass_Apellido_CargaTitular__c, Vass_Asunto__c, Vass_Comentario__c, Vass_Denuncio_OK__c, Vass_Negocio__c, Vass_Nombre_Carga_Titular__c, Vass_Nombre_Completo_Carga_Titular__c, Vass_Nro_Poliza__c, Vass_PolizaColectivo__c, Vass_Poliza__c, Vass_Prestacion__c, Vass_RUT_CargaTitular__c, Vass_Remesa__c, consultas_asegurados_colectivos__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c FROM MessagingSession WHERE Vass_Remesa__c IN : listIn];

        for(MessagingSession ms : listMsj)
        {
            BAT_COL_Gestion_Reembolso_Whastapp myBatchObject = new BAT_COL_Gestion_Reembolso_Whastapp(ms.Id);
            system.debug('@@@@@ myBatchObject  --> '+ myBatchObject);
            Id batchId = Database.executeBatch(myBatchObject);
            system.debug('@@@@@ batchId  --> '+ batchId);
          //  callDelay();
        }
    }


}