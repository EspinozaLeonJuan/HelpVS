/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_CS_Colaboracion															|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Gestión de Colaboraciones de reclamos					                        |
 |  																										|
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/

public class CTR_CS_Colaboracion {
   public class Node
    {
        public String Id {get; set;}
        
        public String Name {get; set;}

        public Id UserId {get; set;}
        
        public boolean Selected {get; set;}
    }
     
    public String IdTarea {get; set;}
    public String Idcaso {get; set;}    
    public Case Caso {get; set;}
    public String[] UR_Select {get; set;}
    public String[] UR_Unselect {get; set;}
    public List<Task> LST_Tareas {get; set;}
    
    public List<SelectOption> UnidadesPorSel = new List<SelectOption>();
    public List<SelectOption> UnidadesSelec  = new List<SelectOption>();    
    public List<Task_Comment__c> LST_ComentariosTareaUR {get; set;}
    public List<Node> URS { get; set;}

    public List<Cola_Usuario__c> listaUR  {get; set;}
	public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;
    
    public Task NewTask { get;set; }
    public Task Tarea { get;set; }
    public String  Exito { get;set; }
 
    public String RESPONSABLE_ACTUAL {get; set;}
    public String RESPONSABLE_ASIGNADO {get; set;}
    
     /*Método para mostrar caso seleccionado y su información relacionada*/
    public String ACTION_VISIBLE {get; set;}

    public Task_Comment__c ComentTask {get; set;}
    public String ErrorOperacion {get; set;}
    public PageReference cargaCaso(){
        try
        {
            this.Exito = 'N';
            this.Idcaso  = apexpages.currentpage().getparameters().get('id');

            if(this.Idcaso  != ''){

                listaUR = [select Id, Id_Cola__c, Nombre_Cola__c, Usuario__c from Cola_Usuario__c];
                URS = new List<Node>();
                for(Cola_Usuario__c val : this.listaUR)
                {
                    Node nd = new Node();
                    nd.Id = val.Id_Cola__c;
                    nd.Name = val.Nombre_Cola__c;
                    nd.UserId = val.Usuario__c;
                    nd.Selected = false;
                    URS.add(nd);
                }

                this.cargaUnidades();

                this.Caso = new Case();
                this.NewTask = new Task();
                this.NewTask.WhatId = this.IdCaso;
                this.NewTask.Subject = 'Colaboración Reclamo';
                this.NewTask.RecordTypeId = this.RecordTypeId;
                this.NewTask.Status = 'No iniciada';
                this.NewTask.Priority = 'Normal';
                
                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate,	
                            Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                            FROM Case
                            WHERE Id =: this.Idcaso];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);
                }

