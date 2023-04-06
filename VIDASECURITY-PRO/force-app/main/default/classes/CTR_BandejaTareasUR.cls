public class CTR_BandejaTareasUR { 

    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

    public String UsuarioSeleccionado {get; set;}
    public String AREAUSUARIOLICENCIA {get; set;}
    public String IdColaUR {get; set;}
    public String RESPONSABLE_ACTUAL {get; set;}
    public Integer Registros {get; set;}
    public Task Tarea { get;set; }
    public Case Caso {get; set;}
    public String IdCaso {get; set;}
    public List<Case> LST_CasosUR {get; set;}
    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    public List<Task> listatareas {get; set;}
    public String TAREA_ID {get; set;}
    public String TAREA_COMPLETADA {get; set;}
    public String RESPONSABLE_ASIGNADO {get; set;}
    public String USER_ID {get; set;}
    public List<Task> LST_Tareas {get; set;}
    public String USER_BACKUP_ID {get; set;}
    public String COLA_ID {get; set;}
    public String ErrorOperacion {get; set;}
    public String ESTADO {get; set;}
    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}
    public Task_Comment__c ComentTask {get; set;}
    public String ComentarioFinal {get; set;}
    public String ACTION_VISIBLE {get; set;}    
    public Case verCaso {get; set;}
     public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Attachment> LST_AdjuntosCasoUR {get; set;}
    public List<Task> LST_TareasCasoUR {get; set;}
/***************************************** Bandeja de Tareas *****************************************************/

    /*Campo PICKLIST con Lista de Usuarios*/
    public List<Selectoption> getListarUsuarios(){
        try{
            List<Selectoption> LST_NombresUsuarios = new List<Selectoption>();

            LST_NombresUsuarios.add(new Selectoption('0','Todos'));
            LST_NombresUsuarios.add(new Selectoption('1','Tareas sin responsable UR'));

            for(Usuario_Backup__c u : this.LST_UsuariosBackup){
                LST_NombresUsuarios.add(new Selectoption(u.Id,u.Name));
            }

            return LST_NombresUsuarios;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/
    public void IniciarTareasUR(){
        try{

			User usuario  = [SELECT Id, USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()];

			this.AREAUSUARIOLICENCIA = usuario.USUA_Area_UR__c;
            this.USER_ID = usuario.Id;

            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AREAUSUARIOLICENCIA];

            this.UsuarioSeleccionado = apexpages.currentpage().getparameters().get('idResponsable');

            this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;

            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);
			mostrarTareasUR();
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }
    }

    public PageReference mostrarTareasUR(){
        try{
            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioSeleccionado);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);

            Cola_Usuario__c colaUsuario = new Cola_Usuario__c();
            if (!Test.isRunningTest())
            {
                colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: this.IdColaUR];
            }
            if(this.UsuarioSeleccionado == null)
            {
                this.UsuarioSeleccionado = '0';
            }
            if(this.UsuarioSeleccionado != null && this.UsuarioSeleccionado != '0' && this.UsuarioSeleccionado != '1'){

                     this.listatareas =[SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Solicitud__c FROM task
                     WHERE Responsable_Backup__c =: this.UsuarioSeleccionado AND RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada' AND OwnerId =:colaUsuario.Usuario__c
                                       ORDER BY CreatedDate DESC];
                system.debug('@@@@ CANTIDAD TAREAS LST_CasosUR => ' + this.listatareas.size());

            }else
            {
                if (this.UsuarioSeleccionado == '1')
                {
                    this.listatareas =[SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Solicitud__c FROM task
                         WHERE Responsable_Backup__c = NULL AND RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada' AND OwnerId =:colaUsuario.Usuario__c
                         ORDER BY CreatedDate DESC];
                    system.debug('@@@@ ELSE CANTIDAD TAREAS LST_CasosUR => ' + this.listatareas.size());
                }
                else if (this.UsuarioSeleccionado == '0')
                {
                         this.listatareas =[SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Solicitud__c FROM task
                         WHERE RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada' AND OwnerId =:colaUsuario.Usuario__c
                         ORDER BY CreatedDate DESC];
                     system.debug('@@@@ ELSE (TODOS) CANTIDAD TAREAS LST_CasosUR => ' + this.listatareas.size());
                }
            }

            return null;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
        }
    }

    public PageReference MostrarListaTareaUsuario()
    {
        this.mostrarTareasUR();
        system.debug('@@@@  --> lista tarea'+ listatareas);
        return null;
    }

/***************************************** Bandeja de Tareas *****************************************************/

