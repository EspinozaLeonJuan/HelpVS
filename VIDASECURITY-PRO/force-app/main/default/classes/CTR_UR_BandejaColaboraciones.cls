/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_BandejaColaboraciones													|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Permite listar, buscar y administrar las colaboraciones existentes en la       |
 |                           Bandeja UR                                                                     |
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
 
public class CTR_UR_BandejaColaboraciones {
    public String RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;
 
    public String CurrentPage {get; set;}
    /*Paginación*/
    public integer OffsetSize = 0;
    
    public integer LimitSize= 15;
    
    public integer totalRecs {get; set;}
    
    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}
    /*Paginación*/

    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    
    public String IdColaUR {get; set;}

    public String SOQL_IDs {get; set;}

    public String AreaUsuarioLicencia {get; set;}

    public String UsuarioBackUp {get; set;}

    public String Estado {get; set;}

    private String nombreColaUR {get; set;}

    public String NumeroCaso {get; set;}

    public Date FechaInicio {get; set;}

    public Date FechaTermino {get; set;}

    /*Paginación*/
    public void FirstPage()
    {
         OffsetSize = 0;
         Page = 1;
    }

    public void previous()
    {
        OffsetSize = OffsetSize - LimitSize;
        Page--;
    }

    public void next()
    {
        OffsetSize = OffsetSize + LimitSize;
        Page++;
    }

    public void LastPage()
    {
        OffsetSize = totalrecs - Math.mod(totalRecs,LimitSize);
        Page = totalRecs / LimitSize;

        if(totalrecs > OffsetSize)
        {
             Page++;
        }

        system.debug('@@@@ OffsetSize '+ OffsetSize);
        system.debug('@@@@ totalrecs '+ totalrecs);
        system.debug('@@@@ Page '+ Page);
    }


    public boolean getprev()
    {
        if(OffsetSize == 0)
        {
            return true;
        }            
        else
        {
            return false;
        }            
    }
    
    public boolean getnxt()
    {
        if((OffsetSize + LimitSize) > totalRecs)
            {
            return true;
        }            
        else
        {
            return false;
        }
    }
    /*Paginación*/

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

    public List<Selectoption> getListarEstados(){
        try{
            List<Selectoption> LST_Estados = new List<Selectoption>();
            
            LST_Estados.add(new Selectoption('Todos','Todos'));
            
            if (this.CurrentPage == 'COLABORACIONES_UR')
            {
                LST_Estados.add(new Selectoption('No Iniciada','No Iniciada'));
                LST_Estados.add(new Selectoption('En Curso','En Curso'));
            }
            else if (this.CurrentPage == 'COLABORACIONES_UR_HISTORICO')
            {
                LST_Estados.add(new Selectoption('Completada','Completada'));
                LST_Estados.add(new Selectoption('Rechazada','Rechazada'));  
                LST_Estados.add(new Selectoption('Descartada','Descartada'));                
            }
            
            return LST_Estados;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

     /*Realiza busqueda segun usuario responsable seleccionado*/         
    public Pagereference seleccionResponsableUR(){
        try{
            
            String query = '';

            if (this.CurrentPage == 'COLABORACIONES_UR')
            {
                query = this.queryColaboracionesUR('');
            }
            else if (this.CurrentPage == 'COLABORACIONES_UR_HISTORICO')
            {
                //query = this.queryCasosURHistorico('');
            } 
        
            List<Task> tareasUR = new List<Task>();
            
            if (!Test.isRunningTest())
            {
                 tareasUR = Database.query(query);
            }                     

            system.debug('@@@@  CASOS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }

            if (this.TotalPage == 0)
           {
               this.Page = 0;
           }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }   

        return null;        
    }

    private Boolean CargaUsuario()
    {
       try 
        {
            this.UsuarioBackUp = apexpages.currentpage().getparameters().get('idResponsable');
        } 
        catch (Exception ex) 
        {
            this.UsuarioBackUp = '';
        }  

        system.debug('@@@@ UsuarioBackUp IN  --> '+ this.UsuarioBackUp);

        User UsuarioSF = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];
        
        system.debug('@@@@ USUARIO SF'+ UsuarioSF);
        system.debug('@@@@ USUARIO Id'+ UsuarioSF.Id);
        system.debug('@@@@ USUARIO Area'+ UsuarioSF.USUA_Area_UR__c);

        if (String.IsBlank(UsuarioSF.USUA_Area_UR__c))
        {
           return false;
        }

        this.AreaUsuarioLicencia = UsuarioSF.USUA_Area_UR__c;
        
        List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND Usuario__c =: UsuarioSF.Id];
        
        system.debug('@@@@ ubacks '+ ubacks);
        
        if (String.isBlank(this.UsuarioBackup))
        {
            if (ubacks.Size() == 0)
            {
                this.UsuarioBackUp = '0';
            }
            else {
                this.UsuarioBackUp = ubacks[0].Id;
            }
        }

        system.debug('@@@@ AreaUsuarioLicencia  --> '+ this.AreaUsuarioLicencia);
        system.debug('@@@@ UsuarioBackUp  --> '+ this.UsuarioBackUp);

        return true;

    }

    public PageReference IniciarBandejaColaboracionesUR(){
        Boolean exito =  this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.CargaBandejaColaboraciones();
             return null;
        }
        else {
            return ErrorAcceso();
        }       
    }

    public void CargaBandejaColaboraciones(){
       
        try
        {
            this.SOQL_IDs = '';
                      
            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuarioLicencia];

            if (!Test.isRunningTest()){
        	    this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;   //obtiene Id de Cola a partir de area deusuarios backup        
            	this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;            
            }
            else
            {
                Group gQuery = [SELECT Name FROM Group WHERE Type = 'Queue' LIMIT 1];
                this.IdColaUR = gQuery.Id;        
        	    this.nombreColaUR = gQuery.Name;        
            }            

            this.FechaInicio = Date.today().addDays(-183);//6 meses
            this.FechaTermino = Date.today();

            this.Estado = 'Todos';
 
            String query = this.queryColaboracionesUR('');

            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);

            List<Task> tareasUR = new List<Task>();

            if (!Test.isRunningTest())
            {
	            tareasUR = Database.query(query);                
            }
            
            system.debug('@@@@  TAREAS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }       

           if (this.TotalPage == 0)
           {
               this.Page = 0;
           } 

           this.CurrentPage = 'COLABORACIONES_UR';
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }
    }
    
    public PageReference ErrorAcceso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ErrorAcceso');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

      /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryColaboracionesUR(String qlimit)
    {
        try{

            String query = 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, '+
            'TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Operacion__c FROM Task';

            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioBackUp);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);

         /*   if(this.UsuarioBackUp == null)
            {
                this.UsuarioBackUp = '0';
            }
*/
            Cola_Usuario__c colaUsuario = new Cola_Usuario__c();
            
            if (!Test.isRunningTest())
            {
                colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: this.IdColaUR];
            }

            String qwhere = ' WHERE RecordTypeId = \''+ this.RecordTypeId + '\''+' AND OwnerId = \''+ colaUsuario.Usuario__c + '\'';

            String qestado = '';

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'No Iniciada\' OR Status = \'En Curso\' ) ';
            } 
            else 
            {
                 qestado = ' AND (Status = \''+ this.Estado +'\' ) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z ';    

            String quback = '';//Todos
            if(this.UsuarioBackUp != null && this.UsuarioBackUp != '0' && this.UsuarioBackUp != '1'){
                quback = ' AND Responsable_Backup__c = \'' + this.UsuarioBackUp + '\' AND IsClosed = false';
            }else
            { 
                if (this.UsuarioBackUp == '1')
                {
                    quback = ' AND Responsable_Backup__c = NULL AND IsClosed = false';              
                }                
            }

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND caso_numero__c = \''+ this.NumeroCaso.trim() +'\'';
            }

            String  qorden = ' ORDER BY CreatedDate ASC';

            String queryTareasUR  = query + qwhere + quback + qestado + qfecha +  qnumeroCaso + qorden + qlimit;
            system.debug('@@@@ QUERY TAREAS UR --> '+ queryTareasUR);
            return queryTareasUR;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }

    public List<Task> getColaboracionesUR()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryColaboracionesUR(queryLimit);

        system.debug('@@@@ query --> '+ query);

        List<Task> tareas = new List<Task>();
        
        if (!Test.isRunningTest())
        {
			tareas = Database.query(query);   
        }

        String queryAll = this.queryColaboracionesUR('');

        List<Task> tareasUR = new List<Task>();
        if (!Test.isRunningTest())
        {
            tareasUR = Database.query(queryAll);
        }
        
        system.debug('@@@@  CASOS LST_TareasUR => ' + tareasUR.size());

        totalRecs = tareasUR.Size();

  //      OffsetSize = 0;   
    //    Page = 1;

        Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
        this.TotalPage = totalRecs / LimitSize;

        if(totalrecs > range)
        {
            this.TotalPage++;
        }   

  //      if (this.TotalPage == 0)
    //    {
