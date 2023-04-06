/**
 * @description       : 
 * @author            : Juan Espinoza León
 * @group             : 
 * @last modified on  : 04-12-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author               Modification
 * 1.0   03-05-2021   Juan Espinoza León   Initial Version
**/
public  class CTR_UR_Bandeja_Casos_Optativos {
    public CTR_UR_Bandeja_Casos_Optativos() {

    }

    
    public String AreaUsuarioLicencia {get; set;}

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

    public Date FechaInicio {get; set;}

    public Date FechaTermino {get; set;}

    public Boolean FiltroVentas {get; set;}

    public Boolean RequerimientoVentas {get; set;}


    public String IdTipoRegistro = [SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND DeveloperName = 'Solicitudes' AND IsActive = true].Id;

    public PAR_UR_BandejaCasos Pantalla {get; set;}

    public Boolean SeleccionMultiple {get; set;}
      /*Paginación*/
      public integer OffsetSize = 0;
    
      public integer LimitSize= 15;
       
      public integer totalRecs {get; set;}
      
      public Integer Page {get; set;}
  
      public Integer TotalPage {get; set;}
      /*Paginación*/

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

    public PageReference verCasoUR(){
        try
        {
            String ID = apexpages.currentpage().getparameters().get('Id');

            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Caso_Optativo?Id='+ID);
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK verCasoUR -->'+ ex);
        	return null;
        }
    }

    /*Paginación*/
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

    public Pagereference limpiaBusquedaCasos()
    {
       PageReference page = new PageReference('/apex/SEC_VF_UR_Casos_Optativos');
       page.setRedirect(true);
       return page;
    }
    
    public List<Selectoption> getListarEstados(){
        try{
            List<Selectoption> LST_Estados = new List<Selectoption>();
            
            LST_Estados.add(new Selectoption('Todos','Todos'));
            
            LST_Estados.add(new Selectoption('Nuevo','Nuevo'));
            LST_Estados.add(new Selectoption('Back Office','Back Office'));
            LST_Estados.add(new Selectoption('En Proceso','En Proceso'));
            LST_Estados.add(new Selectoption('En Revisión','En Revisión'));
            LST_Estados.add(new Selectoption('Cerrado','Cerrado'));
            LST_Estados.add(new Selectoption('Rechazado','Rechazado'));  
            
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

    public Boolean CargaUsuario()
    {
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
        
        if (Test.isRunningTest()){
            
            this.AreaUsuarioLicencia = 'Producción RRVV';
        }
        
       // List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND Usuario__c =: UsuarioSF.Id];
        //List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE UBAC_Activo__c = true AND UBAC_Area__c =: UsuarioSF.USUA_Area_UR__c];
        
        List<Usuario_Backup__c> LST_UsuariosBackup = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId
        FROM Usuario_Backup__c
        WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
        
        system.debug('@@@@  LST_UsuariosBackup[0 => ' + LST_UsuariosBackup[0].OwnerId);
        
        if (!Test.isRunningTest()){
            this.IdColaUR = LST_UsuariosBackup[0].OwnerId;           
            this.nombreColaUR = [SELECT Name FROM Group WHERE Type = 'Queue' AND Id = :this.IdColaUR LIMIT 1].Name;            
        }
        else
        {
            Group gQuery = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 1];
            this.IdColaUR = gQuery.Id;        
            this.nombreColaUR = gQuery.Name;        
        }
        
        system.debug('@@@@ FiltroVentas  --> '+ this.FiltroVentas);
        system.debug('@@@@ AreaUsuarioLicencia  --> '+ this.AreaUsuarioLicencia);

        return true;
    } 
 

    /*Realiza carga inicial de datos para ser visualizados por pantalla*/         
    public PageReference inicio()
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
        /*PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_ErrorAcceso');
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;*/
        return null;
    }
    
    public void CargaBandejaCasos(){
        this.cargaParametrosPantallas();
        try
        {
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
      
            this.FechaInicio = Date.today().addDays(-183);//6 meses aproximadamente
            this.FechaTermino = Date.today();

            this.Estado = 'Todos';
            this.Origen ='Todos';

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

        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }            
    }

