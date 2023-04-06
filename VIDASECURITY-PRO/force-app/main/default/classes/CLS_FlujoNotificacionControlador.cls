/*******************************************************************************************
*  NOMBRE                 : CLS_FlujoNotificacionControlador
*  TIPO                   : APEX CLASS
*  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
* 
* *****************************************************************************************
*  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
*  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
*  1.1     - 01/11/2018 - IS - JE          - Cierre automático de caso padre para consolas, check automatico de envio para consolas
* *****************************************************************************************/
public class CLS_FlujoNotificacionControlador {
    
    //Objetos 
    public Case CASO_PRI {get; set;}
    public String CASO_ID {get; set;}
    public String USUA_ID {get; set;}
    public String ESTADO {get; set;} 
    public String CORREOOK {get; set;} 
    public String CORREOCONTACTO {get; set;} 
    
    //Datos
    public Boolean C_NOTIFI {get; set;}
    public String C_ASUNTO {get; set;}
    public String C_COMENT {get; set;}    
    
    /*  ED */
    
    public String IdRequerimiento {get; set;}
    public String RutUsuario {get; set;}    
    public String MensajeError {get; set;}    
    /*  ED */
    
    public String Titulo {get; set;}
    
    public Set<String> ORIGENES = new Set<String>{'Cobranzas Vida', 'Recepción Pagos'};
        
