/*******************************************************************************************
 *  NOMBRE                 : CLS_BandejaResolutorUR_Controlador
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 *  2.0     - 24/10/2018 - J.ESPINOZA       - Limpieza y documentación código
 * 
 * *****************************************************************************************/
global class CLS_BandejaResolutorUR_Controlador {

    public String UsuarioSeleccionado {get; set;}
    public String IdcasoVisualizado {get; set;}
    public Boolean CasoFinalizado {get; set;}
    public Case verCaso {get; set;}
    public CaseComment Ncomentario {get; set;}    
    public String AREAUSUARIOLICENCIA {get; set;}
    public String IdColaUR {get; set;}
    public String Prueba {get; set;} //utilizada para pruebas en metodo cargaCasoSeleccionado()
    public Boolean OpcionEdicion {get; set;} //utilizada en manejo de vistas
    public String C_COMENT {get; set;}   
    public String RESPONSABLE_ACTUAL {get; set;}   
    public String MensajeError {get; set;} 
    
    public Integer Registros {get; set;}
    public String RUT_Cliente {get; set;}
    public String NumeroCaso {get; set;}



    /*Listas empleadas para desplegar su correspondiente información por pantalla*/
    public List<Case> LST_CasosUR {get; set;}     
    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Attachment> LST_AdjuntosCasoUR {get; set;}
    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    /*Listas empleadas para desplegar su correspondiente información por pantalla*/
    
    /*  Variables utilizadas en comunicación con Escritorio Digital*/  
    public Integer Persistencia {get; set;}
    public String IdRequerimiento {get; set;}
    public String RutUsuario {get; set;}
    public String apodo {get; set;}
    public String UserOS {get; set;}
    /*  Variables utilizadas en comunicación con Escritorio Digital*/

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarBandejaUR(){
        try{
            
			this.AREAUSUARIOLICENCIA = [SELECT USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()].USUA_Area_UR__c;
                      
            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AREAUSUARIOLICENCIA];

            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');

            this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;
            
			mostrarCasosUR();
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }           
    }
    
    /*Campo PICKLIST con Lista de Usuarios*/
    public List<Selectoption> getListarUsuarios(){
        try{
            List<Selectoption> LST_NombresUsuarios = new List<Selectoption>();
            
            LST_NombresUsuarios.add(new Selectoption('0','Todos'));
            LST_NombresUsuarios.add(new Selectoption('1','Casos sin responsable UR'));

            for(Usuario_Backup__c u : this.LST_UsuariosBackup){
                LST_NombresUsuarios.add(new Selectoption(u.Id,u.Name));
            }

            return LST_NombresUsuarios;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
        
    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public PageReference mostrarCasosUR(){
        try{
            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioSeleccionado);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);
         
            if(this.UsuarioSeleccionado == null)
            {
                this.UsuarioSeleccionado = '0';
            }
            if(this.UsuarioSeleccionado != null && this.UsuarioSeleccionado != '0' && this.UsuarioSeleccionado != '1'){

                this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                      ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                      Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                      Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                      CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                               		  Parent.OwnerId, Fecha_Asignacion_UR__c
                               FROM Case
                               WHERE CASO_Responsable_UR__c =: this.UsuarioSeleccionado AND Status != 'Basura'AND Status != 'Rechazado' AND Status != 'Nuevo' AND Status != 'Cerrado' AND 
                                     Status != 'Caso Cerrado' AND Status != 'Cerrado (Correo Duplicado)' AND Status != 'Cerrado (Correo Masivo)' AND 
                                     IsClosed = false AND OwnerId =: this.IdColaUR ORDER BY Fecha_Asignacion_UR__c DESC];
                
                system.debug('@@@@ CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());

            }else
            { 
                if (this.UsuarioSeleccionado == '1')
                {
                     this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                          ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                          Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                          Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                          CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                               			  Parent.OwnerId, Fecha_Asignacion_UR__c
                                   FROM Case
                                   WHERE CASO_Responsable_UR__c = NULL AND Status != 'Nuevo' AND Status != 'Basura'AND Status != 'Rechazado' AND Status != 'Cerrado' AND 
                                         Status != 'Caso Cerrado' AND Status != 'Cerrado (Correo Duplicado)' AND Status != 'Cerrado (Correo Masivo)' AND 
                                         IsClosed = false AND OwnerId =: this.IdColaUR ORDER BY Fecha_Asignacion_UR__c DESC];  
                
                    system.debug('@@@@ ELSE CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());
                    
                }
                else if (this.UsuarioSeleccionado == '0')
                {
                     this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                          ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                          Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                          Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                          CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                               			  Parent.OwnerId, Fecha_Asignacion_UR__c
                                   FROM Case
                                   WHERE OwnerId =: this.IdColaUR And (Status = 'Back Office' OR Status = 'En Proceso') ORDER BY Fecha_Asignacion_UR__c DESC];  
                
                    system.debug('@@@@ ELSE (TODOS) CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());
                    
                }                
                             
            }

            return null;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    }
        
    /*Método para navegar a página ver Caso seleccionado por Usuario UR*/
    public PageReference verCasoSeleccionadoUR(){
        try{
            String ID = apexpages.currentpage().getparameters().get('idCaso');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ID + '&idResponsable=' + this.UsuarioSeleccionado+'&historial=N');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    }
    
    /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference cargaCasoSeleccionado(){
        try{
            String IDCASO = apexpages.currentpage().getparameters().get('idCaso');
            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');
            String historial = apexpages.currentpage().getparameters().get('historial');

            if (historial == 'Y')
            {
                this.CasoFinalizado  = true;
            }
            else 
            {
                this.CasoFinalizado  = false;
            }
            
            If(IDCASO != ''){
            
                this.IdcasoVisualizado = IDCASO;
                this.verCaso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                    this.verCaso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c
                            FROM Case
                            WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.verCaso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);       

                    if (this.Prueba == 'SI')
                    {
                        this.verCaso.Id_Requerimiento_EscritorioDigital__c = '96';
                    }
                }
                                
                if(this.verCaso.Id != null){                    
                 
                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: verCaso.Id
                                            ORDER BY CreatedDate DESC];                        
                
                    this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: verCaso.Id ORDER BY CreatedDate DESC];
                   
                    /* Escritorio Digital */
                    if (this.verCaso.Id_Requerimiento_EscritorioDigital__c != null && this.verCaso.Id_Requerimiento_EscritorioDigital__c != '')
                    {
                    	this.IdRequerimiento = verCaso.Id_Requerimiento_EscritorioDigital__c;    
                    }
                    else
                    {
                        if (this.verCaso.Detalle_Solicitud__c != null && this.verCaso.Detalle_Solicitud__c != '')
                        {
                            String Etiqueta = EscritorioDigital_Internal.Etiqueta(verCaso.Detalle_Solicitud__c);
                    
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
                        this.apodo = '';
                        this.UserOS = '';
                        List<User> lusers = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
                    
                        if (lusers.size() > 0)
                        {
                            this.RutUsuario = lusers[0].RUT_Usuario__c;      
                            this.apodo = lusers[0].CommunityNickname;
                            this.UserOS = 'GRP_SECURITY\\SALESFORCE';                 
                        } 
                         
                        if (this.RutUsuario != '')
                        {
                           this.Persistencia =  EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.UserOS, this.apodo);     
                        }
                        else
                        {
                            this.Persistencia = -8;
                        }
                    }
                    
                    system.debug('@@@@ 01.Persistencia' + this.Persistencia);
                    system.debug('@@@@ 01.IdRequerimiento' + this.IdRequerimiento);
                    system.debug('@@@@ 01.RutUsuario' + this.RutUsuario);
                    /* Escritorio Digital */
                }
                
                this.OpcionEdicion = true;
                
                if (this.verCaso.Status == 'Cerrado' || this.verCaso.Status == 'Caso Cerrado' || 
                this.verCaso.Status == 'Derivación' || this.verCaso.Status == 'En Revisión' || 
                this.verCaso.Status == 'Rechazado' || this.verCaso.Status == 'Back Office')
                {
                    this.OpcionEdicion = false;
                }                
                
                return null;

            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
     /*Método para mostrar caso seleccionado y su información relacionada*/
    public PageReference cargaCasoSeleccionadoReasignacion(){
        try{
            String IDCASO = apexpages.currentpage().getparameters().get('idCaso');
           
            if(IDCASO != ''){
           
                this.IdcasoVisualizado = IDCASO;
                this.verCaso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                    this.verCaso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Fecha_Asignacion_UR__c, CASO_Poliza_Asoc__c, Nombre_Completo_Razon_Social__c,Id_Responsable_UR__c
                            FROM Case
                            WHERE Id =: this.IdcasoVisualizado];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.verCaso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta); 
                }
               
                this.RESPONSABLE_ACTUAL = this.verCaso.CASO_Responsable_UR__c;
                return null;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
       
    /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference volverMenuPrincipal(){
        try{
            System.debug('@@@@@@@ entra en la url llena');
            String ID = apexpages.currentpage().getparameters().get('idCaso');
        
            System.debug('@@@@@@@ UsuarioSeleccionado'+UsuarioSeleccionado);
            if (Test.isRunningTest())
            {
                this.UsuarioSeleccionado = 'null';
            }
            
            if (this.UsuarioSeleccionado == 'null')
            {
                this.UsuarioSeleccionado = '0';
            }            
        
            PageReference pagina_verCaso;

            if (this.CasoFinalizado == true)
            {
                pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_historial?idResponsable=' + this.UsuarioSeleccionado);                        
            }   
            else
            {
                pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.UsuarioSeleccionado);                        
            }     

            pagina_verCaso.setRedirect(true);            
            
            return pagina_verCaso;
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    } 
    
    /*Método para navegar a página Creación de comentarios desde Vista de Caso Seleccionado*/
    public PageReference AgregarComentario( ){
        try{            
            PageReference pagina_Agregar_Comentario = new PageReference('/apex/SEC_VF_UR_Agregar_Comentarios_CasoH?idCaso=' + this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado);
            pagina_Agregar_Comentario.setRedirect(true);

            return pagina_Agregar_Comentario;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }   
    }

    public PageReference CargaCasoComentario(){
       try{
                     
            String IdCasoPadreComentario = apexpages.currentpage().getparameters().get('idCaso');
                       
            if (!Test.isRunningTest()) 
            { 
                this.verCaso = [SELECT Id, CaseNumber, AccountId,  ParentId,  Nombre_Completo_Razon_Social__c,                                
                               CASO_Poliza_Asoc__c, Rut__c, Subject, Parent.OwnerId
                        FROM Case
                        WHERE Id =: IdCasoPadreComentario];            
            } 
           
           this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');
           this.Ncomentario = new CaseComment();
           this.Ncomentario.ParentId = IdCasoPadreComentario;
           
           return null;
            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        
    	}
    }
   

    /*Método que permite Guardar un Comentario y redirecciona a la Vista Principal del Caso en UR*/    
    public PageReference GuardarComentario(){
        try{
            if (!Test.isRunningTest()) 
            { 
            	insert this.Ncomentario;
            }
            
            system.debug('@@@@ DATOS COMENTAIORA' + this.Ncomentario);                        
            
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.Ncomentario.ParentId + '&idResponsable=' + this.UsuarioSeleccionado);
            pagina_verCaso.setRedirect(true);
            
            return pagina_verCaso;
            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        
    	}
    }
    
    /*Método que cancela Guardar un Comentario y redirecciona a la Vista Principal del Caso en UR*/  
  	public PageReference CancelarComentario(){
        
        try{
           String IdCasoPadreComentario = apexpages.currentpage().getparameters().get('idCaso');
           this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');

           this.Ncomentario = new CaseComment(); 
           this.Ncomentario.ParentId = IdCasoPadreComentario;    
           
           PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.Ncomentario.ParentId + '&idResponsable=' + this.UsuarioSeleccionado);
           pagina_verCaso.setRedirect(true);
          
           return pagina_verCaso;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;        
    	}
    }
    
    /*Método que cambia estado de Caso a 'En Proceso'  y redirecciona a la Vista Principal del Caso en UR*/  
    public PageReference CambiarEstadoCasoEnProceso(){
        try{
            if(this.verCaso != null){
                system.debug('@@@@@ ID CASO EDITADO=>' + this.verCaso);
                this.verCaso.Status = 'En Proceso';

                if (!Test.isRunningTest()) 
            	{ 
                	update this.verCaso;
            	}
                
                PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.verCaso.Id + '&idResponsable=' + this.UsuarioSeleccionado);
                pagina_verCaso.setRedirect(true);

                return pagina_verCaso;
            }else{
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    /*Método para navegar a página Cambio de Responsable Caso desde Vista de Caso Seleccionado*/
    public PageReference CambiarResponsable(){
        try
        {           
            if(this.verCaso != null)
            {
                PageReference pag_NotificacionCaso = new PageReference('/apex/SEC_VF_UR_ReasignarResponsableCaso?idCaso=' + this.IdcasoVisualizado);                    
                pag_NotificacionCaso.setRedirect(true);
        
                return pag_NotificacionCaso;                
            }
         	else{
                return null;
            }
        }catch(Exception ex){
            system.debug('@@@@ cambioed @@ Exception=>' + ex);            
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    /*Método para navegar a página Flujo Notificacion Caso, desde Vista de Caso Seleccionado, con parámetro (estado=3) que indica que se trata de un Envío a Ejecutiva*/
    public PageReference EnviaEjecutivo(){
     	try
        {           
            if(this.verCaso != null)
            {
                PageReference pag_NotificacionCaso = new PageReference('/apex/SEC_VF_UR_FlujoNotificacionCaso?IdCaso=' + this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado + '&estado=3');                    
                pag_NotificacionCaso.setRedirect(true);
               
                return pag_NotificacionCaso;                
            }
         	else{
                return null;
            }
        }catch(Exception ex){
            system.debug('@@@@ cambioed @@ Exception=>' + ex);            
            ApexPages.addMessages(ex);
            return null;
        }
    }    
    
    /*Método para navegar a página Flujo Notificacion Caso, desde Vista de Caso Seleccionado, con parámetro (estado=1) que indica que se trata de un Cierre de Caso*/
    public PageReference CambiarEstadoCasoCerrado(){
        try{
            if(verCaso != null)
            {               
				PageReference pag_NotificacionCaso = new PageReference('/apex/SEC_VF_UR_FlujoNotificacionCaso?IdCaso=' + this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado + '&estado=1');                    
                pag_NotificacionCaso.setRedirect(true);
                
                return pag_NotificacionCaso;    
            }else{
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);

            return null;
        }
    }
    
    /*Método para navegar a página Flujo Notificacion Caso, desde Vista de Caso Seleccionado, con parámetro (estado=2) que indica que se trata de un Rechazo de Caso*/
    public PageReference cambiarEstadoCasoRechazado(){
        try{

            PageReference pag_NotificacionCaso = new PageReference('/apex/SEC_VF_UR_FlujoNotificacionCaso?IdCaso=' + this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado + '&estado=2');
            pag_NotificacionCaso.setRedirect(true);

            return pag_NotificacionCaso;
        }catch(Exception ex){            
            ApexPages.addMessages(ex);

            return null;            
        }
    }    
    
    /*Método que cambia responsable asociado a un Caso  y redirecciona a la Vista Principal del Caso en UR*/  
    public PageReference actualizarResponsableCaso(){
        
        try{
            
            system.debug('@@@@@ verCaso.CASO_Responsable_UR__c => ' + this.verCaso.CASO_Responsable_UR__c);
            system.debug('@@@@@ this.RESPONSABLE_ACTUAL => ' + this.RESPONSABLE_ACTUAL);
                
            if (verCaso.CASO_Responsable_UR__c == null)
            {
                this.MensajeError = 'Debe seleccionar un Usuario para poder reasignar el Caso';
                return null;
            }
                
            if (this.RESPONSABLE_ACTUAL == verCaso.CASO_Responsable_UR__c) 
            {
                this.MensajeError = 'Debe seleccionar un Usuario distinto al actual para poder reasignar el Caso';
                return null;
            }    
          
            String usuarioActual = '';
            String usuarioNuevo = '';
            Usuario_Backup__c UBck = new Usuario_Backup__c();
            if (!Test.isRunningTest()) 
            {
                usuarioActual = [Select Name From Usuario_Backup__c Where Id =:this.RESPONSABLE_ACTUAL].Name;
                UBck  =  [Select Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.verCaso.CASO_Responsable_UR__c];                    
            }
            
            usuarioNuevo = UBck.Name;  
            this.verCaso.Fecha_Asignacion_UR__c = Datetime.now();
            this.verCaso.Email_Responsable_UR__c = UBck.UBAC_Email__c;	
            this.verCaso.Id_Responsable_UR__c = this.verCaso.CASO_Responsable_UR__c;
            this.verCaso.Status = 'Back Office'; 

            if (!Test.isRunningTest()) 
            {                 
                update this.verCaso;
            }
                
            if(C_COMENT != null)
            {
                CaseComment comentario = new CaseComment();
                comentario.ParentId = IdcasoVisualizado;
                
                comentario.CommentBody = 'Reasignación de usuario UR : '+usuarioActual+' --> '+usuarioNuevo+' \n'+C_COMENT;  
                
                if (!Test.isRunningTest()) 
                {                 
                        insert comentario;
                }
            }

            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso=' + IdcasoVisualizado+ '&idResponsable=' + UsuarioSeleccionado);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }
        
    }
    
    /*Método que cancela cambio de responsable asociado a un Caso  y redirecciona a la Vista Principal del Caso en UR*/  
    public PageReference cancelaractualizarResponsableCaso(){
        
        try{
             
            PageReference pagVolver = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado);
            pagVolver.setRedirect(true);
            return pagVolver;
            
        }catch(system.Exception ex){
            
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
            return null;
            
        }        
    }    

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarBandejaUR_Historial(){
        try{
            
			this.AREAUSUARIOLICENCIA = [SELECT USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()].USUA_Area_UR__c;
                      
            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AREAUSUARIOLICENCIA];

            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');
            
            this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;
            this.Registros = 250;
            this.RUT_Cliente = '';
            this.NumeroCaso = '';
         
			mostrarCasosUR_Historial();
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }           
    }
        
    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public PageReference mostrarCasosUR_Historial(){
        try{
            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioSeleccionado);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);
           
            if(this.UsuarioSeleccionado == null)
            {
                this.UsuarioSeleccionado = '0';
            }

            if(this.UsuarioSeleccionado != '0' && this.UsuarioSeleccionado != '1'){

                if (this.RUT_Cliente == '' && this.NumeroCaso == '')
                {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                    ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                    Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                    Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                    CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                    Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                            FROM Case
                            WHERE CASO_Responsable_UR__c =: this.UsuarioSeleccionado AND (Status =: 'Cerrado' OR Status = 'Rechazado') AND 
                                  OwnerId =: this.IdColaUR 
                                  ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];                
                }
                else if(this.RUT_Cliente != '') {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                      ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                      Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                      Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                      CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                               		  Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                               FROM Case
                               WHERE CASO_Responsable_UR__c =: this.UsuarioSeleccionado AND (Status =: 'Cerrado' OR Status = 'Rechazado') AND 
                                     OwnerId =: this.IdColaUR AND Rut__c =:this.RUT_Cliente 
                                     ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];                

                }
                else if(this.NumeroCaso != '') {
                     this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                      ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                      Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                      Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                      CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                               		  Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                               FROM Case
                               WHERE CASO_Responsable_UR__c =: this.UsuarioSeleccionado AND (Status =: 'Cerrado' OR Status = 'Rechazado') AND 
                                     OwnerId =: this.IdColaUR AND CaseNumber =:this.NumeroCaso 
                                     ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];
                
                }                   
                
                system.debug('@@@@ CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());

            }else if (this.UsuarioSeleccionado == '1')
            {                
                if (this.RUT_Cliente == '' && this.NumeroCaso == '')
                {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE CASO_Responsable_UR__c = NULL AND (Status = 'Cerrado' OR Status = 'Rechazado') AND 
                                    OwnerId =: this.IdColaUR 
                                    ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];            
                }
                else if(this.RUT_Cliente != '') {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE CASO_Responsable_UR__c = NULL AND (Status = 'Cerrado' OR Status = 'Rechazado') AND 
                                    OwnerId =: this.IdColaUR AND Rut__c =:this.RUT_Cliente 
                                        ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];            
                }
                else if(this.NumeroCaso != '') {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE CASO_Responsable_UR__c = NULL AND (Status = 'Cerrado' OR Status = 'Rechazado') AND 
                                    OwnerId =: this.IdColaUR AND CaseNumber =:this.NumeroCaso
                                    ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];
                }   

                system.debug('@@@@ ELSE CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());
            }
            else if (this.UsuarioSeleccionado == '0')
            {   
                if (this.RUT_Cliente == '' && this.NumeroCaso == '')
                {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE OwnerId =: this.IdColaUR AND (Status = 'Cerrado' OR Status = 'Rechazado') 
                                ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];
                }
                else if(this.RUT_Cliente != '') {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE OwnerId =: this.IdColaUR AND (Status = 'Cerrado' OR Status = 'Rechazado') 
                                AND Rut__c =:this.RUT_Cliente
                                ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];
                }
                else if(this.NumeroCaso != '') {
                    this.LST_CasosUR = [SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	,
                                        ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, 
                                        Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c,
                                        Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, 
                                        CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c,
                                        Parent.OwnerId, Fecha_Asignacion_UR__c, Fecha_Hora_de_Cierre__c, Rut__c
                                FROM Case
                                WHERE OwnerId =: this.IdColaUR AND (Status = 'Cerrado' OR Status = 'Rechazado') 
                                AND CaseNumber =:this.NumeroCaso
                                ORDER BY Fecha_Hora_de_Cierre__c DESC LIMIT : this.Registros];
                }   

                system.debug('@@@@ ELSE (TODOS) CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());
                
            }       
            
            return null;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    }

    

        
    /*Método para navegar a página ver Caso seleccionado por Usuario UR*/
    public PageReference verCasoSeleccionado_HistorialUR(){
        try{
            String ID = apexpages.currentpage().getparameters().get('idCaso');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ID + '&idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    }

     /*Campo PICKLIST con Lista de Usuarios*/
    public List<Selectoption> getListarNumeroRegistros(){
        try{
            List<Selectoption> LST_NumeroRegistros = new List<Selectoption>();
            
            LST_NumeroRegistros.add(new Selectoption('250','250'));
            LST_NumeroRegistros.add(new Selectoption('200','200'));
            LST_NumeroRegistros.add(new Selectoption('150','150'));
            LST_NumeroRegistros.add(new Selectoption('100','100'));
            LST_NumeroRegistros.add(new Selectoption('50','50'));
            LST_NumeroRegistros.add(new Selectoption('25','25'));
            LST_NumeroRegistros.add(new Selectoption('10','10'));
            LST_NumeroRegistros.add(new Selectoption('5','5'));
            return LST_NumeroRegistros;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }
}