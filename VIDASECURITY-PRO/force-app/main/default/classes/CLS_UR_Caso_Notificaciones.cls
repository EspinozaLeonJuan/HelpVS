/**
 * @description       :
 * @author            : Juan Espinoza León
 * @group             :
 * @last modified on  : 10-24-2022
 * @last modified by  : Juan Espinoza León
**/
public class CLS_UR_Caso_Notificaciones {

    public Case Caso {get; set;}
    public Account CuentaPDF {get; set;}
    public Contact ContactoPDF {get; set;}

    public String IdCaso {get; set;}
    public String Estado {get; set;}

    public class DataMessage
    {
        public String Asunto {get; set;}

        public String Nombre {get; set;}

        public String Poliza {get; set;}

        public String Fecha {get; set;}

        public String ResponsableUR {get; set;}

        public String Comentario {get; set;}

    }

    public CLS_UR_Caso_Notificaciones() {

    }

	 //se envia correo a Cliente cuando se procesa exitosamente un rescate total o parcial
    public void EnviaNotificacion_RescateWeb(String id)
    {
        this.IdCaso = id;

        this.CargaDatosCaso();
        this.enviarEmail_RescateWeb();
    }

    public void EnviaNotificacion(String id, String estado, List<String> ccEmails, String comentario)
    {
        this.IdCaso = id;
        this.Estado = estado;

        this.CargaDatosCaso();
        Attachment adjunto = this.GeneraAdjunto();
        this.enviarEmail(adjunto, ccEmails, comentario);
    }

    public void EnviaNotificacion_Individual(String casoId, String estado, String tipoCarta, List<String> ccEmails, String comentario)
    {
        this.IdCaso = casoId;
        this.Estado = estado;
        this.CargaDatosCaso();

        if(this.Estado == 'En Revisión')
        {
            if (String.isNotBlank(tipoCarta) == true)
            {
                List<Carta_Caso__c> cartas = [SELECT Id FROM Carta_Caso__c WHERE IdCaso__c =: this.IdCaso AND Tipo__c =: tipoCarta];

                String IdCarta = '';

                if (cartas.size() > 0)
                {
                    IdCarta = cartas[0].Id;
                }

                if (String.isNotBlank(IdCarta))
                {
                    Attachment adjunto = this.GeneraAdjunto(tipoCarta, IdCarta);
                    this.enviarEmail_Individuales(adjunto, ccEmails, comentario);
                }
                else {
                    this.enviarEmail_Individuales(null, ccEmails, comentario);
                }
            }
            else {
                this.enviarEmail_Individuales(null, ccEmails, comentario);
            }

        }
        else {
              this.enviarEmail_Individuales(null, ccEmails, comentario);
        }
    }