        public PageReference cargaCaso(){
            
            try{
                
                //if (!Test.isRunningTest()) 
                //{ 
                CASO_ID = ApexPages.currentPage().getParameters().get('IdCaso');
                USUA_ID = ApexPages.currentPage().getParameters().get('idResponsable');
                ESTADO = ApexPages.currentPage().getParameters().get('estado');  
                
                //}            
                system.debug('@@@@ Carga Caso ESTADO => ' + ESTADO);
                
                CASO_PRI = new Case();
                
                if (!Test.isRunningTest()) 
                { 
                    CASO_PRI = [SELECT Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, 
                                SourceId, CommunityId, BusinessHoursId, ParentId, SuppliedName, 
                                SuppliedEmail, SuppliedPhone, SuppliedCompany, Type, RecordTypeId, 
                                Status, Reason, Origin, Subject, Priority, Description, IsClosed, 
                                ClosedDate, IsEscalated, OwnerId, SlaStartDate, SlaExitDate, 
                                IsStopped, StopStartDate, CreatedDate, CreatedById, LastModifiedDate, 
                                LastModifiedById, SystemModstamp, ContactPhone, ContactMobile, 
                                MilestoneStatus, CreatorFullPhotoUrl, CreatorSmallPhotoUrl, CreatorName, 
                                Tipo_de_Contacto__c, D_as_restantes_para_cerrar_Reclamo__c, Concepto__c, 
                                Entrega_Respuesta__c, Problema__c, Apellidos__c, Atencion_Presencial__c, 
                                Canal__c, Cantidad_Dias__c, Cargo_Propietario__c, Celular__c, 
                                Ciudad_Comercial__c, Ciudad_Particular__c, Ciudad_Solicitante__c, 
                                Comuna_Comercial__c, Comuna_Particular__c, Comuna_Solicitante__c, 
                                Concepto_Final__c, ContactEmail, Correo_Electronico__c, Correo_electronico_Solicitante__c, 
                                Correo_electronico_alternativo__c, Descripcion__c, Descripcion_de_Respuesta__c, 
                                Detalle_Operacion__c, Detalle_Solicitud__c, Direccion_Comercial__c, 
                                Direccion_Particular__c, Direccion_Postal_Alternativa__c, 
                                Direccion_Solicitante__c, Direccion_envio_respuesta__c, 
                                Domicilio_Comercial_Completo__c, Domicilio_Particular_Completo__c, Email_1__c, 
                                Email_2__c, Email_Contacto__c, Fecha_Cierre_Tope__c, Fecha_de_nacimiento__c, 
                                Cantidad_de_dias_H__c, IDVS__c, IdPoliza__c, LInea_Negocio_Final__c, 
                                Linea_Negocio__c, Negocio__c, Nombre_Completo_Razon_Social__c, 
                                Nombre_Solicitante__c, Nombres__c, Numero_caso_estandar__c, Producto__c, 
                                RUT_Solicitante__c, RUT__c, Ramo_Fecu__c, Region_Comercial__c, 
                                Region_Particular__c, Region_Solicitante__c, Solicita_envio_a_otra_direccion__c, 
                                Sucursal_del_Propietario__c, Telefono_Comercial__c, Telefono_Particular__c, 
                                Telefono_Solicitante__c, Tipo_Contacto_Final__c, Tipo_Operacion__c, 
                                Tipo_de_Solicitante__c, Campa_a_Mailing__c, Fecha_Hora_de_Cierre__c, 
                                Numero_del_Caso_Original__c, Tipo_de_Resoluci_n_del_Reclamo__c, 
                                Llamadas_Out__c, Funci_n_Propietario_del_Caso__c, 
                                Fecha_de_EPA_Contact_Center_Caso__c, Colectivo_Banco_BCI__c, 
                                Complejidad_Numerico__c, Cliente_Colectivo__c, Complejidad_del_Reclamo__c, 
                                Reasignar_a_Rut__c, Tipo_de_Cliente__c, G_Asistencia_Agentes__c, 
                                Detalle_de_Rescate__c, Cantidad_de_Dias_Abierto__c, Dia_de_Creacion__c, 
                                Cantidad_Dias_Desde_Creacion__c, Cumplimiento_Fecha_Cierre__c, 
                                Cliente_Compania__c, Carta_Cliente__c, Estado_Requerimiento_EscritorioDigital__c, 
                                Id_Requerimiento_EscritorioDigital__c, Tipo_Requerimiento_EscritorioDigital__c, 
                                Genero__c, Anular_aprobacion_reclamo_repetitivo__c, Aprobado_Reclamo__c, 
                                Correo_Instancia_del_Reclamo__c, Instancia_del_Reclamo__c, 
                                Numero_de_Caso_Anterior__c, Numero_de_Caso_Inicial__c, Fecha_tope_Vida_Security__c, 
                                CASO_Categoria__c, CASO_Dias_en_Back_Office__c, CASO_N_Poliza__c, 
                                CASO_Responsable_UR__c, Tipo_de_Requerimiento__c, PolizaED__c, 
                                CASO_Poliza_Asoc__c, Casos_Hijos_cerrados__c, CASO_Activa_Flujo_Notificaci_n_Cliente__c, Parent.OwnerId
                                FROM Case
                                WHERE Id =: CASO_ID];            
                } 
                
                system.debug('@@@@ CASO POR CERRAR => ' + CASO_PRI);
                
                C_ASUNTO = CASO_PRI.Subject;
                
                CORREOOK = '0';
                CORREOCONTACTO = CASO_PRI.ContactEmail;
                if(CASO_PRI.ContactEmail != null || CASO_PRI.Correo_electronico_Solicitante__c != null || CASO_PRI.Correo_electronico_alternativo__c != null){
                    CORREOOK = '1';
                }    
                
                /* ED */
                this.CargaRequerimientoED();
                /* ED */
                
                if(ESTADO == '1'){
                    CASO_PRI.Status = 'Cerrado';
                    this.Titulo = 'Cerrar Caso';
                    //  CASO_PRI.Entrega_Respuesta__c = true;
                }
                if(ESTADO == '2'){
                    CASO_PRI.Status = 'Rechazado';
                    this.Titulo = 'Rechazar Caso';
                }
                if(ESTADO == '3'){
                    
                    Case Caso_Parent = new Case();
                    
                    Caso_Parent = [Select  OwnerId from Case where id=: CASO_PRI.ParentId Limit 1] ;
                    CASO_PRI.CASO_Resultado_Derivaci_n__c = null;
                    CASO_PRI.Status = 'En Revisión';
                    CASO_PRI.OwnerId = Caso_Parent.OwnerId;
                    CASO_PRI.CASO_Responsable_UR__c = null;
                    CASO_PRI.Email_Responsable_UR__c = null;
                    this.Titulo = 'Regresar Caso a Ejecutiva';
                }
                
                /*  this.Poliza = CASO_PRI.CASO_Poliza_Asoc__c;
this.NumeroCaso = CASO_PRI.CaseNumber;
this.RUTTitular = CASO_PRI.Rut__c;
this.NombreTitular = CASO_PRI.Nombre_Completo_Razon_Social__c; */
                // CASO_PRI.Entrega_Respuesta__c = true;
                
                if (ORIGENES.contains(CASO_PRI.Origin))
                    C_NOTIFI = true;
                
                return null;    
                
            }catch(system.Exception ex){
                
                system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
                return null;
                
            }
            
        }
    
