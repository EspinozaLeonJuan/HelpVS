public class EditarSolicitudEDController {
	
    public String CodigoSolicitud {get; set;}    
    public String TipoRequerimiento { get; set; }    
      
    public Integer IdRequerimiento { get; set; }
    
    public Integer Persistencia { get; set; } 
    public String RutUsuario { get; set; }    
    public String UserOS { get; set; }   
    public String Ip { get; set; }   
    
    public String AnulaRequerimiento { get; set; }      
    public String EstadoActual { get; set; }  
    
    public Solicitud__c Solicitud {get; set;}
    public Id casoId {get; set;}    

    public EditarSolicitudEDController() {
        
    }    
    
    public EditarSolicitudEDController(ApexPages.StandardController controller) {
        if (!Test.isRunningTest()) 
        { 
            controller.addFields(new String[] {'Id', 'Id'});
            controller.addFields(new String[] {'Caso__c', 'Caso__c'}); 
            controller.addFields(new String[] {'Codigo_Solicitud__c', 'Codigo_Solicitud__c'});
            controller.addFields(new String[] {'Detalle_Solicitud__c', 'Detalle_Solicitud__c'});
            controller.addFields(new String[] {'EstadoRequerimiento__c', 'EstadoRequerimiento__c'});
            controller.addFields(new String[] {'IdRequerimiento__c', 'IdRequerimiento__c'});
            controller.addFields(new String[] {'Nombre_Titular__c', 'Nombre_Titular__c'});
            controller.addFields(new String[] {'RUT_Titular__c', 'RUT_Titular__c'});        
            controller.addFields(new String[] {'Solicitante__c', 'Solicitante__c'});  
            controller.addFields(new String[] {'TipoRequerimiento__c', 'TipoRequerimiento__c'});                   
        }
        
        this.Solicitud = (Solicitud__c)controller.getRecord(); 
        this.casoId = Id.valueOf(this.Solicitud.Caso__c);
        this.CargaDatosUsuario();
    }
    
    public void CargaDatosUsuario()  {
        List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
        
        if (lrecords.size() > 0)
        {
            this.RutUsuario = lrecords[0].RUT_Usuario__c;      
            String apodo = lrecords[0].CommunityNickname;
            this.UserOS = 'GRP_SECURITY\\SALESFORCE';
            this.Ip = apodo;           
        }
    }   
    
    public void ConsultaEstadoRequerimiento()  {
        this.EstadoActual = Escritorio.consultaEstadoSolicitud(this.Persistencia, this.RutUsuario, this.Solicitud);
    }
    
    public List<SelectOption> getListaSolicitudes() {                 
        List<SelectOption> lista =  Escritorio.getListaSolicitudes();
        
        if (this.CodigoSolicitud == null || this.CodigoSolicitud == '')
        {         
            this.CodigoSolicitud = this.Solicitud.Codigo_Solicitud__c; 
        }
        
        return lista;
    }
        
    public List<SelectOption> getListaSolicitantes() {
        List<SelectOption> lista = Escritorio.getListaSolicitantes(this.CodigoSolicitud);
        
        if (this.TipoRequerimiento == null || this.TipoRequerimiento == '')
        {
            this.TipoRequerimiento = this.Solicitud.TipoRequerimiento__c; 
        }
        
        return lista;
    }
    
    public PageReference cancelarSolicitud() {      
        PageReference page = new PageReference ('/'+ this.CasoId);
        return page;
    }
    
    public void ObtienePersistencia() {
        this.Persistencia  = EscritorioNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);
    }
    
    public void AnulaRequerimientoActual() {
        this.AnulaRequerimiento = EscritorioNegocio.cambiarEstadoRequerimiento(this.Persistencia , Integer.valueOf(this.Solicitud.IdRequerimiento__c), 'ANULADO', this.RutUsuario);                 
    }
    
    public void CrearRequerimiento() {
        this.IdRequerimiento = EscritorioNegocio.crearRequerimiento(this.Persistencia , this.Solicitud.RUT_Titular__c, this.TipoRequerimiento, this.RutUsuario);
    }
    
    public PageReference actualizarSolicitud() {    
        if (!Test.isRunningTest()) 
        {
            ObtienePersistencia(); 
        }
        
        if (this.Persistencia > 0)
        {   
            if (!Test.isRunningTest())
            {
                AnulaRequerimientoActual();
            }
            
            if (this.AnulaRequerimiento == 'ok')
            {
                if (!Test.isRunningTest()) 
                {
                    this.CrearRequerimiento();
                }
                
                //crear nuevo requerimiento
                if (this.IdRequerimiento  != -2 && this.IdRequerimiento  != -1 && this.IdRequerimiento  != 0)
                {                       
                    if (!Test.isRunningTest()) 
                    {
                        this.ActualizaSolicitud();
                    }
                    
                    PageReference page = new PageReference ('/'+ this.Solicitud.Id);
                    page.getParameters().put('operacion','EDITAR');
                    page.setRedirect(true);
                    return page;               
                }   
            }
            else
            {    
               
                PageReference page = new PageReference ('/apex/SolicitudED?Id='+ this.Solicitud.Id);
                page.getParameters().put('operacion','ERROREDITAR');
                page.getParameters().put('Mensaje', this.AnulaRequerimiento);
                page.setRedirect(true);
                return page;
            }                   
        }   
        
        return null;
    }

    public void ActualizaSolicitud()   {
        
        this.Solicitud.Name = 'ED-'+IdRequerimiento;
        this.Solicitud.Detalle_Solicitud__c =  Escritorio.getSolicitud(this.CodigoSolicitud);
        this.Solicitud.TipoRequerimiento__c =  this.TipoRequerimiento;
        this.Solicitud.EstadoRequerimiento__c = 'NUEVO';
        this.Solicitud.IdRequerimiento__c = this.IdRequerimiento;
        this.Solicitud.Solicitante__c = Escritorio.getSolicitante(this.TipoRequerimiento);
        this.Solicitud.Codigo_Solicitud__c = this.CodigoSolicitud;
        
        update Solicitud;
    }
}