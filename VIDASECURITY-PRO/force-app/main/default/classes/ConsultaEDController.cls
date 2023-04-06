public class ConsultaEDController {
    
	public Solicitud__c Solicitud {get; set;}
    public Integer Persistencia { get; set; }    
 	public String RutUsuario { get; set; }    
    public String UserOS { get; set; }   
    public String Ip { get; set; }          
    public Id casoId {get; set;}  
        
    public ConsultaEDController()  {
        
    }
    
    public ConsultaEDController(ApexPages.StandardController controller)  {    
       if (!Test.isRunningTest()) 
       { 
           controller.addFields(new String[] {'Id', 'Id'});
           controller.addFields(new String[] {'Caso__c', 'Caso__c'}); 
           controller.addFields(new String[] {'EstadoRequerimiento__c', 'EstadoRequerimiento__c'});
           controller.addFields(new String[] {'IdRequerimiento__c', 'IdRequerimiento__c'});
       }
               
       this.Solicitud = (Solicitud__c)controller.getRecord();     
       
       this.casoId = Id.valueOf(this.Solicitud.Caso__c);
        
       this.CargaDatosUsuario();
       this.ObtienePersistencia();
    }
    
    public void CargaDatosUsuario()   {
       List<User> lrecords = [Select RUT_Usuario__c, CommunityNickname From User Where Id = :UserInfo.getUserId()];
 
       if (lrecords.size() > 0)
       {
           this.RutUsuario = lrecords[0].RUT_Usuario__c;      
           String apodo = lrecords[0].CommunityNickname;
           this.UserOS = 'GRP_SECURITY\\SALESFORCE';
           this.Ip = apodo;           
       }
    }   
    
    public void ObtienePersistencia()  {
       this.Persistencia  = EscritorioNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip); 
    }
    
    public PageReference toCaso() { 
		PageReference page =  new PageReference ('/'+ this.CasoId);        
        return page;
    }
}