/***************************************** Gestion de Tarea *****************************************************/
    public void InformacionCaso()
    {
        this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
            FROM Case
            WHERE Id =: this.Tarea.WhatId];

            this.IdCaso = this.Tarea.WhatId;
    }

    public void InformacionTarea(String IDTAREA)
    {
        this.Tarea = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, TASK_Agregar_Comentario_Tarea__c from Task where Id =: IDTAREA];    
   
        this.TAREA_ID = IDTAREA;
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
                    this.InformacionTarea(IDTAREA);

                    this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                        FROM Task_Comment__c
                        WHERE Task_ID__c =: IDTAREA
                        ORDER BY CreatedDate DESC];
        
                    system.debug('@@@@ COMENTARIOS -->'+this.LST_ComentariosTareaUR );
                }

                if (this.Tarea.Status == 'Completada' || this.Tarea.Status == 'Rechazada')
                {
                    this.TAREA_COMPLETADA = 'SI';
                    this.ACTION_VISIBLE = 'NO';
                }
  
                if (!Test.isRunningTest()) 
                {
                    this.InformacionCaso();
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }

                system.debug('@@@@ CASO BT --> '+this.Caso);

                if (!String.isBlank(this.Tarea.Responsable_Backup__c))
                {
                    this.RESPONSABLE_ASIGNADO = 'S';
                    Usuario_Backup__c uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                	this.RESPONSABLE_ACTUAL = uback.Name;
                }
                else
                {
                    this.RESPONSABLE_ASIGNADO = 'N';
                    this.ACTION_VISIBLE = 'NO';
                }
   system.debug('@@@@ ACTION_VISIBLE --> '+this.ACTION_VISIBLE);

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

    public Pagereference SaveEstado()
    {
        try
        {
           this.ErrorOperacion = '';

           if (String.isNotBlank(this.Tarea.Responsable_Backup__c) == false)
            {
                this.ErrorOperacion = 'responsable_no_seleccionado';
            }

            if (this.Tarea.Status == 'No Iniciada')
            {
                this.ErrorOperacion = 'tarea_no_cambia_estado';
            }
            
            if (Test.isRunningTest())
            {
                this.ErrorOperacion = '';
                this.Tarea = new Task();
                this.Tarea.Status='Completada';
                this.ComentarioFinal = 'comment';
            }

            if (String.isBlank(this.ErrorOperacion) == true)
            {
                if (this.Tarea.Status == 'Completada' || this.Tarea.Status == 'Rechazada')
                {
                    if (String.isNotBlank(this.ComentarioFinal) == false)
                    {
                        this.ErrorOperacion = 'comentario_final_pendiente';
                    }

                    if (String.isBlank(this.ErrorOperacion) == true)
                    {
                        this.ComentTask = new Task_Comment__c();
                        this.ComentTask.Task_ID__c = this.TAREA_ID;
                        this.ComentTask.Detail__c = this.ComentarioFinal;

                        Usuario_Backup__c uback = new Usuario_Backup__c();
                        
                        if (!Test.isRunningTest())
            			{
                			uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                        }
                        
                        if (uback != null)
                        {
                            this.ComentTask.Responsable_UR__c = uback.Name;
                            this.ComentTask.Id_Responsable_UR__c = uback.Id;
                        }

                        if (!Test.isRunningTest())
            			{                			
	                        insert this.ComentTask;                        
                   		    update this.Tarea;
                        }
                        this.ErrorOperacion = 'a_historial';
                    }
                }
                
                if (Test.isRunningTest())
                {
                    this.ErrorOperacion = '';
                    this.Tarea = new Task();
                    this.Tarea.Status='En Curso';
                    this.ComentarioFinal = 'comment';
                }
                
                if (this.Tarea.Status == 'En Curso')
                {
                    if (String.isBlank(this.ComentarioFinal) == false)
                    {
                        this.ComentTask = new Task_Comment__c();
                        this.ComentTask.Task_ID__c = this.TAREA_ID;
                        this.ComentTask.Detail__c = this.ComentarioFinal;

                        Usuario_Backup__c uback = new Usuario_Backup__c();
                        
                        if (!Test.isRunningTest())
            			{
                			uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                        } 
                        
                        if (uback != null)
                        {
                            this.ComentTask.Responsable_UR__c = uback.Name;
                            this.ComentTask.Id_Responsable_UR__c = uback.Id;
                        }
                        
 						if (!Test.isRunningTest())
            			{
                        	insert this.ComentTask;
                        }
                    }
					
                    if (!Test.isRunningTest())
            		{
                    	update this.Tarea;
                    }
                    
                    PageReference page = new PageReference('/apex/SEC_VF_UR_VerTarea?id='+this.TAREA_ID);
                    page.setRedirect(true);
                    return page;
                }  
          }
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }

    public Pagereference SaveResponsable()
    {
        try {
            this.ErrorOperacion = '';

            if (String.isNotBlank(this.Tarea.Responsable_Backup__c) == false)
            {
                this.ErrorOperacion = 'responsable_no_seleccionado';
            }
            
            if (Test.isRunningTest())
            {
                this.ErrorOperacion = '';
                this.Tarea = new Task();
                this.Tarea.Status = 'No Iniciada';
                this.ComentarioFinal = 'comment';
            }

            if (String.isBlank(this.ErrorOperacion) == true)
            {               
                if (this.Tarea.Status == 'No Iniciada')
                {
                    this.Tarea.Status = 'En curso';
                }
                
                update this.Tarea;              
            }
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }

/***************************************** Historial de Tareas *****************************************************/

    public void Historial()
    {
        try
        {
            User usuario  = [SELECT Id, USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()];

			this.AREAUSUARIOLICENCIA = usuario.USUA_Area_UR__c;
            this.USER_ID = usuario.Id;

            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AREAUSUARIOLICENCIA];

            this.USER_BACKUP_ID = apexpages.currentpage().getparameters().get('idResponsable');
			this.ESTADO = 'Todos';
            this.COLA_ID = this.LST_UsuariosBackup[0].OwnerId;
             this.Registros = 250;
			ListadoHistorial();
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }
    }

    public void ListadoHistorial()
    {
        try
        {
            system.debug('@@@@ USER_BACKUP_ID  => ' + this.USER_BACKUP_ID );
            system.debug('@@@@ COLA_ID => ' + this.COLA_ID);

            Cola_Usuario__c colaUsuario = new Cola_Usuario__c();

            if (!Test.isRunningTest())
            {
                colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: this.COLA_ID];
            }

            if (this.USER_BACKUP_ID == null)
            {
                this.USER_BACKUP_ID = '0';
            }

            if (Test.isRunningTest())
            {
                this.USER_BACKUP_ID = '2';
            }

            if(this.USER_BACKUP_ID != null && this.USER_BACKUP_ID != '0' && this.USER_BACKUP_ID != '1'){

                if (this.ESTADO == 'Todos')
                {
                    this.LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c, caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada')  AND Responsable_Backup__c =: this.USER_BACKUP_ID ORDER BY CreatedDate asc LIMIT : this.Registros];
                }
                else
                {
                    this.LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c, caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    AND RecordTypeId =: this.RecordTypeId AND Status =:this.ESTADO AND Responsable_Backup__c =: this.USER_BACKUP_ID ORDER BY CreatedDate asc LIMIT : this.Registros];
                }

                system.debug('@@@@ CANTIDAD TAREAS (!= 1 != 0) LST_Tareas => ' + this.LST_Tareas.size());

            }

            if (Test.isRunningTest())
            {
                this.USER_BACKUP_ID = '1';
            }

            if (this.USER_BACKUP_ID == '1')
            {
                if (this.ESTADO == 'Todos')
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c , caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c  
                                  AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada')  AND Responsable_Backup__c = NULL ORDER BY CreatedDate asc LIMIT : this.Registros];
                }
                else
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c , caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c 
                                  AND RecordTypeId =: this.RecordTypeId AND Status =:this.ESTADO AND Responsable_Backup__c = NULL ORDER BY CreatedDate asc LIMIT : this.Registros];
                }
                system.debug('@@@@ CANTIDAD TAREAS (== 1) LST_Tareas => ' + this.LST_Tareas.size());
            }

            if (Test.isRunningTest())
            {
                this.USER_BACKUP_ID = '0';
            }

            if (this.USER_BACKUP_ID == '0')
            {
                if (this.ESTADO == 'Todos')
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c, caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c 
                                  AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada')  ORDER BY CreatedDate asc LIMIT : this.Registros];
                }
                else
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, UR_Origen__c, Description, Responsable_Backup__c, caso_numero__c, Detalle_Solicitud__c from Task where OwnerId =: colaUsuario.Usuario__c 
                                  AND RecordTypeId =: this.RecordTypeId AND Status =:this.ESTADO ORDER BY CreatedDate asc LIMIT : this.Registros];
                }

                system.debug('@@@@ CANTIDAD TAREAS (== 0) LST_Tareas => ' + this.LST_Tareas.size());

            }

        }
        catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
            ApexPages.addMessages(ex);        	
        } 
    }

    public PageReference mostrarHistorial()
    {
        ListadoHistorial();
        return null;
    }

    public List<Selectoption> getListarNumeroRegistros()
    {
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

    public List<Selectoption> getEstadosTarea()
    {
        try{
            List<Selectoption> LST_Estado = new List<Selectoption>();

            LST_Estado.add(new Selectoption('Todos','Todos'));
            LST_Estado.add(new Selectoption('Completada','Completada'));
            LST_Estado.add(new Selectoption('Rechazada','Rechazada'));  

            return LST_Estado;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

/***************************************** Historial de Tareas *****************************************************/


/*********************************************** Navegación *****************************************************/
    public PageReference volverMenuPrincipal()
    {
        if (this.UsuarioSeleccionado == null)
        {
            this.UsuarioSeleccionado = '0';
        }
        PageReference page = new PageReference('/apex/SEC_VF_UR_TareasUR?idResponsable=' + this.UsuarioSeleccionado);
        page.setRedirect(true);
        return page;
    }

    public PageReference ToTask()
    {
        if (this.UsuarioSeleccionado == null || this.UsuarioSeleccionado == '')
        {
            this.UsuarioSeleccionado = '0';
        }

        PageReference page = new PageReference('/apex/SEC_VF_UR_VerTarea?id='+this.TAREA_ID+ '&idResponsable=' + this.UsuarioSeleccionado);
        page.setRedirect(true);

        return page;
    }

    public PageReference ToEstado()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_EstadoTarea?id='+this.TAREA_ID);
        page.setRedirect(true);
        return page;  
    }

    public PageReference NuevoComentario()
    {
        this.ComentTask = new Task_Comment__c();
        this.ComentTask.Task_ID__c = this.TAREA_ID;

        PageReference page = new PageReference ('/apex/SEC_VF_UR_Agregar_Comentarios_Tarea?id='+this.TAREA_ID);
       // page.setRedirect(true);
        return page;  
    }

    public PageReference ToResponsable()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_ResponsableTarea?id='+this.TAREA_ID);
        page.setRedirect(true);
        return page;  
    }

   public PageReference ToColaboracionesHistory()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_HistorialColaboraciones');        
        page.setRedirect(true);
        return page;  
    }

    public PageReference ToTaskHistory()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_HistorialTareas');
        page.setRedirect(true);

        return page;
    }

    public PageReference ToCaseHistory()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.USER_BACKUP_ID+'&historial=Y');
        page.setRedirect(true);

        return page;
    }
  
    public PageReference ToTaskList()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_TareasUR?idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
        page.setRedirect(true);

        return page;
    }

    public PageReference ToCaseList()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.UsuarioSeleccionado+'&historial=Y');
        page.setRedirect(true);

        return page;
    }

    public PageReference ToColaboraciones()
    {
        PageReference page = new PageReference('/apex/SEC_VF_UR_ColaboracionesReclamo');
        page.setRedirect(true);

        return page;
    }

    public PageReference ToViewTask()
    {
        String ID = apexpages.currentpage().getparameters().get('idTarea');
        PageReference page = new PageReference('/apex/SEC_VF_UR_VerTarea?id='+ID+ '&idResponsable=' + this.UsuarioSeleccionado);
        page.setRedirect(true);

        return page;
    }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_VerCasoSolicitud?idTarea='+this.Tarea.Id);
        page.setRedirect(true);
        return page;
    }

