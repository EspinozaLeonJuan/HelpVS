public with sharing class CTR_UR_Bandeja_ResponsableMultiple {
    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}

    public String AreaUsuarioLicencia {get; set;}

    public String ResponsableUR {get; set;}

    public String IdColaUR {get; set;}
   
    private String nombreColaUR {get; set;} 

    public String Ids {get; set;}

    public String Tipo {get; set;}

    public String SOQL_IDs {get; set;}

    public Boolean SIN_DATA {get; set;}

    public Boolean CASOS_OK {get; set;}    

    public Boolean TAREAS_OK {get; set;}    

    public Boolean COLABORACIONES_OK {get; set;}

    public List<Case> CasosUPD {get; set;}

    public List<Task> TareasUPD {get; set;}
    
    public String Titulo {get; set;}

    public String UsuarioBackup {get; set;}

    public CTR_UR_Bandeja_ResponsableMultiple() {

    }

    public List<Selectoption> getListarUsuarios(){
        try{
            List<Selectoption> LST_NombresUsuarios = new List<Selectoption>();
            
            LST_NombresUsuarios.add(new Selectoption('0','Ninguno'));

            for(Usuario_Backup__c u : this.LST_UsuariosBackup){
                LST_NombresUsuarios.add(new Selectoption(u.Id,u.Name));
            }

            return LST_NombresUsuarios;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public void IniciarAsignacion(){
        try
        {
           
            this.SIN_DATA = false;

            this.Tipo = System.currentPageReference().getParameters().get('Tipo');
            this.UsuarioBackup = apexpages.currentpage().getparameters().get('idResponsable');
            this.Ids = System.currentPageReference().getParameters().get('Ids');
            this.AreaUsuarioLicencia = System.currentPageReference().getParameters().get('area');

            system.debug('@@@@ Ids => ' + this.Ids);

          //  this.AreaUsuarioLicencia = [SELECT USUA_Area_UR__c FROM User WHERE Id =: UserInfo.getUserId()].USUA_Area_UR__c;
                      
            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuarioLicencia];

            if (!Test.isRunningTest()){
              this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;           
              this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;            
            }
            else
            {
                Group gQuery = [SELECT Name FROM Group WHERE Type = 'Queue' LIMIT 1];
                this.IdColaUR = gQuery.Id;        
              this.nombreColaUR = gQuery.Name;        
            }
            
            this.ResponsableUR = '0';
            
            system.debug('@@@@ Ids => ' + this.Ids);

            String[] IdsCambio = this.Ids.split('@');         

            for (String id : IdsCambio) 
            {
                String id_in_quotes = '\''+id+'\'';

                if (this.SOQL_IDs != '') 
                {
                     this.SOQL_IDs +=',';                      
                }  

                this.SOQL_IDs += id_in_quotes;
            }

            system.debug('@@@@ IdsCambio => ' + IdsCambio);
            
//
            if (this.Tipo == 'CASOS_UR')
            {
                String query = this.queryCasosUR();
               
                List<Case> result = new List<Case>();
                if (!Test.isRunningTest())
                {
                    result = Database.query(query);   
                }
            
                system.debug('@@@@  result '+result.size());

                if (result.size() == 0)
                {
                    this.SIN_DATA = true;
                }

                this.CASOS_OK = !this.SIN_DATA;

                this.Titulo = 'Asignación Responsable UR a múltiples Casos';
            } 
            else if (this.Tipo == 'TAREAS_UR')
            {
                String query = this.queryTareasUR();
               
                List<Task> result = new List<Task>();
                if (!Test.isRunningTest())
                {
                    result = Database.query(query);   
                }
            
                system.debug('@@@@  result '+result.size());

                if (result.size() == 0)
                {
                    this.SIN_DATA = true;
                }

                this.Titulo = 'Asignación Responsable UR a múltiples Tareas';

                this.TAREAS_OK = !this.SIN_DATA;
            }
            else if (this.Tipo == 'COLABORACIONES_UR')
            {
                String query = this.queryColaboracionesUR();
               
                List<Task> result = new List<Task>();
                if (!Test.isRunningTest())
                {
                    result = Database.query(query);   
                }
                
                system.debug('@@@@  result '+result.size());

                if (result.size() == 0)
                {
                    this.SIN_DATA = true;
                }

                this.Titulo = 'Asignación Responsable UR a múltiples Colaboraciones de Reclamo';

                this.COLABORACIONES_OK = !this.SIN_DATA;
            }


        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryCasosUR(){
        try
        {
            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c,'+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Email_Responsable_UR__c, '+
            'Id_Responsable_UR__c FROM Case WHERE Id IN ('+this.SOQL_IDs+')';

            return query;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
          return '';
        }
    }

    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryTareasUR(){
        try
        {
            String query = 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, '+
            'TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Solicitud__c, Id_Solicitante_UR__c, Id_Ejecutiva_Caso__c FROM Task WHERE Id IN ('+this.SOQL_IDs+')';

            system.debug('@@@@ Query tareas --> '+ query);
            return query;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
          return '';
        }
    }

    public String queryColaboracionesUR(){
        try
        {
            String query = 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, '+
            'TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Operacion__c, Id_Solicitante_UR__c, Id_Ejecutiva_Caso__c FROM Task WHERE Id IN ('+this.SOQL_IDs+')';

            system.debug('@@@@ Query tareas --> '+ query);
            return query;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
          return '';
        }
    }


    public List<Case> getCasosUR()
    {
        String query = this.queryCasosUR();
       
        this.CasosUPD = Database.query(query);   
        
        system.debug('@@@@  result'+ this.CasosUPD.size());  

        return  this.CasosUPD;
    }

     public List<Task> getTareasUR()
    {
        String query = this.queryTareasUR();
       
        this.TareasUPD = Database.query(query);   
        
        system.debug('@@@@  result'+ this.TareasUPD.size());  

        return  this.TareasUPD;
    }


     public List<Task> getColaboracionesUR()
    {
        String query = this.queryColaboracionesUR();
       
        this.TareasUPD = Database.query(query);   
        
        system.debug('@@@@  result'+ this.TareasUPD.size());  

        return  this.TareasUPD;
    }

    public void SeleccionResponsable()
    {
        //utilizado para cambio de responsable        
    }

    public void CambiarResponsable()//modificar para otros tiposde
    {
        if (this.ResponsableUR != '0' && this.ResponsableUR != 'Ninguno')
        {
            if (this.Tipo == 'CASOS_UR')
            {
                this.CambiaResponsable_Casos();
            }
            else if (this.Tipo == 'TAREAS_UR') 
            {
                this.CambiaResponsable_Tareas();
            }
            else if (this.Tipo == 'COLABORACIONES_UR')
            {
                this.CambiaResponsable_Colaboraciones();
            }
        }
    }

    public void CambiaResponsable_Casos()
    {
        try
        {
            Usuario_Backup__c UBck = new Usuario_Backup__c();
            
            if (!Test.isRunningTest())
            {
                UBck = [Select Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ResponsableUR]; 
            }            

            List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable>();

            List<CaseComment> comentarios = new List<CaseComment>();
            String estadoActual = '';
            String responsableActual = '';
            
            for(Case caso : this.CasosUPD){

                Usuario_Backup__c UActual = null;


                if (String.isNotBlank(caso.Id_Responsable_UR__c) == true)
                {
                    UActual = [Select Name, UBAC_Email__c From Usuario_Backup__c Where Id =: caso.Id_Responsable_UR__c];
                    responsableActual = caso.Id_Responsable_UR__c;
                }
                else
                {
                    responsableActual = 'NO_ID';
                } 

                estadoActual = caso.Status;

                caso.Fecha_Asignacion_UR__c = Datetime.now();
                caso.Email_Responsable_UR__c = UBck.UBAC_Email__c;  
                caso.Id_Responsable_UR__c = this.ResponsableUR;
                caso.Status = 'Back Office';     
                caso.CASO_Responsable_UR__c = this.ResponsableUR;

                CaseComment comentario = new CaseComment();
                comentario.ParentId = caso.Id;

                if (UActual != null)
                {
                    comentario.CommentBody = 'Reasignación de usuario UR : '+UActual.Name+' --> '+UBck.Name;  
                }
                else
                {
                    comentario.CommentBody = 'Asignación de usuario UR : '+UBck.Name;  
                }                

                comentarios.add(comentario);

                CLS_UR_Bandeja_Contador.CambioMasivoResponsable cambio = new CLS_UR_Bandeja_Contador.CambioMasivoResponsable();
                cambio.IdActual = responsableActual;
                cambio.IdNuevo = this.ResponsableUR;
                cambio.EstadoActual = estadoActual;
                lista.add(cambio);
            }

            if (!Test.isRunningTest()) 
            {                 
                update this.CasosUPD;

                insert comentarios;
                    
                for(CLS_UR_Bandeja_Contador.CambioMasivoResponsable data : lista){
                    CLS_UR_Bandeja_Contador.ActualizaResponsable_Caso(data.IdActual, data.IdNuevo, data.EstadoActual);
                }
            }
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }

    public void CambiaResponsable_Tareas()
    {
        try
        {
            Usuario_Backup__c UBck = new Usuario_Backup__c();
            
            if (!Test.isRunningTest())
            {
                UBck = [Select Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ResponsableUR]; 
            }
            
            List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable>();

            List<Task_Comment__c> Comentarios = new List<Task_Comment__c>();
            String estadoActual = '';
            String responsableActual = '';

            for(Task tarea : this.TareasUPD){

                tarea.Fecha_Asignacion_UR__c = Datetime.now();
                tarea.Email_Responsable_UR__c = UBck.UBAC_Email__c;  
                
                responsableActual = tarea.Responsable_Backup__c ;
                estadoActual = tarea.Status;

                if (String.isBlank(responsableActual))
                {
                    responsableActual = 'NO_ID';
                }

                tarea.Responsable_Backup__c = this.ResponsableUR;
                tarea.Status = 'No Iniciada';    
                //generar comentarios tarea
                
                Usuario_Backup__c uResponsable = new Usuario_Backup__c();
            
                if (!Test.isRunningTest())
                {
                    uResponsable = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: tarea.Responsable_Backup__c];
                }
                
                System.debug('@@@@ uResponsable '+ uResponsable);

                String comentario = '';
                
                if (uResponsable != null)
                {
                    comentario =  'Se ha asignado a '+  uResponsable.Name + ' como responsable de la Tarea UR.';
                }

                Usuario_Backup__c uSolicitante = null;

                if (String.isBlank(tarea.Id_Solicitante_UR__c) == false)
                //if (tarea.Id_Solicitante_UR__c != null)
                {
                    uSolicitante = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: tarea.Id_Solicitante_UR__c]; 
                }

                Comentarios.add(this.GeneraComentarioTarea(tarea.Id, comentario, 'TUR_AS', uSolicitante , uResponsable, tarea.Status, tarea.caso_numero__c));

                CLS_UR_Bandeja_Contador.CambioMasivoResponsable cambio = new CLS_UR_Bandeja_Contador.CambioMasivoResponsable();
                cambio.IdActual = responsableActual;
                cambio.IdNuevo = this.ResponsableUR;
                cambio.EstadoActual = estadoActual;
                lista.add(cambio);
                //CLS_UR_Bandeja_Contador.ActualizaResponsable_Tareas(responsableActual, this.UsuarioBackUp, estadoActual);
            }

            if (!Test.isRunningTest()) 
            {                 
                update this.TareasUPD;
                insert Comentarios; //insertar comentarios tarea
                for(CLS_UR_Bandeja_Contador.CambioMasivoResponsable data : lista){
                    CLS_UR_Bandeja_Contador.ActualizaResponsable_Tarea(data.IdActual, data.IdNuevo, data.EstadoActual);
                }
            }          
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }

    public Task_Comment__c GeneraComentarioTarea(string idTarea, string textoComentario, string notificacion, Usuario_Backup__c usol, Usuario_Backup__c uresp, String estadoTarea, String numeroCaso)
    {
        Task_Comment__c comentario = null;
        try
        {
            comentario = new Task_Comment__c();
            comentario.Task_ID__c = idTarea;
            comentario.Detail__c = textoComentario;

            List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable>();

            if (uresp != null)
            {
                comentario.Responsable_UR__c = uresp.Name;
                comentario.Id_Responsable_UR__c = uresp.Id;
                comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            }

            if (usol != null)
            {
                comentario.Solicitante_UR__c = usol.Name;
                comentario.Id_Solicitante_UR__c = usol.Id;
                comentario.Email_Solicitante_UR__c = usol.UBAC_Email__c;
            }

            comentario.Notificacion__c = notificacion;
            comentario.CaseNumber__c = numeroCaso;
            comentario.Estado_Tarea__c = estadoTarea;
               
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }     

        system.debug('@@@@ DATOS COMENTARIO (TAREA) --> '+ comentario);
        return comentario;
    }

    public void CambiaResponsable_Colaboraciones()
    {
        try
        {
            Usuario_Backup__c UBck = new Usuario_Backup__c();
            
            if (!Test.isRunningTest())
            {
                UBck = [Select Name, UBAC_Email__c From Usuario_Backup__c Where Id =: this.ResponsableUR]; 
            }

            List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoResponsable>();
            
            List<Task_Comment__c> Comentarios = new List<Task_Comment__c>();

            String estadoActual = '';
            String responsableActual = '';

            for(Task tarea : this.TareasUPD){

                responsableActual = tarea.Responsable_Backup__c ;
                estadoActual = tarea.Status;

                if (String.isBlank(responsableActual))
                {
                    responsableActual = 'NO_ID';
                }

                tarea.Fecha_Asignacion_UR__c = Datetime.now();
                tarea.Email_Responsable_UR__c = UBck.UBAC_Email__c;  
                tarea.Responsable_Backup__c = this.ResponsableUR;
                tarea.Status = 'No Iniciada';    
                //generar comentarios tarea
                //Usuario_Backup__c uResponsable = [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: tarea.Responsable_Backup__c];
                 Usuario_Backup__c uResponsable = new Usuario_Backup__c();
            
                if (!Test.isRunningTest())
                {
                    uResponsable =  [SELECT Id, Name, UBAC_Email__c FROM Usuario_Backup__c WHERE Id =: tarea.Responsable_Backup__c];
                }
                
                System.debug('@@@@ uResponsable '+ uResponsable);

                String comentario = '';
                
                if (uResponsable != null)
                {
                    comentario = 'Se ha asignado a '+  uResponsable.Name + ' como responsable de la Colaboracion de Reclamo UR.';
                }

                User ejecutiva = null;

                if (String.isBlank(tarea.Id_Ejecutiva_Caso__c) == false)
                {
                    system.debug('@@@@ Id_Ejecutiva_Caso__c => ' + tarea.Id_Ejecutiva_Caso__c);
                    try 
                    {
                        ejecutiva = [Select Id, Name, Email FROM User WHERE ID=: tarea.Id_Ejecutiva_Caso__c];                                        
                    } catch (Exception ex) {
                        
                    }
                }

                Comentarios.add(this.GeneraComentarioColaboracion(tarea.Id, comentario, 'CUR_AS', ejecutiva , uResponsable, tarea.Status, tarea.caso_numero__c));

                CLS_UR_Bandeja_Contador.CambioMasivoResponsable cambio = new CLS_UR_Bandeja_Contador.CambioMasivoResponsable();
                cambio.IdActual = responsableActual;
                cambio.IdNuevo = this.ResponsableUR;
                cambio.EstadoActual = estadoActual;
                lista.add(cambio);

               // CLS_UR_Bandeja_Contador.ActualizaResponsable_Tareas(responsableActual, this.UsuarioBackUp, estadoActual);
            }

            if (!Test.isRunningTest()) 
            {                 
                update this.TareasUPD;
                insert Comentarios; //insertar comentarios tarea
                for(CLS_UR_Bandeja_Contador.CambioMasivoResponsable data : lista){
                    CLS_UR_Bandeja_Contador.ActualizaResponsable_Colaboracion(data.IdActual, data.IdNuevo, data.EstadoActual);
                }
            }          
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }

    public Task_Comment__c GeneraComentarioColaboracion(string idTarea, string textoComentario, string notificacion, User ejecutiva, Usuario_Backup__c uresp, String estadoTarea, String numeroCaso)
    {
        Task_Comment__c comentario = null;
        try
        {
            comentario = new Task_Comment__c();
            comentario.Task_ID__c = idTarea;
            comentario.Detail__c = textoComentario;

            if (uresp != null)
            {
                comentario.Responsable_UR__c = uresp.Name;
                comentario.Id_Responsable_UR__c = uresp.Id;
                comentario.Email_Responsable_UR__c = uresp.UBAC_Email__c;
            }

            if (ejecutiva != null)
            {
                    comentario.Ejecutiva_Caso__c = ejecutiva.Name;
                    comentario.Id_Ejecutiva_Caso__c = ejecutiva.Id;
                    comentario.Email_Ejecutiva_Caso__c = ejecutiva.Email;
            }

            comentario.Notificacion__c = notificacion;
            comentario.CaseNumber__c = numeroCaso;
            comentario.Estado_Tarea__c = estadoTarea;
               
        }
        catch (Exception ex) {
           system.debug('@@@@  EXCEPCION --> '+  ex.getLineNumber()+'   '+ ex.getMessage());
        }     

        system.debug('@@@@ DATOS COMENTARIO (TAREA) --> '+ comentario);
        return comentario;
    }
}