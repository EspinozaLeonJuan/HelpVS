/*******************************************************************************************
*  NOMBRE                 : CLS_generaPDFdevejecutivo
*  TIPO				   : APEX CLASS
*  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
*  1.1     - 04/12/2018 - I.SALAZAR 	   - Modificaciones para UR Cobranza
*  1.2     - 12/02/2018 - I.SALAZAR        - Modificaciones para UR Producción Individuales - Plantilla para Cierre y Rechazo de Caso
*****************************************************************************************/
public class CLS_generaPDFdevejecutivo {
    
    public String IDCAS_PDF {get; set;}
    public Case CASO_PDF {get; set;}
    public Account ACCOU_PDF {get; set;}
    public Contact CONTA_PDF {get; set;}
    public Poliza__c POLIZ_PDF {get; set;}
    public Date FECHA_PDF {get; set;}
    public String MESFE_PDF {get; set;}
    public String CLIEN_PDF {get; set;}
    public String NPOLI_PDF {get; set;}
    public String NCASO_PDF {get; set;}
    public String ASUNT_PDF {get; set;}
    public String COMEN_PDF {get; set;}
    public String UNOMB_PDF {get; set;}
    public String UCARG_PDF {get; set;}
    public String COMPA_PDF {get; set;}
    public Case CASO_PDF2 {get; set;}
    public Account ACCOU_PDF2 {get; set;}
    public Contact CONTA_PDF2 {get; set;}
    public Poliza__c POLIZ_PDF2 {get; set;}
    public Date FECHA_PDF2 {get; set;}
    public String MESFE_PDF2 {get; set;}
    public String CLIEN_PDF2 {get; set;}
    public String NPOLI_PDF2 {get; set;}
    public String NCASO_PDF2 {get; set;}
    public String ASUNT_PDF2 {get; set;}
    public String COMEN_PDF2 {get; set;}
    public String UNOMB_PDF2 {get; set;}
    public String UCARG_PDF2 {get; set;}
    public String COMPA_PDF2 {get; set;}    
    public List<String> direcciones {get; set;}
    public List<String> direccionesBcc {get; set;}
    public List<Attachment> LST_AdjuntosCasoUR { get; set;}
    
    //Constructor...
    public PageReference cargaPDF(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                IDCAS_PDF = ApexPages.currentPage().getParameters().get('id');
                ASUNT_PDF = ApexPages.currentPage().getParameters().get('asunto');
                COMEN_PDF = ApexPages.currentPage().getParameters().get('comentario');
            }
            
