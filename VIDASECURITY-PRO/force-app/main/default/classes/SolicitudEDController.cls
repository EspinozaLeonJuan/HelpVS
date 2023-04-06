public class SolicitudEDController {
    
    public Solicitud__c Solicitud {get; set;}
    public Integer Persistencia { get; set; }    
    public String RutUsuario { get; set; }    
    public String UserOS { get; set; }   
    public String Ip { get; set; }         
    
    public String Operacion {get; set;}
    public String Mensaje {get; set;}
    
    public Id casoId {get; set;}    
    
    public SolicitudEDController() {        
    }
    
    public SolicitudEDController(ApexPages.StandardController controller) {    
        if (!Test.isRunningTest()) 
        {        
            controller.addFields(new String[] {'Id', 'Id'});
            controller.addFields(new String[] {'Caso__c', 'Caso__c'});      
            controller.addFields(new String[] {'Detalle_Solicitud__c', 'Detalle_Solicitud__c'});     
            controller.addFields(new String[] {'IdRequerimiento__c', 'IdRequerimiento__c'});
            controller.addFields(new String[] {'Nombre_Titular__c', 'Nombre_Titular__c'});
            controller.addFields(new String[] {'RUT_Titular__c', 'RUT_Titular__c'});                
        }
        
        //generacion de mensajes
        CargaParametrosMensaje();
        GeneraMensaje();
        
        this.Solicitud = (Solicitud__c)controller.getRecord();            
        this.casoId = Id.valueOf(this.Solicitud.Caso__c);       
        this.CargaDatosUsuario();     
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
    
    public void CargaParametrosMensaje()  {
        this.Operacion = Apexpages.currentPage().GetParameters().get('Operacion');
        this.Mensaje = Apexpages.currentPage().GetParameters().get('Mensaje');       
    }
    
    public void GeneraMensaje()  {   
        if (this.Operacion == 'ERRORELIMINAR' || this.Operacion == 'ERROREDITAR')
        {
            if (this.Mensaje != null && this.Mensaje != '') 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.Mensaje));           
            }    
        }
    }
    
    public void verRequerimiento() {  
        this.Persistencia  = EscritorioNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);   
    }
    
    public PageReference VolverCaso() {
        PageReference page = new PageReference ('/'+ this.CasoId);
        return page;
    }  
}