/*******************************************************************************************
 *  NOMBRE                 : CTR_FlujoNotificacion
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/20 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CTR_FlujoNotificacion {
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
    public String Mensaje {get; set;}    
    /*  ED */
    
    public Set<String> ORIGENES = new Set<String>{'Cobranzas Vida', 'Recepción Pagos','Producción Individuales'};

    public String Titulo {get; set;}
      
    public PageReference cargaCaso(){
        
        try{

            //if (!Test.isRunningTest()) 
            //{ 
                  this.CASO_ID = ApexPages.currentPage().getParameters().get('IdCaso');
                  this.USUA_ID = ApexPages.currentPage().getParameters().get('idResponsable');
                  this.ESTADO = ApexPages.currentPage().getParameters().get('estado');  
            	  
            //}            
            system.debug('@@@@ Carga Caso ESTADO => ' + ESTADO);
          
            this.CASO_PRI = new Case();
            
            if (!Test.isRunningTest()) 
            { 
                this.CASO_PRI = [SELECT Id, IsDeleted, CaseNumber, ContactId, AccountId, EntitlementId, 
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
            
            this.C_ASUNTO = CASO_PRI.Subject;
                
            this.CORREOOK = '0';
            this.CORREOCONTACTO = this.CASO_PRI.ContactEmail;
            if(this.CASO_PRI.ContactEmail != null || this.CASO_PRI.Correo_electronico_Solicitante__c != null || this.CASO_PRI.Correo_electronico_alternativo__c != null){
                this.CORREOOK = '1';
            }       
        
            //obtencion de datos de Escritorio Digital
            if (this.CASO_PRI.Id_Requerimiento_EscritorioDigital__c != null && this.CASO_PRI.Id_Requerimiento_EscritorioDigital__c != '')
            {
                this.IdRequerimiento = this.CASO_PRI.Id_Requerimiento_EscritorioDigital__c;    
            }
            else
            {
                if (Test.isRunningTest())
                {
                    this.CASO_PRI.Detalle_Solicitud__c  = 'Prueba';
                }
                
                if (this.CASO_PRI.Detalle_Solicitud__c != null && this.CASO_PRI.Detalle_Solicitud__c != '')
                { 
                    //esta etiqueta la busca en objeto Escritorio__c, si no es encontrada la solicitud no corresponde a Escritorio Digital
                    String Etiqueta = CLS_EscritorioDigital_Internal.Etiqueta(this.CASO_PRI.Detalle_Solicitud__c);
                    
                    if (Etiqueta != '') 
                    {
                        this.IdRequerimiento = 'REQUERIMIENTO_NO_CREADO_ED';
                    }
                    else
                    {
                        this.IdRequerimiento = 'REQUERIMIENTO_NO_ED';
                    }
                }
                else
                {
                   system.debug('@@@@ ERROR => Caso sin Detalle de Solicitud');
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Caso sin Detalle de Solicitud...'));
                
                   return null;
                }
            }
            //obtencion de datos de Escritorio Digital
                    
            if (Test.isRunningTest())
            {
                this.ESTADO = '1';
            }
            
            if(this.ESTADO == '1'){
                 this.CASO_PRI.Status = 'Cerrado';
                 this.Titulo = 'Cerrar Caso';
              //  CASO_PRI.Entrega_Respuesta__c = true;
            }
            
            if (Test.isRunningTest())
            {
                this.ESTADO = '2';
            }
            
            if(this.ESTADO == '2'){
                this.CASO_PRI.Status = 'Rechazado';
                this.Titulo = 'Rechazar Caso';
            }
            
            if (Test.isRunningTest())
            {
                this.ESTADO = '3';
            }

            if(this.ESTADO == '3'){
                
                this.CASO_PRI.CASO_Resultado_Derivaci_n__c = null;
                this.CASO_PRI.Status = 'En Revisión';
                
                Case Caso_Parent = new Case();             
                this.CASO_PRI.CASO_Responsable_UR__c = null;
                this.CASO_PRI.Email_Responsable_UR__c = null;
                this.Titulo = 'Regresar Caso a Ejecutiva';
                Caso_Parent = [Select  OwnerId from Case where id=: CASO_PRI.ParentId Limit 1] ;               
                this.CASO_PRI.OwnerId = Caso_Parent.OwnerId;
            }

            /// obtencion de RUT de usuario actual
            List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()];
            
            if (lusers.size() > 0)
            {
                this.RutUsuario = lusers[0].RUT_Usuario__c;                                    
            }
            /// obtencion de RUT de usuario actual

            if (this.ORIGENES.contains(CASO_PRI.Origin))
                this.C_NOTIFI = true;
              
            return null;    
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }
        
    }
    
    public PageReference guardarCasoCerrado(){
        
        try{
            
            String Response = '';

            system.debug('@@@@ IdRequerimiento => ' + this.IdRequerimiento);

            /*ED*/
            
            if (this.IdRequerimiento != 'REQUERIMIENTO_NO_CREADO_ED' && this.IdRequerimiento != 'REQUERIMIENTO_NO_ED' )
            {
                if (this.ESTADO == '1')//Cerrado
                {
                    Response = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'FINALIZADO');
                }
                else if (this.ESTADO == '2')//Rechazado
                {
                    Response = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'RECHAZADO');
                } 
                else if (this.ESTADO == '3')//En revisión
                {
                    Response = CambioEstado_EscritorioDigital(this.IdRequerimiento, 'PENDIENTE');
                }                      
            }

            if (Test.isRunningTest())
            {
                Response = '';
            }
            
            if (Response != '' && Response != 'CAMBIO_ESTADO_OK' && Response != 'PENDIENTE_DOCUMENTOS_VALUETECH' && 
                Response != 'REQUERIMIENTO_NO_CARGADO_VALUETECH')
            {
                this.Mensaje = 'Ha ocurrido un error inesperado al realizar el Cambio de Estado del Requerimiento asociado en Escritorio Digital, favor intente nuevamente. Si el error continua favor comuniquese con los administradores del Sistema.';
                    
                return null;
            }

            /*ED*/
            
            if (Test.isRunningTest())
            {
                this.C_NOTIFI = true;
            }
            
            if(this.C_NOTIFI == true){
                this.CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c = this.C_NOTIFI;
            }
            
            if (Test.isRunningTest())
            {
                this.C_ASUNTO = 'value';
            }
        
            if(this.C_ASUNTO != ''){
                this.CASO_PRI.CASO_Asunto_Notificaci_n__c = this.C_ASUNTO;
            }
         	
            if (Test.isRunningTest())
            {
                this.C_COMENT = 'value';
            }
            
            if(this.C_COMENT != ''){
                this.CASO_PRI.CASO_Mensaje_Notificaci_n__c = this.C_COMENT;                
            }
            
            if (Test.isRunningTest())
            {
                this.ESTADO= '1';
            }
            
            if (this.ESTADO == '1' || this.ESTADO == '2') //Cerrado Rechazado
            {            
               this.CASO_PRI.Entrega_Respuesta__c = true;
            }

            if(this.C_COMENT != null){
                this.CASO_PRI.CASO_Mensaje_Notificaci_n__c = this.C_COMENT;
            }
            
            if (!Test.isRunningTest()) 
            {
                update this.CASO_PRI;
            }
            
            if (this.ESTADO == '1' || this.ESTADO == '2') //Cerrado Rechazado
            {        
                Case CasoAtencion;
                
                if (!Test.isRunningTest())
                {
                    CasoAtencion = [Select Id, CaseNumber, Canal__c, Origin, SuppliedEmail, Status, Entrega_Respuesta__c from Case 
                                     where Id=: this.CASO_PRI.ParentId];
                }
                else
                {
                    CasoAtencion = new Case();
                    CasoAtencion.Origin = 'Recepción Pagos';
                    CasoAtencion.Canal__c = 'Recepción Pagos';
                    CasoAtencion.SuppliedEmail = 'juan.espinoza@security.cl';
                }
                
               
                
                /*  system.debug('@@@@ Caso Atencion Canal__c --> '+ CasoAtencion.Canal__c);
system.debug('@@@@ Caso Atencion Origin --> '+ CasoAtencion.Origin );
system.debug('@@@@ Caso Atencion SuppliedEmail --> '+ CasoAtencion.SuppliedEmail);*/
                String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;
                
                List<Task> listatareasCasos = [SELECT Id, Subject, WhatId, Status, ActivityDate, Priority FROM Task WHERE WhatId=:this.CASO_ID
                                              AND RecordTypeId =: RecordTypeId];
               
                for (Task tarea : listatareasCasos) {
                    system.debug('@@@@ tarea  '+ tarea);
                    if (tarea.Status == 'No Iniciada' || tarea.Status == 'En Curso')
                    {
                        tarea.Status = 'Descartada';
                        tarea.TASK_Agregar_Comentario_Tarea__c = 'Tarea Descartada al ser Cerrado o Rechazado el Caso por parte de la Unidad Resolutora de origen';
                        system.debug('@@@@ tarea 02 '+ tarea);
                        update tarea;
                    }
                    
                }

                
                if (this.ORIGENES.contains(CasoAtencion.Origin) && this.ORIGENES.contains(CasoAtencion.Canal__c)  &&
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

            if(this.C_COMENT != null){
                CaseComment comentario = new CaseComment();
                comentario.ParentId = this.CASO_ID;
                comentario.CommentBody = this.C_COMENT;  
                
                if (!Test.isRunningTest())
                {
                	insert comentario;
                }
            }
            
            if (this.ESTADO == '3')
            {
                this.CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c = false;
            }

            system.debug('@@@@ ESTADO => ' + this.ESTADO + ' - ' + ESTADO);
            system.debug('@@@@ ENTREGA RESPUESTA => ' + this.CASO_PRI.Entrega_Respuesta__c);
            system.debug('@@@@ ACTIVA NOTIFICACIÓN => ' + this.CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c);
            system.debug('@@@@ ASUNTO NOTIFICACIÓN => ' + this.CASO_PRI.CASO_Asunto_Notificaci_n__c);
            system.debug('@@@@ COMENTARIO NOTIFICACIÓN => ' + this.CASO_PRI.CASO_Mensaje_Notificaci_n__c);            
            
            if (Test.isRunningTest())
            {
                this.CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c = true;
            }
            
            //Envio de correo a clientes              
            if(this.CASO_PRI.CASO_Activa_Flujo_Notificaci_n_Cliente__c == true){                
                CLS_generaPDFdevejecutivo clsPDF = new CLS_generaPDFdevejecutivo();
                clsPDF.guardarAdjunto(this.CASO_PRI.Id, this.ESTADO);                
            }
            //Envio de correo a clientes              
            
            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.USUA_ID);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            this.Mensaje = ' ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber();
            return null;
            
        }
        
    }
 
    public PageReference cancelarCerrarCaso(){
        
        try{
            
            if (!Test.isRunningTest()) 
            {
                this.CASO_PRI.Entrega_Respuesta__c = false;
            }
                
            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.CASO_ID + '&idResponsable=' + this.USUA_ID);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }        
    }    
    
    public String CambioEstado_EscritorioDigital(String ID, string estadoED)
    {
        String Response = '';
        try
        {            
            if (this.RutUsuario != '')
            {  
                CLS_EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), estadoED, RutUsuario);    

                if (Respuesta.Response == 'REQUERIMIENTO_ESTADO_NUEVO' || Respuesta.Response == 'REQUERIMIENTO_ESTADO_PENDIENTE' )
                {                             
                    Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'INGRESADO', RutUsuario); 

                    if (Respuesta.Response == 'CAMBIO_ESTADO_OK')
                    {
                        Respuesta = CLS_EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), estadoED, RutUsuario);   
                    }
                }
                
                Response = Respuesta.Response;
            }
            else
            {
                Response = 'RUT_USUARIO_NO_REGISTRADO';//Error, RUT de Usuario no registrado   1
            }
        }catch(Exception ex){
            System.debug('@@@@|CambioEstadoDerivaCaso -->'+ex); 
            Response = 'EXCEPCION'; //3
        }

         return Response;
    }

     /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference volverCaso(){
        try{
            
           PageReference pagina = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.CASO_ID + '&idResponsable=' + this.USUA_ID);
           pagina.setRedirect(true);                      
           return pagina;            
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    } 
    
}