            //Objeto caso...
            CASO_PDF = [SELECT AccountId, Anular_aprobacion_reclamo_repetitivo__c, Apellidos__c, Aprobado_Reclamo__c, 
                        Atencion_Presencial__c, BusinessHoursId, CASO_Activa_Flujo_Notificaci_n_Cliente__c, 
                        CASO_Asunto_Notificaci_n__c, CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_Mensaje_Notificaci_n__c, 
                        CASO_N_Poliza__c, CASO_Poliza_Asoc__c, CASO_Responsable_UR__c, CASO_Resultado_Derivaci_n__c, 
                        Campa_a_Mailing__c, Canal__c, Cantidad_Dias_Desde_Creacion__c, Cantidad_Dias__c, 
                        Cantidad_de_Dias_Abierto__c, Cantidad_de_dias_H__c, Cargo_Propietario__c, Carta_Cliente__c, 
                        CaseNumber, Casos_Hijos_cerrados__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, 
                        Ciudad_Solicitante__c, Cliente_Colectivo__c, Cliente_Compania__c, ClosedDate, Colectivo_Banco_BCI__c, 
                        Comments, CommunityId, Complejidad_Numerico__c, Complejidad_del_Reclamo__c, Comuna_Comercial__c, 
                        Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c, Concepto__c, ContactEmail, ContactFax, 
                        ContactId, ContactMobile, ContactPhone, Correo_Electronico__c, Correo_Instancia_del_Reclamo__c, 
                        Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, CreatedById, CreatedDate, 
                        CreatorFullPhotoUrl, CreatorName, CreatorSmallPhotoUrl, Cumplimiento_Fecha_Cierre__c, 
                        D_as_restantes_para_cerrar_Reclamo__c, Descripcion__c, Descripcion_de_Respuesta__c, Description, 
                        Detalle_Operacion__c, Detalle_Solicitud__c, Detalle_de_Rescate__c, Dia_de_Creacion__c, 
                        Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c, Direccion_Solicitante__c, 
                        Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, 
                        Email_1__c, Email_2__c, Email_Contacto__c, EntitlementId, Entrega_Respuesta__c, 
                        Estado_Requerimiento_EscritorioDigital__c, Fecha_Cierre_Tope__c, Fecha_Hora_de_Cierre__c, 
                        Fecha_de_EPA_Contact_Center_Caso__c, Fecha_de_nacimiento__c, Fecha_tope_Vida_Security__c, 
                        Funci_n_Propietario_del_Caso__c, G_Asistencia_Agentes__c, Genero__c, IDVS__c, Id, IdPoliza__c, 
                        Id_Requerimiento_EscritorioDigital__c, Instancia_del_Reclamo__c, IsClosed, IsDeleted, IsEscalated, 
                        IsStopped, LInea_Negocio_Final__c, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, 
                        Linea_Negocio__c, Llamadas_Out__c, MilestoneStatus, Negocio__c, Nombre_Completo_Razon_Social__c, 
                        Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Numero_de_Caso_Anterior__c, 
                        Numero_de_Caso_Inicial__c, Numero_del_Caso_Original__c, Origin, OwnerId, ParentId, PolizaED__c, 
                        Priority, Problema__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Reasignar_a_Rut__c, 
                        Reason, RecordTypeId, Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, SlaExitDate, 
                        SlaStartDate, Solicita_envio_a_otra_direccion__c, SourceId, Status, StopStartDate, Subject, 
                        Sucursal_del_Propietario__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, 
                        Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c, Tipo_Contacto_Final__c, 
                        Tipo_Operacion__c, Tipo_Requerimiento_EscritorioDigital__c, Tipo_de_Cliente__c, Tipo_de_Contacto__c, 
                        Tipo_de_Requerimiento__c, Tipo_de_Resoluci_n_del_Reclamo__c, Tipo_de_Solicitante__c, Type 
                        FROM Case
                        WHERE Id =: IDCAS_PDF];
            
            if(CASO_PDF != null){
                
                //Rescate Cuenta o Contacto Asociado o Solicitante
                if(CASO_PDF.AccountId != null){
                    ACCOU_PDF = [SELECT Id, Name, IsPersonAccount, PersonEmail, PersonContactId FROM Account WHERE Id =: CASO_PDF.AccountId];
                    if(ACCOU_PDF != null){
                        if(ACCOU_PDF.IsPersonAccount == True){
                            CLIEN_PDF = ACCOU_PDF.Name;
                        }else{
                            if(CASO_PDF.ContactId != null){
                                CONTA_PDF = [SELECT Id, Name, Email FROM Contact WHERE Id =: CASO_PDF.ContactId];
                                if(CONTA_PDF != null){
                                    CLIEN_PDF = CONTA_PDF.Name;
                                }
                            }
                        }
                    }
                }else{
                    CLIEN_PDF = CASO_PDF.Nombre_Solicitante__c;
                }
                
                //Rescate Póliza Asociada
                if(CASO_PDF.CASO_N_Poliza__c != null){
                    POLIZ_PDF = [SELECT Id, Name, Cuenta__c FROM Poliza__c WHERE Id =: CASO_PDF.CASO_N_Poliza__c];
                    if(POLIZ_PDF != null){
                        NPOLI_PDF = POLIZ_PDF.Name;
                    }
                }
                
                //Rescate otros datos...
                FECHA_PDF = Date.today();
                String[] meses = new List<String>(20);
                meses[1] = 'Enero';
                meses[2] = 'Febrero';
                meses[3] = 'Marzo';
                meses[4] = 'Abril';
                meses[5] = 'Mayo';
                meses[6] = 'Junio';
                meses[7] = 'Julio';
                meses[8] = 'Agosto';
                meses[9] = 'Septiembre';
                meses[10] = 'Octubre';
                meses[11] = 'Noviembre';
                meses[12] = 'Diciembre';
                MESFE_PDF = meses[FECHA_PDF.month()];
                
                
                
                NCASO_PDF = CASO_PDF.CaseNumber;
                //ASUNT_PDF = CASO_PDF.CASO_Asunto_Notificaci_n__c;
                //COMEN_PDF = CASO_PDF.CASO_Mensaje_Notificaci_n__c;
                
                
                system.debug('@@@@ Asunto => ' + CASO_PDF.CASO_Asunto_Notificaci_n__c);
                system.debug('@@@@ Mensaje => ' + CASO_PDF.CASO_Mensaje_Notificaci_n__c);
                system.debug('@@@@ Asunto => ' + ASUNT_PDF);
                system.debug('@@@@ Mensaje => ' + COMEN_PDF);
                
                /*
UNOMB_PDF = UserInfo.getName();
UCARG_PDF = [SELECT Id, Title FROM User WHERE Id =: UserInfo.getUserId()].Title;
COMPA_PDF = UserInfo.getOrganizationName();
*/
                UNOMB_PDF = 'Hernán Ríos L.';
                UCARG_PDF = 'Gerente de Clientes';
                COMPA_PDF = 'Vida Security S.A.';        
                
                
            }
            
