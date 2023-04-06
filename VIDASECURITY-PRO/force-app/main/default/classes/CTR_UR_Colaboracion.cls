/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Colaboracion                                                            |
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Gestión de Colaboraciones de Reclamos en Unidad Resolutora                     |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public class CTR_UR_Colaboracion {
   
    public String UsuarioBackUp {get; set;}

    public String IdCaso {get; set;}

    public String IdTarea {get; set;}

    public String Procedencia {get; set;}
    
    public String Estado {get; set;} 

    public Task Colaboracion {get; set;}

    public Task ColaboracionPopup {get; set;}

    public Case Caso {get; set;}
 
    public Integer Etapa {get; set;}

    public String Ejecutiva {get; set;}

    public String ResponsableUR {get; set;}

    public List<Task_Comment__c> LST_ComentariosColaboracion {get; set;}

    public List<Attachment> LST_AdjuntosCasoUR {get; set;}

    public blob fileBody { get; set; }

    public String fileName {get; set;}

    public Boolean ResultadoPopup {get; set;}

    public String MensajePopup {get; set;}
    
    public String ComentarioUbk {get; set;}   

    public String IdResponsableActual {get; set;}

    public String EstadoCambio {get; set;}

    public String Titulo {get; set;}   

    public Task_Comment__c Comentario {get; set;}

    public String Asignacion {get; set;}

    public Case CasoPopup {get; set;}

    public List<CaseComment> LST_ComentariosCasoUR {get; set;}
   
    public List<Task> LST_ColaboracionesCaso {get; set;}

    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;

    public PageReference CargaColaboracion()
    {
        try
        {
            this.IdTarea = apexpages.currentpage().getparameters().get('Id');
            this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.Colaboracion = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Operacion__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Ejecutiva_Caso__c from Task where Id =: this.IdTarea];    
   
                this.LST_ComentariosColaboracion = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                    FROM Task_Comment__c
                    WHERE Task_ID__c =: this.IdTarea
                    ORDER BY CreatedDate DESC];
        
                system.debug('@@@@ COMENTARIOS -->'+this.LST_ComentariosColaboracion );

               if (!Test.isRunningTest())
               {
                	this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                            FROM Case
                            WHERE Id =: this.Colaboracion.WhatId];
               }

                this.IdCaso = this.Colaboracion.WhatId;

                this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.IdCaso ORDER BY CreatedDate DESC];
                system.debug('@@@@ CASO BT --> '+this.Caso);

                if (String.isBlank(this.Colaboracion.Responsable_Backup__c))
                {
                    this.Etapa = 1;             
                    this.Asignacion = 'NUEVO';       
                }
                else
                {
                    Usuario_Backup__c uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Colaboracion.Responsable_Backup__c];
                	this.ResponsableUR = uback.Name;
                    this.Asignacion = 'CAMBIO';

                    if (this.Colaboracion.Status == 'No Iniciada')
                    {
                        this.Etapa = 2;   
                    }
                    else if (this.Colaboracion.Status == 'En Curso')
                    {
                        this.Etapa = 3;
                    }
                    else if (this.Colaboracion.Status == 'Completada' || this.Colaboracion.Status == 'Rechazada')
                    {
                        this.Etapa = 4;
                    }
                }
                
                if (Test.isRunningTest())
                {
                    this.Colaboracion.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
                }
                
                if (String.isNotBlank(this.Colaboracion.Id_Ejecutiva_Caso__c)  == true)
                {
                    User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Colaboracion.Id_Ejecutiva_Caso__c];
                    
                    if (ejecutiva != null)
                    {
                        this.Ejecutiva  = ejecutiva.Name;
                    }
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

     public Pagereference GuardarAdjunto()
    {
        try 
        {
            Attachment myAttachment = new Attachment();            
            System.debug('@@@@@fileBody'+ this.fileBody);     
            myAttachment .clear();
            myAttachment.Body = this.fileBody; 
            myAttachment.Name = this.fileName; 
            myAttachment.ParentId = this.Caso.Id;
            insert myAttachment;      
        } 
        catch (Exception ex) {
            system.debug('@@@@ ex GuardarAdjunto '+ ex+ ' line: '+ ex.getLineNumber());
             //this.MensajePopup = ex.getMessage();
             //this.ResultadoPopup = false;
        }

        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Colaboracion?Id='+this.IdTarea+'&idResponsable='+this.UsuarioBackUp+'&procedencia='+this.Procedencia);                
        pagina.setRedirect(true);
        return pagina;
    }

    public Pagereference IniciaCambioResponsable()
    {
        try{
            this.ResultadoPopup = false;         
            this.IdTarea= apexpages.currentpage().getparameters().get('Id');
            this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');
            this.Asignacion = apexpages.currentpage().getparameters().get('asignacion');

            if (Asignacion == 'Nuevo')
            {
                this.Titulo = 'Asignar Responsable UR Colaboración';
            }
            else
            {
                this.Titulo = 'Reasignar Responsable UR Colaboración';
            }

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.ColaboracionPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Operacion__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Ejecutiva_Caso__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
                	this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c 
                        FROM Case
                        WHERE Id =: this.ColaboracionPopup.WhatId];
                }
                
                this.IdCaso = this.ColaboracionPopup.WhatId;
            }

            system.debug('@@@@ Caso  -> '+ this.Caso);
            
            this.UsuarioBackUp = UsuarioBackUp;
            this.Procedencia = Procedencia;
            
            if (String.IsNotBlank(this.ColaboracionPopup.Responsable_Backup__c) == true)
            {
                this.IdResponsableActual = this.ColaboracionPopup.Responsable_Backup__c;

                Usuario_Backup__c uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ColaboracionPopup.Responsable_Backup__c];    

                if (uresp != null)
                {
                    this.ResponsableUR = uresp.Name;
                }
            }            
            
            if (Test.isRunningTest())
            {
                this.ColaboracionPopup.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
            }
            
            if (String.isNotBlank(this.ColaboracionPopup.Id_Ejecutiva_Caso__c)  == true)
            {
                User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.ColaboracionPopup.Id_Ejecutiva_Caso__c];
                if (ejecutiva != null)
                {
                    this.Ejecutiva  = ejecutiva.Name;
                }
            }            

            system.debug('@@@@ Ejecutiva'+ this.Ejecutiva);

            return null;            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
            system.debug('@@@@ ERROR Linea'+ ex.getLineNumber());
        	return null;
        
    	}
    }

     public void CambioResponsable(){
        try
        {
            system.debug('@@@@@ TareaPopup.CASO_Responsable_UR__c => ' + this.ColaboracionPopup.Responsable_Backup__c);
            system.debug('@@@@@ this.IdResponsableActual => ' + this.IdResponsableActual);
            String estadoActual = this.ColaboracionPopup.Status;
            Boolean error = false;        
            
            if (this.ColaboracionPopup.Responsable_Backup__c == null)
            {
                this.MensajePopup = 'Debe seleccionar un Usuario para poder reasignar la Tarea';                
                error = true;
            }

            if (this.IdResponsableActual == this.ColaboracionPopup.Responsable_Backup__c) 
            {
                this.MensajePopup = 'Debe seleccionar un Usuario distinto al actual para poder reasignar la Tarea';                
                error = true;
            }    
                       
            if (error == false)
            {
                String usuarioActual = '';
                String usuarioNuevo = '';
                Usuario_Backup__c uresp = new Usuario_Backup__c();
                
                if (this.IdResponsableActual != null)
                {
                    usuarioActual = [Select Name From Usuario_Backup__c Where Id =:this.IdResponsableActual].Name;
                }

                uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ColaboracionPopup.Responsable_Backup__c];    

                this.ColaboracionPopup.Fecha_Asignacion_UR__c = Datetime.now();
                this.ColaboracionPopup.Email_Responsable_UR__c = uresp.UBAC_Email__c;	
                this.ColaboracionPopup.Status = 'No Iniciada'; 

                if (!Test.isRunningTest()) 
                {             
                    update this.ColaboracionPopup;                           
                }
                
                this.Comentario = new Task_Comment__c();
                
                this.Comentario.Task_ID__c = this.IdTarea;
                this.Comentario.Responsable_UR__c = uresp.Name;
                this.Comentario.Id_Responsable_UR__c = uresp.Id;
                this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;

                usuarioNuevo = uresp.Name;  

                if (Test.isRunningTest())
                {
                    this.ColaboracionPopup.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
                }
                
                if (String.isNotBlank(this.ColaboracionPopup.Id_Ejecutiva_Caso__c)  == true)
                {
                    User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.ColaboracionPopup.Id_Ejecutiva_Caso__c];
                    if (ejecutiva != null)
                    {
                        this.Comentario.Ejecutiva_Caso__c = ejecutiva.Name;
                        this.Comentario.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                        this.Comentario.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                    }
                }
 
                this.Comentario.Notificacion__c = 'CUR_AS';
                this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
                this.Comentario.Estado_Tarea__c = 'No Iniciada';
            
                if (usuarioActual != '')
                {
                    this.Comentario.Detail__c = 'Reasignación de usuario UR : '+usuarioActual+' --> '+usuarioNuevo+' \n'+this.ComentarioUbk;  
                }
                else
                {
                    this.Comentario.Detail__c = 'Asignación de usuario UR : '+usuarioNuevo+' \n'+this.ComentarioUbk;  
                }
                system.debug('@@@@ Comentario -->'+ this.Comentario);

                if (!Test.isRunningTest()) 
                {             
                    insert this.Comentario;
                }

                if (String.isBlank(this.IdResponsableActual))
                {
                    this.IdResponsableActual = 'NO_ID';
                }

                CLS_UR_Bandeja_Contador.ActualizaResponsable_Colaboracion(this.IdResponsableActual,  this.ColaboracionPopup.Responsable_Backup__c, estadoActual);

                this.ResultadoPopup = true;
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR CambioResponsable'+ ex);   
            system.debug('@@@@ ERROR '+ ex.getMessage()+'  '+ex.getLineNumber());        
    	}
    }

    public void EnCurso(){
        try{
            if(this.Colaboracion != null){
                system.debug('@@@@@ ID TAREA EDITADO=>' + this.Colaboracion);
                this.Colaboracion.Status = 'En Curso';

                this.Comentario = new Task_Comment__c();
                Usuario_Backup__c uresp = new Usuario_Backup__c();
                if (!Test.isRunningTest())
                {
                    uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.Colaboracion.Responsable_Backup__c];    
                }
                
                if (uresp != null)
                {
                    this.ResponsableUR = uresp.Name;
                }

                if (Test.isRunningTest())
                {
                    this.Colaboracion.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
                }
                
                if (String.isNotBlank(this.Colaboracion.Id_Ejecutiva_Caso__c)  == true)
                {
                    try 
                    {
                        User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Colaboracion.Id_Ejecutiva_Caso__c];
                        if (ejecutiva != null)
                        {
                            this.Ejecutiva = ejecutiva.Name;
                            this.Comentario.Ejecutiva_Caso__c = ejecutiva.Name;
                            this.Comentario.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                            this.Comentario.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                        }
                    } 
                    catch (Exception ex) {
                        
                    }
                    
                }

                this.Comentario.Task_ID__c = this.IdTarea;
                this.Comentario.Responsable_UR__c = uresp.Name;
                this.Comentario.Id_Responsable_UR__c = uresp.Id;
                this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;

                this.Comentario.Detail__c = 'Se ha cambiado el Estado de la Colaboración de Reclamo a En Curso';
                
                this.Comentario.Notificacion__c = 'CUR_CE';
                this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
                this.Comentario.Estado_Tarea__c = 'En Curso';                

                if (!Test.isRunningTest()) 
            	{ 
                	update this.Colaboracion;
                    insert this.Comentario;
            	}

                if (String.isNotBlank(this.Colaboracion.Responsable_Backup__c))
                {
                    CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(this.Colaboracion.Responsable_Backup__c, 'En Curso', 'No Iniciada');
                }
            }
        }catch(Exception ex){
            system.debug('@@@@ EnProceso '+ex);
        }
    }

    public Pagereference IniciaNuevoComentario()
    {
        try{
            this.ResultadoPopup = false;         
            this.IdTarea= apexpages.currentpage().getparameters().get('Id');
            this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.ColaboracionPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Operacion__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Ejecutiva_Caso__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
	                this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c 
                        FROM Case
                        WHERE Id =: this.ColaboracionPopup.WhatId];
                }
                
                this.IdCaso = this.ColaboracionPopup.WhatId;
            }
            
            this.IdResponsableActual = this.ColaboracionPopup.Responsable_Backup__c;
            this.Comentario = new Task_Comment__c();

            Usuario_Backup__c uresp = new Usuario_Backup__c();
            if (!Test.isRunningTest())
            {
                uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ColaboracionPopup.Responsable_Backup__c];    
            }

            if (uresp != null)
            {
                this.ResponsableUR = uresp.Name;
            }

            if (Test.isRunningTest())
            {
                this.ColaboracionPopup.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
            }
            
            if (String.isNotBlank(this.ColaboracionPopup.Id_Ejecutiva_Caso__c)  == true)
            {
                User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.ColaboracionPopup.Id_Ejecutiva_Caso__c];
                if (ejecutiva != null)
                {
                    this.Ejecutiva = ejecutiva.Name;
                    this.Comentario.Ejecutiva_Caso__c = ejecutiva.Name;
                    this.Comentario.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                    this.Comentario.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                }
            }
 
            this.Comentario.Notificacion__c = 'CUR_CM';
            this.Comentario.Task_ID__c = this.IdTarea;
            this.Comentario.Responsable_UR__c = uresp.Name;
            this.Comentario.Id_Responsable_UR__c = uresp.Id;
            this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            
            this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
            this.Comentario.Estado_Tarea__c = this.ColaboracionPopup.Status;

            return null;            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
        	return null;
        
    	}
    }

    public void GuardarComentario()
    {
        try 
        {
            this.ResultadoPopup = true;

            if (String.isBlank(this.Comentario.Detail__c) == true)
            {
                this.ResultadoPopup = false;
            }
                system.debug('@@@@  Comentario'+ Comentario);
            if (this.ResultadoPopup == true)
            {
                insert this.Comentario;
            } 
        } 
        catch (Exception ex) {
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
             this.MensajePopup = ex.getMessage();
             this.ResultadoPopup = false;
        }
    }

    public Pagereference IniciaCambioEstado()
    {
        try{
            this.ResultadoPopup = false;         
            this.IdTarea= apexpages.currentpage().getparameters().get('Id');
            this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
            this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');
            String tipo = apexpages.currentpage().getparameters().get('cambio');

            if (tipo == 'C')
            {
                this.EstadoCambio = 'Completada';
                this.Titulo = 'Cambiar Estado Colaboración a COMPLETADA';
            }
            else if (tipo == 'R')
            {
                this.EstadoCambio = 'Rechazada';
                this.Titulo = 'Cambiar Estado Colaboración a RECHAZADA';
            }
            else
            {
                this.EstadoCambio = '';
            }

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.ColaboracionPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Operacion__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Ejecutiva_Caso__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
                     this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c 
                        FROM Case
                        WHERE Id =: this.ColaboracionPopup.WhatId];
                }
               
                this.IdCaso = this.ColaboracionPopup.WhatId;
            }
            
            this.IdResponsableActual = this.ColaboracionPopup.Responsable_Backup__c;

            this.Comentario = new Task_Comment__c();
            Usuario_Backup__c uresp = new Usuario_Backup__c();
            if (!Test.isRunningTest())
            {
                uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ColaboracionPopup.Responsable_Backup__c];    
            }
            
            if (uresp != null)
            {
                this.ResponsableUR = uresp.Name;
            }

            if (Test.isRunningTest())
            {
                this.ColaboracionPopup.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
            }
            
            if (String.isNotBlank(this.ColaboracionPopup.Id_Ejecutiva_Caso__c)  == true)
            {
                try 
                {
                    User ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.ColaboracionPopup.Id_Ejecutiva_Caso__c];
                    if (ejecutiva != null)
                    {
                        this.Ejecutiva = ejecutiva.Name;
                        this.Comentario.Ejecutiva_Caso__c = ejecutiva.Name;
                        this.Comentario.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                        this.Comentario.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                    }
                } 
                catch (Exception ex) {
                    
                }
            }

            this.Comentario.Task_ID__c = this.IdTarea;
            this.Comentario.Responsable_UR__c = uresp.Name;
            this.Comentario.Id_Responsable_UR__c = uresp.Id;
            this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            
            this.Comentario.Notificacion__c = 'CUR_CE';
            this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
            this.Comentario.Estado_Tarea__c = this.EstadoCambio;

            return null;            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioEstado'+ ex + '   linea: '+ex.getLineNumber());
        	return null;
        
    	}
    }

    public void CambioEstado()
    {
        try {
            
            if(String.isNotBlank(this.ComentarioUbk)){
                
                this.Comentario.Detail__c = 'Colaboración '+ this.EstadoCambio+ ' --> '+ this.ComentarioUbk;                
                this.ResultadoPopup = true;
                this.MensajePopup = 'El Cambio de Estado para la Colaboración seleccionada ha sido realizado.';
                this.ColaboracionPopup.Status = this.EstadoCambio;
                if (!Test.isRunningTest())
                {
                    update this.ColaboracionPopup;
                    insert this.Comentario;
                }   

                if (String.isNotBlank(this.ColaboracionPopup.Responsable_Backup__c))
                {
                    CLS_UR_Bandeja_Contador.ActualizaEstado_Colaboracion(this.ColaboracionPopup.Responsable_Backup__c,  this.EstadoCambio, 'En Curso');
                }
            } 
            else
            {
                this.MensajePopup = 'Para realizar el Cambio de Estado, es necesario que sea agregado un Comentario';
            }

        } catch (Exception ex) {
            system.debug('@@@@ ERROR CambioEstado'+ ex + '   linea: '+ex.getLineNumber());
        }     
    }

    public PageReference Colaboraciones()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Colaboraciones?idResponsable='+ this.UsuarioBackUp);
                
        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference HistoricoUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_ColaboracionesHistorico?idResponsable='+ this.UsuarioBackUp);
                
        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference cargaCaso()
    {
        try{
           
            String ID = apexpages.currentpage().getparameters().get('Id');

            if(Id != ''){

                this.CasoPopup = new Case();

                if (!Test.isRunningTest()) 
                {
                    this.CasoPopup = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,
                            Parent.OwnerId, Id_Responsable_UR__c,  CASO_Poliza_Asoc__c, Nombre_Completo_Razon_Social__c  
                            FROM Case
                            WHERE Id =: Id];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert(); 
                    this.CasoPopup = FactoryEscritorio.buildCasoED('Reclamos', cuenta);
                }

                if(this.CasoPopup.Id != null){

                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: this.CasoPopup.Id
                                            ORDER BY CreatedDate DESC];

                    this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.CasoPopup.Id ORDER BY CreatedDate DESC];

                    this.LST_ColaboracionesCaso = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Operacion__c  from Task where RecordTypeId =: this.RecordTypeId AND whatId=: this.CasoPopup.Id ORDER BY CreatedDate asc];

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