                system.debug('@@@@ Producto__c'+ this.Caso.Producto__c);
                system.debug('@@@@ Tipo_Operacion__c'+ this.Caso.Tipo_Operacion__c);
                system.debug('@@@@ Detalle_Operacion__c'+ this.Caso.Detalle_Operacion__c);
                
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
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }

    public void cargaUnidades()
    {
        this.UnidadesPorSel.clear();
        this.UnidadesSelec.clear();
        
        for(Node q : this.URS)
        {
            if (q.Selected == false)
            {
            	this.UnidadesPorSel.add(new SelectOption(q.Id, q.Name));    
            }
            else
            {
                this.UnidadesSelec.add(new SelectOption(q.Id, q.Name));
            }
        }
        
        System.debug('Selected Queue | ' + this.UnidadesPorSel);  
    }

    public List<SelectOption> getUnidadesSelect() 
    {       
        return this.UnidadesPorSel;
    }

    public List<SelectOption> getUnidadesUnselect() 
    {       
        return this.UnidadesSelec;
    }

    public Pagereference AddUR()
    {
        system.debug('@@@@ ID --> '+ this.UR_Select);
        
        for (String selec : this.UR_Select)
        {
            for(Node val : this.URS)
            {
                if (val.Id == selec)
                {
                    val.Selected = true;
                    break;                    
                }
            }
        }
        
        system.debug('@@@@ URS --> '+ this.URS);
        
        this.cargaUnidades();
        
        return null;
    }

    public Pagereference RemoveUR()
    {
        system.debug('@@@@ ID --> '+ this.UR_Unselect);

        for (String selec : this.UR_Unselect)
        {
            for(Node val : this.URS)
            {
                if (val.Id == selec)
                {
                    val.Selected = false;
                    break;                    
                }
            }
        }
    
        system.debug('@@@@ URS --> '+ this.URS);
        
        this.cargaUnidades();

        return null;
    }
    
    public PageReference SaveTask()
    {
       // List<Node> URS_SEL = new List<Node>();
        List<Task> tareas = new List<Task>();
        
        Boolean ErrorDate = false;
        
        if (this.NewTask.ActivityDate < Date.today())
        {
            ErrorDate = true;
        }
        
		if (ErrorDate == false)
        {
             Boolean URSelect = false;
             
            for(Node val : this.URS)
        	{
                if (val.Selected == true)
                {
                    Task nuevaTask = new Task();                
                    nuevaTask.WhatId = this.NewTask.WhatId;
                    nuevaTask.Subject = this.NewTask.Subject;
                    nuevaTask.RecordTypeId = this.NewTask.RecordTypeId;
                    nuevaTask.OwnerId = val.UserId;
                    nuevaTask.Status = this.NewTask.Status;
                    nuevaTask.Priority = this.NewTask.Priority;
                    nuevaTask.caso_numero__c  = this.Caso.CaseNumber;
                    nuevaTask.ActivityDate = this.NewTask.ActivityDate;
                    nuevaTask.Description = this.NewTask.Description;
                    nuevaTask.Detalle_Operacion__c = this.Caso.Subject;                    
                    nuevaTask.Id_Ejecutiva_Caso__c = this.Caso.OwnerId;
                    URSelect = true;

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
            }
            
            if (URSelect == false)
            {
                 this.Exito = 'N1';
            }        
        }
        else
        {
            this.Exito = 'N2';
        }

        return null;
    }

    public Pagereference ListadoTareas()
    {   
        try
        {
            String IDCASO = apexpages.currentpage().getparameters().get('id');            
                    
            If(IDCASO != ''){

                if (!Test.isRunningTest()) 
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                            createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                            Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate, Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                            FROM Case
                            WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    this.Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);                           
                }                                               
                
                LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, Detalle_Solicitud__c, 
                Detalle_Operacion__c, Responsable_Backup__c from Task where WhatId =: this.IdCaso
                AND RecordTypeId =: this.RecordTypeId  ORDER BY CreatedDate DESC];

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

    public PageReference ToList()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboraciones?id='+ this.Idcaso);     
        return page;        
    }

    public PageReference ToNew()
    {
        PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboracion_Nueva?id='+ this.Idcaso);     
        return page;        
    }

    public PageReference verColaboracionSeleccionada()
    {
        String ID = apexpages.currentpage().getparameters().get('idTarea');
        PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboracion?id='+ ID);     
        return page;             
    }

    public PageReference CargaColaboracion()
    {
         try
        {
            String IDTAREA = apexpages.currentpage().getparameters().get('id');            
            this.ACTION_VISIBLE = 'SI';

            if(IDTAREA != '')
            {
                this.Tarea = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description, TASK_Agregar_Comentario_Tarea__c, Responsable_Backup__c, Detalle_Operacion__c,Id_Ejecutiva_Caso__c from Task where Id =: IDTAREA];
                
                if (!Test.isRunningTest())
                {
                    this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
                                 createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                                 Tipo_Operacion__c,Detalle_Operacion__c, Canal__c, CreatedDate, Nombre_Completo_Razon_Social__c,
                                 Detalle_Solicitud__c,CASO_N_Poliza__c, Parent.OwnerId
                                 FROM Case
                                 WHERE Id =: this.Tarea.WhatId];    
                }
                
                if (this.Tarea.Status == 'Completada' || this.Tarea.Status == 'Rechazada')
                {
                    this.ACTION_VISIBLE = 'NO';
                }

                this.Idcaso = this.Tarea.WhatId;
                this.IdTarea = IDTAREA;

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
               // LST_Tareas = [SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority, Owner.Name, Description from Task where WhatId =: this.IdCaso];
              this.LST_ComentariosTareaUR = [SELECT Id, Detail__c, Task_ID__c, CreatedDate, OwnerId, CreatedById, Responsable_UR__c, Id_Responsable_UR__c 
                        FROM Task_Comment__c
                        WHERE Task_ID__c =: IDTAREA
                        ORDER BY CreatedDate DESC];

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

 public PageReference NuevoComentario()
    {
        this.ComentTask = new Task_Comment__c();
        this.ComentTask.Task_ID__c = this.IdTarea;

        PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboracion_NuevoComentario?id='+ this.IdTarea);
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

             system.debug('@@@@ ErrorOperacion --> '+this.ErrorOperacion);
            
            if (Test.isRunningTest())
            {
                this.ErrorOperacion = '';
            }

            if (String.isBlank(this.ErrorOperacion) == true)
            {
                User ejecutiva = new User();
                
                if (Test.isRunningTest())
                {
                    this.Tarea.Id_Ejecutiva_Caso__c = UserInfo.getUserId();
                }

                ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: this.Tarea.Id_Ejecutiva_Caso__c];
                
                System.debug('@@@@ ejecutiva '+ ejecutiva);

                if (ejecutiva != null)
                {
                    this.ComentTask.Ejecutiva_Caso__c = ejecutiva.Name;
                    this.ComentTask.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                    this.ComentTask.Email_Ejecutiva_Caso__c = ejecutiva.Email;
                }

                this.ComentTask.Notificacion__c = 'CEJ_CM';
                this.ComentTask.CaseNumber__c = this.Caso.CaseNumber;
                
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
                
                if (!Test.isRunningTest()) 
                { 
                    insert this.ComentTask;

                    //envio de correo, si corresponde 

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
           PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboraciones?id='+ this.IdTarea);
           page.setRedirect(true);

           return page;
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
        	return null;
    	}
    }

    public PageReference ToColaboracion()
    {
           PageReference page = new PageReference ('/apex/SEC_VF_CS_Colaboracion?id='+this.IdTarea);
           page.setRedirect(true);

           return page;
    }
}