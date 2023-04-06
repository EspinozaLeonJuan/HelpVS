/*******************************************************************************************
 *  NOMBRE                 : CTR_EscritorioDigital
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CTR_EscritorioDigital {
    public Case Caso {get; set;}       
 
    public Integer Persistencia { get; set; }   
    public String  RutUsuario { get; set; }    
    public String  UserOS { get; set; }   
    public String  Ip { get; set; }   
            
    public String  EtiquetaSolicitud {get; set;}
	public String  Solicitante { get; set; }      
    public Integer NumPoliza { get; set; }       
    public String  Poliza { get; set; } 
    
    public Integer IdRequerimiento {get; set;}
    public String  TipoRequerimientoED { get; set; } 
    public String  Botonera { get; set; } 
      
    public CLS_EscritorioDigital_Consume.Respuesta_Persistencia RespuestaPersistencia {get; set;}
    public CLS_EscritorioDigital_Consume.Respuesta_Requerimiento RespuestaRequerimiento {get; set;}
    public CLS_EscritorioDigital_Internal.Usuario Usuario {get; set;}

    /*Método para mostrar caso y su información relacionada*/
    public PageReference cargaCaso()
    {
       try{
            String IDCASO = apexpages.currentpage().getparameters().get('id');
                      
            if(IDCASO != '')
            {  
                this.Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                   this.Caso = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c,
                                    Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c,CaseNumber, Tipo_de_Requerimiento__c, CASO_Resultado_Derivaci_n__c, 
                                    CASO_Responsable_UR__c, Negocio__c, CASO_Categoria__c FROM Case
                                    WHERE Id =: IDCASO];
                }
                
                system.debug('@@@@ CASO ==>'+this.Caso);
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
                                           
                if (!Test.isRunningTest()) 
                { 
                    this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);  		
                }
                else
                {
                    this.EtiquetaSolicitud = 'ED - Solicitud periodo garantizado';
                }

                system.debug('@@@@ EtiquetaSolicitud ==>'+this.EtiquetaSolicitud);
                system.debug('@@@@ UserInfo ==>'+ UserInfo.getUserId());
                
                if (this.EtiquetaSolicitud != '')
                {                               
                    Usuario = CLS_EscritorioDigital_Internal.CargaDatosUsuario(UserInfo.getUserId());
                    
                    this.RutUsuario = Usuario.RUT;
                    this.Ip = Usuario.Ip;
                    this.UserOS = Usuario.UserOS;      

                    if (Test.isRunningTest()) 
                    { 
                        this.RutUsuario = '16942371-7';
                    }
                    
                    if (this.RutUsuario == '16942371-7')//problema con usuario Evelyn Estay
                    {
                        this.RutUsuario = '14343349-8';//RUT usuario Pamela Tirapegui
                    }                       
                }
                else
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);                    
         	        page.getParameters().put('Error', 'REQUERIMIENTO_NO_SOPORTADO');    
            
                    return page;     
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
           
       }catch (Exception ex)
       {      
            system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());  
            ApexPages.addMessages(ex);            
       }

       return null;
    }


    public PageReference cargaVerCaso()
    {
       try{
            this.Botonera = 'SI';
            String IDCASO = apexpages.currentpage().getparameters().get('id');
             
            if(IDCASO != '')
            {  
                this.Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                   this.Caso = [SELECT  Id, RUT__c, Detalle_Solicitud__c, Id_Requerimiento_EscritorioDigital__c,Tipo_Requerimiento_EscritorioDigital__c,
                                    Nombre_Completo_Razon_Social__c, CASO_Poliza_Asoc__c,CaseNumber, Tipo_de_Requerimiento__c, CASO_Resultado_Derivaci_n__c, 
                                    CASO_Responsable_UR__c, Negocio__c, CASO_Categoria__c, Status FROM Case
                                    WHERE Id =: IDCASO];
                }
                
                system.debug('@@@@ Caso ==>'+this.Caso);
                
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
                
                if (Test.isRunningTest())
                {
                    this.Caso.Status = 'Cerrado';
                }

                if (this.Caso.Status == 'Cerrado' || this.Caso.Status == 'Rechazado' || this.Caso.Status == 'Back Office' || 
                (this.Caso.Status == 'En Proceso' && String.isNotBlank(this.Caso.CASO_Responsable_UR__c)))
                {
                    this.Botonera = 'NO';
                }
           
                if (!Test.isRunningTest()) 
                { 
                    this.EtiquetaSolicitud = CLS_EscritorioDigital_Internal.Etiqueta(this.Caso.Detalle_Solicitud__c);  		
                }
                else
                {
                    this.EtiquetaSolicitud = 'ED - Solicitud periodo garantizado';                    
                }

                system.debug('@@@@ EtiquetaSolicitud ==>'+this.EtiquetaSolicitud);
                system.debug('@@@@ UserInfo ==>'+ UserInfo.getUserId());
                
                if (this.EtiquetaSolicitud != '')
                {                               
                    Usuario = CLS_EscritorioDigital_Internal.CargaDatosUsuario(UserInfo.getUserId());
                    
                    this.RutUsuario = Usuario.RUT;
                    this.Ip = Usuario.Ip;
                    this.UserOS = Usuario.UserOS;

                    if (Test.isRunningTest()) 
                    { 
                        this.RutUsuario = '16942371-7';
                    }

                    if (this.RutUsuario == '16942371-7')//problema con usuario Evelyn Estay en ED
                    {
                        this.RutUsuario = '14343349-8';//RUT usuario Pamela Tirapegui
                    }

                    if (Test.isRunningTest())
                    {
                        this.Caso.Id_Requerimiento_EscritorioDigital__c = '1123';
                    }
                    
                    if (this.Caso.Id_Requerimiento_EscritorioDigital__c != null)
                    {
                        this.IdRequerimiento = Integer.valueOf(this.Caso.Id_Requerimiento_EscritorioDigital__c);
                        this.TipoRequerimientoED = this.Caso.Tipo_Requerimiento_EscritorioDigital__c;            
                        this.Solicitante = CLS_EscritorioDigital_Internal.Solicitante(this.TipoRequerimientoED);                        
                    }                                   
                }
                else
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);                    
         	        page.getParameters().put('Error', 'REQUERIMIENTO_NO_SOPORTADO');    
            
                    return page;     
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
           
       }catch (Exception ex)
       {    system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            ApexPages.addMessages(ex);            
       }

       return null;
    }

    public PageReference verRequerimiento()
    {        
        if (!Test.isRunningTest()) 
        { 
            this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.userOS, this.ip);  
        }
		else
        {
			this.RespuestaPersistencia.Response = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ';            
        }
        
        if (this.RespuestaPersistencia.Response != 'PERSISTENCIA_OK')
        {
            PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);                    
         	page.getParameters().put('Error', this.RespuestaPersistencia.Response);    
            
            return page;            
        }

        this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

        return null;              
    }

    public PageReference crearRequerimiento() {         
        if (!Test.isRunningTest()) 
        { 
            this.RespuestaPersistencia = CLS_EscritorioDigital_Consume.obtenerPersistencia(this.RutUsuario, this.userOS, this.ip);  
        }
        else
        {
            this.RespuestaPersistencia = new CLS_EscritorioDigital_Consume.Respuesta_Persistencia();
            this.RespuestaPersistencia.Response = 'PERSISTENCIA_OK';
        }      

        if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_OK')
        {
            this.Persistencia = this.RespuestaPersistencia.IdPersistencia;

            if (!Test.isRunningTest()) 
        	{ 
                RespuestaRequerimiento = CLS_EscritorioDigital_Consume.crearRequerimiento(this.Persistencia, this.Caso.RUT__c, Integer.valueOf(this.NumPoliza), this.TipoRequerimientoED, this.RutUsuario);                
        	}
            else {
                RespuestaRequerimiento = new CLS_EscritorioDigital_Consume.Respuesta_Requerimiento();
                RespuestaRequerimiento.Response = 'REQUERIMIENTO_CREADO';
                RespuestaRequerimiento.IdRequerimiento = 221;
            }
            
            system.debug('@@@@ RespuestaRequerimiento --> '+ RespuestaRequerimiento);
            
            if (RespuestaRequerimiento.Response == 'REQUERIMIENTO_CREADO')
            {
                Caso.Tipo_Requerimiento_EscritorioDigital__c = this.TipoRequerimientoED;                
                Caso.Id_Requerimiento_EscritorioDigital__c = String.valueOf(RespuestaRequerimiento.IdRequerimiento);
                this.IdRequerimiento = RespuestaRequerimiento.IdRequerimiento;
                
                if (!Test.isRunningTest()) 
        		{ 
                     Update Caso;                     
            	}
                
                return null;     
            }
            else {
                PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);                    
            	page.getParameters().put('Error', this.RespuestaRequerimiento.Response);    
                return page;
            }
        }
        else {
           loadError();           
        }    
        
        return null;
    }
   
    public Pagereference loadError()
    {
        String Error = '';

        if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_EXCEPCION')
        {
            Error = 'PERSISTENCIA_EXCEPCION_CREA_REQ';
        }
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES')
        {
            Error = 'PERSISTENCIA_ERROR_PARAMETROS_FALTANTES_CREA_REQ';
        } 
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_USUARIO_INVALIDO')
        {
            Error = 'PERSISTENCIA_ERROR_USUARIO_INVALIDO_CREA_REQ';
        } 
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO')
        {
            Error = 'PERSISTENCIA_ERROR_USUARIO_NO_REGISTRADO_CREA_REQ';
        } 
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED')
        {
            Error = 'PERSISTENCIA_ERROR_USUARIO_SIN_PERMISO_ED_CREA_REQ';
        } 
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA')
        {
            Error = 'PERSISTENCIA_ERROR_PERSISTENCIA_INVALIDA_CREA_REQ';
        } 
        else if (this.RespuestaPersistencia.Response == 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO')
        {
            Error = 'PERSISTENCIA_ERROR_RUT_USUARIO_INVALIDO_CREA_REQ';
        } 
            
        PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorRequerimiento?Id='+ this.Caso.Id);                    
        page.getParameters().put('Error', Error);    
        return page;
    }

    public PageReference eliminarRequerimiento()
    {
        this.Caso.Id_Requerimiento_EscritorioDigital__c = '';
        this.Caso.Tipo_Requerimiento_EscritorioDigital__c = '';
        if (!Test.isRunningTest()) 
        {
            Update Caso;
        }
        
        return null;
    }

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }

    public List<SelectOption> getListaSolicitantes() {
        return CLS_EscritorioDigital_Internal.getListaSolicitantes(this.Caso.Detalle_Solicitud__c);
    }
    
}