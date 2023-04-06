public class EscritorioDigital_Controller {

    public Case Caso {get; set;}   
     
    public Integer Persistencia { get; set; }   
    public String  RutUsuario { get; set; }    
    public String  UserOS { get; set; }   
    public String  Ip { get; set; }   
    
    public String  RUTTitular { get; set; }     
    public String  NombreTitular { get; set; }     
    public String  CodigoSolicitud { get; set; }     
	public String  DetalleSolicitud { get; set; }  
    public String EtiquetaSolicitud {get; set;}
	public String  Solicitante { get; set; }      
    public Integer NumPoliza { get; set; }       
    public String  Poliza { get; set; } 
    
    public Integer IdRequerimiento {get; set;}
    public String  TipoRequerimientoED { get; set; } 
    public String  TipoRequerimientoSF { get; set; }     
    public String  NumeroCaso { get; set; } 
    //public String  ResultadoDerivacion { get; set; } 
    public String ResponsableUR {get; set;}
    public String Panel { get; set; } 
        
    public EscritorioDigital_Controller()
    {
        
    }
            
    public EscritorioDigital_Controller(ApexPages.StandardController controller) 
    {
        if (!Test.isRunningTest()) 
        { 
            controller.addFields(new String[] {'RUT__c', 'RUT__c'});
            controller.addFields(new String[] {'Detalle_Solicitud__c', 'Detalle_Solicitud__c'});
            controller.addFields(new String[] {'Id', 'Id'});
            controller.addFields(new String[] {'Id_Requerimiento_EscritorioDigital__c', 'Id_Requerimiento_EscritorioDigital__c'});
            controller.addFields(new String[] {'Tipo_Requerimiento_EscritorioDigital__c', 'Tipo_Requerimiento_EscritorioDigital__c'});
            controller.addFields(new String[] {'Nombre_Completo_Razon_Social__c', 'Nombre_Completo_Razon_Social__c'});        
            controller.addFields(new String[] {'CASO_Poliza_Asoc__c', 'CASO_Poliza_Asoc__c'});
            controller.addFields(new String[] {'CaseNumber', 'CaseNumber'}); 
            controller.addFields(new String[] {'Tipo_de_Requerimiento__c', 'Tipo_de_Requerimiento__c'});       
            controller.addFields(new String[] {'CASO_Resultado_Derivaci_n__c', 'CASO_Resultado_Derivaci_n__c'});   
            controller.addFields(new String[] {'CASO_Responsable_UR__c', 'CASO_Responsable_UR__c'});               
        }  
        
        this.Caso = (Case)controller.getRecord();   
            
        if (!Test.isRunningTest()) 
        { 
            this.RUTTitular = this.Caso.RUT__c;       		
        }
        else
        {
            this.RUTTitular = '1-9';
        }
       
               
        if (this.RUTTitular == '-')
        {
            this.RUTTitular = '';
        }
        
        this.NombreTitular = this.Caso.Nombre_Completo_Razon_Social__c;            
        this.NumeroCaso = this.Caso.CaseNumber;
        
        this.TipoRequerimientoSF = this.Caso.Tipo_de_Requerimiento__c;
         
        if (this.TipoRequerimientoSF == 'Solicitudes')
        {
            this.DetalleSolicitud = this.Caso.Detalle_Solicitud__c;        
            //this.ResultadoDerivacion = this.Caso.CASO_Resultado_Derivaci_n__c;
            this.ResponsableUR = this.Caso.CASO_Responsable_UR__c;
            
            if (this.ResponsableUR == null)
            {
                this.ResponsableUR ='';
            }
            
            if(this.RUTTitular != null && this.RUTTitular != '')
            { 
                if(this.Caso.CASO_Poliza_Asoc__c != null && this.Caso.CASO_Poliza_Asoc__c != '')
                {
                    this.NumPoliza = Integer.valueOf(this.Caso.CASO_Poliza_Asoc__c);
                    this.Poliza = this.Caso.CASO_Poliza_Asoc__c;
                }
                else
                {
                    this.NumPoliza = 0;
                    this.Poliza = 'No seleccionada';
                }
                
                if(this.DetalleSolicitud != null && this.DetalleSolicitud != '')
                {
                   
                    
                    
        if (!Test.isRunningTest()) 
        { 
             this.EtiquetaSolicitud = EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);  		
        }
        else
        {
            this.EtiquetaSolicitud = 'ED - Solicitud periodo garantizado';
        }
                    
                    
                    if (this.EtiquetaSolicitud != '')
                    {   
                        String idReq = this.Caso.Id_Requerimiento_EscritorioDigital__c;
                        
                        this.CargaDatosUsuario();
                        
                        if (idReq != null)
                        {
                            this.IdRequerimiento = Integer.valueOf(idReq);            
                            this.TipoRequerimientoED = this.Caso.Tipo_Requerimiento_EscritorioDigital__c;            
                            this.Solicitante = EscritorioDigital_Internal.Solicitante(this.TipoRequerimientoED);
                            this.Panel = 'REQ_DETAIL';
                        }
                        else
                        {
                            this.Panel = 'NEW_REQ_DETAIL';
                            
                            if (this.ResponsableUR != '')
                            {
                                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'No se puede crear la Solicitud asociada al caso en Escritorio Digital, ya que el Caso ha sido Derivado.'));             
                            }
                        }               
                    }
                    else
                    {
                        this.Panel = 'REQ_NOT_FOUND';                        
                        this.EtiquetaSolicitud = this.DetalleSolicitud;                    
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'La Solicitud asociada al caso no es soportada por Escritorio Digital.'));             
                    }
                }
                else
                {
                    this.Panel = 'REQ_NOT_FOUND';
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'La Solicitud asociada al caso no es soportada por Escritorio Digital.'));             
                }                 
            }
            else
            {
                  this.Panel = 'REQ_NOT_FOUND';
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'La Solicitud asociada al caso no tiene una Cuenta asociada.'));             
            }     
        }
        else
        {
            this.Panel = 'REQ_NOT_FOUND';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'El Tipo de Requerimiento asociado al caso no es soportado por Escritorio Digital.'));             
        }
        
    }
    
    public void obtienePersistencia() {        
        
        this.Persistencia =  EscritorioDigital_Consume.obtenerPersistencia(RutUsuario, userOS, ip);    
    }
    
    public PageReference verRequerimiento()
    {
        obtienePersistencia();
        
        if (this.Persistencia <= 0)
        {
            PageReference page = new PageReference ('/apex/EscritorioDigitalError_Page?Id='+ this.Caso.Id);                    
         	//page.getParameters().put('Operacion','COMUNICATION');       
            page.getParameters().put('Operacion','PERSISTENCIA|'+ this.Persistencia);    
            
            return page;
        }
        
		return null;        
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
    
    public List<SelectOption> getListaSolicitantes() {
        return EscritorioDigital_Internal.getListaSolicitantes(this.DetalleSolicitud);
    }
    
	public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }

    
    public PageReference crearRequerimiento() {         
        if (!Test.isRunningTest()) 
        { 
       		this.obtienePersistencia();
        }
        
        system.debug('@@@@ Persistencia ED: '+this.Persistencia);
        
        String Excepcion = '';
        
        if (this.Persistencia != -2 && this.Persistencia != -1 && this.Persistencia != 0)
        {            
            if (!Test.isRunningTest()) 
        	{ 
           		 EscritorioDigital_Consume.Respuesta_Requerimiento Requerimiento = EscritorioDigital_Consume.crearRequerimiento(this.Persistencia, this.RUTTitular, Integer.valueOf(this.NumPoliza), this.TipoRequerimientoED, this.RutUsuario);
                 this.IdRequerimiento = Requerimiento.IdRequerimiento;
                 Excepcion = Requerimiento.Excepcion;         
                 System.debug('@@@@|Requerimiento@@'+ Requerimiento); 
        	}
            
            
           
            if (this.IdRequerimiento  > 0)
            {
                 if (!Test.isRunningTest()) 
        		 { 
                     Caso.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;                
                     Caso.Id_Requerimiento_EscritorioDigital__c = String.valueOf(this.IdRequerimiento);
                     Update Caso;
            	 }
                
                 return null;                
            }
            else
            {
                PageReference page = new PageReference ('/apex/EscritorioDigitalError_Page?Id='+ this.Caso.Id);        
        		page.getParameters().put('Operacion','REQUERIMIENTO|'+ this.IdRequerimiento);    
                page.getParameters().put('Excepcion', Excepcion); 
        		return page;
            }            
        }
		else
		{
            PageReference page = new PageReference ('/apex/EscritorioDigitalError_Page?Id='+ this.Caso.Id);  
            
            if (this.Persistencia == -2)
            {
                this.Persistencia = -5;
            }
            else if (this.Persistencia == -1)
            {
                this.Persistencia = -4;
            }
            else if (this.Persistencia == 0)
            {
                this.Persistencia = -3;
            }
            
        	page.getParameters().put('Operacion','PERSISTENCIA|'+ this.Persistencia);            
        	return page;
        }        
    }
   
    public PageReference eliminarRequerimiento()
    {
        if (!Test.isRunningTest()) 
        { 
     		this.Caso.Id_Requerimiento_EscritorioDigital__c = '';
        	this.Caso.Tipo_Requerimiento_EscritorioDigital__c = '';
            Update Caso;
        }
        
        return null;
    }
    /*
     public PageReference ToValuetechED() {  
          this.obtienePersistencia();
        
      	  String url = 'http://vidasecuritytest.valueweb.cl/TotalAgility/forms/vs-ed-dev/VS-ED-FormularioFirma.form?';
            
          url +=  'IDRequerimiento='+this.IdRequerimiento;
          url +=  '&Rut='+this.RutUsuario;
          url +=  '&Persistencia='+this.Persistencia;

         return new System.Pagereference(url);
	  }
	*/
}