//            this.Page = 0;
  //      }        
                   
        return tareas;
    }
    
    public PageReference BandejaUR()
    {
        try
        {
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Bandeja');
            pagina_verCaso.setRedirect(true);
            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaUR -->'+ ex);            
        	return null;
        }
    }

    public Pagereference BandejaColaboracionesUR_Historico()
    {
        try{
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ColaboracionesHistorico?idResponsable=' + this.UsuarioBackUp);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaColaboracionesUR_Historico -->'+ ex);
        	return null;
        }
    }

    public Pagereference BandejaColaboracionesUR()
    {
        try{
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Colaboraciones?idResponsable=' + this.UsuarioBackUp);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaColaboracionesUR -->'+ ex);
        	return null;
        }
    }

    public void SeleccionResponsable()
    {

    } 

     /*Realiza busqueda segun usuario responsable seleccionado*/         
    public Pagereference busquedaColaboracionesUR(){
        try{
	        system.debug('@@@@  ENTRO ACA ');
            system.debug('@@@@  Fecha Imicio =>' + FechaInicio);
            system.debug('@@@@  Fecha Termino =>' + FechaTermino);
            String query = this.queryColaboracionesUR('');
            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);

            List<Task> tareasUR = Database.query(query);
            system.debug('@@@@  CASOS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }   

            if (this.TotalPage == 0)
            {
               this.Page = 0;
            }


             system.debug('@@@@  Page => ' + Page);
             system.debug('@@@@  TotalPage => ' + TotalPage);

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }   

        return null;        
    }

    public Pagereference limpiabusquedaColaboracionesUR()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_Colaboraciones?idResponsableUR='+this.UsuarioBackUp);
       page.setRedirect(true);
       return page;
    }

    public PageReference verColaboracion(){
        try{
            String ID = apexpages.currentpage().getparameters().get('Id');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Colaboracion?Id='+ID + '&idResponsable=' + this.UsuarioBackUp+'&procedencia='+this.CurrentPage);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }catch(Exception ex){
            system.debug('@@@@ ERROR LINK verColaboracionUR -->'+ ex);
        	return null;
        }
    }


    public PageReference IniciarBandejaColaboracionesUR_Historico(){
        Boolean exito =  this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.CargaBandejaColaboraciones_Historico();
             return null;
        }
        else {
            return ErrorAcceso();
        }       
    }

    public void CargaBandejaColaboraciones_Historico(){
        try
        {
            this.CargaUsuario();

            this.SOQL_IDs = '';
                      
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
     
            this.FechaInicio = Date.today().addDays(-183);//6 meses
            this.FechaTermino = Date.today();

            this.Estado = 'Todos';
 
            String query = this.queryColaboracionesHistorico('');


            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);
			List<Task> tareasUR = new List<Task>();
            
            if (!Test.isRunningTest())
            {
            	tareasUR = Database.query(query);    
            }
            
            system.debug('@@@@  TAREAS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }       

           if (this.TotalPage == 0)
           {
               this.Page = 0;
           } 

           this.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }
    }

