/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_BandejaCasos															|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Permite listar, buscar y administrar los casos existentes en la Bandeja UR     |
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/
 
public class CTR_UR_BandejaCasos {

    /*Paginación*/
    public integer OffsetSize = 0;
    
    public integer LimitSize= 15;
     
    public integer totalRecs {get; set;}
    
    public Integer Page {get; set;}

    public Integer TotalPage {get; set;}
    /*Paginación*/

    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}
    
    public String UsuarioNativo { get; set; }

    public String AreaUsuarioLicencia {get; set;}
    
    public String UsuarioBackUp {get; set;}

    public String IdColaUR {get; set;}
   
    public String NumeroCaso {get; set;}

    public String Poliza {get; set;}

    public String Estado {get; set;}

    public String Origen {get; set;}

    private String nombreColaUR {get; set;}

    public String SOQL_IDs {get; set;}

    public String CurrentPage {get; set;}

    public String RUT {get; set;}

    public String Tipo {get; set;}

    public String Propuesta {get; set;}

    public Case FiltroCaso {get; set;}

    public Date FechaInicioDerivacion {get; set;}

    public Date FechaTerminoDerivacion {get; set;}

    public Time HoraInicioDerivacion { get; set;}

    public Time HoraTerminoDerivacion { get; set;}    

    public Boolean FiltroVentas {get; set;}

    public Boolean RequerimientoVentas {get; set;}

    public String EstadoACSEL  {get; set;}

    public String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;

    public PAR_UR_BandejaCasos Pantalla {get; set;}

    public Boolean SeleccionMultiple {get; set;}

    public String Categoria_Beneficios {get; set;}

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

            if (this.CurrentPage == 'CASOS_UR')
            {
                LST_NombresUsuarios.add(new Selectoption('1','Casos sin responsable UR'));
            }

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
            
            if (this.CurrentPage == 'CASOS_UR')
            {
                LST_Estados.add(new Selectoption('Back Office','Back Office'));
                LST_Estados.add(new Selectoption('En Proceso','En Proceso'));
            }
            else if (this.CurrentPage == 'CASOS_UR_ENREVISION')
            {            
                            
            }
            else if (this.CurrentPage == 'CASOS_UR_HISTORICO')
            {
                LST_Estados.add(new Selectoption('Cerrado','Cerrado'));
                LST_Estados.add(new Selectoption('Rechazado','Rechazado'));                
            }
            
            return LST_Estados;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<Selectoption> getListarEstadosAcsel(){
        try{
            List<Selectoption> LST_Estados = new List<Selectoption>();
            
            LST_Estados.add(new Selectoption('Todos','Todos'));            
            LST_Estados.add(new Selectoption('ING','ING'));                    
            LST_Estados.add(new Selectoption('AUT','AUT'));
            LST_Estados.add(new Selectoption('PRA','PRA'));   
            LST_Estados.add(new Selectoption('ACE','ACE'));   
            LST_Estados.add(new Selectoption('ACT','ACT'));   
            LST_Estados.add(new Selectoption('Pago en Formalización','Pago en Formalización'));   
            
            return LST_Estados;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<Selectoption> getListarTipos(){
        try{
            List<Selectoption> LST_Tipos = new List<Selectoption>();
            
            LST_Tipos.add(new Selectoption('Todos','Todos'));
            
            LST_Tipos.add(new Selectoption('Clientes','Clientes'));
            LST_Tipos.add(new Selectoption('No Clientes','No Clientes'));
            
            return LST_Tipos;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public List<SelectOption> getListarOrigenes()
    {
        try{
            List<Selectoption> LST_Origenes = new List<Selectoption>();

            LST_Origenes.add(new Selectoption('Todos','Todos'));

            LST_Origenes.add(new Selectoption('Asistencia Agente', 'Asistencia Agente'));
            LST_Origenes.add(new Selectoption('Call Center','Call Center'));
            LST_Origenes.add(new Selectoption('CMF','CMF'));
            LST_Origenes.add(new Selectoption('Sucursal','Sucursal'));
            LST_Origenes.add(new Selectoption('Post Venta','Post Venta'));
            LST_Origenes.add(new Selectoption('Contacto Vida','Contacto Vida'));
            LST_Origenes.add(new Selectoption('Sernac','Sernac'));
            LST_Origenes.add(new Selectoption('DDA','DDA'));
            LST_Origenes.add(new Selectoption('Línea Directa Mercurio','Línea Directa Mercurio'));
            LST_Origenes.add(new Selectoption('Sernac Financiero','Sernac Financiero'));
            LST_Origenes.add(new Selectoption('Redes Sociales','Redes Sociales'));
            LST_Origenes.add(new Selectoption('Contacto SBS','Contacto SBS'));
            LST_Origenes.add(new Selectoption('Servicios Colectivos','Servicios Colectivos'));
            LST_Origenes.add(new Selectoption('Cobranzas Vida','Cobranzas Vida'));
            LST_Origenes.add(new Selectoption('Recepción Pagos','Recepción Pagos'));
            LST_Origenes.add(new Selectoption('Producción Individuales','Producción Individuales'));
            LST_Origenes.add(new Selectoption('Servicios BCI','Servicios BCI'));
            LST_Origenes.add(new Selectoption('Servicios Telefónica','Servicios Telefónica'));
            LST_Origenes.add(new Selectoption('Televenta','Televenta'));

            return LST_Origenes;            
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }

    }

    public String NombreUsuarioBackup(String id)
    {
         for(Usuario_Backup__c u : LST_UsuariosBackup){
             if (u.Id == id)
             {
                 return u.Name;
             }                
        }

        return '';
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
        
        this.FiltroVentas = false;

        User UsuarioSF = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

        //entas de individuales
        Profile perfil = [SELECT Id FROM Profile WHERE Name =  'Ejecutiva Producción Individuales Central'];

        if (UsuarioSF.ProfileId == perfil.Id)
        {
            this.FiltroVentas = true;
        }    
        //ventas de individuales

        system.debug('@@@@ USUARIO SF'+ UsuarioSF);
        system.debug('@@@@ USUARIO Id'+ UsuarioSF.Id);
        system.debug('@@@@ USUARIO Area'+ UsuarioSF.USUA_Area_UR__c);

        if (String.IsBlank(UsuarioSF.USUA_Area_UR__c))
        {
           return false;
        }

        this.AreaUsuarioLicencia = UsuarioSF.USUA_Area_UR__c;
        system.debug('@@@@  AreaUsuarioLicencia => ' + this.AreaUsuarioLicencia);
        
        this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
        FROM Usuario_Backup__c
        WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
        
        system.debug('@@@@  LST_UsuariosBackup[0 => ' + this.LST_UsuariosBackup[0].OwnerId);
        
        if (!Test.isRunningTest()){
            this.IdColaUR = this.LST_UsuariosBackup[0].OwnerId;           
            this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue'AND Id = :this.IdColaUR LIMIT 1].Name;            
        }
        else
        {
            Group gQuery = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 1];
            this.IdColaUR = gQuery.Id;        
            this.nombreColaUR = gQuery.Name;        
        }
        
        if (String.isBlank(this.UsuarioBackup))
        {
            this.UsuarioBackUp = '0';           
        }

        system.debug('@@@@ FiltroVentas  --> '+ this.FiltroVentas);
        system.debug('@@@@ AreaUsuarioLicencia  --> '+ this.AreaUsuarioLicencia);
        system.debug('@@@@ UsuarioBackUp  --> '+ this.UsuarioBackUp);

        return true;
    } 
 

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public PageReference IniciarBandejaCasos()
    {
        Boolean exito =  this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.CargaBandejaCasos();
             return null;
        }
        else {
            return ErrorAcceso();
        }
    }

    public PageReference ErrorAcceso()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ErrorAcceso');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }
    
    public void cargaParametrosPantallas()
    {
        OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();
        
        if(!Test.isRunningTest())
        {
            CnfBandeja = [SELECT Id, CNF_UR_BandejaCasos__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c =: this.IdColaUR  AND Usuario__c =: UserInfo.getUserId()];
        	system.debug('@@@@  CnfBandeja => ' + CnfBandeja);
        }
                    
        String jsonDisplay = '';

        if (String.isNotBlank(CnfBandeja.CNF_UR_BandejaCasos__c))
        {
            jsonDisplay = CnfBandeja.CNF_UR_BandejaCasos__c;
        }
        else
        {
            jsonDisplay = '{'+
            '"Filtro":'+ 
            '{'+ 
            '"FechaDerivacion" : true,'+
            '"HoraDerivacion" : true,'+ 
            '"EstadoCaso" : true,'+ 
            '"Negocio" : false,'+ 
            '"Categoria" : false,'+ 
            '"Solicitud" : false,'+ 
            '"NumeroCaso" : true,'+ 
            '"RUTCaso" : true,'+ 
            '"ClienteNoCliente" : true,'+ 
            '"Poliza" : true,'+ 
            '"Propuesta" : true,'+ 
            '"Origen" : true,'+ 
            '"SubEstadoACSEL" : false,'+ 
            '"FiltroBeneficios" : false'+ 
            '},'+ 
            '"Grilla" :'+ 
            '{'+ 
            '"EstadoCaso" : true,'+ 
            '"NumeroCaso" : true,'+
            '"Propuesta" : true,'+ 
            '"Poliza" : true,'+
            '"ClienteNoCliente" : true,'+
            '"RUTCaso" : true,'+
            '"Nombre" : true,'+
            '"Negocio" : false,'+
            '"Categoria" : true,'+
            '"Solicitud" : true,'+
            '"FechaCreacion" : true,'+
            '"FechaDerivacion" : true,'+
            '"FechaAsignacion" : true,'+
            '"FechaCierre" : true,'+
            '"Agente" : false,'+
            '"Ejecutivo" : true,'+
            '"Responsable" : true,'+
            '"Origen" : true,'+
            '"SubEstadoACSEL" : false,'+
            '"MontoRescate" : false'+
            '},'+
            '"Acciones":'+
            '{'+
            '"ResponsableMultiple" : true,'+
            '"CierreMultiple" : true'+
            '},'+
            '"Botonera":'+
            '{'+
            '"CasosUR" : true,'+
            '"CasosUREnRevision" : false,'+
            '"CasosURHistorico" : true'+ 
            '}'+
            '}';
        }
system.debug('@@@@ jsonDisplay => ' + jsonDisplay);       
        this.Pantalla = PAR_UR_BandejaCasos.parse(jsonDisplay);
system.debug('@@@@  this.Pantalla => ' + this.Pantalla);
    }

    public void CargaBandejaCasos(){
        try
        {
           this.cargaParametrosPantallas();

            this.SeleccionMultiple = false;

            if(this.Pantalla.Acciones.CierreMultiple == true || this.Pantalla.Acciones.ResponsableMultiple == true)
            {
                this.SeleccionMultiple = true;
            }

            this.FiltroCaso = new Case();
            this.FiltroCaso.RecordTypeId = IdTipoRegistro;

            this.SOQL_IDs = '';         

            if (this.AreaUsuarioLicencia == 'Producción Individuales')
            {
                this.FiltroCaso.Negocio__c = 'Seguros Individuales';
            }
            else if (this.AreaUsuarioLicencia == 'Producción RRVV')
            {
                this.FiltroCaso.Negocio__c = 'RRVV';
            }             
      
            this.FechaInicioDerivacion = Date.today().addDays(-183);//6 meses aproximadamente
            this.FechaTerminoDerivacion = Date.today();

            this.HoraInicioDerivacion = Time.newInstance(0, 0, 0, 0);
            this.HoraTerminoDerivacion = Time.newInstance(23, 59, 59, 999);

            this.Estado = 'Todos';
            this.Origen ='Todos';
            this.EstadoACSEL = 'Todos';

            String query = this.queryCasosUR('');

            system.debug('@@@@  QUERY CASOS LST_CasosUR => ' + query);

            List<Case> casosUR =  new List<Case>();
            
            if (String.isNotBlank(query))
            {
                casosUR =  Database.query(query);
            }

            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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

            this.CurrentPage = 'CASOS_UR';

            this.Categoria_Beneficios = '';

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }            
    }

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public void IniciarBandejaCasos_EnRevision(){
        try
        {
            this.CargaUsuario();

            this.cargaParametrosPantallas();


            this.FiltroCaso = new Case();
            this.FiltroCaso.RecordTypeId = IdTipoRegistro;

            if (this.AreaUsuarioLicencia == 'Producción Individuales')
            {
                this.FiltroCaso.Negocio__c = 'Seguros Individuales';
            }
            else if (this.AreaUsuarioLicencia == 'Producción RRVV')
            {
                this.FiltroCaso.Negocio__c = 'RRVV';
            }
            
            this.SOQL_IDs = '';

            this.LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
                                  FROM Usuario_Backup__c
                                  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuarioLicencia];

            if (this.UsuarioBackup == '1')
            {
                this.UsuarioBackup = '0';
            }

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
     
            this.FechaInicioDerivacion = Date.today().addDays(-183);//6 meses aproximadamente
            this.FechaTerminoDerivacion = Date.today();

            this.Estado = 'Todos';
            this.Origen ='Todos';

            String query = this.queryCasosEnRevision('');

            system.debug('@@@@  QUERY CASOS LST_CasosUR => ' + query);

            List<Case> casosUR =  new List<Case>();

            if (!Test.isRunningTest())
            {
            	if (String.isNotBlank(query))
                {
                    casosUR = Database.query(query);
                }    
            }
            
            
            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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

           this.CurrentPage = 'CASOS_UR_ENREVISION';

        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

    public void IniciarBandejaCasos_Historico(){
        try
        {
            this.CargaUsuario();

            this.cargaParametrosPantallas();

            this.FiltroCaso = new Case();
            this.FiltroCaso.RecordTypeId = IdTipoRegistro;
            
            if (this.AreaUsuarioLicencia == 'Producción Individuales')
            {
                this.FiltroCaso.Negocio__c = 'Seguros Individuales';
            }
            else if (this.AreaUsuarioLicencia == 'Producción RRVV')
            {
                this.FiltroCaso.Negocio__c = 'RRVV';
            }
            
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
            
            this.FechaInicioDerivacion = Date.today().addDays(-183);//6 meses aproximadamente
            this.FechaTerminoDerivacion = Date.today();

            this.Estado = 'Todos';
            this.Origen ='Todos';

            String query = this.queryCasosURHistorico('');

            system.debug('@@@@  QUERY CASOS LST_CasosUR => ' + query);

            List<Case> casosUR =  new List<Case>();
            
            if (String.isNotBlank(query))
            {
                casosUR = Database.query(query);
            }

            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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

           this.CurrentPage = 'CASOS_UR_HISTORICO';

        }catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }           
    }

     /*Realiza busqueda segun usuario responsable seleccionado*/         
    public Pagereference seleccionResponsableUR(){
        try{
            
            String query = '';

            if (this.CurrentPage == 'CASOS_UR')
            {
                query = this.queryCasosUR('');
            }
            else if (this.CurrentPage == 'CASOS_UR_ENREVISION')
            {
                query = this.queryCasosEnRevision('');
            }
            else if (this.CurrentPage == 'CASOS_UR_HISTORICO')
            {
                query = this.queryCasosURHistorico('');
            }

            List<Case> casosUR =  new List<Case>();
            
            if (String.isNotBlank(query))
            {
                casosUR =  Database.query(query);
            }
            
            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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
    
     /*Realiza busqueda segun usuario responsable seleccionado*/         
    public void busquedaCasosUR(){
          system.debug('@@@@  ERROR');
          system.debug('@@@@  FechaInicio => ' + FechaInicioDerivacion);
            system.debug('@@@@  FechaTermino => ' + FechaTerminoDerivacion);
          
        try{

            system.debug('@@@@  FechaInicio => ' + FechaInicioDerivacion);
            system.debug('@@@@  FechaTermino => ' + FechaTerminoDerivacion);

            List<Case> casosUR = new List<Case>();

            String query = this.queryCasosUR('');
            system.debug('@@@@  QUERY CASOS LST_CasosUR => ' + query); 
            
            if (String.isNotBlank(query))
            {
                casosUR =  Database.query(query);
            }
            //List<Case> casosUR = Database.query(query);
            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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

       // return null;        
    }

    public Pagereference limpiaBusquedaCasosUR()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_Casos?idResponsable='+this.UsuarioBackUp);
       page.setRedirect(true);
       return page;
    }

      /*Realiza busqueda segun usuario responsable seleccionado*/         
    public Pagereference busquedaCasosUR_EnRevision(){
        try{
	
            String query = this.queryCasosEnRevision('');
            system.debug('@@@@  QUERY CASOS LST_CasosUR EnRevision => ' + query);

            List<Case> casosUR_Revision =  new List<Case>();

            if (String.isNotBlank(query))
            {
                casosUR_Revision = Database.query(query);
            }
            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR_Revision.size());

            totalRecs = casosUR_Revision.Size();

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

    public Pagereference limpiaBusquedaCasosUR_EnRevision()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_CasosEnRevision?idResponsable='+this.UsuarioBackUp);
       page.setRedirect(true);
       return page;
    }


     public Pagereference busquedaCasosUR_Historico(){
        try{
	
            String query = this.queryCasosURHistorico('');
            system.debug('@@@@  QUERY CASOS LST_CasosUR => ' + query);

            List<Case> casosUR =  new List<Case>();
            
            if (String.isNotBlank(query))
            {
                casosUR = Database.query(query);
            }

            system.debug('@@@@  CASOS LST_CasosUR => ' + casosUR.size());

            totalRecs = casosUR.Size();

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

    public Pagereference limpiaBusquedaCasosUR_Historico()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_CasosHistorico?idResponsable='+this.UsuarioBackUp);
       page.setRedirect(true);
       return page;
    }

    /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
    public String queryCasosUR(String qlimit)
    {
        try{

            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c, Numero_Propuesta__c, '+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, Agente__c, Sucursal__c, Supervisor__c, RVentas__c, '+
            ' Rut_Agente__c, Mail_Agente__c, Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Fecha_Derivacion_UR__c, OwnerId__c, '+
            ' Monto_Rescate__c, Sub_Estado_Acsel__c FROM Case ';

            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioBackUp);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);

            if(this.UsuarioBackUp == null)
            {
                this.UsuarioBackUp = '0';
            }

            String qwhere = '';

            if(this.UsuarioBackUp != null && this.UsuarioBackUp != '0' && this.UsuarioBackUp != '1'){
                qwhere = ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = \'' + this.UsuarioBackUp + '\' AND IsClosed = false';
            }else
            { 
                if (this.UsuarioBackUp == '1')
                {
                    qwhere = ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = NULL AND IsClosed = false';              
                }
                else if (this.UsuarioBackUp == '0')
                {
                    qwhere =  ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'';
                }
            }

            String qfechaDerivacion = '';

            Boolean errorFechaDerivacion = false;

            system.debug('@@@@  Hora Derivacion INI --> ' + this.HoraInicioDerivacion);
            system.debug('@@@@  Hora Derivacion TER --> ' + this.HoraTerminoDerivacion);

            system.debug('@@@@  this.Pantalla.Filtro.FechaDerivacion --> ' + this.Pantalla.Filtro.FechaDerivacion);
                        system.debug('@@@@  this.Pantalla.Filtro.HoraDerivacion --> ' + this.Pantalla.Filtro.HoraDerivacion);
            if (this.Pantalla.Filtro.FechaDerivacion == true && this.Pantalla.Filtro.HoraDerivacion == false)
            {
                if (this.FechaInicioDerivacion == null || this.FechaTerminoDerivacion == null)
                {
                    errorFechaDerivacion = true;
                }

                if (errorFechaDerivacion == false)
                {
                    DateTime dateIni = DateTime.newInstance(this.FechaInicioDerivacion.year(), this.FechaInicioDerivacion.month(), this.FechaInicioDerivacion.day(), 0, 0, 0);
                    String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    DateTime dateTer = DateTime.newInstance(this.FechaTerminoDerivacion.year(), this.FechaTerminoDerivacion.month(), this.FechaTerminoDerivacion.day(), 23,59, 59);
                    String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    qfechaDerivacion = ' AND Fecha_Derivacion_UR__c >= '+ format_DateIni +' AND Fecha_Derivacion_UR__c <=' +format_DateTer;     
                }
            }
            else if (this.Pantalla.Filtro.FechaDerivacion == true && this.Pantalla.Filtro.HoraDerivacion == true)
            {
                if (this.FechaInicioDerivacion == null || this.FechaTerminoDerivacion == null || this.HoraInicioDerivacion == null || this.HoraTerminoDerivacion == null)
                {
                    errorFechaDerivacion = true;
                }
     
                if (errorFechaDerivacion == false)
                {
                    DateTime dateIni = DateTime.newInstance(this.FechaInicioDerivacion.year(), this.FechaInicioDerivacion.month(), this.FechaInicioDerivacion.day(), this.HoraInicioDerivacion.hour(), this.HoraInicioDerivacion.minute(), 0);
                    String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    DateTime dateTer = DateTime.newInstance(this.FechaTerminoDerivacion.year(), this.FechaTerminoDerivacion.month(), this.FechaTerminoDerivacion.day(), this.HoraTerminoDerivacion.hour(), this.HoraTerminoDerivacion.minute(), 59);
                    String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    qfechaDerivacion = ' AND Fecha_Derivacion_UR__c >= '+ format_DateIni +' AND Fecha_Derivacion_UR__c <=' +format_DateTer;     
                }
            } 
            else if (this.Pantalla.Filtro.FechaDerivacion == false && this.Pantalla.Filtro.HoraDerivacion == true)
            {
                if (this.HoraInicioDerivacion == null || this.HoraTerminoDerivacion == null)
                {
                    errorFechaDerivacion = true;
                }

                if (errorFechaDerivacion == false)
                {

                    DateTime dateIni = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 0, 0, 0);
                    String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    DateTime dateTer = DateTime.newInstance(Date.Today().year(), Date.Today().month(), Date.Today().day(), 23,59, 59);
                    String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                    qfechaDerivacion = ' AND Fecha_Derivacion_UR__c >= '+ format_DateIni +' AND Fecha_Derivacion_UR__c <=' +format_DateTer;     
                }
            }

            if (errorFechaDerivacion == true)
            {
                return '';
            }

            
            String qestado = '';

            if (this.Pantalla.Filtro.EstadoCaso == true)
            {
                if (this.Estado == 'Todos')
                {
                    qestado = ' AND (Status = \'Back Office\' OR Status = \'En Proceso\' ) ';
                } 
                else 
                {
                     qestado = ' AND (Status = \''+ this.Estado +'\' ) ';
                }
            }

            String qtipo = '';

            if (this.Pantalla.Filtro.ClienteNoCliente == true)
            {
                if (this.Tipo == 'Todos')
                {
                    qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
                } 
                else if (this.Tipo == 'Clientes')
                {
                    qtipo = ' AND (EsNoCliente__c = false) ';
                }
                else if (this.Tipo == 'No Clientes')
                {
                    qtipo = ' AND (EsNoCliente__c = true) ';
                }
            }

            String qestadoACSEL = '';

            if (this.Pantalla.Filtro.SubEstadoACSEL == true)
            {
                if (this.EstadoACSEL != 'Todos')
                {
                    qestadoACSEL = ' AND (Sub_Estado_Acsel__c = \''+this.EstadoACSEL+'\') ';
                }
            }

            String qnumeroCaso = '';

            if (this.Pantalla.Filtro.NumeroCaso == true)
            {
                if (String.isNotBlank(this.NumeroCaso) == true)
                {
                    qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
                }
            }
            
            String qrut = '';

            if (this.Pantalla.Filtro.RUTCaso == true)
            {
                if (String.isNotBlank(this.RUT) == true)
                {
                    qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
                }
            }   
            
            String qnumeroPoliza = '';

            if (this.Pantalla.Filtro.RUTCaso == true)
            {
                if (String.isNotBlank(this.Poliza) == true)
                {
                    qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
                }
            } 

            String qnumeroPropuesta = '';
            
            if (this.Pantalla.Filtro.Propuesta == true)
            {
                if (String.isNotBlank(this.Propuesta) == true)
                {
                    qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
                }
            }  

            String qorigen = '';

            if (this.Pantalla.Filtro.Origen == true)
            {
                if (this.Origen != 'Todos')
                {
                    qorigen = ' AND (Canal__c = \'' + this.Origen + '\' ) ';
                } 
            }  
                
            String qnegocio = '';

            if (this.Pantalla.Filtro.Negocio == true)
            {
                if (String.isNotBlank(this.FiltroCaso.Negocio__c))
                {
                    qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
                }
            }  

            String qcategoria = '';

            if (this.Pantalla.Filtro.Categoria == true)
            {
                if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
                {
                    qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
                }
            }  
  

            String qsolicitud = '';

            if (this.Pantalla.Filtro.Solicitud == true)
            {
                if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
                {
                    qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
                }
            }  
  
            String qVenta = '';

            if (this.RequerimientoVentas == true)
            {
                qVenta = ' AND RVentas__c = true ';
            }
               
            system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
            system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
            system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);

            String qorden = '';

            if (this.nombreColaUR == 'UR - Producción Individuales')
            {
                qorden = ' ORDER BY CreatedDate ASC';
            }
            else if (this.nombreColaUR == 'UR - Beneficios')
            {
                qorden = ' ORDER BY CreatedDate DESC';//fecha de creacion descendiente
            }
            else
            {
                qorden = ' ORDER BY Fecha_Asignacion_UR__c DESC';
            }  
               
            String  qbeneficios = '';
            if (this.Pantalla.Filtro.FiltroBeneficios == true && String.isnotBlank(this.Categoria_Beneficios))
            {
                if (this.Categoria_Beneficios == 'Rescates')
                {
                    qbeneficios = ' AND Detalle_Solicitud__c IN (\'ED - Solicitud de Rescate Total\',\'ED - Solicitud de Rescate Parcial\',\'ED - Solicitud de Rescate Patrimonial Parcial\',\'ED - Solicitud de Rescate Patrimonial Total\') ';
                }
                else if (this.Categoria_Beneficios == 'Siniestros')
                {
                    qbeneficios = ' AND Detalle_Solicitud__c IN (\'Siniestro Catastrófico\',\'Siniestro Individuales\',\'Solicitud préstamo\',\'Solicitud rescate valores garantizados\','+
                    '\'Desistimiento de traspaso\',\'Siniestro Tradicional Vida COL\',\'Denuncio de siniestro\',\'Siniestro IQ\',\'Siniestros PF\','+
                    '\'Solicitud rescate valores garantizados\',\'Vencimientos y Saldamientos\') ';
                }
                //this.FiltroCaso.Detalle_Solicitud__c = '';
                //qsolicitud = '';
                //qbeneficios = '';
            }

            String qfull = query + qwhere + qestado + qtipo + qfechaDerivacion + qestadoACSEL+  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qorigen +  + qnegocio + qcategoria + qsolicitud + qbeneficios +  qVenta +  qorden + qlimit;

            system.debug('@@@@ query casos ur --> '+ qfull);
            return qfull; 

        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            system.debug('@@@@ Exception Line => ' + ex.getLineNumber());
            system.debug('@@@@ Exception Message => ' + ex.getMessage());
        	return '';
        }
    }

    public List<SelectOption> getListadoCategoriasBeneficios()
    {
        List<SelectOption> cat_beneficios  = new List<SelectOption>();
        cat_beneficios.add(new SelectOption('', '--Ninguno--'));
        cat_beneficios.add(new SelectOption('Rescates', 'Rescates'));
        cat_beneficios.add(new SelectOption('Siniestros', 'Siniestros'));

        return cat_beneficios;
    }


    public static String GetTime(Time value)
    {
        String outTime = '';

        String hour = '';

        if (value.hour() < 10)
        {
            hour = '0'  + String.valueOf(value.hour());
        }
        else {
            hour = String.valueOf(value.hour());
        }
        
        String minute = '';
 
        if (value.minute() < 10)
        {
            minute = '0'  + String.valueOf(value.minute());
        }
        else {
            minute = String.valueOf(value.minute());
        }

        String second = '';  

        if (value.second() < 10)
        {
            second = '0'  + String.valueOf(value.second());
        }
        else {
            second = String.valueOf(value.second());
        }

        outTime  = 'T'  + hour + ':' + minute + ':' + second + 'Z';

        return outTime;
    }


    public String queryCasosEnRevision(String qlimit)
    {
        try
        {
            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, Id_Responsable_UR__c, '+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c,'+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Numero_Propuesta__c, Agente__c, Fecha_Derivacion_UR__c, OwnerId__c, '+
            ' Rut_Agente__c, Mail_Agente__c, Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Monto_Rescate__c, Sub_Estado_Acsel__c '+
            'FROM Case WHERE Status = \'En Revisión\' AND RecordTypeId =  \''+ this.IdTipoRegistro + '\' ';
             
            if(this.UsuarioBackUp == null)
            {
                this.UsuarioBackUp = '0';                
            }

            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioBackUp);
            
            String qubak = '';
            
            if(this.UsuarioBackUp != null && this.UsuarioBackUp != '0' && this.UsuarioBackUp != '1'){
                qubak = ' AND Id_Responsable_UR__c = \'' + this.UsuarioBackUp + '\' AND IsClosed = false ';
            }else
            { 
                if (this.UsuarioBackUp == '0')
                {
                    List<Usuario_Backup__c> usbackup = [SELECT Id FROM Usuario_Backup__c WHERE OwnerId =:this.IdColaUR];
            
                    for (Usuario_Backup__c ubk : usbackup) {
                        String id_in_quotes = '\''+ubk.Id+'\'';

                        if (this.SOQL_IDs != '') 
                        {
                            this.SOQL_IDs +=',';                      
                        }  

                        this.SOQL_IDs += id_in_quotes;
                    }

                    qubak = ' AND Id_Responsable_UR__c  IN ('+this.SOQL_IDs+') AND IsClosed = false ';                                 
                }
                else if (this.UsuarioBackUp == '1')
                {
                    qubak = '';
                }                
            }

            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }


            Boolean error = false;

            if (this.FechaInicioDerivacion == null || this.FechaTerminoDerivacion == null)
            {
                error = true;
            }
            if (!error)
            {
                String qfecha = ' AND Fecha_Derivacion_UR__c >= '+ String.valueOf(FechaInicioDerivacion)+'T00:00:00Z' +' AND Fecha_Derivacion_UR__c <=' + String.valueOf(FechaTerminoDerivacion.addDays(1))+'T23:59:59Z';    

                String qnumeroCaso = '';
                
                if (String.isNotBlank(this.NumeroCaso) == true)
                {
                    qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
                }
            
                String qrut = '';
                if (String.isNotBlank(this.RUT) == true)
                {
                    qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
                }

                String qnumeroPoliza = '';

                if (String.isNotBlank(this.Poliza) == true)
                {
                    qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
                }

                String qnumeroPropuesta = '';

                if (String.isNotBlank(this.Propuesta) == true)
                {
                    qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
                }

                String qorigen = '';

                if (this.Origen != 'Todos')
                {
                    qorigen = ' AND (Canal__c = \'' + this.Origen + '\' ) ';
                } 

                String qnegocio = '';
                
                if (String.isNotBlank(this.FiltroCaso.Negocio__c))
                {
                    qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
                }

                String qcategoria = '';
                if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
                {
                    qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
                }

                String qsolicitud = '';

                if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
                {
                    qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
                }

                String qVenta = '';

                if (this.RequerimientoVentas == true)
                {
                    qVenta = ' AND RVentas__c = true ';
                }

                system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
                system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
                system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);

                String qorden = '';

                if (this.nombreColaUR == 'UR - Producción Individuales')
                {
                    qorden = ' ORDER BY CreatedDate ASC';
                }
                else
                {
                    qorden = ' ORDER BY Fecha_Asignacion_UR__c DESC';
                }          

                return query + qubak  + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qorigen + qnegocio + qcategoria  + qsolicitud + qventa +  qorden + qlimit;
            }

            return '';
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            system.debug('@@@@ Exception Line => ' + ex.getLineNumber());
            system.debug('@@@@ Exception Message => ' + ex.getMessage());

        	return '';
        }
    }

    public String queryCasosURHistorico(String qlimit)
    {
        try{

            String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, Fecha_Derivacion_UR__c,'+
            'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
            'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c,'+
            'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, Numero_Propuesta__c, Agente__c, OwnerId__c, '+
            ' Rut_Agente__c, Mail_Agente__c, Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c,  Monto_Rescate__c, Sub_Estado_Acsel__c  '+
            'FROM Case';

            system.debug('@@@@ UsuarioSeleccionado => ' + this.UsuarioBackUp);
            system.debug('@@@@ IdColaUR => ' + this.IdColaUR);

            if(this.UsuarioBackUp == null)
            {
                this.UsuarioBackUp = '0';
            }

            String qwhere = '';

            String qestado = '';

            if (this.Estado == 'Todos')
            {                
                qestado = ' AND (Status = \'Cerrado\' OR Status = \'Rechazado\' ) ';
            } 
            else 
            {
                 qestado = ' AND (Status = \''+ this.Estado +'\' ) ';
            }

            String qtipo = '';

            if (this.Tipo == 'Todos')
            {
                qtipo = '';//' AND (Status = \'Nuevo\' OR Status = \'En Proceso\' OR Status = \'En Revisión\' ) ';
            } 
            else if (this.Tipo == 'Clientes')
            {
                 qtipo = ' AND (EsNoCliente__c = false) ';
            }
            else if (this.Tipo == 'No Clientes')
            {
                  qtipo = ' AND (EsNoCliente__c = true) ';
            }

            Boolean error = false;

            if (this.FechaInicioDerivacion == null || this.FechaTerminoDerivacion == null)
            {
                error = true;
            }
            if (!error)
            {
                String qfecha = ' AND Fecha_Derivacion_UR__c >= '+ String.valueOf(FechaInicioDerivacion)+'T00:00:00Z' +' AND Fecha_Derivacion_UR__c <=' + String.valueOf(FechaTerminoDerivacion.addDays(1))+'T23:59:59Z';    

                if(this.UsuarioBackUp != null && this.UsuarioBackUp != '0' && this.UsuarioBackUp != '1'){
                    qwhere = ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = \'' + this.UsuarioBackUp + '\'';
                }else
                { 
                    if (this.UsuarioBackUp == '1')
                    {
                        qwhere = ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'' + ' AND CASO_Responsable_UR__c = NULL';              
                    }
                    else if (this.UsuarioBackUp == '0')
                    {
                        qwhere =  ' WHERE  RecordTypeId =  \''+ this.IdTipoRegistro + '\' AND OwnerId = \''+ this.IdColaUR + '\'';
                    }
                }

                String qnumeroCaso = '';
                
                if (String.isNotBlank(this.NumeroCaso) == true)
                {
                    qnumeroCaso = ' AND CaseNumber = \''+ this.NumeroCaso.trim() +'\'';
                }
            
                String qrut = '';
                if (String.isNotBlank(this.RUT) == true)
                {
                    qrut = ' AND (RUT_no_Cliente__c = \''+ this.RUT.trim() +'\' OR  RUT__c = \''+ this.RUT.trim() +'\' )';
                }


                String qnumeroPoliza = '';

                if (String.isNotBlank(this.Poliza) == true)
                {
                    qnumeroPoliza = ' AND CASO_POLIZA_ASOC__C = \''+ this.Poliza.trim() +'\'';
                }

                String qnumeroPropuesta = '';

                if (String.isNotBlank(this.Propuesta) == true)
                {
                    qnumeroPropuesta = ' AND Numero_Propuesta__c = \''+ this.Propuesta.trim() +'\'';
                }

                String qnegocio = '';
                
                if (String.isNotBlank(this.FiltroCaso.Negocio__c))
                {
                    qnegocio = ' AND Negocio__c = \''+ this.FiltroCaso.Negocio__c +'\'';
                }

                String qcategoria = '';
                if (String.isNotBlank(this.FiltroCaso.CASO_Categoria__c))
                {
                    qcategoria = ' AND CASO_Categoria__c = \''+ this.FiltroCaso.CASO_Categoria__c +'\'';
                }

                String qsolicitud = '';

                if (String.isNotBlank(this.FiltroCaso.Detalle_Solicitud__c))
                {
                    qsolicitud = ' AND Detalle_Solicitud__c = \''+ this.FiltroCaso.Detalle_Solicitud__c +'\'';
                }

                String qVenta = '';

                if (this.RequerimientoVentas == true)
                {
                    qVenta = ' AND RVentas__c = true ';
                }

                system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
                system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
                system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);

                String qorigen = '';

                if (this.Origen != 'Todos')
                {
                    qorigen = ' AND (Canal__c = \'' + this.Origen + '\' ) ';
                }

                String qorden = '';

                if (this.nombreColaUR == 'UR - Producción Individuales')
                {
                    qorden = ' ORDER BY CreatedDate ASC';
                }
                else
                {
                    qorden = ' ORDER BY Fecha_Asignacion_UR__c DESC';
                }          

                return query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza +qnumeroPropuesta + qrut + qorigen + qnegocio + qcategoria + qsolicitud + qVenta + qorden + qlimit;

            }

            return '';

            
        }catch(Exception ex){
            system.debug('@@@@ Exception Line => ' + ex.getLineNumber());
            system.debug('@@@@ Exception Message => ' + ex.getMessage());

        	
            ApexPages.addMessages(ex);
        	return '';
        }
    }

    public List<Case> getCasosUR()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryCasosUR(queryLimit);

        system.debug('@@@@ query --> '+ query);

        List<Case> casos = new List<Case>();
        
        if (!Test.isRunningTest())
        {
            if (String.isNotBlank(query))
            {
                casos =  Database.query(query);
            }
        }
        
        query = this.queryCasosUR('');
        
        List<Case> casosCount = new List<Case>();
        
        if (!Test.isRunningTest())
        {
            if (String.isNotBlank(query))
            {
                casosCount =  Database.query(query);
            }
        }
               
        totalRecs = casosCount.Size();
        
        Integer range =  totalrecs - Math.mod(totalRecs, LimitSize);
        this.TotalPage = totalRecs / LimitSize;

        if(totalrecs > range)
        {
            this.TotalPage++;
        }       
        
        for (Case caso : casos) {
            if (caso.OwnerId__c != null && caso.OwnerId__c != '')
            {
                User u = [SELECT Name FROM User WHERE Id =: caso.OwnerId__c];
                caso.OwnerId__c = u.Name;
            }
        }
        return casos;
    }

     public List<Case> getCasosUR_EnRevision()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryCasosEnRevision(queryLimit);

        system.debug('@@@@ query --> '+ query);

        List<Case> casos =  new List<Case>();

        if (String.isNotBlank(query))
        {
            casos = Database.query(query);
        }

        for (Case caso : casos) {
            if (caso.OwnerId__c != null && caso.OwnerId__c != '')
            {
                User u = [SELECT Name FROM User WHERE Id =: caso.OwnerId__c];
                caso.OwnerId__c = u.Name;
            }
        }

        return casos;
    }

    public List<Case> getCasosUR_Historico()
    {
        String queryLimit = ' LIMIT '+ this.LimitSize+' OFFSET '+ this.OffsetSize;

        String query = this.queryCasosURHistorico(queryLimit);

        system.debug('@@@@ query --> '+ query);

        List<Case> casos = new List<Case>();
    	
        if (!Test.isRunningTest())
        {
             if (String.isNotBlank(query))
             {
                 casos =  Database.query(query);   
             }
        }

        for (Case caso : casos) {
            if (caso.OwnerId__c != null && caso.OwnerId__c != '')
            {
                User u = [SELECT Name FROM User WHERE Id =: caso.OwnerId__c];
                caso.OwnerId__c = u.Name;
            }
        }
   
        return casos;
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

    public Pagereference BandejaCasosUR()
    {
        try
        {
            //PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Casos?Area='+this.AreaUsuarioLicencia+'&Usuario='+this.UsuarioNativo+'&idResponsableUR=' + this.UsuarioBackUp);
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Casos?idResponsable=' + this.UsuarioBackUp);
            
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaCasosUR -->'+ ex);
        	return null;
        }
    }

    public Pagereference BandejaCasosUR_EnRevision()
    {
        try{
            //PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_CasosEnRevision?Area='+this.AreaUsuarioLicencia+'&Usuario='+this.UsuarioNativo+'&idResponsableUR=' + this.UsuarioBackUp);
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_CasosEnRevision?idResponsable=' + this.UsuarioBackUp);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK  BandejaCasosUR_EnRevision -->'+ ex);
        	return null;
        }
    }

    public Pagereference BandejaCasosUR_Historico()
    {
        try{
         //   PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_CasosHistorico?Area='+this.AreaUsuarioLicencia+'&Usuario='+this.UsuarioNativo+'&idResponsableUR=' + this.UsuarioBackUp);
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_CasosHistorico?idResponsable=' + this.UsuarioBackUp);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaCasosUR_Historico -->'+ ex);
        	return null;
        }
    }

    public PageReference verCasoUR(){
        try
        {
            String ID = apexpages.currentpage().getparameters().get('Id');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Caso?Id='+ID +'&idResponsable=' + this.UsuarioBackUp+'&procedencia='+this.CurrentPage);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK verCasoUR -->'+ ex);
        	return null;
        }
    }

    public PageReference ToTaskList()
    {            
        //PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Caso?Id='+ID +'Area='+this.AreaUsuarioLicencia+'&idResponsable=' + this.UsuarioBackUp+'&procedencia='+this.CurrentPage+'&FVentas='+this.FiltroVentas);
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_TareasUR?idResponsable=' + this.UsuarioBackUp+'&historial=Y');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public PageReference ToColaboraciones()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ColaboracionesReclamo');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public void SeleccionResponsable()
    {

    } 
}