/*
 ************************************************************************************************************
 |  NOMBRE                 : CTR_UR_Bandeja															|
 |  TIPO                   : APEX CLASS																		|
 |  REQUERIMIENTO          : MEJORAS UR                                                                  	|
 |  DESCRIPCION            : Panel UR con informacion de usuarios responsables, cantidad de casos, tareas   |
 |                           y colaboraciones existentes                                                    |  														
 ************************************************************************************************************
 |  VERSIÓN    *    FECHA C/M    *    RESPONSABLE    *    OBSERVACIONES										|
 |    1.0      *    2019/08/01   *    JUAN ESPINOZA  *    Creación Clase									|
 |     																										|
 ************************************************************************************************************
*/ 

public  class CTR_UR_Bandeja {
    
    public class UsuarioBKP 
    {
        public String Id {get; set;}
        
        public String Name {get; set;}

        public String Email {get; set;}

        public Integer Casos_BackOffice {get; set;}

        public Integer Casos_EnProceso {get; set;}

        public Integer Casos_EnRevision {get; set;}

        public Integer Casos_Cerrados {get; set;}

        public Integer Casos_Rechazados {get; set;}

        public Integer Casos_Totales {get; set;}

        public Integer Tareas_SinIniciar {get; set;}

        public Integer Tareas_EnCurso {get; set;}

        public Integer Tareas_Completadas {get; set;}

        public Integer Tareas_Rechazadas {get; set;}

        public Integer Tareas_Descartadas {get; set;}

        public Integer Tareas_Totales {get; set;}

        public Integer Colaboraciones_SinIniciar {get; set;}

        public Integer Colaboraciones_EnCurso {get; set;}

        public Integer Colaboraciones_Completadas {get; set;}

        public Integer Colaboraciones_Rechazadas {get; set;}

        public Integer Colaboraciones_Descartadas {get; set;}

        public Integer Colaboraciones_Totales {get; set;}
    }


    public Integer Casos_Totales {get; set;}
    public Integer Casos_Cerrados {get; set;}
    public Integer Casos_Rechazados {get; set;}
    public Integer Casos_EnProceso{get; set;}
    public Integer Casos_EnRevision {get; set;}
    public Integer Casos_BackOffice {get; set;}


    public Integer Tareas_Totales {get; set;}
    public Integer Tareas_Completadas {get; set;}
    public Integer Tareas_Rechazadas {get; set;}
    public Integer Tareas_EnCurso{get; set;}    
    public Integer Tareas_SinIniciar {get; set;}
    public Integer Tareas_Descartadas {get; set;}

    public Integer Colaboraciones_Totales {get; set;}
    public Integer Colaboraciones_Completadas {get; set;}
    public Integer Colaboraciones_Rechazadas {get; set;}
    public Integer Colaboraciones_EnCurso {get; set;}    
    public Integer Colaboraciones_SinIniciar {get; set;}
    public Integer Colaboraciones_Descartadas {get; set;}

    public List<UsuarioBKP> LST_UsuariosUR {get; set;}

    public List<Usuario_Backup__c> LST_UsuariosBackup {get; set;}

    public String AreaUsuarioLicencia {get; set;}

    public User UsuarioSF { get; set; }

    public String UbackId { get; set; }

    public Boolean FiltroVentas {get; set;}

    public String UsuarioBackUp {get; set;}

    public Boolean IsuBack {get; set;}

    public PAR_UR_Bandeja Pantalla {get; set;}

    public String IdColaUR {get; set;}