    public PageReference guardarCasoCerrado(){
        
        try{
            /*ED*/            
            
            boolean cambioED = true;
            
            system.debug('@@@@ IdRequerimiento => ' + this.IdRequerimiento);
            
            if (this.IdRequerimiento != 'NO_REQED' && this.IdRequerimiento != 'UNSUP_REQED')
            {               
                system.debug('@@@@ ED  IdRequerimiento => ' + this.IdRequerimiento);
                this.MensajeError = '';
                if (this.ESTADO == '1') //Cerrado
                {
                    CASO_PRI.Entrega_Respuesta__c = true;
                    //CASO_PRI.Status = 'Cerrado';
                    EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'FINALIZADO');   
                    system.debug('@@@@ ED Respuesta Cerrado => ' + Respuesta);
                    if (Respuesta.SalidaLlamada != 0 && Respuesta.SalidaLlamada != 1)
                    {
                        this.MensajeError = Respuesta.Mensaje;
                        system.debug('@@@@ MensajeError Cerrado => ' + MensajeError);
                        
                        cambioED = false; 
                    }
                }
                else if (this.ESTADO == '2') //Rechazado
                {
                    CASO_PRI.Entrega_Respuesta__c = true;
                    
                    EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'FINALIZADO');
                    
                    system.debug('@@@@ ED Respuesta Rechazado => ' + Respuesta);
                    
                    if (Respuesta.SalidaLlamada != 0 && Respuesta.SalidaLlamada != 1)
                    {
                        this.MensajeError = Respuesta.Mensaje;
                        system.debug('@@@@ MensajeError Rechazado => ' + MensajeError);
                        
                        cambioED = false; 
                    } 
                }
                else if (this.ESTADO == '3') //En Revisión
                {
                    //CASO_PRI.Status = 'En Revisión';
                    //CASO_PRI.OwnerId = CASO_PRI.CreatedById;
                    //CASO_PRI.CASO_Responsable_UR__c = null;
                    
                    /*EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'REVISION');   
system.debug('@@@@ ED Respuesta Revision => ' + Respuesta);
if (Respuesta.SalidaLlamada != 0 && Respuesta.SalidaLlamada != 1)
{
this.MensajeError = Respuesta.Mensaje;
system.debug('@@@@ MensajeError  EnRevision => ' + MensajeError);
cambioED = false; 
}   */                
                }
            }
            
            if (cambioED == false)
            {
                return null;
            }
            /*ED*/
            
            if(C_NOTIFI == true){
                CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c = C_NOTIFI;
            }
            
            if(C_ASUNTO != ''){
                CASO_PRI.CASO_Asunto_Notificaci_n__c = C_ASUNTO;
            }
            
            if(C_COMENT != ''){
                CASO_PRI.CASO_Mensaje_Notificaci_n__c = C_COMENT;                
            }
            
            if (this.ESTADO == '1' || this.ESTADO == '2') //Cerrado Rechazado
            {            
                CASO_PRI.Entrega_Respuesta__c = true;
            }
            
            if(C_COMENT != null){
                CASO_PRI.CASO_Mensaje_Notificaci_n__c = C_COMENT;
            }
            
            if (!Test.isRunningTest()) 
            {
                update CASO_PRI;
            }
            
            if (this.ESTADO == '1' || this.ESTADO == '2') //Cerrado Rechazado
            {            
                Case CasoAtencion = [Select Id, CaseNumber, Canal__c, Origin, SuppliedEmail, Status, Entrega_Respuesta__c from Case 
                                     where Id=:CASO_PRI.ParentId];
                
                /*  system.debug('@@@@ Caso Atencion Canal__c --> '+ CasoAtencion.Canal__c);
system.debug('@@@@ Caso Atencion Origin --> '+ CasoAtencion.Origin );
system.debug('@@@@ Caso Atencion SuppliedEmail --> '+ CasoAtencion.SuppliedEmail);*/
                
                Set<String> ORIGENES = new Set<String>{'Cobranzas Vida', 'Recepción Pagos','Producción Individuales'};
                    
                    if (ORIGENES.contains(CasoAtencion.Origin) && ORIGENES.contains(CasoAtencion.Canal__c)  &&
                        (CasoAtencion.SuppliedEmail != null && String.isNotBlank(CasoAtencion.SuppliedEmail)))
                {
                    CasoAtencion.Status = 'Cerrado';
                    CasoAtencion.Entrega_Respuesta__c = true;
                    
                    if (!Test.isRunningTest()) 
                    {
                        update CasoAtencion;	
                        //system.debug('@@@@ Caso Atencion --> '+ CasoAtencion);
                    }
                }
            }   
            
            if(C_COMENT != null){
                CaseComment comentario = new CaseComment();
                comentario.ParentId = CASO_ID;
                comentario.CommentBody = C_COMENT;  
                insert comentario;
            }
            