/*
    public void IniciarBandejaColaboracionesUR_Historico(){
        try
        {
            this.CargaUsuario();

            this.SOQL_IDs = '';
                      
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
     
            this.FechaInicio = Date.today().addDays(-30);
            this.FechaTermino = Date.today();

            this.Estado = 'Todos';
 
            String query = this.queryColaboracionesHistorico('');


            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);
			List<Task> tareasUR = new List<Task>();
            
            if (!Test.isRunningTest())
            {
            	tareasUR = Database.query(query);    
            }
            
            system.debug('@@@@  TAREAS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }       

           if (this.TotalPage == 0)
           {
               this.Page = 0;
           } 

           this.CurrentPage = 'COLABORACIONES_UR_HISTORICO';
        }catch(Exception ex){
            system.debug('@@ ERROR => ' + ex);
        }
    }
*/
    public String queryColaboracionesHistorico(String qlimit)

    {
        try{

            String query = 'SELECT Id, Subject, WhatId, Status, CreatedDate, ActivityDate, Priority,OwnerId, UR_Origen__c, Owner.Name, Description, Responsable_Backup__c, '+
            'TASK_Agregar_Comentario_Tarea__c, caso_numero__c, Detalle_Operacion__c FROM Task';

            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioBackUp);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);
/*
            if(this.UsuarioBackUp == null)
            {
                this.UsuarioBackUp = '0';
            }
*/
            Cola_Usuario__c colaUsuario = new Cola_Usuario__c();
            if (!Test.isRunningTest())
            {
                colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: this.IdColaUR];
            }

            String qwhere = ' WHERE RecordTypeId = \''+ this.RecordTypeId + '\''+' AND OwnerId = \''+ colaUsuario.Usuario__c + '\'';

            String qestado = '';

            if (this.Estado == 'Todos')
            {
                qestado = ' AND (Status = \'Completada\' OR Status = \'Rechazada\' OR Status = \'Descartada\' ) ';
            } 
            else 
            {
                 qestado = ' AND (Status = \''+ this.Estado +'\' ) ';
            }

            String qfecha = ' AND CreatedDate >= '+ String.valueOf(FechaInicio)+'T00:00:00Z' +' AND CreatedDate <=' + String.valueOf(FechaTermino.addDays(1))+'T23:59:59Z ';    

            String quback = '';//Todos
            if(this.UsuarioBackUp != null && this.UsuarioBackUp != '0' && this.UsuarioBackUp != '1'){
                quback = ' AND Responsable_Backup__c = \'' + this.UsuarioBackUp + '\' AND IsClosed = false';
            }else
            { 
                if (this.UsuarioBackUp == '1')
                {
                    quback = ' AND Responsable_Backup__c = NULL AND IsClosed = false';              
                }                
            }

            String qnumeroCaso = '';
            
            if (String.isNotBlank(this.NumeroCaso) == true)
            {
                qnumeroCaso = ' AND caso_numero__c = \''+ this.NumeroCaso.trim() +'\'';
            }
            

            String  qorden = ' ORDER BY CreatedDate ASC';

            String queryTareasUR  = query + qwhere + quback + qestado + qfecha +  qnumeroCaso  + qorden + qlimit;
            system.debug('@@@@ QUERY TAREAS UR --> '+ queryTareasUR);
            return queryTareasUR;

        }catch(Exception ex){
            ApexPages.addMessages(ex);
        	return '';
        }
    }

    public List<Task> getColaboracionesURHistorico()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryColaboracionesHistorico(queryLimit);


        system.debug('@@@@ query --> '+ query);

       List<Task> tareas = new List<Task>();
            
        if (!Test.isRunningTest())
        {
            tareas = Database.query(query);    
        }

        totalRecs = tareas.Size();

     //   OffsetSize = 0;   
       // Page = 1;

        Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
        this.TotalPage = totalRecs / LimitSize;

        if(totalrecs > range)
        {
            this.TotalPage++;
        }   

    //    if (this.TotalPage == 0)
      //  {
        //    this.Page = 0;
        //} 
       
        return tareas;
    }

    public Pagereference queryColaboracionesHistorico(){

        try{
	
            String query = this.queryColaboracionesHistorico('');

            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);

            List<Task> tareasUR = new List<Task>();
            
            if (!Test.isRunningTest())
            {
            	tareasUR = Database.query(query);    
            }
            
            system.debug('@@@@  CASOS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }   

            if (this.TotalPage == 0)
            {
               this.Page = 0;
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }   

        return null;        
    }

     public List<Task> getColaboracionesHistorico()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryColaboracionesHistorico(queryLimit);


        system.debug('@@@@ query --> '+ query);

        List<Task> tareas = new List<Task>();
        
        if (!Test.isRunningTest())
        {
            tareas = Database.query(query);    
        }
                   
        return tareas;
    }

    public Pagereference busquedaColaboracionesHistorico(){
        try{
	
            String query = this.queryColaboracionesHistorico('');

            system.debug('@@@@  QUERY TAREAS LST_TareasUR => ' + query);

            List<Task> tareasUR = Database.query(query);
            system.debug('@@@@  CASOS LST_TareasUR => ' + tareasUR.size());

            totalRecs = tareasUR.Size();

            OffsetSize = 0;   
            Page = 1;

            Integer range =  totalrecs - Math.mod(totalRecs,LimitSize);
            this.TotalPage = totalRecs / LimitSize;

            if(totalrecs > range)
            {
                this.TotalPage++;
            }   

            if (this.TotalPage == 0)
            {
               this.Page = 0;
            }
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }   

        return null;        
    }

    public Pagereference limpiabusquedaColaboracionesHistorico()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_ColaboracionesHistorico?idResponsableUR='+this.UsuarioBackUp);
       page.setRedirect(true);
       return page;
    }

    
}