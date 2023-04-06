/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 09-09-2022
 * @last modified by  : Juan Espinoza León
**/
global class BAT_COL_Gestion_Reembolso_Whastapp implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{

    public String IdMS {get; set;}

    global BAT_COL_Gestion_Reembolso_Whastapp(String id) {
        this.IdMS = id;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name, CreatedDate, StartTime, EndTime, Status, AgentType, CaseId,  Origin, Contacto__c, OwnerId, Vass_Apellido_CargaTitular__c, Vass_Asunto__c, Vass_Comentario__c, Vass_Denuncio_OK__c, Vass_Negocio__c, Vass_Nombre_Carga_Titular__c, Vass_Nombre_Completo_Carga_Titular__c, Vass_Nro_Poliza__c, Vass_PolizaColectivo__c, Vass_Poliza__c, Vass_Prestacion__c, Vass_RUT_CargaTitular__c, Vass_Remesa__c, consultas_asegurados_colectivos__c, Numero_Denuncio__c, Id_Solicitud_Valuetech__c, Fecha_Envio_VT__c FROM MessagingSession WHERE Id =\'' + this.IdMS + '\'';

        system.debug('@@@@ query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<sObject> scope) {

        MessagingSession ms = null;

        String numeroDenuncio = '', remesa = '', fecha = '';

        Integer IdSolicitud = 0;

        for (SObject sObj : scope)
        {
            ms = (MessagingSession)sObj;     //for ever one
        }

        if (ms != null)
        {
            if (String.IsBlank(ms.Numero_Denuncio__c))
            {
                String data = GetDenuncio(MS.Id);
                ms.Numero_Denuncio__c = data;
                update MS;
            }

            if (String.IsNotBlank(ms.Numero_Denuncio__c))
            {
                numeroDenuncio = ms.Numero_Denuncio__c;
            }

            if (String.IsNotBlank(ms.Vass_Remesa__c))
            {
                remesa = ms.Vass_Remesa__c;
            }

            if (String.isNotBlank(numeroDenuncio) && String.isNotBlank(remesa))
            {
                fecha = String.valueOf(ms.StartTime);

                IdSolicitud = CLS_COL_Gestion_Documentos_Valuetech.SendDocuments(ms.Id, numeroDenuncio, remesa, fecha);
            }

            ms.Id_Solicitud_Valuetech__c = String.valueOf(IdSolicitud);

            //String Datetime.now().formatGMT('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'')

            DateTime dt = DateTime.now();
            system.debug('dt --> '+dt);
            ms.Fecha_Envio_VT__c  = DateTime.newInstanceGMT(dt.year(), dt.month(), dt.day(), dt.hour(), dt.minute(), dt.second());
            update ms;
            //callDelay();
        }
    }


    global void finish(Database.BatchableContext bc) {

        try {

        } catch (Exception e) {
            system.debug('@@@@ finish Exception: ' + e.getMessage());
        }
    }

    public static String GetDenuncio(String idMessage)
    {
        List<ConversationEntry> conversacion = [SELECT Id, ActorType, ActorId, ActorName, Message, MessageStatus, MessageStatusCode, MessageSendTime, MessageDeliverTime, MessageReadTime, MessageIdentifier, HasAttachments FROM ConversationEntry WHERE ConversationId =: idMessage];

        String message = '', idDenuncio = '';
        for (ConversationEntry entry : conversacion)
        {
            if (String.isNotBlank(entry.Message))
            {
                if (entry.Message.contains('Tu número de solicitud es: *'))
                {
                    message = entry.Message;

                    String[] values =  message.split('\\*');
                    system.debug('@@@@ values.size'+values.size());
                    if (values.size() == 3)
                    {
                        idDenuncio = values[1];
                        break;
                    }
                }
            }
        }

        system.debug('@@@@ message --> '+message);
        system.debug('@@@@ idDenuncio --> '+idDenuncio);

        return idDenuncio;
    }
}