            system.debug('@@@@ ESTADO => ' + this.ESTADO + ' - ' + ESTADO);
            system.debug('@@@@ ENTREGA RESPUESTA => ' + CASO_PRI.Entrega_Respuesta__c);
            system.debug('@@@@ ACTIVA NOTIFICACIÓN => ' + CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c);
            system.debug('@@@@ ASUNTO NOTIFICACIÓN => ' + CASO_PRI.CASO_Asunto_Notificaci_n__c);
            system.debug('@@@@ COMENTARIO NOTIFICACIÓN => ' + CASO_PRI.CASO_Mensaje_Notificaci_n__c);            
            
            //Codigo para envio de correo a clientes
            
            if(CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c == true){
                
                CLS_generaPDFdevejecutivo clsPDF = new CLS_generaPDFdevejecutivo();
                clsPDF.guardarAdjunto(CASO_PRI.Id,ESTADO);
                
            }
            
            
            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + USUA_ID);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }
        
    }
    
    public PageReference cancelarCerrarCaso(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                CASO_PRI.Entrega_Respuesta__c = false;
            }
            
            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ CASO_ID + '&idResponsable=' + USUA_ID);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }        
    }    
    
    public EscritorioDigital_Consume.Respuesta_CambioEstado CambioEstado_EscritorioDigital(String ID, String estadoED){
        
        EscritorioDigital_Consume.Respuesta_CambioEstado RespuestaCambio;
        
        try
        {
            if (this.IdRequerimiento == null || this.IdRequerimiento == '' ||this.IdRequerimiento == 'UNSUP_REQED')
            {
                RespuestaCambio = new EscritorioDigital_Consume.Respuesta_CambioEstado();
                RespuestaCambio.SalidaLlamada = 0;
                
                return RespuestaCambio;
            }
            
            if (estadoED == 'FINALIZADO')  //  -->   CERRAR CASO
            {
                if (this.IdRequerimiento != 'NO_REQED')
                {
                    RespuestaCambio = EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'FINALIZADO', this.RutUsuario);    
                    
                    if (RespuestaCambio.Codigo == '00')
                    {
                        RespuestaCambio.SalidaLlamada = 1;//Ok
                    }
                    else
                    {                        
                        RespuestaCambio.SalidaLlamada = 2;//Error al cambiar estado en ED o Valuetech.                        
                    }  
                }
                else
                {
                    RespuestaCambio = new EscritorioDigital_Consume.Respuesta_CambioEstado();
                    RespuestaCambio.SalidaLlamada = -2;//falta requerimiento edigital
                } 
            }
            else if (estadoED == 'REVISION') //   --> DEVOLVER A EJECUTIVA
            {
                if (this.IdRequerimiento != 'NO_REQED')
                {                                                                                                           
                    RespuestaCambio = EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'REVISION', this.RutUsuario);    
                    
                    if (RespuestaCambio.Codigo == '00')
                    {
                        RespuestaCambio.SalidaLlamada = 1;//Ok
                    }
                    else
                    {                        
                        RespuestaCambio.SalidaLlamada = 2;//Error al cambiar estado en ED o Valuetech.                        
                    } 
                } 
                else
                {
                    RespuestaCambio = new EscritorioDigital_Consume.Respuesta_CambioEstado();
                    RespuestaCambio.SalidaLlamada = -2;//falta requerimiento edigital
                }    
            }
        }catch(Exception ex){
            System.debug('@@@@ CambioEstado@@'+ex); 
            //    ApexPages.addMessages(ex);            
            RespuestaCambio = new EscritorioDigital_Consume.Respuesta_CambioEstado();
            RespuestaCambio.SalidaLlamada = -1;//excepcion
        }
        
        return RespuestaCambio;
    } 
    
    public void CargaRequerimientoED()
    {          
        if (CASO_PRI.Id_Requerimiento_EscritorioDigital__c != null && CASO_PRI.Id_Requerimiento_EscritorioDigital__c != '')
        {
            this.IdRequerimiento = CASO_PRI.Id_Requerimiento_EscritorioDigital__c;    
        }
        else
        {
            if (CASO_PRI.Detalle_Solicitud__c != null && CASO_PRI.Detalle_Solicitud__c != '')
            {
                String Etiqueta = EscritorioDigital_Internal.Etiqueta(CASO_PRI.Detalle_Solicitud__c);
                
                if (Etiqueta != '') 
                {
                    this.IdRequerimiento = 'NO_REQED';
                }
                else
                {
                    this.IdRequerimiento = 'UNSUP_REQED';
                }
            }
        }
        
        if (this.IdRequerimiento != 'NO_REQED' && this.IdRequerimiento != 'UNSUP_REQED')
        {                
            List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()];
            
            if (lusers.size() > 0)
            {
                this.RutUsuario = lusers[0].RUT_Usuario__c;                                    
            }
        }
        
    }    
}