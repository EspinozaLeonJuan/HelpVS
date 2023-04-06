/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 07-28-2022
 * @last modified by  : Juan Espinoza León
 * Modifications Log
 * Ver   Date         Author               Modification
 * 1.0   02-04-2021   Juan Espinoza León   Initial Version
**/
public with sharing class CLS_LINK_Notificacion {
    public CLS_LINK_Notificacion() {

    }


    public static void envioCorreo(String IdOportunidad)
    {
        Opportunity oportunidad = [SELECT id, ContactId, Name, StageName, Agente_de_venta__c, Agente_de_Venta__r.Email, Agente_de_Venta__r.ReportsToId, Agente_de_Venta__r.ReportsTo.Name, Agente_de_Venta__r.ReportsTo.Email, Codigo_de_Link__c, Agente_de_Venta__r.Ciudad__r.Name, Agente_de_Venta__r.Name, Fecha_Entrevista__c, Hora_Entrevista__c, Direccion__c, Comuna__r.Name, Renta__c, Account.Name, AccountId,  Agente_de_venta__r.Ranking_de_agente__c, Fecha_de_nacimiento__c, Telefono_activo__c, Account.PersonTitle, Observacion__c, Correo_electronico__c, Nota_a_Agente__c, Titulo_Nota_a_Agente__c FROM Opportunity WHERE Id =: IdOportunidad];

        List<Opportunity> oportunidades = new List<Opportunity>();
        oportunidades.add(oportunidad);

        sendmail(oportunidades);
    }

    public static void envioCorreo()
    {
        String recordTypeLink = [SELECT Id FROM RecordType WHERE Name = 'Venta - Link'].Id;

        List<Opportunity> oportunidadesHoy = [SELECT id, ContactId, Name, StageName, Agente_de_venta__c, Agente_de_Venta__r.Email, Agente_de_Venta__r.ReportsToId, Agente_de_Venta__r.ReportsTo.Name, Agente_de_Venta__r.ReportsTo.Email, Codigo_de_Link__c, Agente_de_Venta__r.Ciudad__r.Name, Agente_de_Venta__r.Name, Fecha_Entrevista__c, Hora_Entrevista__c, Direccion__c, Comuna__r.Name, Renta__c, Account.Name, AccountId, Agente_de_venta__r.Ranking_de_agente__c, Fecha_de_nacimiento__c, Telefono_activo__c, Account.PersonTitle, Observacion__c, Correo_electronico__c, Nota_a_Agente__c, Titulo_Nota_a_Agente__c FROM Opportunity WHERE agente_asignado__c = true AND StageName ='Asignación' AND RecordTypeId =:recordTypeLink];

        sendmail(oportunidadesHoy);
    }

    public static void envioCorreo_Cliente(String IdOportunidad)
    {
        Opportunity oportunidad = [SELECT id, ContactId, Name, StageName, Agente_de_venta__c, Agente_de_Venta__r.Email, Agente_de_Venta__r.ReportsToId, Agente_de_Venta__r.ReportsTo.Name, Agente_de_Venta__r.ReportsTo.Email, Codigo_de_Link__c, Agente_de_Venta__r.Ciudad__r.Name, Agente_de_Venta__r.Name, Fecha_Entrevista__c, Hora_Entrevista__c, Direccion__c, Comuna__r.Name, Renta__c, Account.Name, AccountId,  Agente_de_venta__r.Ranking_de_agente__c, Fecha_de_nacimiento__c, Telefono_activo__c, Account.PersonTitle, Account.PersonEmail, Observacion__c, Correo_electronico__c, Nota_a_Agente__c, Titulo_Nota_a_Agente__c FROM Opportunity WHERE Id =: IdOportunidad];

        List<Opportunity> oportunidades = new List<Opportunity>();
        oportunidades.add(oportunidad);

        sendmail_Cliente(oportunidades);
    }

    public static void envioCorreo_Cliente()
    {
        String recordTypeLink = [SELECT Id FROM RecordType WHERE Name = 'Venta - Link'].Id;

        List<Opportunity> oportunidadesHoy = [SELECT id, ContactId, Name, StageName, Agente_de_venta__c, Agente_de_Venta__r.Email, Agente_de_Venta__r.ReportsToId, Agente_de_Venta__r.ReportsTo.Name, Agente_de_Venta__r.ReportsTo.Email, Codigo_de_Link__c, Agente_de_Venta__r.Ciudad__r.Name, Agente_de_Venta__r.Name, Fecha_Entrevista__c, Hora_Entrevista__c, Direccion__c, Comuna__r.Name, Renta__c, Account.Name, AccountId, Agente_de_venta__r.Ranking_de_agente__c, Fecha_de_nacimiento__c, Telefono_activo__c, Account.PersonTitle, Observacion__c, Account.PersonEmail,  Correo_electronico__c, Nota_a_Agente__c, Titulo_Nota_a_Agente__c FROM Opportunity WHERE agente_asignado__c = true AND StageName ='Asignación' AND RecordTypeId =:recordTypeLink AND Notificacion_Entrevista_Links__c = true];

        system.debug('@@@@ oportunidadesHoy '+oportunidadesHoy.size());

        sendmail_Cliente(oportunidadesHoy);
    }

    public static Boolean validateEmail(String email) {
        String InputString = email;

        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';

        Pattern MyPattern = Pattern.compile(emailRegex);

        Matcher MyMatcher = MyPattern.matcher(InputString);

        if (!MyMatcher.matches()) {
            return false;
        }
        else {
           return true;
        }
    }

    public static void sendmail_Cliente(List<Opportunity> oportunidades)
    {
        String orgEmailAddressId = [SELECT Id FROM OrgWideEmailAddress WHERE Address='sfvida@security.cl'].Id;
        EmailTemplate ET = [Select Id,Body, HtmlValue,Subject FROM EmailTemplate Where Name = 'SEC - Plantilla Notifica Entrevista'];

        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email;

        String vEmail = '';

        for (Opportunity op : oportunidades)
        {
            email =  new Messaging.SingleEmailMessage();

            if (String.isNotBlank(op.Direccion__c) && validateEmail(op.Direccion__c))
            {
                vEmail = op.Direccion__c;
            }

            if (String.isBlank(vEmail) && String.isNotBlank(op.Correo_electronico__c))
            {
                vEmail = op.Correo_electronico__c;
            }

            if (String.isBlank(vEmail) && String.isNotBlank(op.Account.PersonEmail))
            {
                vEmail = op.Account.PersonEmail;
            }

            if (String.isNotBlank(vEmail))
            {
                email.setWhatId(op.Id);
                String[] vEmails = new String[]{};
                vEmails.add(vEmail);
                email.setToAddresses(vEmails);
                email.setTargetObjectId(op.ContactId);
                email.setSaveAsActivity(true);//true guarda correo electronico
                email.setOrgWideEmailAddressId(orgEmailAddressId);
                email.setTemplateId(ET.Id);
                emails.add(email);
            }
        }

        if (emails.size() > 0 ) {
            Messaging.sendEmail(emails);
            System.debug(Limits.getEmailInvocations());
        }
    }


    public static void sendmail(List<Opportunity> oportunidades)
    {
        System.debug('@@@@ sendmail');

        String[] toAddresses = new String[]{};
        String[] ccAddresses = new String[]{};
        String[] bbcAddresses = new String[]{};  //tmp
        bbcAddresses.add('monica.rojas@security.cl');
        bbcAddresses.add('juespinoza@security.cl');



        String orgEmailAddressId = [SELECT Id FROM OrgWideEmailAddress WHERE Address='sfvida@security.cl'].Id;

        List<Opportunity> linksEnviados = new List<Opportunity>();

        List<OBJ_LINK_Notificacion> notificaciones = new List<OBJ_LINK_Notificacion>();

        System.debug('@@@@ oportunidadesHoy l:31 --> '+ oportunidades);

        for (Opportunity opp : oportunidades)
        {
          if ((!String.isBlank(opp.Agente_de_Venta__c) || opp.Agente_de_venta__c !=null)
          && (!String.IsBlank(opp.Agente_de_Venta__r.Email) || opp.Agente_de_Venta__r.Email != null))
          {
              OBJ_LINK_Notificacion notif = new OBJ_LINK_Notificacion();

              String ranking = opp.Agente_de_Venta__r.Ranking_de_agente__c;

              if (ranking == 'A' || ranking == 'B') // solo notifica a supervisores para agentes ranking A y B
              {
                 notif.Supervisor_Id = opp.Agente_de_Venta__r.ReportsToId;
                 notif.Supervisor_Name = opp.Agente_de_Venta__r.ReportsTo.Name;
                 notif.Supervisor_Email = opp.Agente_de_Venta__r.ReportsTo.Email;
              }

              notif.Agente_Id = opp.Agente_de_venta__c;
              notif.Agente_Name = opp.Agente_de_Venta__r.Name;
              notif.Agente_Email = opp.Agente_de_Venta__r.Email;

              notif.Entrevista_Fecha = opp.Fecha_Entrevista__c.format();

              notif.Oportunidad_Entrevista_Fecha = opp.Fecha_Entrevista__c;
              notif.Oportunidad_Entrevista_Hora = opp.Hora_Entrevista__c;

              if (opp.Hora_Entrevista__c.hour() != null && opp.Hora_Entrevista__c != null ) {
                Integer horaLink = opp.Hora_Entrevista__c.hour();
                Integer minLink = opp.Hora_Entrevista__c.minute();
                if(minLink == 0)
                {
                  notif.Entrevista_Hora = String.valueOf(horaLink) + ':' + String.valueOf(minLink)+'0';
                }
                else
                {
                  notif.Entrevista_Hora = String.valueOf(horaLink) + ':' + String.valueOf(minLink);
                }
              }

              notif.Oportunidad_Name = (String.isBlank(opp.Name)? '' : opp.Name);
              notif.Oportunidad_Direccion =  (String.isBlank(opp.Direccion__c)? '' : opp.Direccion__c);
              notif.Oportunidad_Cargo = (String.isBlank(opp.Account.PersonTitle)? '' : opp.Account.PersonTitle);
              notif.Oportunidad_Comuna = (String.isBlank(opp.Comuna__r.Name)? '' : opp.Comuna__r.Name);
              notif.Oportunidad_Observacion = (String.isBlank(opp.Observacion__c)? '' : opp.Observacion__c);

              if(opp.Fecha_de_nacimiento__c!=null){
                  notif.Oportunidad_FechaNacimiento = String.valueOf(opp.Fecha_de_nacimiento__c.format());
              }
              if(opp.Renta__c !=null){
                notif.Oportunidad_Renta = String.valueOf(opp.Renta__c);
              }
              if(opp.Codigo_de_Link__c!=null){
                  notif.Oportunidad_CodigoLink = String.valueOf(opp.Codigo_de_Link__c);
              }

              if(opp.Telefono_activo__c!=null){
                  notif.Oportunidad_Telefono = String.valueOf(opp.Telefono_activo__c);
              }
              System.debug('@@@@ notif l:118 --> '+ notif);

              notif.Titulo_Mensaje_Agente = opp.Titulo_Nota_a_Agente__c;
              notif.Mensaje_Agente = opp.Nota_a_Agente__c;

              notificaciones.add(notif);

              opp.StageName = 'Links Enviado';
              linksEnviados.add(opp);
          }
      }

      System.debug('@@@@ oportunidadesHoy l:40 --> '+ oportunidades);
      System.debug('@@@@ oportunidadesHoy.size l:41 --> '+ oportunidades.size());

      List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

      for (OBJ_LINK_Notificacion notif: notificaciones) {

          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

          mail.setTargetObjectId(notif.Agente_Id);
          mail.setOrgWideEmailAddressId(orgEmailAddressId);
          //CORREOS PARA ENVIO

          toAddresses.add(notif.Agente_Email);
          mail.setToAddresses(toAddresses);

          //copia a Supervisor
          if (String.isNotBlank(notif.Supervisor_Email))
          {
            ccAddresses.add(notif.Supervisor_Email);
            system.debug('@@@@@ toCc --> '+ ccAddresses);
            mail.setCcAddresses(ccAddresses);
          }
          //copia a Supervisor

          //tmp
          mail.setBccAddresses(bbcAddresses);
          //tmp

          //detalle correo

          String subject = 'Link :'+notif.Oportunidad_CodigoLink + +' Fecha Entrevista :' + notif.Entrevista_Fecha+' '+notif.Entrevista_Hora;
          mail.setSubject(subject);

          String htmlBody = GetHtmlBody(notif);
          mail.sethtmlBody(htmlBody);
          System.debug(htmlBody);
          //detalle correo

          //adjunto
          Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
          attach.filename = 'LINK AGENDADO.ics';
          attach.ContentType = 'text/calendar';
          attach.inline = true;
          attach.body = invite(notif.Oportunidad_Entrevista_Fecha, notif.Oportunidad_Entrevista_Hora, notif.Oportunidad_Direccion, notif.Oportunidad_Comuna, notif.Oportunidad_Name);
          mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});
          //adjunto

          System.debug(mail);
          mail.setSaveAsActivity(false);
          mails.add(mail);
          System.debug(toAddresses);

          toAddresses.clear();
          ccAddresses.clear();
      }

      if (mails.size() > 0 ) {
          Messaging.sendEmail(mails);
          System.debug(Limits.getEmailInvocations());
      }

      if (linksEnviados.size()> 0 ) {
          try {
              update linksEnviados;
              System.debug('linksEnviados.size() --> '+linksEnviados.size());
              System.debug('linksEnviados --> '+linksEnviados);
          } catch (DmlException e) {
              System.debug(e.getDmlStatusCode(0));
          }
      }
    }

    public static String GetHtmlBody(OBJ_LINK_Notificacion notif)
    {
        if (String.isBlank(notif.Mensaje_Agente))
        {
            notif.Mensaje_Agente = 'Deberá atender a todos los clientes que le sean derivados a través de Televenta, independiente del lugar físico donde este se encuentre. '+
            'No podrá chequear telefónicamente, en forma previa, la información de estos, ni la fecha u hora de entrevista, salvo que el documento así lo exprese claramente.'+
            'Cuando realice la entrevista, deberá informar del resultado a la Cía.';
            notif.Titulo_Mensaje_Agente = 'Decálogo del agente - Ítem 8 - No confirmar entrevistas';
        }


        String htmlBody = '<html><head><style>table, th, td {border: 1px solid #ddd;text-align: left;}table {border-collapse: collapse;width: 100%;}th, td {padding: 15px;}</style></head><body>'+
                          '<div style="overflow-x:auto;">'+
                          '<table><tbody><tr>'+
                              '<th>Cliente</th>'+
                              '<td>'+ notif.Oportunidad_Name +'</td>'+
                              '<th>Link</th>'+
                              '<td>'+notif.Oportunidad_CodigoLink+'</td>'+
                              '<th>Agente</th>'+
                              '<td>'+ notif.Agente_Name +'</td>'+
                            '</tr>'+
                            '<tr>'+
                              '<th>Fecha Nacimiento</th>'+
                              '<td>'+ notif.Oportunidad_FechaNacimiento +'</td>'+
                              '<th>Fecha Entrevista</th>'+
                              '<td>'+ notif.Entrevista_Fecha +'</td>'+
                              '<th>Hora Entrevista</th>'+
                              '<td>'+ notif.Entrevista_Hora +'</td>'+
                              '</tr>'+
                            '<tr>'+
                              '<th>Teléfono Activo</th>'+
                              '<td>'+ notif.Oportunidad_Telefono +'</td>'+
                              '<th>Direccion</th>'+
                              '<td>'+ notif.Oportunidad_Direccion +'</td>'+
                              '<th>Comuna</th>'+
                              '<td>'+ notif.Oportunidad_Comuna +'</td>'+
                            '</tr>'+
                            '<tr>'+
                              '<th>Cargo</th>'+
                              '<td>'+ notif.Oportunidad_Cargo +'</td>'+
                              '<th>Renta</th>'+
                              '<td>'+ notif.Oportunidad_Renta +'</td>'+
                              '<td></td>'+
                              '<td></td>'+
                            '</tr>'+
                            '<tr>'+
                              '<th>Observación</th>'+
                              '<td colspan="5">'+ notif.Oportunidad_Observacion +'</td>'+
                            '</tr>'+
                          '</tbody>'+
                          '</table><br/>'+
                          '<table><tbody><tr>'+
                          '<th>'+notif.Titulo_Mensaje_Agente+'</th>'+
                          '<td>'+notif.Mensaje_Agente+
                          '</td>'+
                          '</tr>'+
                          '</table>'+
                          '</div>'+
                          '</body>'+
                          '</html>';

        return htmlBody;
    }

    public static Blob invite(Date fecha_entrevista, Time horaEntrevistaLink, String direccion, String comuna, String cliente) {
        Integer horaLink = horaEntrevistaLink.hour();
        Integer minLink = horaEntrevistaLink.minute();
        Integer holaFinalizacionLink = horaEntrevistaLink.hour() + 1;

        String startdatetime=String.valueof(fecha_entrevista)+ 'T' + String.valueof(horaLink)+':' +String.valueof(minLink)+':00';
        System.debug(startdatetime);

        String enddatetime=String.valueof(fecha_entrevista)+ 'T' + String.valueof(holaFinalizacionLink)+':' +String.valueof(minLink)+':00';
        System.debug(enddatetime);

        String txtInvite = '';

        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID::-//hacksw/handcal//NONSGML v1.0//EN\n';
        txtInvite += 'VERSION:2.0\n';
        txtInvite += 'METHOD:PUBLISH\n';
        txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
        txtInvite += 'BEGIN:VEVENT\n';
        txtInvite += 'CLASS:PUBLIC\n';
        txtInvite += 'CREATED:20091026T203709Z\n';
        txtInvite += 'DTEND:'+enddatetime+'\n';
        txtInvite += 'DTSTAMP:20191026T203709Z\n';
        txtInvite += 'DTSTART:'+startdatetime+'\n';
        txtInvite += 'LAST-MODIFIED:20091026T203709Z\n';
        txtInvite += 'LOCATION:'+direccion+','+comuna +',Chile,\n';
        txtInvite += 'PRIORITY:5\n';
        txtInvite += 'SEQUENCE:0\n';
        txtInvite += 'SUMMARY;';
        txtInvite += 'LANGUAGE=en-us:'+cliente+'\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
        txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
        txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR';

        return Blob.valueOf(txtInvite);
    }

}