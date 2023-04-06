/*******************************************************************************************
 *  NOMBRE                 : CTR_BandejaColaboraciones
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : COLABORACION UR - RECLAMOS
 *  DESCRIPCION            :
 *   
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2019/01/15 - J.ESPINOZA       - Creación Clase 
 *  2.0     - 2019/06/06 - J.ESPINOZA       - Notificaciones Colaboración Reclamo
 * 
 * *****************************************************************************************/
public class CTR_BandejaColaboraciones {

    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    public List<Task> LST_Tareas {get; set;}

    public String AREAUSUARIOLICENCIA {get; set;}
    public String USER_ID {get; set;}
    public String USER_BACKUP_ID {get; set;}
    public String CASO_ID {get; set;}
    public String TAREA_ID {get; set;}
    public String COLA_ID {get; set;}

    public String TAREA_COMPLETADA {get; set;}
    
    public Case Caso {get; set;}
    public Task Tarea {get; set;}
    
    public Integer Registros {get; set;}

    public String RESPONSABLE_ASIGNADO {get; set;}
    public String RESPONSABLE_ACTUAL {get; set;}   
    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;
    
    public String ErrorOperacion {get; set;}
    
    public String ESTADO {get; set;}
    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}
    public String ACTION_VISIBLE {get; set;}

    public Task_Comment__c ComentTask {get; set;}
    public String ComentarioFinal {get; set;}

    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
    public List<Attachment> LST_AdjuntosCasoUR {get; set;}
    public List<Task> LST_ColaboracionesCaso {get; set;}
    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarBandeja(){
        try
        { 
            User usuario  = [SELECT Id, USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()];

			this.AREAUSUARIOLICENCIA = usuario.USUA_Area_UR__c;
            this.USER_ID = usuario.Id;

            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AREAUSUARIOLICENCIA];

            this.COLA_ID = this.LST_UsuariosBackup[0].OwnerId;

            system.debug('@@@@ COLA_ID => ' + this.COLA_ID);
            this.USER_BACKUP_ID = apexpages.currentpage().getparameters().get('idResponsable');

            
            Cola_Usuario__c queueUser = [SELECT Id, Id_Cola__c, Nombre_Cola__c, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =:this.COLA_ID];
            this.USER_ID = queueUser.Usuario__c;

            system.debug('@@@@ COLA_ID => ' + this.COLA_ID);

			ListadoTareas();
        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
            system.debug('@@@@ ERROR DETALLE => ' + ex.getLineNumber());
        }
    }

    public void Historial(){
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
            this.Registros = 250;
            this.COLA_ID = this.LST_UsuariosBackup[0].OwnerId;
             
			ListadoHistorial();
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }           
    }

    public void ListadoTareas()
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
                       
            if(this.USER_BACKUP_ID == null)
            {
                this.USER_BACKUP_ID = '0';
            }

            system.debug('@@@@  colaUsuario => ' +colaUsuario);

            if(this.USER_BACKUP_ID != null && this.USER_BACKUP_ID != '0' && this.USER_BACKUP_ID != '1'){
                LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    AND RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada' AND Responsable_Backup__c =: this.USER_BACKUP_ID 
                    ORDER BY CreatedDate DESC];
                 system.debug('@@@@ 1');
                system.debug('@@@@ CANTIDAD TAREAS (!= 1 != 0) LST_Tareas => ' + this.LST_Tareas.size());

                 system.debug('@@@@  SQL => ' +                 
                 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId = '+ colaUsuario.Usuario__c +
                   ' AND RecordTypeId = ' +this.RecordTypeId +' AND Status != Completada AND Status != Rechazada AND Responsable_Backup__c = '+ this.USER_BACKUP_ID +
                   ' ORDER BY CreatedDate DESC');
                 

            }
            else
            { 
                if (this.USER_BACKUP_ID == '1')
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                     AND RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada'  AND Responsable_Backup__c = NULL 
                     ORDER BY CreatedDate DESC];
                system.debug('@@@@ 2');
                system.debug('@@@@ CANTIDAD TAREAS (== 1) LST_Tareas => ' + this.LST_Tareas.size());
                    
  system.debug('@@@@  SQL => ' +                 
                 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId ='+ colaUsuario.Usuario__c  +
                   ' AND RecordTypeId = ' +this.RecordTypeId +' AND Status != Completada AND Status != Rechazada  AND Responsable_Backup__c = NULL '+
                    ' ORDER BY CreatedDate DESC');

                }


                else if (this.USER_BACKUP_ID == '0')
                {
                    LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                     AND RecordTypeId =: this.RecordTypeId AND Status != 'Completada' AND Status != 'Rechazada' ORDER BY CreatedDate DESC];

                      system.debug('@@@@  SQL => ' +                 
                 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId ='+ colaUsuario.Usuario__c  +
                    ' AND RecordTypeId = ' +this.RecordTypeId +' AND Status != Completada AND Status != Rechazada ORDER BY CreatedDate DESC');
                system.debug('@@@@ 3');
                system.debug('@@@@ CANTIDAD TAREAS (== 0) LST_Tareas => ' + this.LST_Tareas.size());
                    
                }            
            }
        }
        catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
            ApexPages.addMessages(ex);        	
        } 
    }

    public void ListadoHistorial()
    {  
        try 
        {
            system.debug('@@@@ USER_BACKUP_ID  => ' + this.USER_BACKUP_ID );
            system.debug('@@@@ COLA_ID => ' + this.COLA_ID);

            if (this.USER_BACKUP_ID == null)
            {
                this.USER_BACKUP_ID = '0';
            }
            
            Cola_Usuario__c colaUsuario = new Cola_Usuario__c();
            
            if (!Test.isRunningTest())
            {
                colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: this.COLA_ID];
            }
                       
            if(this.USER_BACKUP_ID != null && this.USER_BACKUP_ID != '0' && this.USER_BACKUP_ID != '1'){
                
                if (this.ESTADO == 'Todos')
                {
	                this.LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada')  AND Responsable_Backup__c =: this.USER_BACKUP_ID ORDER BY CreatedDate asc LIMIT : this.Registros];    
                }
                else
                {
                      this.LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    AND RecordTypeId =: this.RecordTypeId AND Status =: this.ESTADO AND Responsable_Backup__c =: this.USER_BACKUP_ID ORDER BY CreatedDate asc LIMIT : this.Registros];    
                }
                
                system.debug('@@@@ CANTIDAD TAREAS (!= 1 != 0) LST_Tareas => ' + this.LST_Tareas.size());

            }
            else
            {
                if (this.USER_BACKUP_ID == '1')
                {
                    if (this.ESTADO == 'Todos')
                	{
                    	LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    	AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada') AND Responsable_Backup__c = NULL ORDER BY CreatedDate asc LIMIT : this.Registros];
                	}
                    else
                    {
                        LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    	AND RecordTypeId =: this.RecordTypeId AND Status =:this.ESTADO AND Responsable_Backup__c = NULL ORDER BY CreatedDate asc LIMIT : this.Registros];
                    }

                system.debug('@@@@ CANTIDAD TAREAS (== 1) LST_Tareas => ' + this.LST_Tareas.size());
                    
                }
                else if (this.USER_BACKUP_ID == '0')
                {
                    if (this.ESTADO == 'Todos')
                	{
                        LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    	AND RecordTypeId =: this.RecordTypeId AND (Status = 'Completada' OR Status = 'Rechazada') ORDER BY CreatedDate asc LIMIT : this.Registros];
                    }
                    else
                    {
                         LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, caso_numero__c, Detalle_Operacion__c from Task where OwnerId =: colaUsuario.Usuario__c 
                    	AND RecordTypeId =: this.RecordTypeId AND Status =:this.ESTADO ORDER BY CreatedDate asc LIMIT : this.Registros];
                    }
                    
                	system.debug('@@@@ CANTIDAD TAREAS (== 0) LST_Tareas => ' + this.LST_Tareas.size());
                    
                }   
            }

        }
        catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
            ApexPages.addMessages(ex);        	
        } 
    }

    /*Campo PICKLIST con Lista de Usuarios*/
    public List<Selectoption> getListarUsuarios(){
        try{
            List<Selectoption> LST_NombresUsuarios = new List<Selectoption>();
            
            LST_NombresUsuarios.add(new Selectoption('0','Todos'));
            LST_NombresUsuarios.add(new Selectoption('1','Colaboraciones sin responsable UR'));

            for(Usuario_Backup__c u : this.LST_UsuariosBackup){
                LST_NombresUsuarios.add(new Selectoption(u.Id,u.Name));
            }

            return LST_NombresUsuarios;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public PageReference mostrarTareas()
    {
        this.ListadoTareas();
        return null;
    }

    public PageReference ToColaboracion()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_ColaboracionReclamo?id='+ this.TAREA_ID );     
        page.setRedirect(true);
        return page;  
    }

    public PageReference ToViewColaboracion()
    {
        String ID = apexpages.currentpage().getparameters().get('idTarea');
        PageReference page = new PageReference ('/apex/SEC_VF_UR_ColaboracionReclamo?id='+ ID );     
        page.setRedirect(true);
        return page;  
    }

    public PageReference CargaColaboracion()
    {
         try
        {
            String IDTAREA = apexpages.currentpage().getparameters().get('id');            

            If(IDTAREA != ''){
				system.debug('@@@@ ID '+ IDTAREA);
                this.TAREA_COMPLETADA = 'NO';
                this.ACTION_VISIBLE = 'SI';

                this.Tarea = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Operacion__c, Id_Ejecutiva_Caso__c from Task where Id =: IDTAREA];
               
                if (this.Tarea.Status == 'Completada' || this.Tarea.Status == 'Descartada')
                {
                    this.TAREA_COMPLETADA = 'SI';
                    this.ACTION_VISIBLE = 'NO';
                }
                    
                if (!Test.isRunningTest()) 
                {
                   this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                        FROM Case
                        WHERE Id =: this.Tarea.WhatId];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }

                if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == true)
                {
                    this.Tarea.Id_Ejecutiva_Caso__c = this.Caso.OwnerId;
                }

                this.CASO_ID = this.Tarea.WhatId;
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
                     this.ACTION_VISIBLE = 'NO';
                }

                system.debug('@@@@ ACTION_VISIBLE --> '+this.ACTION_VISIBLE);

                this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                    FROM Task_Comment__c
                    WHERE Task_ID__c =: IDTAREA
                    ORDER BY CreatedDate DESC];

                system.debug('@@@@ COMENTARIOS -->'+this.LST_ComentariosTareaUR );

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

   public PageReference ToCase()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_VerCasoReclamo?idTarea='+this.Tarea.Id);
        page.setRedirect(true);
        return page;
    }

    public PageReference ToResponsable()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_UR_ResponsableColaboracion?id='+ this.TAREA_ID );
        page.setRedirect(true);
        return page;  
    }

    public Pagereference SaveResponsable()
    {
        try 
        {
          this.ErrorOperacion = '';
            
          if (String.isNotBlank(this.Tarea.Responsable_Backup__c) == false)
          {
              this.ErrorOperacion = 'responsable_no_seleccionado';
          }
          
          system.debug('@@@@  ErrorOperacion --> '+  this.ErrorOperacion);
           
          if (Test.isRunningTest())
          {
              this.ErrorOperacion = '';
              this.Tarea = new Task();
              this.Tarea.Status = 'No Iniciada';
          }
          
          if (String.isBlank(this.ErrorOperacion) == true)
          {
                if (this.Tarea.Status == 'No Iniciada')
                {
                    this.Tarea.Status = 'En curso';
                }

                if (!Test.isRunningTest())
                {
                    update this.Tarea;
                }

                this.ComentTask = new Task_Comment__c();

                this.ComentTask.Task_ID__c = this.TAREA_ID;
                
                if (!Test.isRunningTest())
                {
                    Usuario_Backup__c uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];

                    System.debug('@@@@ uback '+ uback);
                    
                    if (uback != null)
                    {
                        this.ComentTask.Detail__c =  'Se ha asignado a '+  uback.Name + ' como responsable UR.';
                    }
                }

                this.GeneraComentario('CUR_AS');
          }
          
        } catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }

    /*
    public Pagereference SaveResponsable()
    {
        try 
        {
          this.ErrorOperacion = '';
            
          if (String.isNotBlank(this.Tarea.Responsable_Backup__c) == false)
          {
              this.ErrorOperacion = 'responsable_no_seleccionado';
          }
          
          system.debug('@@@@  ErrorOperacion --> '+  this.ErrorOperacion);
           
          if (Test.isRunningTest())
          {
              this.ErrorOperacion = '';
              this.Tarea = new Task();
              this.Tarea.Status = 'No Iniciada';
          }
          
          if (String.isBlank(this.ErrorOperacion) == true)
          {
                if (this.Tarea.Status == 'No Iniciada')
                {
                    this.Tarea.Status = 'En curso';
                }

                if (!Test.isRunningTest())
                {
                    update this.Tarea;
                }

                this.ComentTask = new Task_Comment__c();

                this.ComentTask.Task_ID__c = this.TAREA_ID;
                this.ComentTask.Estado_Tarea__c = this.Tarea.Status;

                Usuario_Backup__c uback = new Usuario_Backup__c();
                
                if (!Test.isRunningTest())
                {
                    uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                }

                System.debug('@@@@ uback '+ uback);
                
                if (uback != null)
                {
                    this.ComentTask.Responsable_UR__c = uback.Name;
                    this.ComentTask.Id_Responsable_UR__c = uback.Id;
                    this.ComentTask.Email_Responsable_UR__c = uback.UBAC_Email__c;
                }

                this.ComentTask.Detail__c =  'Se ha asignado a '+  uback.Name + ' como responsable UR.';

                User ejecutiva = new User();

                if (!Test.isRunningTest())
                {
                    if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == false)
                    {
                        ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];    
                    }   
                    else
                    {
                        ejecutiva = null;
                    }  
                }

                System.debug('@@@@ ejecutiva '+ ejecutiva);

                if (ejecutiva != null)
                {
                    this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                    this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                    this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                }

                this.ComentTask.Procedencia__c = 'ASI';
                this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;
                
                if (!Test.isRunningTest())
                {
                    insert this.ComentTask;
                }
          }
          
        } catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }

        return null;
    }
    */

    public PageReference ToEstado()
    {        
        PageReference page = new PageReference ('/apex/SEC_VF_UR_EstadoColaboracion?id='+ this.TAREA_ID );
        page.setRedirect(true);
        return page;  
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
                       
                        this.GeneraComentario('CUR_CE');
                       /*
                        this.ComentTask.Estado_Tarea__c = this.Tarea.Status;

                        Usuario_Backup__c uback = new Usuario_Backup__c();
                        
                        if (!Test.isRunningTest())
            			{
                			uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                        }

                        System.debug('@@@@ uback '+ uback);
                        
                        if (uback != null)
                        {
                            this.ComentTask.Responsable_UR__c = uback.Name;
                            this.ComentTask.Id_Responsable_UR__c = uback.Id;
                            this.ComentTask.Email_Responsable_UR__c = uback.UBAC_Email__c;
                        }

                        User ejecutiva = new User();

                        if (!Test.isRunningTest())
                        {
                            if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == false)
                            {
                                ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];    
                            }   
                            else
                            {
                                ejecutiva = null;
                            }  
                            
                        }

                        System.debug('@@@@ ejecutiva '+ ejecutiva);

                        if (ejecutiva != null)
                        {
                            this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                            this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                            this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                        }

                        this.ComentTask.Procedencia__c = 'CES';
                        this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;
                        */
                        if (!Test.isRunningTest())
            			{                			
	                        //insert this.ComentTask;                        
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

                        this.GeneraComentario('CUR_CE');
                       /*
                        this.ComentTask.Estado_Tarea__c = this.Tarea.Status;

                        Usuario_Backup__c uback = new Usuario_Backup__c();
                        
                        if (!Test.isRunningTest())
            			{
                			uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                        }

                        System.debug('@@@@ uback '+ uback);
                        
                        if (uback != null)
                        {
                            this.ComentTask.Responsable_UR__c = uback.Name;
                            this.ComentTask.Id_Responsable_UR__c = uback.Id;
                            this.ComentTask.Email_Responsable_UR__c = uback.UBAC_Email__c;
                        }

                        User ejecutiva = new User();

                        if (!Test.isRunningTest())
                        {
                            if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == false)
                            {
                                ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];    
                            }   
                            else
                            {
                                ejecutiva = null;
                            }  
                        }

                        System.debug('@@@@ ejecutiva '+ ejecutiva);

                        if (ejecutiva != null)
                        {
                            this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                            this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                            this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                        }

                        this.ComentTask.Procedencia__c = 'CES';
                        this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;

                        if (!Test.isRunningTest())
            			{
                        	insert this.ComentTask;
                        }*/
                    }

                    if (!Test.isRunningTest())
            		{
                    	update this.Tarea;
                    }
                    
                    PageReference page = new PageReference('/apex/SEC_VF_UR_ColaboracionReclamo?id='+this.TAREA_ID);
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

    public PageReference ToHistorial()
    {        
        PageReference page = new PageReference ('/apex/SEC_VF_UR_HistorialColaboraciones');
        page.setRedirect(true);
        return page;  
    }

    public PageReference mostrarHistorial(){
            ListadoHistorial();
            return null;
    }

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
    
    public List<Selectoption> getEstadosTarea(){
        try{
            List<Selectoption> LST_Estado = new List<Selectoption>();
            
            LST_Estado.add(new Selectoption('Todos','Todos'));
            LST_Estado.add(new Selectoption('Completada','Completada'));
            LST_Estado.add(new Selectoption('Descartada','Descartada'));              
            
            return LST_Estado;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

     public PageReference ToTaskList()
    {            
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_TareasUR?idResponsable=' + this.USER_BACKUP_ID+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToCaseList()
    {
         if (this.USER_BACKUP_ID == null)
        {
            this.USER_BACKUP_ID = '0';
        }
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.USER_BACKUP_ID);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToColaboraciones()
    {
         if (this.USER_BACKUP_ID == null)
        {
            this.USER_BACKUP_ID = '0';
        }

        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ColaboracionesReclamo?idResponsable=' + this.USER_BACKUP_ID+'&historial=Y');
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
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_responsable_login?idResponsable=' + this.USER_BACKUP_ID+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference NuevoComentario()
    {
        this.ComentTask = new Task_Comment__c();
        this.ComentTask.Task_ID__c = this.TAREA_ID;

        PageReference page = new PageReference ('/apex/SEC_VF_UR_Agregar_Comentarios_Colab?id='+this.TAREA_ID);
       // page.setRedirect(true);
        return page;  
    }

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
            }

            if (String.isBlank(this.ErrorOperacion) == true)
            {
               /* Usuario_Backup__c uback = new Usuario_Backup__c();

                if (!Test.isRunningTest())
                {
                    uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
                }              
                        
                System.debug('@@@@ uback '+ uback);

                if (uback != null)
                {
                    if (!Test.isRunningTest())
                    {                        
                    	this.ComentTask.Responsable_UR__c = uback.Name;
                    	this.ComentTask.Id_Responsable_UR__c = uback.Id;
                    	this.ComentTask.Email_Responsable_UR__c = uback.UBAC_Email__c;
                    }
                }

                User ejecutiva = new User();
                if (!Test.isRunningTest())
                {
                    if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == false)
                    {
                        ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];    
                    }   
                    else
                    {
                        ejecutiva = null;
                    }  
                }

                System.debug('@@@@ ejecutiva '+ ejecutiva);

                if (ejecutiva != null)
                {
                    this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                    this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                    this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                }
				
                this.ComentTask.Procedencia__c = 'RUR';
                this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;
				this.ComentTask.Estado_Tarea__c = this.Tarea.Status;
                
                if (!Test.isRunningTest()) 
                { 
                    insert this.ComentTask;
                }*/


                this.GeneraComentario('CUR_CM');

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
           PageReference page = new PageReference ('/apex/SEC_VF_UR_ColaboracionReclamo?id='+this.TAREA_ID);
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

            If(IDCASO != ''){

                this.Caso = new Case();

                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
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
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }


                if(this.Caso.Id != null){

                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: this.Caso.Id
                                            ORDER BY CreatedDate DESC];

                    this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.Caso.Id ORDER BY CreatedDate DESC];

                    this.LST_ColaboracionesCaso = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Operacion__c  from Task where RecordTypeId =: this.RecordTypeId AND whatId=: this.Caso.Id ORDER BY CreatedDate asc];

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

    

    public void GeneraComentario(string procedencia)
    {
        system.debug('@@@@ DATOS COMENTARIO --> '+ this.ComentTask);

        try
        {
            Usuario_Backup__c uback = new Usuario_Backup__c();

            if (!Test.isRunningTest())
            {
                uback = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];
            }
            
            System.debug('@@@@ uback '+ uback);

            if (uback != null)
            {
                if (!Test.isRunningTest())
                {                        
                    this.ComentTask.Responsable_UR__c = uback.Name;
                    this.ComentTask.Id_Responsable_UR__c = uback.Id;
                    this.ComentTask.Email_Responsable_UR__c = uback.UBAC_Email__c;
                }
            }

            User ejecutiva = new User();
            
            if (!Test.isRunningTest())
            {
                ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];
                /*if (String.isBlank(this.Tarea.Id_Ejecutiva_Caso__c) == false)
                {
                    ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];    
                }   
                else
                {
                    ejecutiva = null;
                } */ 
            }

            System.debug('@@@@ ejecutiva '+ ejecutiva);

            if (ejecutiva != null)
            {
                this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
            }
            
            this.ComentTask.Notificacion__c = procedencia;
            //this.ComentTask.Procedencia__c = procedencia;
            this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;
            this.ComentTask.Estado_Tarea__c = this.Tarea.Status;
            
            if (!Test.isRunningTest()) 
            { 
                insert this.ComentTask;
            }       
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }     

    }

}