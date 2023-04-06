public class RequerimientoController {
    
    public string RutTitular {get; set;}
    public String DetalleSolicitud {get; set;}
    public String Requerimiento {get; set;}
    public String Solicitante {get; set;}
    public String TipoRequerimientoED { get; set; }
    public String EstadoRequerimientoED { get; set; }
    public Integer IdRequerimientoED { get; set; }
    public Integer IdPersistenciaED { get; set; }
    public String RutUsuario { get; set; }    
    public String UserOS { get; set; }   
    public String Ip { get; set; }   
    public String ElimAlert { get; set; }
    public Integer ElimResult { get; set; }
    
    public Case Caso{get; set;}
    public String Panel {get; set;}
   // public String RutUsuario {get; set;}
    public RequerimientoController(){}
    
    public void GeneraParametrosInterfaz()
    {        
        if (validaSolicitud() == true)
        {
            this.Panel = 'CRE_REQ';
            
            if (this.IdRequerimientoED != 0)
            {           
                this.getInformacionRequerimiento(); 
                if (EstadoRequerimientoED == 'FINALIZADO')
                {
                    this.Panel = 'FIN_REQ';
                }
                else                    
                {
                    this.Panel = 'VER_REQ';
                }                
            }     
        }
        else            
        {
            this.Panel = 'NUL_REQ';            
        }
        
        if (this.RutUsuario == null || this.RutUsuario  == '')
        {
            this.Panel = 'NUL_USER';
        }        
    }
    
    public RequerimientoController(ApexPages.StandardController controller) {  
       //controller.addFields(new String[] {'RUT_Usuario__c', 'RUT_Usuario__c'});
      controller.addFields(new String[] {'RUT__c', 'RUT__c'});
        controller.addFields(new String[] {'Detalle_Solicitud__c', 'Detalle_Solicitud__c'});
        controller.addFields(new String[] {'Id', 'Id'});
        controller.addFields(new String[] {'Id_Requerimiento_EscritorioDigital__c', 'Id_Requerimiento_EscritorioDigital__c'});
        controller.addFields(new String[] {'Tipo_Requerimiento_EscritorioDigital__c', 'Tipo_Requerimiento_EscritorioDigital__c'});
        controller.addFields(new String[] {'Estado_Requerimiento_EscritorioDigital__c', 'Estado_Requerimiento_EscritorioDigital__c'});
        
        this.RutUsuario = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()][0].RUT_Usuario__c;      
        String apodo = [Select CommunityNickname From User Where Id = :UserInfo.getUserId()][0].CommunityNickname;
        this.UserOS = 'GRP_SECURITY\\SALESFORCE';
        this.Ip = apodo;
        
        this.Caso = (Case)controller.getRecord();
        
        this.RutTitular = Caso.RUT__c;
        //this.RutTitular = '10103133-0';
        this.DetalleSolicitud = Caso.Detalle_Solicitud__c;
        this.IdRequerimientoED = 0;
        if (this.Caso.Id_Requerimiento_EscritorioDigital__c != null)
        {  
            this.IdRequerimientoED = Integer.valueOf(Caso.Id_Requerimiento_EscritorioDigital__c);
            this.TipoRequerimientoED = Caso.Tipo_Requerimiento_EscritorioDigital__c;
            this.EstadoRequerimientoED = this.Caso.Estado_Requerimiento_EscritorioDigital__c;
        }
       
        
        GeneraParametrosInterfaz();      
    }
    
    public boolean validaSolicitud() {
      return EscritorioDigital.ValidaSolicitud(DetalleSolicitud);        
    }
    
    public List<SelectOption> getTiposSolicitante() {
        List<SelectOption> options = new List<SelectOption>();
        boolean exito = false;
        if (DetalleSolicitud == 'Solicitud pensión sobrevivencia')
        {
            options.add(new SelectOption('RRVVTIPO0001','Conyuge'));
            options.add(new SelectOption('RRVVTIPO0002','Madre Filiación'));
            options.add(new SelectOption('RRVVTIPO0003','Hijo menor 18 años'));
            options.add(new SelectOption('RRVVTIPO0004','Hijo mayor 18 años'));                    
            exito = true;
        }
        else if  (DetalleSolicitud == 'Solicitud cuota mortuoria')
        {
            options.add(new SelectOption('RRVVTIPO0005','Persona o Entidad que realiza el gasto'));  
            //options.add(new SelectOption('RRVVTIPO0005','Beneficiario'));  
            exito = true;
        }
        else if  (DetalleSolicitud == 'Solicitud cambio pago pensión')
        {
            options.add(new SelectOption('RRVVTIPO0006','Rentista Titular'));            
            exito = true;
        }
        /*else if  (DetalleSolicitud == 'Solicitud de ingreso poder notarial')
        {
            options.add(new SelectOption('RRVVTIPO0007','Rentista Titular'));            
            exito = true;
        }*/
        else if  (DetalleSolicitud == 'Solicitud periodo garantizado')
        {
            options.add(new SelectOption('RRVVTIPO0008','Rentista Titular'));            
            exito = true;
        }
        else if  (DetalleSolicitud == 'Solicitud de incorporación/ Renovación asignación familiar')
        {
            //options.add(new SelectOption('RRVVTIPO0010','Cónyuge'));                        
            //options.add(new SelectOption('RRVVTIPO0011','Hijo menor de 18 años'));            
            //options.add(new SelectOption('RRVVTIPO0012','Hijo mayor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0013','Afiliado Titular'));            
            //options.add(new SelectOption('RRVVTIPO0014','Madre o Padre (Ascendente)'));            
            exito = true;
        }
      /*  else if  (DetalleSolicitud == 'Declaración Ingresos nuevos beneficiarios')
        {
            options.add(new SelectOption('RRVVTIPO0015','Afiliado Titular')); 
            exito = true;
        }*/
        else if  (DetalleSolicitud == 'Declaración Ingresos Actualización')
        {
            options.add(new SelectOption('RRVVTIPO0016','Afiliado Titular')); 
            exito = true;
        }
        else if  (DetalleSolicitud == 'Solicitud de Extinción')
        {            
            options.add(new SelectOption('RRVVTIPO0017','Cónyuge'));                        
            options.add(new SelectOption('RRVVTIPO0018','Hijo menor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0019','Hijo mayor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0020','Otros'));            
            options.add(new SelectOption('RRVVTIPO0021','Madre o Padre (Ascendente)'));            
            exito = true;
        }
        else if  (DetalleSolicitud == 'Solicitud garantía estatal')
        {
            options.add(new SelectOption('RRVVTIPO0022','Afiliado Titular'));            
            options.add(new SelectOption('RRVVTIPO0023','Cónyuge'));            
            options.add(new SelectOption('RRVVTIPO0024','Madre Filiación N/M'));            
            options.add(new SelectOption('RRVVTIPO0025','Hijo menor de 18 años'));            
            options.add(new SelectOption('RRVVTIPO0026','Hijo mayor de 18 años'));            
            exito = true;
        }       
        else if (DetalleSolicitud == 'Renuncia Garantía Estatal')
        {
            options.add(new SelectOption('RRVVTIPO0027','Afiliado Titular')); 
            exito = true;
        }       

        if (exito == false)        
        {
            this.Panel = 'NUL_REQ';           
        }

        return options; 
    }
    
    public void getInformacionRequerimiento()
    {     
        this.Requerimiento =  EscritorioDigital.Requerimiento(this.TipoRequerimientoED);
        this.Solicitante = EscritorioDigital.Solicitante(this.TipoRequerimientoED); 
    }
    
    public string getNombreFormulario() {
      return EscritorioDigital.Formulario(this.DetalleSolicitud);              
    }
    
    public void crearRequerimiento() {  
        this.IdPersistenciaED  = EscritorioDigitalNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);
 	    if (this.IdPersistenciaED != -6 && this.IdPersistenciaED != -1 && this.IdPersistenciaED != 0)
        {            
            nuevoRequerimiento();                     
        }              
    }
    
    public void nuevoRequerimiento()
    {
		this.IdRequerimientoED = EscritorioDigitalNegocio.crearRequerimiento(this.IdPersistenciaED , this.RutTitular, this.TipoRequerimientoED, this.RutUsuario);
        if (this.IdRequerimientoED  != -2 && this.IdRequerimientoED  != -1 && this.IdRequerimientoED  != 0)
        {            
            Caso.Estado_Requerimiento_EscritorioDigital__c = 'NUEVO';//estado inicial al crear un requerimiento en ED
            Caso.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;                
            Caso.Id_Requerimiento_EscritorioDigital__c = String.valueOf(this.IdRequerimientoED);
            Update Caso;
        }   
    }
            
    public void verRequerimiento() {  
        this.IdPersistenciaED  = EscritorioDigitalNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);        
    }
    
    public void eliminarRequerimiento() {    
       this.IdPersistenciaED  = EscritorioDigitalNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);
        if (this.IdPersistenciaED > 0)
        {            
            eliminaRequerimiento();             
        }       
    }
    
    public void eliminaRequerimiento() {           
        if (this.IdPersistenciaED > 0)
        {            
            String Result =  EscritorioDigitalNegocio.cambiarEstadoRequerimiento(this.IdPersistenciaED , this.IdRequerimientoED, 'ANULADO', this.RutUsuario);               
            if (Result == 'ok')
            {
                Caso.Id_Requerimiento_EscritorioDigital__c = null;//''
                Caso.Tipo_Requerimiento_EscritorioDigital__c = null;  //''   
                Caso.Estado_Requerimiento_EscritorioDigital__c = null;  //''
                this.IdRequerimientoED = 0;
                //this.IdPersistenciaED = 0;
                this.TipoRequerimientoED ='';
                this.ElimResult = 0;
                update Caso;                
            }
            else
            {                    
                this.ElimAlert = Result;
                this.ElimResult = this.IdRequerimientoED;
            }                 
        }       
    }
    
    /*
    //a implementar en posterior Webservice Salesforce
    public void finalizarRequerimiento() {    
        this.IdPersistenciaED  = EscritorioDigitalNegocio.obtenerPersistencia(this.RutUsuario, this.UserOS, this.Ip);
        if (this.IdPersistenciaED != 0)
        {            
            boolean Result =  EscritorioDigitalNegocio.cambiarEstadoRequerimiento(this.IdPersistenciaED , this.IdRequerimientoED, 'FINALIZADO', this.RutUsuario);               
            if (Result == true)
            {               
                Caso.Estado_Requerimiento_EscritorioDigital__c = 'FINALIZADO';  //''
                update Caso;                
            }
        }        
    }
  */
}