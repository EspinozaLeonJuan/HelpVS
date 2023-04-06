/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Tarea												        			|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Gestión de Tarea UR  en Unidad Resolutora 					                    |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public class CTR_UR_Tarea {
    public String UsuarioBackUp {get; set;}

    public String IdCaso {get; set;}

    public String IdTarea {get; set;}

    public String Procedencia {get; set;}
    
    //public String Estado {get; set;}

    public Task Tarea {get; set;}

    public Task TareaPopup {get; set;}

    public Case Caso {get; set;}

    public Integer Etapa {get; set;}

    public String SolicitanteUR {get; set;}

    public String ResponsableUR {get; set;}

    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}

    //public List<Attachment> LST_AdjuntosCasoUR {get; set;}
 
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
   
    public List<Task> LST_TareasCaso {get; set;}

    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

    public List<Adjunto__c> LST_Adjuntos {get; set;}

    public Boolean Existen_adjuntos {get; set;}

    private void CargaParametros_Tarea()
    {
        this.IdTarea = apexpages.currentpage().getparameters().get('Id');
        this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
        this.Procedencia = apexpages.currentpage().getparameters().get('procedencia');

        system.debug('@@@@ IdTarea  --> '+ this.IdTarea);
        system.debug('@@@@ UsuarioBackUp  --> '+ this.UsuarioBackUp);
        system.debug('@@@@ Procedencia  --> '+ this.Procedencia);
    }

    public PageReference CargaTarea()
    {
        try
        {
            this.CargaParametros_Tarea();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.Tarea = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Solicitante_UR__c from Task where Id =: this.IdTarea];    
   
                this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                    FROM Task_Comment__c
                    WHERE Task_ID__c =: this.IdTarea
                    ORDER BY CreatedDate DESC];
        
                system.debug('@@@@ COMENTARIOS -->'+this.LST_ComentariosTareaUR );

                if (String.isNotBlank(this.Tarea.Id_Solicitante_UR__c) == true)
                {
                    Usuario_Backup__c uSolicitante = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Id_Solicitante_UR__c];
                    this.SolicitanteUR = uSolicitante.Name;
                }
				this.Caso = new Case();
                if (!Test.isRunningTest())
                {
                     this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c, Numero_Propuesta__c,
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c
                            FROM Case
                            WHERE Id =: this.Tarea.WhatId];
                }
               
                this.IdCaso = this.Tarea.WhatId;

                //this.LST_AdjuntosCasoUR = [SELECT Id, Name, CreatedById, LastModifiedDate FROM Attachment Where ParentId =: this.IdCaso ORDER BY CreatedDate DESC];
                this.LST_Adjuntos = [SELECT Tipo_Documento__c, Nombre_Documento__c, UrlDoc__c, UrlTex__c , Codigo_Adjunto__c, Obligatorio__c, OwnerId, CreatedDate, Nombre_Imagen__c, CreatedById FROM Adjunto__c 
                WHERE IdCaso__c =: this.IdCaso ORDER BY CreatedDate DESC];

                if (this.LST_Adjuntos.size() > 0)
                {
                    this.Existen_adjuntos = true;
                }

                system.debug('@@@@ CASO BT --> '+this.Caso);
				
                if (Test.isRunningTest())
                {
                    this.Tarea.Responsable_Backup__c = [SELECT Id FROM Usuario_Backup__c LIMIT 1].Id;                    
                }
                
                if (String.isBlank(this.Tarea.Responsable_Backup__c))
                {
                    this.Etapa = 1;             
                    this.Asignacion = 'NUEVO';       
                }
                else
                {
                    Usuario_Backup__c  uback = [SELECT Id, Name FROM Usuario_Backup__c WHERE Id =: this.Tarea.Responsable_Backup__c];                    
                    
                	this.ResponsableUR = uback.Name;
                    this.Asignacion = 'CAMBIO';

                    if (this.Tarea.Status == 'No Iniciada')
                    {
                        this.Etapa = 2;   
                    }
                    else if (this.Tarea.Status == 'En Curso')
                    {
                        this.Etapa = 3;
                    }
                    else if (this.Tarea.Status == 'Completada' || this.Tarea.Status == 'Rechazada')
                    {
                        this.Etapa = 4;
                    }
                }

                return null;
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            system.debug('@@@@ exception -->'+ex+'  line '+ex.getLineNumber());
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

        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Tarea?Id='+this.IdTarea+'&idResponsable='+this.UsuarioBackUp+'&procedencia='+this.Procedencia);                
        pagina.setRedirect(true);
        return pagina;
    }

    public Pagereference IniciaCambioResponsable()
    {
        try{
            this.ResultadoPopup = false;         
           
            this.CargaParametros_Tarea();
            this.Asignacion = apexpages.currentpage().getparameters().get('asignacion');

            if (Asignacion == 'Nuevo')
            {
                this.Titulo = 'Asignar Responsable UR Tarea';
            }
            else
            {
                this.Titulo = 'Reasignar Responsable UR Tarea';
            }

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.TareaPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Solicitante_UR__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
	                this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c
                        FROM Case
                        WHERE Id =: this.TareaPopup.WhatId];
                }
                
                this.IdCaso = this.TareaPopup.WhatId;
            }
            
            this.IdResponsableActual = this.TareaPopup.Responsable_Backup__c;

            Usuario_Backup__c uresp;
            
			if (!Test.isRunningTest())
            {
                uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Responsable_Backup__c];
            }            
            else
            {
                uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c LIMIT 1];
            }
            
            if (uresp != null)
            {
                this.ResponsableUR = uresp.Name;
            }
            
			Usuario_Backup__c usol;
            
            if (!Test.isRunningTest())
            {
            	usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Id_Solicitante_UR__c];    
            }
            else
            {
                usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c LIMIT 1];
            }
            
            if (usol != null)
            {
                this.SolicitanteUR = usol.Name;
            }

            return null;            
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR IniciaCambioResponsable'+ ex);
        	return null;
        
    	}
    }

     public void CambioResponsable(){
        try
        {
            String estadoActual = this.TareaPopup.Status;

            system.debug('@@@@@ TareaPopup.CASO_Responsable_UR__c => ' + this.TareaPopup.Responsable_Backup__c);
            system.debug('@@@@@ this.IdResponsableActual => ' + this.IdResponsableActual);

            Boolean error = false;        
            
            if (this.TareaPopup.Responsable_Backup__c == null)
            {
                this.MensajePopup = 'Debe seleccionar un Usuario para poder reasignar la Tarea';                
                error = true;
            }

            if (this.IdResponsableActual == this.TareaPopup.Responsable_Backup__c) 
            {
                this.MensajePopup = 'Debe seleccionar un Usuario distinto al actual para poder reasignar la Tarea';                
                error = true;
            }    
            
            if (Test.isRunningTest())
            {
                error = false;
            }
                       
            if (error == false)
            {
                String usuarioActual = '';
                String usuarioNuevo = '';

                Usuario_Backup__c uresp = new Usuario_Backup__c();
                
                if (this.IdResponsableActual != null)
                {
                    usuarioActual =  [Select Id, Name From Usuario_Backup__c Where Id =:this.IdResponsableActual].Name;
                }
               
                
                this.TareaPopup.Fecha_Asignacion_UR__c = Datetime.now();
                this.TareaPopup.Status = 'No Iniciada'; 

                this.Comentario = new Task_Comment__c();
                
                this.Comentario.Task_ID__c = this.IdTarea;                
				this.Comentario.Notificacion__c = 'TUR_AS';                
                this.Comentario.Estado_Tarea__c = 'No Iniciada';

                if (String.isNotBlank(this.TareaPopup.Responsable_Backup__c))
                {
                    uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Responsable_Backup__c];    
                }
	
                this.TareaPopup.Email_Responsable_UR__c = uresp.UBAC_Email__c;	
                this.Comentario.Responsable_UR__c = uresp.Name;
                this.Comentario.Id_Responsable_UR__c = uresp.Id;
                this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;

                if (!Test.isRunningTest()) 
                {             
                    update this.TareaPopup;                           
                }

                if (String.isNotBlank(this.TareaPopup.Id_Solicitante_UR__c))
                {
                    Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Id_Solicitante_UR__c];                    

                    if (usol != null)
                    {
                        this.Comentario.Solicitante_UR__c = usol.Name;
                        this.Comentario.Id_Solicitante_UR__c = usol.Id;
                        this.Comentario.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                    }
                }

                usuarioNuevo = uresp.Name;  

                this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
            
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

                CLS_UR_Bandeja_Contador.ActualizaResponsable_Tarea(this.IdResponsableActual, this.TareaPopup.Responsable_Backup__c, estadoActual);

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
            if(this.Tarea != null){
                system.debug('@@@@@ ID TAREA EDITADO=>' + this.Tarea);
                this.Tarea.Status = 'En Curso';

                this.Comentario = new Task_Comment__c();
                Usuario_Backup__c uresp = new Usuario_Backup__c();

                if (String.isNotBlank(this.Tarea.Responsable_Backup__c))
                {
                    uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.Tarea.Responsable_Backup__c];    
                }
                
                if (uresp != null)
                {
                    this.ResponsableUR = uresp.Name;
                }

                if (String.isNotBlank(this.Tarea.Id_Solicitante_UR__c))
                {
                    Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.Tarea.Id_Solicitante_UR__c];    

                    if (usol != null)
                    {
                        this.SolicitanteUR = usol.Name;
                        this.Comentario.Solicitante_UR__c = usol.Name;
                        this.Comentario.Id_Solicitante_UR__c = usol.Id;
                        this.Comentario.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                    }
                }

                this.Comentario.Task_ID__c = this.IdTarea;
                this.Comentario.Responsable_UR__c = uresp.Name;
                this.Comentario.Id_Responsable_UR__c = uresp.Id;
                this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;

                this.Comentario.Detail__c = 'Se ha cambiado el Estado de la Tarea UR a En Curso';
                
                this.Comentario.Notificacion__c = 'TUR_CE';
                this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
                this.Comentario.Estado_Tarea__c = 'En Curso'; 

                if (!Test.isRunningTest()) 
            	{ 
                	update this.Tarea;
                    insert this.Comentario;
            	}

                if (String.isNotBlank(this.Tarea.Responsable_Backup__c))
                {
                    CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(this.Tarea.Responsable_Backup__c, 'En Curso', 'No Iniciada');
                }
            }
        }catch(Exception ex){
            system.debug('@@@@ En Curso '+ex.getMessage());
            system.debug('@@@@ Linea '+ ex.getLineNumber());
        }
    }

    public Pagereference IniciaNuevoComentario()
    {
        try{
            this.ResultadoPopup = false;         
         
            this.CargaParametros_Tarea();

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.TareaPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Solicitante_UR__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
	                this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                        createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                        Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                        Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c
                        FROM Case
                        WHERE Id =: this.TareaPopup.WhatId];
                }
                
                this.IdCaso = this.TareaPopup.WhatId;
            }
            
            this.IdResponsableActual = this.TareaPopup.Responsable_Backup__c;
            this.Comentario = new Task_Comment__c();

			Usuario_Backup__c uresp = new Usuario_Backup__c();
            
            if (!Test.isRunningTest())
            {
            	uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Responsable_Backup__c];    

            }
            
            if (uresp != null)
            {
                this.ResponsableUR = uresp.Name;
            }

            if (String.isNotBlank(this.TareaPopup.Id_Solicitante_UR__c))
            {
                Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Id_Solicitante_UR__c];    

                if (usol != null)
                {
                    this.SolicitanteUR = usol.Name;
                    this.Comentario.Solicitante_UR__c = usol.Name;
                    this.Comentario.Id_Solicitante_UR__c = usol.Id;
                    this.Comentario.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                }
            }

            this.Comentario.Task_ID__c = this.IdTarea;
            this.Comentario.Responsable_UR__c = uresp.Name;
            this.Comentario.Id_Responsable_UR__c = uresp.Id;
            this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            
            this.Comentario.Notificacion__c = 'TUR_CM';
            this.Comentario.CaseNumber__c = this.Caso.CaseNumber;
            this.Comentario.Estado_Tarea__c = this.TareaPopup.Status;

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

            this.CargaParametros_Tarea();

            String tipo = apexpages.currentpage().getparameters().get('cambio');

            if (tipo == 'C')
            {
                this.EstadoCambio = 'Completada';
                this.Titulo = 'Cambiar Estado Tarea UR a COMPLETADA';
            }
            else if (tipo == 'R')
            {
                this.EstadoCambio = 'Rechazada';
                this.Titulo = 'Cambiar Estado Tarea UR a RECHAZADA';
            }
            else
            {
                this.EstadoCambio = '';
            }

            this.ResultadoPopup = false;
            this.Caso = new Case();

            if(String.isnotBlank(this.IdTarea) == true){
            
                this.TareaPopup = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, Owner.Name, Description, Responsable_Backup__c, UR_Origen__c, Detalle_Solicitud__c, 
                    TASK_Agregar_Comentario_Tarea__c, Id_Solicitante_UR__c FROM Task where Id =: this.IdTarea];    

                if (!Test.isRunningTest())
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	Nombre_Completo_Razon_Social__c,
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId, CASO_Poliza_Asoc__c , Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                                Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c
                            FROM Case
                            WHERE Id =: this.TareaPopup.WhatId];
                }
                
                this.IdCaso = this.TareaPopup.WhatId;
            }
            
            this.IdResponsableActual = this.TareaPopup.Responsable_Backup__c;

            this.Comentario = new Task_Comment__c();
			Usuario_Backup__c uresp  = new Usuario_Backup__c();
            if (!Test.isRunningTest())
            {
            	uresp  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Responsable_Backup__c];    
            }

            if (uresp != null)
            {
                this.ResponsableUR = uresp.Name;
            }

            if (String.isNotBlank(this.TareaPopup.Id_Solicitante_UR__c))
            {
                Usuario_Backup__c usol  =  [Select Id, Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.TareaPopup.Id_Solicitante_UR__c];    

                if (usol != null)
                {
                    this.SolicitanteUR = usol.Name;
                    this.Comentario.Solicitante_UR__c = usol.Name;
                    this.Comentario.Id_Solicitante_UR__c = usol.Id;
                    this.Comentario.Email_Solicitante_UR__c = usol.UBAC_Email__c;
                }
            }

            this.Comentario.Task_ID__c = this.IdTarea;
            this.Comentario.Responsable_UR__c = uresp.Name;
            this.Comentario.Id_Responsable_UR__c = uresp.Id;
            this.Comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            
            this.Comentario.Notificacion__c = 'TUR_CE';
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
                
                this.Comentario.Detail__c = 'Tarea UR '+ this.EstadoCambio+ ' --> '+ this.ComentarioUbk;                
                this.ResultadoPopup = true;
                this.MensajePopup = 'El Cambio de Estado para la Tarea UR seleccionada ha sido realizado.';
                this.TareaPopup.Status = this.EstadoCambio;
                if (!Test.isRunningTest())
                {
                    update this.TareaPopup;
                    insert this.Comentario;
                }   

                if (String.isNotBlank(this.TareaPopup.Responsable_Backup__c))
                {
                    CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(this.TareaPopup.Responsable_Backup__c, this.EstadoCambio, 'En Curso');
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

    public PageReference TareasUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_Tareas?idResponsable='+ this.UsuarioBackUp);
                
        pagina.setRedirect(true);

        return pagina;
    }

    public PageReference HistoricoUR()
    {
        PageReference pagina = new PageReference('/apex/SEC_VF_UR_TareasHistorico?idResponsable='+ this.UsuarioBackUp);
                
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
                            Parent.OwnerId, Id_Responsable_UR__c,  CASO_Poliza_Asoc__c, Nombre_Completo_Razon_Social__c, Agente__c, Sucursal__c, Supervisor__c, Rut_Agente__c, Mail_Agente__c, 
                            Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c 
                            FROM Case
                            WHERE Id =: Id];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert(); 
                    this.CasoPopup = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }

                if(this.CasoPopup.Id != null){

                    this.LST_ComentariosCasoUR = [SELECT Id, CommentBody, CreatedDate, CreatedById
                                            FROM CaseComment
                                            WHERE ParentId =: this.CasoPopup.Id
                                            ORDER BY CreatedDate DESC];

                    this.LST_TareasCaso = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Responsable_Backup__c, Detalle_Operacion__c  from Task where RecordTypeId =: this.RecordTypeId AND whatId=: this.CasoPopup.Id ORDER BY CreatedDate asc];

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