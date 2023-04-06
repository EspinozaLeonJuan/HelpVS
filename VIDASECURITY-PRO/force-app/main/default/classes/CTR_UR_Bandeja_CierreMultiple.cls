/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-06-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-06-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public with sharing class CTR_UR_Bandeja_CierreMultiple {
    public String Ids {get; set;}

    public String Tipo {get; set;}

    public String Estado {get; set;}

    public String SOQL_IDs {get; set;}

    public Boolean SIN_DATA {get; set;}

    public Boolean CASOS_OK {get; set;}    

    public Boolean TAREAS_OK {get; set;}    

    public Boolean COLABORACIONES_OK {get; set;}

    public List<Case> CasosUPD {get; set;}

    public List<Task> TareasUPD {get; set;}
    
    public String Titulo {get; set;}

    public String UsuarioBackup {get; set;}

    public String Comentario {get; set;}
   
    public CTR_UR_Bandeja_CierreMultiple() {
        
    }

    public void CargaCasos(){
        try
        {
            this.SIN_DATA = false;
            this.Tipo = System.currentPageReference().getParameters().get('Tipo');
            this.Ids = System.currentPageReference().getParameters().get('Ids');
            this.UsuarioBackup = apexpages.currentpage().getparameters().get('idResponsable');

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

                this.Titulo = 'Cierre de Casos múltiple de Casos (En Proceso)';
                this.Estado = 'Cerrado';
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

                this.Titulo = 'Cierre múltiple de Tareas';

                this.TAREAS_OK = !this.SIN_DATA;
                this.Estado = 'Descartada';
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

                this.Titulo = 'Cierre múltiple Colaboraciones de Reclamo';

                this.COLABORACIONES_OK = !this.SIN_DATA;
                this.Estado = 'Descartada';
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
            'Id_Responsable_UR__c FROM Case WHERE Id IN ('+this.SOQL_IDs+') AND Status = \'En Proceso\'';

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

    public void Cerrar()//modificar para otros tiposde
    {
        if (this.Tipo == 'CASOS_UR')
        {
            this.Cerrar_Casos();
        }
        else if (this.Tipo == 'TAREAS_UR') 
        {
            this.Cerrar_Tareas();
        }
        else if (this.Tipo == 'COLABORACIONES_UR')
        {
            this.Cerrar_Colaboraciones();
        }
    }

    public void Cerrar_Casos()
    {
        try
        {
            List<CaseComment> comentarios = new List<CaseComment>();

            for(Case caso : this.CasosUPD)
            {
                caso.Status = 'Cerrado';
                caso.Entrega_Respuesta__c = true;
                caso.CASO_Mensaje_Notificaci_n__c = 'Caso resuelto.';
                
                String eval =  'ED - ';

                Boolean limpiar =  caso.Subject.contains(eval);
                if (limpiar == false)
                {
                    eval =  'UR - ';
                }
                
                if (limpiar == true)
                {
                    caso.CASO_Asunto_Notificaci_n__c = caso.Subject.replace(eval, '');
                }
                else
                {
                    caso.CASO_Asunto_Notificaci_n__c = caso.Subject;
                }

                CaseComment comentario = new CaseComment();
                comentario.ParentId = caso.Id;
                comentario.CommentBody = this.Comentario; 
                comentarios.add(comentario);
            }

            if (!Test.isRunningTest()) 
            {                 
                update this.CasosUPD;

                insert comentarios;
            }
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }

    public void Cerrar_Tareas()
    {
        try
        {
            List<CLS_UR_Bandeja_Contador.CambioMasivoEstado> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoEstado>();

            List<Task_Comment__c> comentarios = new List<Task_Comment__c>();

            Task_Comment__c com;
            
            CLS_UR_Bandeja_Contador.CambioMasivoEstado data;

            for (Task tarea : this.TareasUPD) {
                
                system.debug('@@@@ tarea  '+ tarea);
                if (tarea.Status == 'No Iniciada' || tarea.Status == 'En Curso')
                { 
                    com = new Task_Comment__c();
                    data = new CLS_UR_Bandeja_Contador.CambioMasivoEstado();
                    data.EstadoActual = tarea.Status;
                    //TODO: revisar una vez concluidad etapa de tareas
                    tarea.Status = 'Descartada';
                    tarea.TASK_Agregar_Comentario_Tarea__c = 'Tarea UR Descartada por parte de la Unidad Resolutora.';
                    system.debug('@@@@ tarea 02 '+ tarea);
                    data.EstadoNuevo = 'Descartada';
                    data.Id = tarea.Responsable_Backup__c;
                    lista.add(data);

                    com.Id_Solicitante_UR__c = tarea.Id_Solicitante_UR__c;
                    com.Task_ID__c = tarea.Id;
                    com.Id_Responsable_UR__c = tarea.Responsable_Backup__c;
                    com.Notificacion__c = 'TUR_CE';//Tarea UR - Cambio de Estado
                    com.CaseNumber__c = tarea.caso_numero__c;
                    com.Estado_Tarea__c = 'Descartada';
                    com.Detail__c = 'Tarea UR Descartada por parte de la Unidad Resolutora.';
                    comentarios.add(com);
                }                
            }

            update this.TareasUPD;
            insert comentarios;

            for (CLS_UR_Bandeja_Contador.CambioMasivoEstado value : lista) {
                CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(value.Id, value.EstadoNuevo, value.EstadoActual);                
            }
        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }

    public void Cerrar_Colaboraciones()
    {
        try
        {
            List<CLS_UR_Bandeja_Contador.CambioMasivoEstado> lista = new List<CLS_UR_Bandeja_Contador.CambioMasivoEstado>();

            List<Task_Comment__c> comentarios = new List<Task_Comment__c>();

            Task_Comment__c com;
            
            CLS_UR_Bandeja_Contador.CambioMasivoEstado data;

            for (Task tarea : this.TareasUPD) {
                
                system.debug('@@@@ colaboracion  '+ tarea);
                if (tarea.Status == 'No Iniciada' || tarea.Status == 'En Curso')
                { 
                    com = new Task_Comment__c();
                    data = new CLS_UR_Bandeja_Contador.CambioMasivoEstado();
                    data.EstadoActual = tarea.Status;
                    //TODO: revisar una vez concluidad etapa de tareas
                    tarea.Status = 'Descartada';
                    tarea.TASK_Agregar_Comentario_Tarea__c = 'Colaboración UR Descartada por parte de la Unidad Resolutora.';
                    system.debug('@@@@ tarea 02 '+ tarea);
                    data.EstadoNuevo = 'Descartada';
                    data.Id = tarea.Responsable_Backup__c;
                    lista.add(data);

                    com.Id_Solicitante_UR__c = tarea.Id_Solicitante_UR__c;
                    com.Task_ID__c = tarea.Id;
                    com.Id_Responsable_UR__c = tarea.Responsable_Backup__c;
                    com.Notificacion__c = 'CUR_CE';//Colaboración UR - Cambio de Estado
                    com.CaseNumber__c = tarea.caso_numero__c;
                    com.Estado_Tarea__c = 'Descartada';
                    com.Detail__c = 'Colaboración UR Descartada por parte de la Unidad Resolutora.';
                    comentarios.add(com);
                }                
            }

            update this.TareasUPD;
            insert comentarios;

            for (CLS_UR_Bandeja_Contador.CambioMasivoEstado value : lista) {
                CLS_UR_Bandeja_Contador.ActualizaEstado_Tarea(value.Id, value.EstadoNuevo, value.EstadoActual);                
            }

        }
        catch(Exception ex)
        {
            system.debug('@@@@ ERROR => ' + ex.getMessage() + '; LÍNEA => ' + ex.getLineNumber());
        }   
    }
}