/*******************************************************************************************
 *  NOMBRE                 : VSL_NotificacionLinksCorreoScheduler
 *  TIPO                   : APEX SCHEDULER
 *  REQUERIMIENTO          : PROYECTO LINKS - TELEVENTA LINKS
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE    - OBSERVACIONES
 *  1.0     - 20/06/2020 - JP. HERNANDEZ  - Creación de clase para envío de correos notificaciones Links
 * *****************************************************************************************/
global class VSL_NotificacionLinksCorreoScheduler Implements Schedulable{

    global void execute(SchedulableContext ctx)
    {
                sendmail();
    }
    global void sendmail()
    { 
        System.debug('@@@@ sendmail');

        String[] toAddresses = new String[]{}; 
        String[] toCc = new String[]{}; 
        String recordTypeLink = [SELECT Id FROM RecordType WHERE Name = 'Venta - Link'].Id;
        List<Opportunity> linksEnviados = new List<Opportunity>();

        List<Opportunity> oportunidadesHoy = [SELECT id, Name, StageName, Agente_de_venta__c, Agente_de_Venta__r.Email,
        Agente_de_Venta__r.ReportsTo.Email, Codigo_de_Link__c, Agente_de_Venta__r.Ciudad__r.Name, Agente_de_Venta__r.Name,
        Fecha_Entrevista__c, Hora_Entrevista__c, Direccion__c, Comuna__r.Name, Renta__c, Account.Name, AccountId, 
        Fecha_de_nacimiento__c, Telefono_activo__c, Account.PersonTitle, Observacion__c FROM Opportunity WHERE agente_asignado__c = true AND StageName ='Asignación'
         AND RecordTypeId =:recordTypeLink];

         System.debug('@@@@ oportunidadesHoy l:31 --> '+ oportunidadesHoy);

        String orgEmailAddressId = [SELECT Id FROM OrgWideEmailAddress WHERE Address='sfvida@security.cl'].Id;

        for (Opportunity opp : oportunidadesHoy) {

            opp.StageName = 'Links Enviado';
        }

        System.debug('@@@@ oportunidadesHoy l:40 --> '+ oportunidadesHoy);
        System.debug('@@@@ oportunidadesHoy.size l:41 --> '+ oportunidadesHoy.size());

        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

        system.debug(oportunidadesHoy);

        for (Opportunity cont: oportunidadesHoy) {
        
          if(!String.IsBlank(cont.Agente_de_Venta__r.Email) || cont.Agente_de_Venta__r.Email != null 
          || !String.isBlank(cont.Agente_de_Venta__c) || cont.Agente_de_venta__c !=null  ){

              if(!String.isBlank(cont.Agente_de_Venta__r.ReportsTo.Email) || cont.Agente_de_Venta__r.ReportsTo.Email != null){
                switch on cont.Agente_de_Venta__r.Ciudad__r.Name {
                  when  'IQUIQUE'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'ANTOFAGASTA' {
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'LA SERENA'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'VIÑA DEL MAR'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'RANCAGUA'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'TALCA'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'CONCEPCION'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'TEMUCO'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when 'PUERTO MONTT'{
                    toCc.add(cont.Agente_de_Venta__r.ReportsTo.Email);
                    system.debug('@@@@@ toCc --> '+ toCc);
                  }
                  when else {
                    
                  }
                }
              }                
                if(!String.isEmpty(cont.Agente_de_Venta__r.Email) || cont.Agente_de_Venta__r.Email != null){
 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                system.debug(cont.Fecha_Entrevista__c);
                String fecha_entrevista = cont.Fecha_Entrevista__c.format();
                String horaEntrevista = '';
                if (cont.Hora_Entrevista__c.hour() != null && cont.Hora_Entrevista__c != null ) {
                  Integer horaLink = cont.Hora_Entrevista__c.hour();
                  Integer minLink = cont.Hora_Entrevista__c.minute();
                  if(minLink==0){
                    horaEntrevista = String.valueOf(horaLink) + ':' + String.valueOf(minLink)+'0';
                  }
                  else{
                    horaEntrevista = String.valueOf(horaLink) + ':' + String.valueOf(minLink);
                  }
                  
                }
                String horaEntrevistaLink = ((horaEntrevista == null) ? '' : horaEntrevista);
                String fechaNacimiento = '';
                String codigoLink = '';
                String tempPhone = '';
                String tempRenta = '';
                String tempContactName = (String.isBlank(cont.Name)? '' : cont.Name);
                String tempDireccion = (String.isBlank(cont.Direccion__c)? '' : cont.Direccion__c);
                String tempCargo = (String.isBlank(cont.Account.PersonTitle)? '' : cont.Account.PersonTitle);
                String tempComuna = (String.isBlank(cont.Comuna__r.Name)? '' : cont.Comuna__r.Name);
                String tempObservacion = (String.isBlank(cont.Observacion__c)? '' : cont.Observacion__c);

                if(cont.Fecha_de_nacimiento__c!=null){
                    fechaNacimiento = String.valueOf(cont.Fecha_de_nacimiento__c.format());
                }
                if(cont.Renta__c !=null){
                  tempRenta = String.valueOf(cont.Renta__c);
                }
                if(cont.Codigo_de_Link__c!=null){
                    codigoLink = String.valueOf(cont.Codigo_de_Link__c);
                }

                if(cont.Telefono_activo__c!=null){
                    tempPhone = String.valueOf(cont.Telefono_activo__c);
                }

                String subject = 'Link :'+cont.Codigo_de_Link__c+
                +' Fecha Entrevista :'
                +fecha_entrevista+' '+horaEntrevistaLink;

                String htmlBody = 
                '<html><head><style>table, th, td {border: 1px solid #ddd;text-align: left;}table {border-collapse: collapse;width: 100%;}th, td {padding: 15px;}</style></head><body>'+
                '<div style="overflow-x:auto;">'+
                '<table><tbody><tr>'+
                    '<th>Cliente</th>'+
                    '<td>'+tempContactName+'</td>'+
                    '<th>Link</th>'+
                    '<td>'+codigoLink+'</td>'+
                    '<th>Agente</th>'+ 
                    '<td>'+ cont.Agente_de_Venta__r.Name +'</td>'+
                  '</tr>'+
                  '<tr>'+
                    '<th>Fecha Nacimiento</th>'+
                    '<td>'+fechaNacimiento+'</td>'+
                    '<th>Fecha Entrevista</th>'+
                    '<td>'+fecha_entrevista+'</td>'+
                    '<th>Hora Entrevista</th>'+
                    '<td>'+horaEntrevistaLink+'</td>'+
                    '</tr>'+
                  '<tr>'+
                    '<th>Teléfono Activo</th>'+
                    '<td>'+tempPhone+'</td>'+
                    '<th>Direccion</th>'+
                    '<td>'+tempDireccion+'</td>'+
                    '<th>Comuna</th>'+
                    '<td>'+tempComuna+'</td>'+
                  '</tr>'+
                  '<tr>'+
                    '<th>Cargo</th>'+
                    '<td>'+tempCargo+'</td>'+
                    '<th>Renta</th>'+
                    '<td>'+tempRenta+'</td>'+
                    '<td></td>'+
                    '<td></td>'+
                  '</tr>'+
                  '<tr>'+
                    '<th>Observación</th>'+
                    '<td colspan="5">'+tempObservacion+'</td>'+
                  '</tr>'+
                '</tbody>'+
                '</table><br/>'+
                '<table><tbody><tr>'+
                '<th>Decálogo del agente - Ítem 8 - No confirmar entrevistas</th>'+
                '<td>Deberá atender a todos los clientes que le sean derivados a través de Televenta, independiente del lugar físico donde este se encuentre. '+
                'No podrá chequear telefónicamente, en forma previa, la información de estos, ni la fecha u hora de entrevista, salvo que el documento así lo exprese claramente '+
                'Cuando realice la entrevista, deberá informar del resultado a la Cía.'+ 
                '</td>'+
                '</tr>'+
                '</table>'+
                '</div>'+
                '</body>'+
                '</html>';

                String nombreCuenta = cont.Name;
                toAddresses.add(cont.Agente_de_Venta__r.Email);
                system.debug(cont.Name);
                mail.setToAddresses(toAddresses);

                if (toCc.size() > 0) {
                  mail.setCcAddresses(toCc);
                }

                 //TMP
                 String[] bbcAddresses = new String[]{}; 
                 bbcAddresses.add('juespinoza@security.cl');
                 mail.setBccAddresses(bbcAddresses);
                 //TMP

                mail.setSubject(subject);
                mail.sethtmlBody(htmlBody);
                System.debug(htmlBody);
                mail.setTargetObjectId(cont.Agente_de_venta__c);
                mail.setOrgWideEmailAddressId(orgEmailAddressId);
                Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();   
                attach.filename = 'LINK AGENDADO.ics'; 
                attach.ContentType = 'text/calendar';     
                attach.inline = true;
                attach.body = invite(cont.Fecha_Entrevista__c, cont.Hora_Entrevista__c, tempDireccion, tempComuna, tempContactName );   
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach}); 
                System.debug(mail);
                mail.setSaveAsActivity(false);    
                mails.add(mail);
                System.debug(toAddresses);
                toAddresses.clear();
                toCc.clear();
                System.debug(toAddresses);
                linksEnviados.add(cont);
            }

          }
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