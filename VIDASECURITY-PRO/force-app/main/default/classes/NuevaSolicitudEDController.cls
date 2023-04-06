public class NuevaSolicitudEDController 
{
	public String CodigoSolicitud {get; set;}    
    public String DefaultSolicitud {get; set;}    
    public String TipoRequerimiento { get; set; }    
    
    public Integer IdRequerimiento { get; set; }
    
    public Integer Persistencia { get; set; } 
    public String RutUsuario { get; set; }    
    public String UserOS { get; set; }   
    public String Ip { get; set; }   
    
    public String RUTTitular { get; set; }   
    public String NombreTitular { get; set; }   
	
    public String MensajeError {get; set;}    

    public Solicitud__c Solicitud {get; set;}
    public Id CasoId {get; set;}    
    
    public NuevaSolicitudEDController() {
        
    }
    
    public NuevaSolicitudEDController(ApexPages.StandardController controller)  {
        if (!Test.isRunningTest()) 
       {           
           controller.addFields(new String[] {'Caso__c', 'Caso__c'});                   
       }
        
       this.Solicitud = (Solicitud__c)controller.getRecord();     
       
       this.CasoId = Id.valueOf(this.Solicitud.Caso__c);
       
       List<Case> lrecords = [Select Id, RUT__c, Nombre_Completo_Razon_Social__c, Detalle_Solicitud__c From Case Where Id = :this.CasoId];
        
        if (lrecords.size() > 0)
        {
            this.RUTTitular =  lrecords[0].RUT__c;
            this.NombreTitular =  lrecords[0].Nombre_Completo_Razon_Social__c;
            this.DefaultSolicitud =  lrecords[0].Detalle_Solicitud__c;           
        }
        
        this.CargaDatosUsuario();       
        this.CodigoSolicitud = Escritorio.CodigoSolicitud(this.DefaultSolicitud);
    }
    
    public void CargaDatosUsuario() {
        List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
        
        if (lrecords.size() > 0)
        {
            this.RutUsuario = lrecords[0].RUT_Usuario__c;      
            String apodo = lrecords[0].CommunityNickname;
            this.UserOS = 'GRP_SECURITY\\SALESFORCE';
            this.Ip = apodo;           
        }
    }   
    
    public List<SelectOption> getListaSolicitudes() {      
        return Escritorio.getListaSolicitudes();
    }
    
    public List<SelectOption> getListaSolicitantes() {
        return Escritorio.getListaSolicitantes(this.CodigoSolicitud);
    }
    
    public void nuevoRequerimientoED() {
        this.IdRequerimiento = EscritorioNegocio.crearRequerimiento(this.Persistencia , this.RUTTitular, this.TipoRequerimiento, this.RutUsuario);
       
        if (this.IdRequerimiento  != -2 && this.IdRequerimiento  != -1 && this.IdRequerimiento  != 0)
        {            
            this.guardaSolicitud();
        }   
    }
    
    public void guardaSolicitud() {
        this.Solicitud = new Solicitud__c();        
        this.Solicitud.RUT_Titular__c =  this.RUTTitular;
        this.Solicitud.Nombre_Titular__c =  this.NombreTitular;                 
        this.Solicitud.Caso__c = this.CasoId;
        this.Solicitud.Name = 'ED-'+ IdRequerimiento;
        this.Solicitud.Detalle_Solicitud__c =  Escritorio.getSolicitud(this.CodigoSolicitud);
        this.Solicitud.TipoRequerimiento__c =  this.TipoRequerimiento;
        this.Solicitud.EstadoRequerimiento__c = 'NUEVO';
        this.Solicitud.IdRequerimiento__c = IdRequerimiento;
        this.Solicitud.Solicitante__c = Escritorio.getSolicitante(this.TipoRequerimiento);
        this.Solicitud.Codigo_Solicitud__c = this.CodigoSolicitud;
        
        Insert Solicitud;
    }
    
    public void crearSolicitud() {         
        this.obtienePersistencia();
        
        if (this.Persistencia != -6 && this.Persistencia != -1 && this.Persistencia != 0)
        {            
            nuevoRequerimientoED();              
        }        
    }
    
    public void obtienePersistencia() {
        this.Persistencia = EscritorioNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);
    }
    
    public PageReference cancelarSolicitud() {      
        PageReference page = new PageReference ('/'+ this.CasoId);
        return page;
    }
    
    public PageReference toBack() {
        PageReference page = new PageReference ('/'+ this.CasoId);
        return page;
    }
    
    public PageReference toView() {
        PageReference page = new PageReference ('/'+ this.Solicitud.Id);  
        return page;
    }
}