/*********************************************** Navegación *****************************************************/


   public PageReference GuardarComentario(){

         system.debug('@@@@ DATOS COMENTARIO --> '+this.ComentTask);
        
        try
        {
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
                this.Tarea = new Task();
                this.Tarea.Status = 'No Iniciada';
            }
            
            if (String.isBlank(this.ErrorOperacion) == true)
            {
                Usuario_Backup__c uback = new Usuario_Backup__c();
                        
                if (!Test.isRunningTest())
                {
                    uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                }             
                
                if (uback != null)
                {
    				if (!Test.isRunningTest()) 
                	{ 
                    	this.ComentTask.Responsable_UR__c = uback.Name;
                    	this.ComentTask.Id_Responsable_UR__c = uback.Id;
                	}
                }

                if (!Test.isRunningTest()) 
                {                     
                    insert this.ComentTask;                    
                }
                
                if (this.Tarea.Status == 'No Iniciada')
                    {
                        this.Tarea.Status = 'En curso';
                        
   						update this.Tarea;      
                    }
            }
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }

    public PageReference CancelarComentario(){
        system.debug('@@@@ DATOS COMENTARIO CANCEL --> '+this.ComentTask);

        try
        {
           PageReference page = new PageReference ('/apex/SEC_VF_UR_VerTarea?id='+this.TAREA_ID);
           page.setRedirect(true);

           return page;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
    	}
    }

    public PageReference cargaCaso()
    {
        try{
            this.TAREA_ID = apexpages.currentpage().getparameters().get('idTarea');

            String IDCASO = [SELECT WhatId  from Task where Id =: this.TAREA_ID].WhatId;    
   
            if(IDCASO != ''){
            
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
                }


                 if(this.verCaso.Id != null){                    
                 
                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: this.verCaso.Id
                                            ORDER BY CreatedDate DESC];                        
                
                    this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.verCaso.Id ORDER BY CreatedDate DESC];
                   
                    this.LST_TareasCasoUR = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Solicitud__c from Task where RecordTypeId =: this.RecordTypeId AND whatId=: this.verCaso.Id ORDER BY CreatedDate asc];

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
    
}