    private Boolean CargaUsuario()
    {
        this.FiltroVentas = false;

        this.UsuarioSF = [SELECT Id, USUA_Area_UR__c, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

       /* Profile perfil = [SELECT Id FROM Profile WHERE Name =  'Ejecutiva Producción Individuales Central'];

        if (UsuarioSF.ProfileId == perfil.Id)
        {
            this.FiltroVentas = true;
        }*/    

        system.debug('@@@@ USUARIO SF'+ this.UsuarioSF);
        system.debug('@@@@ USUARIO Id'+ this.UsuarioSF.Id);
        system.debug('@@@@ USUARIO Area'+ this.UsuarioSF.USUA_Area_UR__c);

        if (String.IsBlank(this.UsuarioSF.USUA_Area_UR__c))
        {
           return false;
        }

        this.AreaUsuarioLicencia = this.UsuarioSF.USUA_Area_UR__c;
        
        List<Usuario_Backup__c> ubacks = [SELECT Id, Usuario__c, OwnerId FROM Usuario_Backup__c  WHERE 
        UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
      //  UBAC_Activo__c = true AND Usuario__c =: this.UsuarioSF.Id];

        if (!Test.isRunningTest()){
            this.IdColaUR = ubacks[0].OwnerId;           
        }
        else
        {
            Group gQuery = [SELECT Id, Name FROM Group WHERE Type = 'Queue' LIMIT 1];
            this.IdColaUR = gQuery.Id;        
        }
        
        system.debug('@@@@ ubacks '+ ubacks);
        
        if (ubacks.Size() == 0)
        {
            UbackId = '0';
        }
        else {
            UbackId = ubacks[0].Id;
            
        }

        return true;
    }

    public PageReference IniciarBandeja()
    {
        Boolean exito =  this.CargaUsuario();

        system.debug('@@@@ Exito '+ exito);

        if (exito == true)
        {
             this.CargaDatosDashboard();
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

     public Pagereference seleccionResponsableUR(){
        try
        {
            this.RefrescaDatosDashboard();
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR => ' + ex);
        }   

        return null;        
    }

    public List<Selectoption> getListarUsuarios(){
        try{
            List<Selectoption> LST_NombresUsuarios = new List<Selectoption>();

        //   if ( this.LST_UsuariosBackup.size() > 1)
          // {
            LST_NombresUsuarios.add(new Selectoption('0','Todos'));
           //} 
          
            for(Usuario_Backup__c u : this.LST_UsuariosBackup){
                LST_NombresUsuarios.add(new Selectoption(u.Id,u.Name));
            }

            return LST_NombresUsuarios;            
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    }

    public void RefrescaDatosDashboard()
    {
		try
        {
        this.Casos_Cerrados = 0;
        this.Casos_Rechazados = 0;
        this.Casos_EnProceso = 0;
        this.Casos_EnRevision = 0;
        this.Casos_BackOffice = 0;

        this.Tareas_completadas = 0;
        this.Tareas_rechazadas = 0;
        this.Tareas_enCurso = 0;
        this.Tareas_sinIniciar = 0;
        this.Tareas_Descartadas = 0;

        this.Colaboraciones_completadas = 0;
        this.Colaboraciones_rechazadas = 0;
        this.Colaboraciones_enCurso = 0;
        this.Colaboraciones_sinIniciar = 0;
        this.Colaboraciones_Descartadas = 0;

        List<Usuario_Backup__c> ubackups = new List<Usuario_Backup__c>();

         if (this.UsuarioBackUp == null || this.UsuarioBackUp == '0')
            {
                 system.debug('@@@@ entro 1');
                 ubackups = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId,
                    Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                    Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Total__c, 
                    Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Total__c,
                    Tareas_Descartadas__c, Colaboraciones_Descartadas__c 
                    FROM Usuario_Backup__c
                    WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
            }
            else {
                system.debug('@@@@ entro 2');
                 ubackups = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId,
                Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Total__c, 
                Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Total__c,
                Tareas_Descartadas__c, Colaboraciones_Descartadas__c 
                FROM Usuario_Backup__c
                WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia AND Id =: this.UsuarioBackUp];

            }

        system.debug('@@@@ ubackups => ' + ubackups);
        system.debug('@@@@ UsuarioBackUp => ' + UsuarioBackUp);

        this.LST_UsuariosBackup = ubackups;

        this.LST_UsuariosUR = new List<UsuarioBKP>();

        for(Usuario_Backup__c u : ubackups){
            UsuarioBKP ubkp = new UsuarioBKP();
            ubkp.Id = u.Id;
            ubkp.Name = u.Name;
            ubkp.Email = u.UBAC_Email__c;
            ubkp.Casos_BackOffice = Integer.valueOf(u.Casos_BackOffice__c);
            ubkp.Casos_EnProceso = Integer.valueOf(u.Casos_En_Proceso__c);            
            ubkp.Casos_EnRevision = Integer.valueOf(u.Casos_En_Revisi_n__c);
            ubkp.Casos_Cerrados = Integer.valueOf(u.Casos_Cerrados__c);
            ubkp.Casos_Rechazados = Integer.valueOf(u.Casos_Rechazado__c);
            ubkp.Casos_Totales = Integer.valueOf(u.Casos_Total__c);

          /*  ubkp.ResumenCasos = 'Casos BackOffice: '+ubkp.Casos_BackOffice +'\n' + 
                                'Casos En Proceso: '+ubkp.Casos_EnProceso +'\n'+ 
                                'Casos En Revisión: '+ubkp.Casos_EnRevision +'\n'+
                                'Casos Cerrados: '+ubkp.Casos_Cerrados +'\n'+
                                'Casos Rechazados: '+ubkp.Casos_Rechazados;*/
  			
            system.debug('@@@@ ubkp  Casos --> '+ ubkp);
            system.debug('@@@@ Casos_Cerrados  --> '+ this.Casos_Cerrados);
            system.debug('@@@@ Casos_Rechazados  --> '+ this.Casos_Rechazados);
            system.debug('@@@@ Casos_EnProceso  --> '+ this.Casos_EnProceso);
            system.debug('@@@@ Casos_EnRevision  --> '+ this.Casos_EnRevision);
            system.debug('@@@@ Casos_BackOffice  --> '+ this.Casos_BackOffice);
            
            this.Casos_Cerrados = this.Casos_Cerrados + ubkp.Casos_Cerrados;
            this.Casos_Rechazados  = this.Casos_Rechazados + ubkp.Casos_Rechazados;
            this.Casos_EnProceso = this.Casos_enProceso + ubkp.Casos_EnProceso;
            this.Casos_EnRevision = this.Casos_enRevision + ubkp.Casos_EnRevision;
            this.Casos_BackOffice = this.Casos_BackOffice + ubkp.Casos_BackOffice;

            
            ubkp.Tareas_SinIniciar = Integer.valueOf(u.Tareas_Sin_Iniciar__c);
            ubkp.Tareas_EnCurso = Integer.valueOf(u.Tareas_En_Curso__c);
            ubkp.Tareas_Completadas = Integer.valueOf(u.Tareas_Completada__c);
            ubkp.Tareas_Rechazadas = Integer.valueOf(u.Tareas_Rechazada__c);
            ubkp.Tareas_Totales = Integer.valueOf(u.Tareas_Total__c);
            ubkp.Tareas_Descartadas = Integer.valueOf(u.Tareas_Descartadas__c);
            
  		/*	
            ubkp.ResumenTareas = 'Tareas UR Sin Iniciar: '+ubkp.Tareas_SinIniciar +'\n' + 
                                'Tareas UR En Curso: '+ubkp.Tareas_EnCurso +'\n'+ 
                                'Tareas UR Completadas: '+ubkp.Tareas_Completadas +'\n'+
                                'Tareas UR Rechazadas: '+ubkp.Tareas_Rechazadas +'\n'+
                                'Tareas UR Descartadas: '+ubkp.Tareas_Descartadas;
          */  
			system.debug('@@@@ ubkp  Tareas --> '+ ubkp);
            
            this.Tareas_Completadas = this.Tareas_Completadas + ubkp.Tareas_Completadas;
            this.Tareas_Rechazadas = this.Tareas_Rechazadas + ubkp.Tareas_Rechazadas;
            this.Tareas_EnCurso = this.Tareas_EnCurso + ubkp.Tareas_EnCurso;
            this.Tareas_SinIniciar = this.Tareas_SinIniciar + ubkp.Tareas_SinIniciar;
            this.Tareas_Descartadas = this.Tareas_Descartadas + ubkp.Tareas_Descartadas;
            
            ubkp.Colaboraciones_SinIniciar = Integer.valueOf(u.Colaboraciones_Sin_Iniciar__c);
            ubkp.Colaboraciones_EnCurso = Integer.valueOf(u.Colaboraciones_En_Curso__c);
            ubkp.Colaboraciones_Completadas = Integer.valueOf(u.Colaboraciones_Completada__c);
            ubkp.Colaboraciones_Rechazadas = Integer.valueOf(u.Colaboraciones_Rechazada__c);
            ubkp.Colaboraciones_Totales = Integer.valueOf(u.Colaboraciones_Total__c);
            ubkp.Colaboraciones_Descartadas = Integer.valueOf(u.Colaboraciones_Descartadas__c);
			
         /*   ubkp.ResumenColaboraciones = 'Colaboraciones Sin Iniciar: '+ubkp.Colaboraciones_SinIniciar +'\n' + 
                                'Colaboraciones En Curso: '+ubkp.Colaboraciones_EnCurso +'\n'+ 
                                'Colaboraciones Completadas: '+ubkp.Colaboraciones_Completadas +'\n'+
                                'Colaboraciones Rechazadas: '+ubkp.Colaboraciones_Rechazadas+'\n'+
                                'Colaboraciones Descartadas: '+ubkp.Colaboraciones_Descartadas;
*/
            system.debug('@@@@ ubkp  Colaboraciones --> '+ ubkp);
            
            this.Colaboraciones_Completadas = this.Colaboraciones_Completadas + ubkp.Colaboraciones_Completadas;
            this.Colaboraciones_Rechazadas = this.Colaboraciones_Rechazadas + ubkp.Colaboraciones_Rechazadas;
            this.Colaboraciones_EnCurso = this.Colaboraciones_EnCurso + ubkp.Colaboraciones_EnCurso;
            this.Colaboraciones_SinIniciar = this.Colaboraciones_SinIniciar + ubkp.Colaboraciones_SinIniciar;
            this.Colaboraciones_Descartadas = this.Colaboraciones_Descartadas + ubkp.Colaboraciones_Descartadas;

            this.LST_UsuariosUR.add(ubkp);
        }

         this.Casos_Totales = this.Casos_Cerrados +
                          this.Casos_rechazados  +
                          this.Casos_enProceso  +
                          this.Casos_enRevision  +
                          this.Casos_BackOffice;

        this.Tareas_Totales = this.Tareas_completadas +
                        this.Tareas_rechazadas  +
                        this.Tareas_enCurso  +
                        this.Tareas_sinIniciar + 
                        this.Tareas_Descartadas;

        this.Colaboraciones_Totales = this.Colaboraciones_completadas +
                        this.Colaboraciones_rechazadas  +
                        this.Colaboraciones_enCurso  +
                        this.Colaboraciones_sinIniciar +
                        this.Colaboraciones_Descartadas;

/*
        List<Usuario_Backup__c> usuariosBackups = [SELECT OwnerId FROM Usuario_Backup__c WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuarioLicencia LIMIT 1];

        String IdColaUR = usuariosBackups[0].OwnerId; 

        Cola_Usuario__c colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: IdColaUR];

        String OwnerId = colaUsuario.Usuario__c;

        String RecordTypeId_Tarea = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

        
        List<Task> tareas_SinIniciar = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Tarea AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'No Iniciada'];

        List<Task> tareas_Descartada = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Tarea AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'Descartada'];

        this.Tareas_sinIniciar  = this.Tareas_sinIniciar  + tareas_SinIniciar.size();
        this.Tareas_Descartadas  = this.Tareas_Descartadas  + tareas_Descartada.size();

        String RecordTypeId_Colaboracion = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;

        List<Task> colaboraciones_SinIniciar = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Colaboracion AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'No Iniciada'];

        List<Task> colaboraciones_Descartada = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Colaboracion AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'Descartada'];

        this.Casos_Totales = this.Casos_Cerrados +
                          this.Casos_rechazados  +
                          this.Casos_enProceso  +
                          this.Casos_enRevision  +
                          this.Casos_BackOffice;

        this.Tareas_Totales = this.Tareas_completadas +
                        this.Tareas_rechazadas  +
                        this.Tareas_enCurso  +
                        this.Tareas_sinIniciar + 
                        this.Tareas_Descartadas;

        this.Colaboraciones_sinIniciar  = this.Colaboraciones_sinIniciar  + colaboraciones_SinIniciar.size();
        this.Colaboraciones_Descartadas  = this.Colaboraciones_Descartadas  + colaboraciones_Descartada.size();

        this.Colaboraciones_Totales = this.Colaboraciones_completadas +
                        this.Colaboraciones_rechazadas  +
                        this.Colaboraciones_enCurso  +
                        this.Colaboraciones_sinIniciar +
                        this.Colaboraciones_Descartadas;*/
            this.loadPieDataCasos();
            this.loadPieDataTareas();
            this.loadDataColaboraciones();
        }
        catch(Exception ex)
        {
            system.debug('@@@@ Causa Error  --> '+ ex.getCause());
            system.debug('@@@@ Linea Error  --> '+ ex.getLineNumber());
            system.debug('@@@@ Mensaje Error  --> '+ ex.getMessage());
            system.debug('@@@@ Traza Error  --> '+ ex.getStackTraceString());
        }
        
     //   return null;

    }

    public void cargaParametrosDashboard()
    {
        OBJ_BandejaUR_Configuracion__c CnfBandeja = new OBJ_BandejaUR_Configuracion__c();
        
        if (!Test.isRunningTest())
        {	
        	CnfBandeja = [SELECT Id, CNF_UR_Bandeja__c FROM OBJ_BandejaUR_Configuracion__c WHERE Id_Cola__c =: this.IdColaUR  AND Usuario__c =: UserInfo.getUserId()];
        	system.debug('@@@@  CnfBandeja => ' + CnfBandeja);    
        }
        
        String jsonDisplay = '';

        if (String.isNotBlank(CnfBandeja.CNF_UR_Bandeja__c))
        {
            jsonDisplay = CnfBandeja.CNF_UR_Bandeja__c;
        }
        else
        {
            jsonDisplay = '' +
            '{'+
                '"Botonera": '+
                '{'+ 
                '"CasosUR" : true,'+ 
                '"TareasUR" : false,'+
                '"ColaboracionesUR" : true,'+
                '"AsignacionesUR" : true,'+
                '"SeleccionUsuario" : true'+
                '}'+
                '}';       
        }
       
        this.Pantalla = PAR_UR_Bandeja.parse(jsonDisplay);

        system.debug('@@@@ Pantalla --> '+ this.Pantalla);

    }

    public void CargaDatosDashboard()
    {
		try
        {
            this.Casos_Cerrados = 0;
            this.Casos_Rechazados = 0;
            this.Casos_EnProceso = 0;
            this.Casos_EnRevision = 0;
            this.Casos_BackOffice = 0;
    
            this.Tareas_completadas = 0;
            this.Tareas_rechazadas = 0;
            this.Tareas_enCurso = 0;
            this.Tareas_sinIniciar = 0;
            this.Tareas_Descartadas = 0;
    
            this.Colaboraciones_completadas = 0;
            this.Colaboraciones_rechazadas = 0;
            this.Colaboraciones_enCurso = 0;
            this.Colaboraciones_sinIniciar = 0;
            this.Colaboraciones_Descartadas = 0;
            
        	this.cargaParametrosDashboard();

        List<Usuario_Backup__c> ubackups = new List<Usuario_Backup__c>();

        this.IsuBack = true;

        ubackups = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId,
                Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Total__c, 
                Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Total__c,
                Tareas_Descartadas__c, Colaboraciones_Descartadas__c 
                FROM Usuario_Backup__c
                WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia AND Usuario__c =: this.UsuarioSF.Id];

        if (ubackups.Size() == 0)
        {
            ubackups = [SELECT Id, Name, UBAC_Activo__c, UBAC_Area__c, UBAC_Email__c, UBAC_Perfil__c, UBAC_Rut__c, OwnerId,
                Casos_BackOffice__c, Casos_En_Proceso__c, Casos_En_Revisi_n__c, Casos_Cerrados__c, Casos_Rechazado__c, Casos_Total__c, 
                Tareas_Sin_Iniciar__c, Tareas_En_Curso__c, Tareas_Completada__c, Tareas_Rechazada__c, Tareas_Total__c, 
                Colaboraciones_Sin_Iniciar__c, Colaboraciones_En_Curso__c, Colaboraciones_Completada__c, Colaboraciones_Rechazada__c, Colaboraciones_Total__c,
                Tareas_Descartadas__c, Colaboraciones_Descartadas__c 
                FROM Usuario_Backup__c
                WHERE UBAC_Activo__c = true AND UBAC_Area__c =: this.AreaUsuarioLicencia];
            
            this.IsuBack = false;
        }

        system.debug('@@@@ ubackups => ' + ubackups);
        system.debug('@@@@ UsuarioBackUp => ' + UsuarioBackUp);

        this.LST_UsuariosBackup = ubackups;

        if (isuBack == true && ubackups.Size() > 0)
        {
            this.UsuarioBackUp = ubackups[0].Id;
        }

        this.LST_UsuariosUR = new List<UsuarioBKP>();

        for(Usuario_Backup__c u : ubackups){
            UsuarioBKP ubkp = new UsuarioBKP();
            ubkp.Id = u.Id;
            ubkp.Name = u.Name;
            ubkp.Email = u.UBAC_Email__c;
            ubkp.Casos_BackOffice = Integer.valueOf(u.Casos_BackOffice__c);
            ubkp.Casos_EnProceso = Integer.valueOf(u.Casos_En_Proceso__c);            
            ubkp.Casos_EnRevision = Integer.valueOf(u.Casos_En_Revisi_n__c);
            ubkp.Casos_Cerrados = Integer.valueOf(u.Casos_Cerrados__c);
            ubkp.Casos_Rechazados = Integer.valueOf(u.Casos_Rechazado__c);
            ubkp.Casos_Totales = Integer.valueOf(u.Casos_Total__c);

       /*     ubkp.ResumenCasos = 'Casos BackOffice: '+ubkp.Casos_BackOffice +'\n' + 
                                'Casos En Proceso: '+ubkp.Casos_EnProceso +'\n'+ 
                                'Casos En Revisión: '+ubkp.Casos_EnRevision +'\n'+
                                'Casos Cerrados: '+ubkp.Casos_Cerrados +'\n'+
                                'Casos Rechazados: '+ubkp.Casos_Rechazados;
  		**/	
            system.debug('@@@@ ubkp  Casos --> '+ ubkp);
            system.debug('@@@@ Casos_Cerrados  --> '+ this.Casos_Cerrados);
            system.debug('@@@@ Casos_Rechazados  --> '+ this.Casos_Rechazados);
            system.debug('@@@@ Casos_EnProceso  --> '+ this.Casos_EnProceso);
            system.debug('@@@@ Casos_EnRevision  --> '+ this.Casos_EnRevision);
            system.debug('@@@@ Casos_BackOffice  --> '+ this.Casos_BackOffice);
            
            this.Casos_Cerrados = this.Casos_Cerrados + ubkp.Casos_Cerrados;
            this.Casos_Rechazados  = this.Casos_Rechazados + ubkp.Casos_Rechazados;
            this.Casos_EnProceso = this.Casos_enProceso + ubkp.Casos_EnProceso;
            this.Casos_EnRevision = this.Casos_enRevision + ubkp.Casos_EnRevision;
            this.Casos_BackOffice = this.Casos_BackOffice + ubkp.Casos_BackOffice;
            
            ubkp.Tareas_SinIniciar = Integer.valueOf(u.Tareas_Sin_Iniciar__c);
            ubkp.Tareas_EnCurso = Integer.valueOf(u.Tareas_En_Curso__c);
            ubkp.Tareas_Completadas = Integer.valueOf(u.Tareas_Completada__c);
            ubkp.Tareas_Rechazadas = Integer.valueOf(u.Tareas_Rechazada__c);
            ubkp.Tareas_Totales = Integer.valueOf(u.Tareas_Total__c);
            ubkp.Tareas_Descartadas = Integer.valueOf(u.Tareas_Descartadas__c);
     /*       
  			
            ubkp.ResumenTareas = 'Tareas UR Sin Iniciar: '+ubkp.Tareas_SinIniciar +'\n' + 
                                'Tareas UR En Curso: '+ubkp.Tareas_EnCurso +'\n'+ 
                                'Tareas UR Completadas: '+ubkp.Tareas_Completadas +'\n'+
                                'Tareas UR Rechazadas: '+ubkp.Tareas_Rechazadas +'\n'+
                                'Tareas UR Descartadas: '+ubkp.Tareas_Descartadas;
       */     
			system.debug('@@@@ ubkp  Tareas --> '+ ubkp);
            
            this.Tareas_Completadas = this.Tareas_Completadas + ubkp.Tareas_Completadas;
            this.Tareas_Rechazadas = this.Tareas_Rechazadas + ubkp.Tareas_Rechazadas;
            this.Tareas_EnCurso = this.Tareas_EnCurso + ubkp.Tareas_EnCurso;
            this.Tareas_SinIniciar = this.Tareas_SinIniciar + ubkp.Tareas_SinIniciar;
            this.Tareas_Descartadas = this.Tareas_Descartadas + ubkp.Tareas_Descartadas;
            
            ubkp.Colaboraciones_SinIniciar = Integer.valueOf(u.Colaboraciones_Sin_Iniciar__c);
            ubkp.Colaboraciones_EnCurso = Integer.valueOf(u.Colaboraciones_En_Curso__c);
            ubkp.Colaboraciones_Completadas = Integer.valueOf(u.Colaboraciones_Completada__c);
            ubkp.Colaboraciones_Rechazadas = Integer.valueOf(u.Colaboraciones_Rechazada__c);
            ubkp.Colaboraciones_Totales = Integer.valueOf(u.Colaboraciones_Total__c);
            ubkp.Colaboraciones_Descartadas = Integer.valueOf(u.Colaboraciones_Descartadas__c);
			
       /*     ubkp.ResumenColaboraciones = 'Colaboraciones Sin Iniciar: '+ubkp.Colaboraciones_SinIniciar +'\n' + 
                                'Colaboraciones En Curso: '+ubkp.Colaboraciones_EnCurso +'\n'+ 
                                'Colaboraciones Completadas: '+ubkp.Colaboraciones_Completadas +'\n'+
                                'Colaboraciones Rechazadas: '+ubkp.Colaboraciones_Rechazadas+'\n'+
                                'Colaboraciones Descartadas: '+ubkp.Colaboraciones_Descartadas;
*/
            system.debug('@@@@ ubkp  Colaboraciones --> '+ ubkp);
            
            this.Colaboraciones_Completadas = this.Colaboraciones_Completadas + ubkp.Colaboraciones_Completadas;
            this.Colaboraciones_Rechazadas = this.Colaboraciones_Rechazadas + ubkp.Colaboraciones_Rechazadas;
            this.Colaboraciones_EnCurso = this.Colaboraciones_EnCurso + ubkp.Colaboraciones_EnCurso;
            this.Colaboraciones_SinIniciar = this.Colaboraciones_SinIniciar + ubkp.Colaboraciones_SinIniciar;
            this.Colaboraciones_Descartadas = this.Colaboraciones_Descartadas + ubkp.Colaboraciones_Descartadas;

            this.LST_UsuariosUR.add(ubkp);
        }

         this.Casos_Totales = this.Casos_Cerrados +
                          this.Casos_rechazados  +
                          this.Casos_enProceso  +
                          this.Casos_enRevision  +
                          this.Casos_BackOffice;

        this.Tareas_Totales = this.Tareas_completadas +
                        this.Tareas_rechazadas  +
                        this.Tareas_enCurso  +
                        this.Tareas_sinIniciar + 
                        this.Tareas_Descartadas;

        this.Colaboraciones_Totales = this.Colaboraciones_completadas +
                        this.Colaboraciones_rechazadas  +
                        this.Colaboraciones_enCurso  +
                        this.Colaboraciones_sinIniciar +
                        this.Colaboraciones_Descartadas;

/*
        List<Usuario_Backup__c> usuariosBackups = [SELECT OwnerId FROM Usuario_Backup__c WHERE UBAC_Activo__c = true AND UBAC_Area__c =: AreaUsuarioLicencia LIMIT 1];

        String IdColaUR = usuariosBackups[0].OwnerId; 

        Cola_Usuario__c colaUsuario = [SELECT Id, Usuario__c FROM Cola_Usuario__c WHERE Id_Cola__c =: IdColaUR];

        String OwnerId = colaUsuario.Usuario__c;

        String RecordTypeId_Tarea = [SELECT Id FROM RecordType WHERE Name = 'Caso UR'].Id;

        
        List<Task> tareas_SinIniciar = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Tarea AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'No Iniciada'];

        List<Task> tareas_Descartada = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Tarea AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'Descartada'];

        this.Tareas_sinIniciar  = this.Tareas_sinIniciar  + tareas_SinIniciar.size();
        this.Tareas_Descartadas  = this.Tareas_Descartadas  + tareas_Descartada.size();

        String RecordTypeId_Colaboracion = [SELECT Id FROM RecordType WHERE Name = 'Colaboracion Caso'].Id;

        List<Task> colaboraciones_SinIniciar = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Colaboracion AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'No Iniciada'];

        List<Task> colaboraciones_Descartada = [SELECT Id, Status, Responsable_Backup__c FROM Task 
        WHERE RecordTypeId =:RecordTypeId_Colaboracion AND OwnerId =: OwnerId AND Responsable_Backup__c = null AND Status = 'Descartada'];

        this.Casos_Totales = this.Casos_Cerrados +
                          this.Casos_rechazados  +
                          this.Casos_enProceso  +
                          this.Casos_enRevision  +
                          this.Casos_BackOffice;

        this.Tareas_Totales = this.Tareas_completadas +
                        this.Tareas_rechazadas  +
                        this.Tareas_enCurso  +
                        this.Tareas_sinIniciar + 
                        this.Tareas_Descartadas;

        this.Colaboraciones_sinIniciar  = this.Colaboraciones_sinIniciar  + colaboraciones_SinIniciar.size();
        this.Colaboraciones_Descartadas  = this.Colaboraciones_Descartadas  + colaboraciones_Descartada.size();

        this.Colaboraciones_Totales = this.Colaboraciones_completadas +
                        this.Colaboraciones_rechazadas  +
                        this.Colaboraciones_enCurso  +
                        this.Colaboraciones_sinIniciar +
                        this.Colaboraciones_Descartadas;*/
            this.loadPieDataCasos();
            this.loadPieDataTareas();
            this.loadDataColaboraciones();
        }
        catch(Exception ex)
        {
            system.debug('@@@@ Causa Error  --> '+ ex.getCause());
            system.debug('@@@@ Linea Error  --> '+ ex.getLineNumber());
            system.debug('@@@@ Mensaje Error  --> '+ ex.getMessage());
            system.debug('@@@@ Traza Error  --> '+ ex.getStackTraceString());
        }
        
     //   return null;

    }

    public Pagereference BandejaCasosUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Casos?Area='+this.AreaUsuarioLicencia+'&idResponsableUR='+this.UbackId+'&FVentas='+this.FiltroVentas);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference BandejaTareasUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Tareas?Area='+this.AreaUsuarioLicencia+'&idResponsableUR='+this.UbackId);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public Pagereference BandejaColaboracionesUR()
    {
        PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Colaboraciones?Area='+this.AreaUsuarioLicencia+'&idResponsableUR='+this.UbackId);
        pagina_verCaso.setRedirect(true);

        return pagina_verCaso;
    }

    public List<PieWedgeData> dataCasosUR;
    public void loadPieDataCasos() {      
        this.dataCasosUR = new List<PieWedgeData>();  
        this.dataCasosUR.add(new PieWedgeData('Back Office', this.Casos_BackOffice));
        this.dataCasosUR.add(new PieWedgeData('En Proceso', this.Casos_EnProceso));
        this.dataCasosUR.add(new PieWedgeData('En Revisión', this.Casos_EnRevision));
        system.debug('@@@@ entro casos');
        system.debug('@@@@ Back Office' +this.Casos_BackOffice);
        system.debug('@@@@ Revisión'+ this.Casos_EnRevision);
    }

    public List<PieWedgeData> getPieDataCasos() {
        return this.dataCasosUR;
    }

    public List<PieWedgeData> dataTareasUR;
    public void loadPieDataTareas() {
        this.dataTareasUR = new List<PieWedgeData>();
        this.dataTareasUR.add(new PieWedgeData('No Iniciadas', this.Tareas_SinIniciar));
        this.dataTareasUR.add(new PieWedgeData('En Curso', this.Tareas_EnCurso));
    }

    public List<PieWedgeData> getPieDataTareas() {
       return this.dataTareasUR;
    }

    public List<PieWedgeData> dataColaboraciones = new List<PieWedgeData>();
    public void loadDataColaboraciones() {
        this.dataColaboraciones = new List<PieWedgeData>();
        this.dataColaboraciones.add(new PieWedgeData('No Iniciadas', this.Colaboraciones_SinIniciar));
        this.dataColaboraciones.add(new PieWedgeData('En Curso', this.Colaboraciones_EnCurso));
    }

     public List<PieWedgeData> getPieDataColaboraciones() {
        return this.dataColaboraciones;
    }


    // Wrapper class
    public class PieWedgeData {
        public String name { get; set; }
        public Integer data { get; set; }
        public PieWedgeData(String name, Integer data) {
            this.name = name;
            this.data = data;
        }
    }



    public Pagereference AsignacionesUR()
    {
        try{
         //   PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_CasosHistorico?Area='+this.AreaUsuarioLicencia+'&Usuario='+this.UsuarioNativo+'&idResponsableUR=' + this.UsuarioBackUp);
            PageReference pagina_verCaso = new PageReference('/apex/SEC_VF_UR_Asignaciones');
            pagina_verCaso.setRedirect(true);

            return pagina_verCaso;
        }
        catch(Exception ex){
            system.debug('@@@@ ERROR LINK BandejaCasosUR_Historico -->'+ ex);
        	return null;
        }
    }
 
}