    public void CargaDatosCaso()
    {
        try
        {
            system.debug('@@@@ CargaDatosCaso Caso => ' + this.IdCaso);

            this.Caso = [SELECT AccountId, Anular_aprobacion_reclamo_repetitivo__c, Apellidos__c, Aprobado_Reclamo__c, Atencion_Presencial__c,                      CASO_Activa_Flujo_Notificaci_n_Cliente__c, CASO_Asunto_Notificaci_n__c, CASO_Categoria__c, CASO_Mensaje_Notificaci_n__c,                         CASO_N_Poliza__c, CASO_Poliza_Asoc__c, CASO_Responsable_UR__c, CASO_Resultado_Derivaci_n__c, Campa_a_Mailing__c, Canal__c, Cantidad_Dias_Desde_Creacion__c, Cantidad_Dias__c, Cantidad_de_Dias_Abierto__c, Cantidad_de_dias_H__c, Cargo_Propietario__c, Carta_Cliente__c, CaseNumber, Casos_Hijos_cerrados__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c, Cliente_Colectivo__c, Cliente_Compania__c, ClosedDate, Colectivo_Banco_BCI__c, Comments, CommunityId, Complejidad_Numerico__c, Complejidad_del_Reclamo__c, Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c, Concepto__c, ContactEmail, ContactFax, ContactId, ContactMobile, ContactPhone, Correo_Electronico__c, Correo_Instancia_del_Reclamo__c, Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, CreatedById, CreatedDate, CreatorFullPhotoUrl, CreatorName, CreatorSmallPhotoUrl, Cumplimiento_Fecha_Cierre__c, D_as_restantes_para_cerrar_Reclamo__c, Descripcion__c, Descripcion_de_Respuesta__c, Description, Detalle_Operacion__c, Detalle_Solicitud__c, Detalle_de_Rescate__c, Dia_de_Creacion__c, Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c, Direccion_Solicitante__c, Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, Email_1__c, Email_2__c, Email_Contacto__c, EntitlementId, Entrega_Respuesta__c, Estado_Requerimiento_EscritorioDigital__c, Fecha_Cierre_Tope__c, Fecha_Hora_de_Cierre__c, Fecha_de_EPA_Contact_Center_Caso__c, Fecha_de_nacimiento__c, Fecha_tope_Vida_Security__c, Funci_n_Propietario_del_Caso__c, G_Asistencia_Agentes__c, Genero__c, IDVS__c, Id, IdPoliza__c, Id_Requerimiento_EscritorioDigital__c, Instancia_del_Reclamo__c, IsClosed, IsDeleted, Linea_Negocio_Final__c, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, Linea_Negocio__c, Llamadas_Out__c, MilestoneStatus, Negocio__c, Nombre_Completo_Razon_Social__c, Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Numero_del_Caso_Original__c, Origin, OwnerId, ParentId, Priority, Problema__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Reasignar_a_Rut__c, Reason, RecordTypeId, Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, SlaExitDate, SlaStartDate, Solicita_envio_a_otra_direccion__c, SourceId, Status, Subject, Sucursal_del_Propietario__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c, Tipo_Contacto_Final__c, Tipo_Operacion__c, Tipo_Requerimiento_EscritorioDigital__c, Tipo_de_Cliente__c, Tipo_de_Contacto__c,Tipo_de_Requerimiento__c, Tipo_de_Resoluci_n_del_Reclamo__c, Tipo_de_Solicitante__c, Type FROM Case WHERE Id =: this.IdCaso];
        }
        catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());

        }
    }

    public Attachment GeneraAdjunto()
    {
        this.CargaDatosCaso();

        system.debug('@@@@ Asunto en guardarAdjunto => ' + this.Caso.CASO_Asunto_Notificaci_n__c);
        system.debug('@@@@ Mensaje en guardarAdjunto => ' + this.Caso.CASO_Mensaje_Notificaci_n__c);

        PageReference pdf = Page.SEC_PDF_UR_Caso_Notificacion;
        pdf.getParameters().put('id', this.IdCaso);

        Attachment adjunto = new Attachment();

        if(this.Estado == 'En Revisión')
        {
            Blob cuerpo;

            try
            {
                cuerpo = pdf.getContentAsPDF();
            }
            catch (VisualforceException e)
            {
                system.debug('@@@@ ERROR => Generación PDF al derivar a ejecutivo: ' + e.getMessage());
            }

            adjunto.Body = cuerpo;
            adjunto.Name = 'PDF-NOTI-' + this.Caso.CaseNumber + '.pdf';
            adjunto.IsPrivate = false;
            adjunto.ParentId = IdCaso;

            if (!Test.isRunningTest())
            {
                insert adjunto;
            }

            system.debug(adjunto);
        }

        return adjunto;

    }

    public Attachment GeneraAdjunto(String tipoCarta, String IdCarta)
    {
        system.debug('@@@@ Asunto en guardarAdjunto => ' + this.Caso.CASO_Asunto_Notificaci_n__c);
        system.debug('@@@@ Mensaje en guardarAdjunto => ' + this.Caso.CASO_Mensaje_Notificaci_n__c);

        PageReference pdf = null;

        if (tipoCarta == 'SOBREPRIMA')
        {
            pdf = Page.SEC_PDF_UR_Caso_CartaSobreprima;
        }
        else if (tipoCarta == 'EXCLUSION')
        {
              pdf = Page.SEC_PDF_UR_Caso_CartaExclusion;
        }

        Attachment adjunto = null;

        if (pdf != null)
        {
            pdf.getParameters().put('id', IdCarta);

            try
            {
                adjunto = new Attachment();

                Blob cuerpo = pdf.getContentAsPDF();

                adjunto.Body = cuerpo;
                adjunto.Name = 'CARTA '+ tipoCarta + ' - CASO ' + this.Caso.CaseNumber + '.pdf';
                adjunto.IsPrivate = false;
                adjunto.ParentId = IdCaso;

                if (!Test.isRunningTest())
                {
                    insert adjunto;
                }

                system.debug(adjunto);

            }
            catch (VisualforceException e)
            {
                system.debug('@@@@ ERROR => Generación PDF al derivar a ejecutivo: ' + e.getMessage());
            }
        }

        return adjunto;
    }

    //Enviar email de notificación...
    public void enviarEmail(Attachment adjunto, List<String> ccEmails, String comentario)
    {
        try{
            DataMessage data = new DataMessage();

            system.debug('@@@@ PASO => Entro en enviarEmail: ' + this.Estado);

            List<String> direcciones = new List<String>();
            List<String> direccionesBcc = ccEmails;// new List<String>();
            List<String> direccionesCc = new List<String>();

            if(this.Caso.ContactEmail != null)
            {
                direcciones.add(this.Caso.ContactEmail);
                system.debug('@@@@ PASO => Entro por ContactEmail : ' + this.Caso.ContactEmail);
                system.debug('@@@@ PASO => Entro por Asunto : ' + this.Caso.CASO_Asunto_Notificaci_n__c);
                system.debug('@@@@ PASO => Entro por Comentario : ' + this.Caso.CASO_Mensaje_Notificaci_n__c);
            }

            if(this.Caso.Correo_electronico_Solicitante__c != null)
            {
                direcciones.add(this.Caso.Correo_electronico_Solicitante__c);
            }

            if(this.Caso.Correo_electronico_alternativo__c != null)
            {
                direcciones.add(this.Caso.Correo_electronico_alternativo__c);
            }

            List<Messaging.EmailFileAttachment> AdjCorreo = new List<Messaging.EmailFileAttachment>();

            Messaging.EmailFileAttachment adj = new Messaging.EmailFileAttachment();
            adj.setFileName(adjunto.Name);
            adj.setBody(adjunto.Body);
            adj.setContentType(adjunto.ContentType);
            AdjCorreo.add(adj);

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(direcciones);
            email.setBccAddresses(direccionesBcc);

            Contact contacto = null;

            if (this.Caso.ContactId != null)
            {
                contacto = [SELECT Id, Name FROM Contact WHERE Id =: this.Caso.ContactId];
            }

            if (contacto == null)
            {
                Account cuenta = [SELECT Id, Name FROM Account WHERE Id =: this.Caso.AccountId];
                data.Nombre = cuenta.Name;
            }
            else {
                data.Nombre = contacto.Name;
            }

            data.Asunto = this.Caso.CASO_Asunto_Notificaci_n__c;

            //Envío de archivos Cobranzas Vida
            if (this.Caso.Origin == 'Cobranzas Vida' || this.Caso.Origin == 'Recepción Pagos' || this.Caso.Origin == 'Producción Individuales') {
                List<Messaging.EmailFileAttachment> AdjCorreoCob = new List<Messaging.EmailFileAttachment>();

                List<Attachment> LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, Body, ContentType, LastModifiedDate FROM Attachment Where ParentId =: this.Caso.Id ORDER BY CreatedDate DESC];

                for(Attachment att : LST_AdjuntosCasoUR) {
                    Messaging.EmailFileAttachment adj2 = new Messaging.EmailFileAttachment();
                    adj2.setFileName(att.Name);
                    adj2.setBody(att.Body);
                    adj2.setContentType(att.ContentType);
                    AdjCorreoCob.add(adj2);
                }

                if(!AdjCorreoCob.isEmpty()) {
                    email.setFileAttachments(AdjCorreoCob);
                }
            }

            if (this.CuentaPDF != null)
            {
                if(this.CuentaPDF.IsPersonAccount == true)
                {
                    email.setTargetObjectId(this.CuentaPDF.PersonContactId);
                }
                else
                {
                    email.setTargetObjectId(this.ContactoPDF.Id);
                }
            }
            else
            {
                if (this.ContactoPDF != null)
                {
                    email.setTargetObjectId(this.ContactoPDF.Id);
                }
                else
                {
                    email.setTargetObjectId(this.Caso.ContactId);
                }
            }

            email.setWhatId(this.Caso.Id);

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'contactovida@security.cl'];

            if ( owea.size() > 0 )
            {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            email.setSaveAsActivity(true);

            EmailTemplate ET;

            if(this.Estado == 'En Revisión') //Devolver a Ejecutivo
            {

                data.Poliza = this.Caso.CASO_Poliza_Asoc__c;

                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti DevEje - A'].Id);

                if(this.Caso.Nombre_Solicitante__c != null)
                {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti DevEje - B'].Id);
                    data.Nombre = this.Caso.Nombre_Solicitante__c;
                }

                email.setFileAttachments(AdjCorreo);
            }
            else if(this.Estado == 'Rechazado')
            {
                data.Poliza = this.Caso.CASO_Poliza_Asoc__c;

                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - A'].Id);

                if(this.Caso.Nombre_Solicitante__c != null)
                {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - B'].Id);
                    data.Nombre = this.Caso.Nombre_Solicitante__c;
                }

                if (this.Caso.Origin == 'Cobranzas Vida' || this.Caso.Origin == 'Recepción Pagos') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - Cobranza'].Id);
                    data.Poliza = '';
                }

                if (this.Caso.Origin == 'Producción Individuales') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - Producción Individuales'].Id);
                    data.Poliza = '';
                    Usuario_Backup__c ubackup = [SELECT Id, Name FROM Usuario_Backup__c WHERE ID =: this.Caso.CASO_Responsable_UR__c];
                    data.ResponsableUR = ubackup.Name;
                }
            }
            else if(this.Estado == 'Cerrado'){ //Cierre
                data.Poliza = this.Caso.CASO_Poliza_Asoc__c;
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - A'].Id);

                if (this.Caso.Nombre_Solicitante__c != null) {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - B'].Id);
                }

                if (this.Caso.Origin == 'Cobranzas Vida' || this.Caso.Origin == 'Recepción Pagos') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Cobranza'].Id);
                    data.Comentario = this.Caso.CASO_Mensaje_Notificaci_n__c;
                    data.Poliza = '';
                }
                else if (this.Caso.Origin == 'Producción Individuales') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Producción Individuales'].Id);
                    data.Poliza = '';
                    Usuario_Backup__c ubackup = [SELECT Id, Name FROM Usuario_Backup__c WHERE ID =: this.Caso.CASO_Responsable_UR__c];
                    data.ResponsableUR = ubackup.Name;
                }
            }

            system.debug('@@@@ PASO => Va a Enviar Correo : ');

            if (!Test.isRunningTest())
            {
                Messaging.SendEmailResult[] resultadoEnvio = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }

        } catch(system.Exception ex){
            system.debug('@@@@ ERROR => Enviar notificación a Cliente: ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }

    public void enviarEmail_Individuales(Attachment adjunto, List<String> ccEmails, String comentario)
    {
        try
        {
            DataMessage data = new DataMessage();

            List<String> direcciones = new List<String>();
            List<String> direccionesBcc = ccEmails;
            List<String> direccionesCc = new List<String>();

            if(this.Caso.ContactEmail != null){
                direcciones.add(this.Caso.ContactEmail);
                system.debug('@@@@ PASO => Entro por ContactEmail : ' + this.Caso.ContactEmail);
                system.debug('@@@@ PASO => Entro por Asunto : ' + this.Caso.CASO_Asunto_Notificaci_n__c);
                system.debug('@@@@ PASO => Entro por Comentario : ' + this.Caso.CASO_Mensaje_Notificaci_n__c);
            }

            if(this.Caso.Correo_electronico_Solicitante__c != null){
                direcciones.add(this.Caso.Correo_electronico_Solicitante__c);
            }

            if(this.Caso.Correo_electronico_alternativo__c != null){
                direcciones.add(this.Caso.Correo_electronico_alternativo__c);
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(direcciones);
            email.setBccAddresses(direccionesBcc);

            system.debug('@@@@ PASO => this.Caso.ContactId : ' + this.Caso.ContactId);

            if (this.Caso.ContactId != null)
            {
                email.setTargetObjectId(this.Caso.ContactId);
            }
            else {
                email.setTargetObjectId(this.Caso.AccountId);
            }

            email.setWhatId(this.Caso.Id);

            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'contactovida@security.cl'];

            if ( owea.size() > 0 )
            {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }

            email.setSaveAsActivity(true);

            EmailTemplate ET;

            data.Nombre = this.Caso.Nombre_Completo_Razon_Social__c;
            data.Poliza = this.Caso.CASO_Poliza_Asoc__c;
            data.Comentario = this.Caso.CASO_Mensaje_Notificaci_n__c;
            data.Fecha = this.Caso.CreatedDate.format('dd-MM-YYYY');
            data.Asunto = this.Caso.CASO_Asunto_Notificaci_n__c;

            if(this.Estado == 'En Revisión'){ //Devolver a Ejecutivo
                ET = [Select Id,Body, HtmlValue,Subject FROM EmailTemplate Where Name = 'SEC Notifica Endoso - Pendiente'];

                List<Messaging.EmailFileAttachment> AdjCorreo = new List<Messaging.EmailFileAttachment>();

                system.debug('@@@@ PASO => adjunto : ' + adjunto);

                if (adjunto != null)
                {
                    Messaging.EmailFileAttachment adj = new Messaging.EmailFileAttachment();
                    adj.setFileName(adjunto.Name);
                    adj.setBody(adjunto.Body);
                    adj.setContentType(adjunto.ContentType);
                    AdjCorreo.add(adj);
                }

                system.debug('@@@@ PASO => AdjCorreo : ' + AdjCorreo.size());

                if (AdjCorreo.size() > 0)
                {
                    email.setFileAttachments(AdjCorreo);
                }
            }
            else if(this.Estado == 'Rechazado')
            { //Rechazado
                ET = [Select id,Body, HtmlValue,Subject FROM EmailTemplate Where Name = 'SEC Notifica Endoso - Rechazada'];
            }
            else if(this.Estado == 'Cerrado')
            {
                ET= [Select id,Body, HtmlValue,Subject FROM EmailTemplate Where Name = 'SEC Notifica Endoso - Realizada'];
            }

            email.setTemplateId(ET.Id);

            system.debug('@@@@ PASO => Va a Enviar Correo : '+ email);

            if (!Test.isRunningTest())
            {
                Messaging.SendEmailResult[] resultadoEnvio = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }

        } catch(system.Exception ex){
            system.debug('@@@@ ERROR => Enviar notificación a Cliente: ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
        }
    }

     public void enviarEmail_RescateWeb()
     {
         try{
             List<String> direcciones = new List<String>();
             List<String> direccionesBcc = new List<String>();
             List<String> direccionesCc = new List<String>();

             system.debug('@@@@ PASO => Caso.ContactEmail : ' + this.Caso.ContactEmail);
             system.debug('@@@@ PASO => Caso.Correo_Electronico__c : ' + this.Caso.Correo_Electronico__c);
             system.debug('@@@@ PASO => Caso.SuppliedEmail : ' + this.Caso.SuppliedEmail);

             if (String.isNotBlank(this.Caso.ContactEmail))
             {
                direcciones.add(this.Caso.ContactEmail);
             }

             if (String.isNotBlank(this.Caso.Correo_Electronico__c) && direcciones.contains(this.Caso.Correo_Electronico__c) == false)
             {
                direcciones.add(this.Caso.Correo_Electronico__c);
             }

             if (String.isNotBlank(this.Caso.SuppliedEmail) && direcciones.contains(this.Caso.SuppliedEmail) == false)
             {
                direcciones.add(this.Caso.SuppliedEmail);
             }

             if (String.isNotBlank(this.Caso.Correo_electronico_alternativo__c) && direcciones.contains(this.Caso.Correo_electronico_alternativo__c) == false){
                direcciones.add(this.Caso.Correo_electronico_alternativo__c);
             }

             Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

             email.setToAddresses(direcciones);
             email.setBccAddresses(direccionesBcc);

             email.setWhatId(this.Caso.Id);
             email.setTargetObjectId(this.Caso.ContactId);

             OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'contactovida@security.cl'];

             if ( owea.size() > 0 )
             {
                 email.setOrgWideEmailAddressId(owea.get(0).Id);
             }

             email.setSaveAsActivity(true); //true guarda correo electronico
             system.debug('@@@@ Detalle Solicitud  '+this.Caso.Detalle_Solicitud__c);
            if (this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Total'){
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC Notifica Rescate Total'].Id);
            }
            else if (this.Caso.Detalle_Solicitud__c == 'ED - Solicitud de Rescate Parcial'){
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC Notifica Rescate Parcial'].Id);
            }

            system.debug('@@@@ PASO => Va a Enviar Correo : ');

            if (!Test.isRunningTest())
            {
                Messaging.SendEmailResult[] resultadoEnvio = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
            }
         }
         catch(system.Exception ex)
         {
             system.debug('@@@@ ERROR => Enviar notificación a Cliente: ' + ex.getMessage() + '; Línea => ' + ex.getLineNumber());
         }
     }

}