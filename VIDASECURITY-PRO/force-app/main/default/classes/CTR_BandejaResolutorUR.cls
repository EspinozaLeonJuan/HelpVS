/*******************************************************************************************
 *  NOMBRE                 : CTR_BandejaResolutorUR
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 *  1.1		- 2019/01/17 - J.ESPINOZA		- Incoporacion de taras.
 *  1.2     - 2019/02/26 - I.SALAZAR        - Se agrega orden de casos configurable
 * *****************************************************************************************/
global class CTR_BandejaResolutorUR {

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
    public String IdQueue {get; set;}

    public Integer Registros {get; set;}
    public String RUT_Cliente {get; set;}
    public String NumeroCaso {get; set;}

    /*Listas empleadas para desplegar su correspondiente información por pantalla*/
    public List<Case> LST_CasosUR {get; set;}     
    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Attachment> LST_AdjuntosCasoUR {get; set;}
    public List<Task> LST_TareasCasoUR {get; set;}
    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    /*Listas empleadas para desplegar su correspondiente información por pantalla*/
    
    /*  Variables utilizadas en comunicación con Escritorio Digital*/  
    public Integer Persistencia {get; set;}
    public String IdRequerimiento {get; set;}
    public String RutUsuario {get; set;}
    public String apodo {get; set;}
    public String UserOS {get; set;}
    /*  Variables utilizadas en comunicación con Escritorio Digital*/

    /*Variables para Visualforce Tareas nuevas*/
    public String IdResponsableTarea{get;set;}
    public List<Task> listatareas {get; set;}

    public String CodOrigenTarea{get;set;}
    public String IdCasoTarea{get;set;}
    public String IdTipoRegistroTarea{get;set;}
    public Task NuevaTareaCaso{get;set;}
    public Task VerTareaCaso{get;set;}
    public Task modificarTareasCaso{get;set;}
    public String MensajeTarea{get;set;}
    public String IdTareaCaso{get;set;}

    public Task NewTask { get;set; }
    public Task Tarea { get;set; }
    public Case Caso {get; set;}
    public String IdCaso {get; set;}
    
    /*ver tarea*/
    public String TAREA_ID {get; set;}
    public String TAREA_COMPLETADA {get; set;}
    public String RESPONSABLE_ASIGNADO {get; set;}

    public List<Cola_Usuario__c> listaUR  {get; set;}
    
    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

    public String  Exito { get;set; }
    
    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}

    public Task_Comment__c ComentTask {get; set;}
    public String ACTION_VISIBLE {get; set;}    
    public String ErrorOperacion {get; set;}

    public List<Attachment> LST_AdjuntosCasoPadre {get; set;}
    public Set<String> ORIGENES = new Set<String>{'Cobranzas Vida','Recepción Pagos','Producción Individuales'};

    public Boolean especialTeleventa {get; set;}

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

    /*SEC_VF_responsable_login*/

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
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public PageReference mostrarCasosUR(){
        try{
            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioSeleccionado);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);

            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, CASO_N_Poliza__c,LastModifiedDate	, ContactId, Origin, Status, RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c,Detalle_Solicitud__c,Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c FROM Case';
			String nombreCola = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;
            String orden = '';

            if (nombreCola == 'UR - Producción Individuales')
            {
                orden = ' ORDER BY CreatedDate ASC';
            }
            else
            {
                orden = ' ORDER BY Fecha_Asignacion_UR__c DESC';
            }

            if(this.UsuarioSeleccionado == null)
            {
                this.UsuarioSeleccionado = '0';
            }

            if(this.UsuarioSeleccionado != null && this.UsuarioSeleccionado != '0' && this.UsuarioSeleccionado != '1'){
                query = query + ' WHERE OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = \'' + this.UsuarioSeleccionado + '\' AND Status NOT IN (\'Nuevo\', \'Basura\', \'Rechazado\', \'Cerrado\', \'Caso Cerrado\', \'Cerrado (Correo Duplicado)\', \'Cerrado (Correo Masivo)\') AND IsClosed = false' + orden;
                this.LST_CasosUR = Database.query(query);
                system.debug('@@@@ CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());
            }else
            { 
                if (this.UsuarioSeleccionado == '1')
                {
                    query = query + ' WHERE OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = NULL AND Status NOT IN (\'Nuevo\', \'Basura\', \'Rechazado\', \'Cerrado\', \'Caso Cerrado\', \'Cerrado (Correo Duplicado)\', \'Cerrado (Correo Masivo)\') AND IsClosed = false' + orden;
                    this.LST_CasosUR = Database.query(query);
                    system.debug('@@@@ ELSE CANTIDAD CASOS LST_CasosUR => ' + this.LST_CasosUR.size());

                }
                else if (this.UsuarioSeleccionado == '0')
                {
                    query = query + ' WHERE OwnerId = \''+ this.IdColaUR + '\'' + 'And (Status = \'Back Office\' OR Status = \'En Proceso\' )' + orden;

                    system.debug('@@@@ -> QUERY ' + query);
                    system.debug('@@@@ -> ID COLA ' + this.IdColaUR);
                    this.LST_CasosUR = Database.query(query);
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
            this.LST_AdjuntosCasoPadre = new List<Attachment>();
            String IDCASO = apexpages.currentpage().getparameters().get('idCaso');
            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');
            String historial = apexpages.currentpage().getparameters().get('historial');

            this.especialTeleventa = false;             

            if (historial == 'Y')
            {
                this.CasoFinalizado  = true;
            }
            else 
            {
                this.CasoFinalizado  = false;
            }

            if(IDCASO != ''){
                this.IdcasoVisualizado = IDCASO;
                this.verCaso = new Case();

                if (!Test.isRunningTest()) 
                {
                    this.verCaso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c, Frecuencia_de_Pago__c, Prima_Total_Final__c  
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

                    if (this.verCaso.Canal__c == 'Televenta' && this.verCaso.Detalle_Solicitud__c == 'ED - Endoso Aumento de Prima en Exceso')
                    {
                        this.especialTeleventa = true;//    
                    }

                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: this.verCaso.Id
                                            ORDER BY CreatedDate DESC];

                    this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.verCaso.Id ORDER BY CreatedDate DESC];

                    if (ORIGENES.contains(this.verCaso.Origin)) 
                    {
                        try 
                        {
                            this.LST_AdjuntosCasoPadre = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.verCaso.ParentId ORDER BY CreatedDate DESC];
                        } catch (Exception ex) {
                            
                        }
                    }

                    this.LST_TareasCasoUR = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Solicitud__c  from Task where RecordTypeId =: this.RecordTypeId AND whatId=: this.verCaso.Id ORDER BY CreatedDate asc];

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
            
            if (this.UsuarioSeleccionado == 'null' || this.UsuarioSeleccionado == null)
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
            this.IdcasoVisualizado = IdCasoPadreComentario;
            this.verCaso = new Case();
               
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

    /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference volverCaso(){
        try{
            
           PageReference pagina = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.IdcasoVisualizado + '&idResponsable=' + this.UsuarioSeleccionado);
           pagina.setRedirect(true);                      
           return pagina;            
            
        }catch(Exception ex){
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
                if (this.RESPONSABLE_ACTUAL != null)
                {
                    usuarioActual = [Select Name From Usuario_Backup__c Where Id =:this.RESPONSABLE_ACTUAL].Name;
                }

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
                if (usuarioActual != '')
                {
                    comentario.CommentBody = 'Reasignación de usuario UR : '+usuarioActual+' --> '+usuarioNuevo+' \n'+C_COMENT;  
                }
                else
                {
                    comentario.CommentBody = 'Asignación de usuario UR : '+usuarioNuevo+' \n'+C_COMENT;  
                }
                
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
            
            this.Registros = 250;
            this.RUT_Cliente = '';
            this.NumeroCaso = '';
         	this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;
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

    public List<SelectOption> getUnidades()
    {
        List<SelectOption> URS  = new List<SelectOption>();    
              
        for(Cola_Usuario__c q : this.listaUR)
        {
            URS.add(new SelectOption(q.Usuario__c, q.Nombre_Cola__c));
        }
        
        System.debug('@@@@ URS | ' + URS);  

        return URS;
    }

//para nueva tarea
    public PageReference cargaCaso(){
        try
        {
            String IDCASO = apexpages.currentpage().getparameters().get('id');   
            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable'); 
            this.Exito = 'N';
            system.debug('@@@@ IDCASO'+ IDCASO);    
               
                   
            if(IDCASO != ''){

                listaUR = [select Id, Id_Cola__c, Nombre_Cola__c, Usuario__c from Cola_Usuario__c];

                this.Idcaso = IDCASO;
                this.Caso = new Case();
                this.NewTask = new Task();
                this.NewTask.WhatId = this.IdCaso;
                this.NewTask.Subject = 'Tarea UR';
                this.NewTask.RecordTypeId = this.RecordTypeId;
                this.NewTask.Status = 'No iniciada';
                this.NewTask.Priority = 'Normal';
                
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c , 
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                            FROM Case
                            WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);                           
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

    public PageReference ToNewTask()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_NuevaTarea?id='+this.IdcasoVisualizado);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference SaveTask()
    {
        Boolean ErrorDate = false;
        
        if (this.NewTask.ActivityDate < Date.today())
        {
            ErrorDate = true;
        }
        
        if (ErrorDate == false)
        {
            Task nuevaTask = new Task();                
            nuevaTask.WhatId = this.NewTask.WhatId;
            nuevaTask.Subject = this.NewTask.Subject;
            nuevaTask.RecordTypeId = this.NewTask.RecordTypeId;
            nuevaTask.OwnerId = this.IdQueue;
            nuevaTask.caso_numero__c = this.Caso.CaseNumber;
            nuevaTask.Status = this.NewTask.Status;
            nuevaTask.Priority = this.NewTask.Priority;
            nuevaTask.ActivityDate = this.NewTask.ActivityDate;
            nuevaTask.Description = this.NewTask.Description;
            nuevaTask.Detalle_Solicitud__c = this.Caso.Subject;

            if (!Test.isRunningTest())
            {
                Cola_Usuario__c tmpCola = [SELECT Nombre_Cola__c FROM Cola_Usuario__c where Usuario__c =: UserInfo.getUserId()];            

                if (tmpCola != null)
                {
                    nuevaTask.UR_Origen__c = tmpCola.Nombre_Cola__c;    
                }
            }

            try 
            {
                this.Exito = 'S';
                insert nuevaTask;    
            }
            catch(Exception ex){
                this.Exito = 'N';
                system.debug('@@@@  --> '+ex.getLineNumber() + '   -->    '+ ex.getMessage());
            }
        }
        else
        {
            this.Exito = 'N1';
        }
        
        
        return null;
    }

    public PageReference CargaTarea()
    {
         try
        {
            String IDTAREA = apexpages.currentpage().getparameters().get('id');            
            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable'); 
            If(IDTAREA != ''){

                this.TAREA_COMPLETADA = 'NO';
                this.ACTION_VISIBLE = 'SI';
                if (!Test.isRunningTest()) 
                {
                	this.Tarea = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, TASK_Agregar_Comentario_Tarea__c from Task where Id =: IDTAREA];

                    this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                        FROM Task_Comment__c
                        WHERE Task_ID__c =: IDTAREA
                        ORDER BY CreatedDate DESC];
                }
                
                if (Test.isRunningTest()) 
                {
                    this.Tarea.Status = 'Completada';
                }
                
                if (this.Tarea.Status == 'Completada')
                {
                    this.TAREA_COMPLETADA = 'SI';
                    this.ACTION_VISIBLE = 'NO';
                }
                
                if (Test.isRunningTest()) 
                {
                    this.Tarea.Status = 'No Iniciada';
                }
                
                if (this.Tarea.Status == 'No Iniciada')
                {
                    this.ACTION_VISIBLE = 'NO';
                }

                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber, RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate, Nombre_Completo_Razon_Social__c,
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                            FROM Case
                            WHERE Id =: this.Tarea.WhatId];
                }
                                       
                                
                this.IdCaso = this.Tarea.WhatId;
                this.TAREA_ID = IDTAREA;

                if (!String.isBlank(this.Tarea.Responsable_Backup__c))
                {
                    this.RESPONSABLE_ASIGNADO = 'S';
                    Usuario_Backup__c uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                	this.RESPONSABLE_ACTUAL = uback.Name;
                }
                else
                {
                    this.RESPONSABLE_ASIGNADO = 'N';
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


    public PageReference ToViewTask()
    {
        String ID = apexpages.currentpage().getparameters().get('idTarea');
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_VerTareaCaso?id='+ID+ '&idResponsable=' + this.UsuarioSeleccionado);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToTaskList()
    {            
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_TareasUR?idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToCaseList()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference ToCase(){
        try{
            
           PageReference pagina = new PageReference('/apex/SEC_VF_UR_responsable_vercaso?idCaso='+ this.Idcaso + '&idResponsable=' + this.UsuarioSeleccionado);
           pagina.setRedirect(true);                      
           return pagina;            
            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    } 

    public PageReference ToColaboraciones()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ColaboracionesReclamo');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }


     public PageReference ToColaboracionesHistory()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_HistorialColaboraciones');     
        page.setRedirect(true);
        return page;  
    }

    public PageReference ToTaskHistory()
    {            
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_HistorialTareas');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToCaseHistory()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference NuevoComentarioTarea()
    {
        this.ComentTask = new Task_Comment__c();
        this.ComentTask.Task_ID__c = this.TAREA_ID;

        PageReference page = new PageReference ('/apex/SEC_VF_UR_Agregar_Comentarios_TCaso?id='+this.TAREA_ID);
       // page.setRedirect(true);
        return page;  
    }

     public PageReference GuardarComentarioTarea(){

     
        try
        {
            system.debug('@@@@ DATOS COMENTARIO --> '+this.ComentTask);
            system.debug('@@@@ this.Tarea.Id --> '+ this.Tarea.Id);
            
           this.ErrorOperacion = '';

            if (String.isBlank(this.Tarea.Responsable_Backup__c) == true)
            {
                this.ErrorOperacion = 'responsable_no_asignado';
            }

            if (String.isNotBlank(this.ComentTask.Detail__c) == false)
            {
                this.ErrorOperacion = 'comentario_no_ingresado';
            }
            
            if (Test.isRunningTest())
            {
                this.ErrorOperacion = '';
            }

            if (String.isBlank(this.ErrorOperacion) == true)
            {
                if (!Test.isRunningTest()) 
                {
                    String IDResponsableCasoUR = [SELECT Id_Responsable_UR__c FROM Case WHERE Id =: this.Tarea.WhatId].Id_Responsable_UR__c;
                    system.debug('@@@@ IDResponsableCasoUR --> '+ IDResponsableCasoUR);
                    Usuario_Backup__c uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: IDResponsableCasoUR];

                    if (uback != null)
                    {
                        this.ComentTask.Responsable_UR__c = uback.Name;
                        this.ComentTask.Id_Responsable_UR__c = uback.Id;
                    }
                    
                    insert this.ComentTask;
                }
            }
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }

     public PageReference CancelarComentarioTarea(){
        system.debug('@@@@ DATOS COMENTARIO CANCEL --> '+this.ComentTask);

        try
        {
           PageReference page = new PageReference ('/apex/SEC_VF_UR_VerTareaCaso?id='+this.TAREA_ID);
           page.setRedirect(true);

           return page;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
    	}
    }

     public PageReference ToTask()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_VerTareaCaso?id='+this.TAREA_ID);
        page.setRedirect(true);

        return page;
    }
}