            return null;
            
        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
            return null;
        }
        
    }
    
    public void cargaDatosCaso(String Caso){        
        try {
            
            system.debug('@@@@ cargaDatosCaso Caso => ' + Caso);
            
            //Objeto caso...
            CASO_PDF2 = [SELECT AccountId, Anular_aprobacion_reclamo_repetitivo__c, Apellidos__c, Aprobado_Reclamo__c, 
                         Atencion_Presencial__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, 
                         CASO_Asunto_Notificaci_n__c, CASO_Categoria__c, CASO_Mensaje_Notificaci_n__c, 
                         CASO_N_Poliza__c, CASO_Poliza_Asoc__c, CASO_Responsable_UR__c, CASO_Resultado_Derivaci_n__c, 
                         Campa_a_Mailing__c, Canal__c, Cantidad_Dias_Desde_Creacion__c, Cantidad_Dias__c, 
                         Cantidad_de_Dias_Abierto__c, Cantidad_de_dias_H__c, Cargo_Propietario__c, Carta_Cliente__c, 
                         CaseNumber, Casos_Hijos_cerrados__c, Celular__c, Ciudad_Comercial__c, Ciudad_Particular__c, 
                         Ciudad_Solicitante__c, Cliente_Colectivo__c, Cliente_Compania__c, ClosedDate, Colectivo_Banco_BCI__c, 
                         Comments, CommunityId, Complejidad_Numerico__c, Complejidad_del_Reclamo__c, Comuna_Comercial__c, 
                         Comuna_Particular__c, Comuna_Solicitante__c, Concepto_Final__c, Concepto__c, ContactEmail, ContactFax, 
                         ContactId, ContactMobile, ContactPhone, Correo_Electronico__c, Correo_Instancia_del_Reclamo__c, 
                         Correo_electronico_Solicitante__c, Correo_electronico_alternativo__c, CreatedById, CreatedDate, 
                         CreatorFullPhotoUrl, CreatorName, CreatorSmallPhotoUrl, Cumplimiento_Fecha_Cierre__c, 
                         D_as_restantes_para_cerrar_Reclamo__c, Descripcion__c, Descripcion_de_Respuesta__c, Description, 
                         Detalle_Operacion__c, Detalle_Solicitud__c, Detalle_de_Rescate__c, Dia_de_Creacion__c, 
                         Direccion_Comercial__c, Direccion_Particular__c, Direccion_Postal_Alternativa__c, Direccion_Solicitante__c, 
                         Direccion_envio_respuesta__c, Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, 
                         Email_1__c, Email_2__c, Email_Contacto__c, EntitlementId, Entrega_Respuesta__c, 
                         Estado_Requerimiento_EscritorioDigital__c, Fecha_Cierre_Tope__c, Fecha_Hora_de_Cierre__c, 
                         Fecha_de_EPA_Contact_Center_Caso__c, Fecha_de_nacimiento__c, Fecha_tope_Vida_Security__c, 
                         Funci_n_Propietario_del_Caso__c, G_Asistencia_Agentes__c, Genero__c, IDVS__c, Id, IdPoliza__c, 
                         Id_Requerimiento_EscritorioDigital__c, Instancia_del_Reclamo__c, IsClosed, IsDeleted, 
                         Linea_Negocio_Final__c, LastModifiedById, LastModifiedDate, LastReferencedDate, LastViewedDate, 
                         Linea_Negocio__c, Llamadas_Out__c, MilestoneStatus, Negocio__c, Nombre_Completo_Razon_Social__c, 
                         Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Numero_de_Caso_Anterior__c, 
                         Numero_de_Caso_Inicial__c, Numero_del_Caso_Original__c, Origin, OwnerId, ParentId, 
                         Priority, Problema__c, Producto__c, RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Reasignar_a_Rut__c, 
                         Reason, RecordTypeId, Region_Comercial__c, Region_Particular__c, Region_Solicitante__c, SlaExitDate, 
                         SlaStartDate, Solicita_envio_a_otra_direccion__c, SourceId, Status, Subject, 
                         Sucursal_del_Propietario__c, SuppliedCompany, SuppliedEmail, SuppliedName, SuppliedPhone, SystemModstamp, 
                         Telefono_Comercial__c, Telefono_Particular__c, Telefono_Solicitante__c, Tipo_Contacto_Final__c, 
                         Tipo_Operacion__c, Tipo_Requerimiento_EscritorioDigital__c, Tipo_de_Cliente__c, Tipo_de_Contacto__c, 
                         Tipo_de_Requerimiento__c, Tipo_de_Resoluci_n_del_Reclamo__c, Tipo_de_Solicitante__c, Type 
                         FROM Case
                         WHERE Id =: Caso];
            
            if(CASO_PDF2 != null){
                
                system.debug('@@@@ Entro con Caso CASO_PDF2 => ' + Caso);
                
                //Rescate Cuenta o Contacto Asociado o Solicitante
                if(CASO_PDF2.AccountId != null){
                    ACCOU_PDF2 = [SELECT Id, Name, IsPersonAccount, PersonEmail, PersonContactId FROM Account WHERE Id =: CASO_PDF2.AccountId];
                    if(ACCOU_PDF2 != null){
                        if(ACCOU_PDF2.IsPersonAccount == True){
                            CLIEN_PDF2 = ACCOU_PDF2.Name;
                        }else{
                            if(CASO_PDF2.ContactId != null){
                                CONTA_PDF2 = [SELECT Id, Name, Email FROM Contact WHERE Id =: CASO_PDF2.ContactId];
                                if(CONTA_PDF2 != null){
                                    CLIEN_PDF2 = CONTA_PDF2.Name;
                                }
                            }
                        }
                    }
                }else{
                    CLIEN_PDF2 = CASO_PDF2.Nombre_Solicitante__c;
                }
                
                //Rescate Póliza Asociada
                if (!Test.isRunningTest()) 
                { 
                    if(CASO_PDF2.CASO_N_Poliza__c != null){
                        POLIZ_PDF2 = [SELECT Id, Name, Cuenta__c FROM Poliza__c WHERE Id =: CASO_PDF2.CASO_N_Poliza__c];
                        if(POLIZ_PDF2 != null){
                            NPOLI_PDF2 = POLIZ_PDF2.Name;
                        }
                    }
                }           	   
                
                
                //Rescate otros datos...
                FECHA_PDF2 = Date.today();
                String[] meses = new List<String>(20);
                meses[1] = 'Enero';
                meses[2] = 'Febrero';
                meses[3] = 'Marzo';
                meses[4] = 'Abril';
                meses[5] = 'Mayo';
                meses[6] = 'Junio';
                meses[7] = 'Julio';
                meses[8] = 'Agosto';
                meses[9] = 'Septiembre';
                meses[10] = 'Octubre';
                meses[11] = 'Noviembre';
                meses[12] = 'Diciembre';
                MESFE_PDF2 = meses[FECHA_PDF2.month()];
                
                
                NCASO_PDF2 = CASO_PDF2.CaseNumber;
                ASUNT_PDF2 = CASO_PDF2.CASO_Asunto_Notificaci_n__c;
                COMEN_PDF2 = CASO_PDF2.CASO_Mensaje_Notificaci_n__c;
                
                system.debug('@@@@ Asunto Carga Inicial => ' + ASUNT_PDF2);
                
                system.debug('@@@@ Comentario Carga Inicial => ' + COMEN_PDF2);
                
                /*
UNOMB_PDF = UserInfo.getName();
UCARG_PDF = [SELECT Id, Title FROM User WHERE Id =: UserInfo.getUserId()].Title;
COMPA_PDF = UserInfo.getOrganizationName();
*/
                UNOMB_PDF2 = 'Hernán Ríos L.';
                UCARG_PDF2 = 'Gerente de Clientes';
                COMPA_PDF2 = 'Vida Security S.A.';        
                
                
            }
            
            
        }catch(system.Exception ex){
            system.debug('@@@@ ERROR => ' + ex.getMessage());
            
        }
        
    }    
    
    //Guardar PDF y adjuntar al Caso...
    public void guardarAdjunto(String IDCASO, String ESTADO) {
        
        cargaDatosCaso(IDCASO);
        
        system.debug('@@@@ Asunto en guardarAdjunto => ' + CASO_PDF2.CASO_Asunto_Notificaci_n__c);
        system.debug('@@@@ Mensaje en guardarAdjunto => ' + CASO_PDF2.CASO_Mensaje_Notificaci_n__c);
        
        PageReference pdf = Page.SEC_VF_UR_pdfderivaejec;
        pdf.getParameters().put('id', IDCASO);
        pdf.getParameters().put('asunto', CASO_PDF2.CASO_Asunto_Notificaci_n__c);
        pdf.getParameters().put('comentario', CASO_PDF2.CASO_Mensaje_Notificaci_n__c);
        
        CLS_generaPDFdevejecutivo con = new CLS_generaPDFdevejecutivo();
        
        Attachment adjunto = new Attachment();
        
        if(ESTADO == '3'){
            Blob cuerpo;
            
            try {
                
                cuerpo = pdf.getContentAsPDF();
                
            } catch (VisualforceException e) {
                system.debug('@@@@ ERROR => Generación PDF al derivar a ejecutivo: ' + e.getMessage());
                
            }
            
            adjunto.Body = cuerpo;
            adjunto.Name = 'PDF-NOTI-' + CASO_PDF2.CaseNumber + '.pdf';
            adjunto.IsPrivate = false;
            adjunto.ParentId = IDCASO;
            
            if (!Test.isRunningTest())                     
            {
                insert adjunto;
            }   
            
            system.debug(adjunto);
        }
        
        enviarEmail(adjunto,ESTADO);        
    }
    
    
    
    //Enviar email de notificación...
    public void enviarEmail(Attachment adjunto,String ESTADO){
        try{
            system.debug('@@@@ PASO => Entro en enviarEmail: ' + ESTADO);
            
            direcciones = new List<String>();
            direccionesBcc = new List<String>();
            
            if (true)
            {                
                if(CASO_PDF2.ContactEmail != null){
                    direcciones.add(CASO_PDF2.ContactEmail);
                    system.debug('@@@@ PASO => Entro por ContactEmail : ' + CASO_PDF2.ContactEmail);
                    system.debug('@@@@ PASO => Entro por Asunto : ' + CASO_PDF2.CASO_Asunto_Notificaci_n__c);
                    system.debug('@@@@ PASO => Entro por Comentario : ' + CASO_PDF2.CASO_Mensaje_Notificaci_n__c);                                
                    
                }
                if(CASO_PDF2.Correo_electronico_Solicitante__c != null){
                    direcciones.add(CASO_PDF2.Correo_electronico_Solicitante__c); 
                }
                if(CASO_PDF2.Correo_electronico_alternativo__c != null){
                    direcciones.add(CASO_PDF2.Correo_electronico_alternativo__c);
                }                
            }
            
            direccionesBcc.add('cavidal@security.cl');                                  
            
            //direcciones.add(UserInfo.getUserEmail());
            List<Messaging.EmailFileAttachment> AdjCorreo = new List<Messaging.EmailFileAttachment>();
            Messaging.EmailFileAttachment adj = new Messaging.EmailFileAttachment();          
            adj.setFileName(adjunto.Name);
            adj.setBody(adjunto.Body);
            adj.setContentType(adjunto.ContentType);
            AdjCorreo.add(adj);
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(direcciones);
            email.setBccAddresses(direccionesBcc);
            
            //Envío de archivos Cobranzas Vida
            if (CASO_PDF2.Origin == 'Cobranzas Vida' || CASO_PDF2.Origin == 'Recepción Pagos' || CASO_PDF2.Origin == 'Producción Individuales') {
                List<Messaging.EmailFileAttachment> AdjCorreoCob = new List<Messaging.EmailFileAttachment>();
                LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, Body, ContentType, LastModifiedDate FROM Attachment Where ParentId =: CASO_PDF2.Id ORDER BY CreatedDate DESC];
                
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
            
            if (ACCOU_PDF2 != null) {
                if(ACCOU_PDF2.IsPersonAccount == true){
                    email.setTargetObjectId(ACCOU_PDF2.PersonContactId);
                }else{
                    email.setTargetObjectId(CONTA_PDF2.Id);
                }
            } else {
                if (CONTA_PDF2 != null) {
                    email.setTargetObjectId(CONTA_PDF2.Id);
                } else {
                    email.setTargetObjectId(CASO_PDF2.ContactId);
                } 
            }
            
            //email.setTargetObjectId(CASO_PDF2.Id);
            //email.setTargetObjectId(UserInfo.getUserId());
            
            email.setWhatId(CASO_PDF2.Id);
            //email.setSenderDisplayName(UserInfo.getName());
            //email.setSenderDisplayName('Vida Security');
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'contactovida@security.cl'];
            if ( owea.size() > 0 ) {
                email.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            email.setSaveAsActivity(false);
            if(ESTADO == '3'){ //Devolver a Ejecutivo
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti DevEje - A'].Id);             
                if(CASO_PDF2.Nombre_Solicitante__c != null){
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti DevEje - B'].Id);  
                }
                
                email.setFileAttachments(AdjCorreo);                
            }
            
            if(ESTADO == '2'){ //Rechazado
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - A'].Id);            
                if(CASO_PDF2.Nombre_Solicitante__c != null){
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Rechazo - B'].Id);  
                }
                
                if (CASO_PDF2.Origin == 'Cobranzas Vida' || CASO_PDF2.Origin == 'Recepción Pagos') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Cobranza'].Id); 
                }
                
                if (CASO_PDF2.Origin == 'Producción Individuales') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Producción Individuales'].Id); 
                }
            }
            
            if(ESTADO == '1'){ //Cierre
                email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - A'].Id);             
                if (CASO_PDF2.Nombre_Solicitante__c != null) {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - B'].Id);  
                }
                
                if (CASO_PDF2.Origin == 'Cobranzas Vida' || CASO_PDF2.Origin == 'Recepción Pagos') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Cobranza'].Id); 
                }
                
                if (CASO_PDF2.Origin == 'Producción Individuales') {
                    email.setTemplateId([SELECT Id, Name FROM EmailTemplate WHERE Name = 'SEC - Noti Cierre - Producción Individuales'].Id);
                    email.setSaveAsActivity(true);
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
}