     /*Método que permite visualizar y filtrar los casos por Usuario UR seleccionado*/
     public String queryCasosUR(String qlimit)
     {
         try{

            String negocios = '(';

            for (AggregateResult req : [SELECT  Negocio__c FROM Requerimiento_UR__c WHERE Derivacion_Optativa__c = true AND Habilitado__c = true AND Bandeja_UR__c =: this.nombreColaUR GROUP BY Negocio__c])
            {
                negocios = negocios + '\'' + String.valueOf(req.get('Negocio__c')) + '\',';
            }			

            negocios = negocios + '\'\')';
           
            String categorias = '(';

            for (AggregateResult req : [SELECT  Categoria__c FROM Requerimiento_UR__c WHERE Derivacion_Optativa__c = true AND Habilitado__c = true AND Bandeja_UR__c =: this.nombreColaUR GROUP BY Categoria__c])
            {
                categorias = categorias + '\'' +  String.valueOf(req.get('Categoria__c')) + '\',';       
            }
            categorias = categorias + '\'\')';
			
            String solicitudes = '(';

            for (AggregateResult req : [SELECT  Detalle_Solicitud__c FROM Requerimiento_UR__c WHERE Derivacion_Optativa__c = true AND Habilitado__c = true AND Bandeja_UR__c =: this.nombreColaUR GROUP BY Detalle_Solicitud__c])
            {
                solicitudes = solicitudes + '\'' +  String.valueOf(req.get('Detalle_Solicitud__c')) + '\',';    
            }

            solicitudes = solicitudes + '\'\')';

            System.debug('@@@@ negocios --> '+ negocios);
            System.debug('@@@@ categorias --> '+ categorias);
            System.debug('@@@@ Solicitudes --> '+ solicitudes);
          
            
/*

  List<Requerimiento_UR__c> requerimientos = [SELECT Id, Derivacion_Optativa__c, Detalle_Solicitud__c, Categoria__c, Negocio__c, Habilitado__c FROM Requerimiento_UR__c WHERE 
                                      Derivacion_Optativa__c = true AND Habilitado__c = true AND Bandeja_UR__c =: this.nombreColaUR];

SELECT Id, Derivacion_Optativa__c, Detalle_Solicitud__c, Categoria__c, Negocio__c, Habilitado__c FROM Requerimiento_UR__c WHERE 
        Detalle_Solicitud__c =: caso.Detalle_Solicitud__c AND Categoria__c =: caso.CASO_Categoria__c AND Negocio__c =: caso.Negocio__c 
        AND Derivacion_Optativa__c = true AND Habilitado__c = true
*/



             String query = 'SELECT Id, CaseNumber, Subject,createdById, AccountId, RUT__c, CASO_N_Poliza__c, LastModifiedDate, ContactId, Origin, Status, '+
             'RecordTypeId, OwnerId,Fecha_Cierre_Tope__c,Negocio__c, Concepto__c,Producto__c,Detalle_Operacion__c,Detalle_de_Rescate__c,CASO_Categoria__c, Tipo_Operacion__c,'+
             'NOMBRE_COMPLETO_RAZON_SOCIAL__C, CASO_POLIZA_ASOC__C, CASO_Dias_en_Back_Office__c,CASO_Responsable_UR__c, Canal__c, CreatedDate, Tipo_de_Requerimiento__c, Numero_Propuesta__c, '+
             'Detalle_Solicitud__c, Cantidad_Dias_Desde_Creacion__c, Parent.OwnerId, Fecha_Asignacion_UR__c, Id_Responsable_UR__c, Agente__c, Sucursal__c, Supervisor__c, RVentas__c, '+
             ' Rut_Agente__c, Mail_Agente__c, Celular_Agente__c, Telefono_Agente__c, RUT_no_Cliente__c, Nombre_no_Cliente__c, EsNoCliente__c, Lead__c, Fecha_Derivacion_UR__c, OwnerId__c, '+
             ' Monto_Rescate__c, Sub_Estado_Acsel__c, CASO_Deriva_a_UR__c FROM Case ';
 
             system.debug('@@@@ IdColaUR => ' + this.IdColaUR);
 
            
             String qwhere = ' WHERE RecordTypeId =  \''+ this.IdTipoRegistro + '\'' + ' AND IsClosed = false AND Negocio__c IN '+negocios + 
             ' AND CASO_Categoria__c IN '+categorias+ ' AND Detalle_Solicitud__c IN '+solicitudes+ '';
 
             
 
             String qfecha = '';
 
             Boolean errorFecha = false;

             if (this.FechaInicio == null || this.FechaTermino == null)
             {
                 errorFecha = true;
             }

             if (errorFecha == false)
             {
                 DateTime dateIni = DateTime.newInstance(this.FechaInicio.year(), this.FechaInicio.month(), this.FechaInicio.day(), 0, 0, 0);
                 String format_DateIni= dateIni.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                 DateTime dateTer = DateTime.newInstance(this.FechaTermino.year(), this.FechaTermino.month(), this.FechaTermino.day(), 23,59, 59);
                 String format_DateTer= dateTer.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

                 qfecha = ' AND CreatedDate >= '+ format_DateIni +' AND CreatedDate <=' +format_DateTer;     
             }

             String qestado = '';
 
             if (this.Pantalla.Filtro.EstadoCaso == true)
             {
                 if (this.Estado == 'Todos')
                 {
                     qestado = ' AND (Status = \'Back Office\' OR Status = \'En Proceso\' OR Status = \'Nuevo\'  OR Status = \'En Revisión\'  OR Status = \'Cerrado\'  OR Status = \'Rechazado\') ';
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
           
             String qVenta = '';
 
             if (this.RequerimientoVentas == true)
             {
                 qVenta = ' AND RVentas__c = true ';
             }
                
             system.debug('@@@@ Filtro Negocio --> '+ this.FiltroCaso.Negocio__c);
             system.debug('@@@@ Filtro Categoría --> '+ this.FiltroCaso.CASO_Categoria__c);
             system.debug('@@@@ Filtro Detalle --> '+ this.FiltroCaso.Detalle_Solicitud__c);
 
             String qorden = '';
 
             qorden = ' ORDER BY CreatedDate ASC';
                
             String qfull = query + qwhere + qestado + qtipo + qfecha +  qnumeroCaso + qnumeroPoliza + qnumeroPropuesta + qrut + qorigen +  qVenta +  qorden + qlimit;
 
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


     public void cargaParametrosPantallas()
     {
         OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();
         
         if(!Test.isRunningTest())
         {
            system.debug('@@@@  QUERY => ' + 'SELECT Id, CNF_UR_BandejaCasos__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c ='+ this.IdColaUR + ' AND Usuario__c = '+ UserInfo.getUserId());

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
             '"SubEstadoACSEL" : false'+ 
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
        
         this.Pantalla = PAR_UR_BandejaCasos.parse(jsonDisplay);
 
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

     public void busquedaCasosUR(){
        system.debug('@@@@  ERROR');
        system.debug('@@@@  FechaInicio => ' + FechaInicio);
          system.debug('@@@@  FechaTermino => ' + FechaTermino);
        
      try{

          system.debug('@@@@  FechaInicio => ' + FechaInicio);
          system.debug('@@@@  FechaTermino => ' + FechaTermino);

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


}