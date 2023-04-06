public class EscritorioDigitalError_Controller {
    public Case Caso {get; set;}   
    
    public String RUTTitular { get; set; }     
    public String NombreTitular { get; set; }     
    public String CodigoSolicitud { get; set; }     
    public String DetalleSolicitud { get; set; }  
    public String EtiquetaSolicitud {get; set;}
    public String Solicitante { get; set; }      
    public Integer NumPoliza { get; set; }     
    public String Poliza { get; set; } 
    
    public String IdRequerimiento {get; set;}
    public String TipoRequerimiento { get; set; } 
    
    public String TipoRequerimientoSF { get; set; } 
    
    public String Solicitud { get; set; } 
    public String NumeroCaso { get; set; } 
    
    public String Panel { get; set; }  
    public String Operacion { get; set; }
    public String Excepcion { get; set; }
    public String MensajeDerivarCaso { get; set; }
    
    public String ErrorDerivacion {get; set;}
    
    public String ID {get; set;}
    
    public EscritorioDigitalError_Controller()
    {
        
    }
    
    public void LoadAlerta()
    {
        if (!Test.isRunningTest()) 
        { 
            this.Operacion = Apexpages.currentPage().GetParameters().get('Operacion');
        }
        
        
        if (this.Operacion.contains('REQUERIMIENTO'))
        {
            if (!Test.isRunningTest()) 
      	    { 
          	   this.Excepcion = Apexpages.currentPage().GetParameters().get('Excepcion');
            }
                       
            if (this.Operacion == 'REQUERIMIENTO|-7')
            {
           		 ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error inesperado en la Creación del Requerimiento, favor intente nuevamente. Si el error continua favor comuniquese con los administradores del Sistema.'));            
            }
            else
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, Excepcion));
            }
        }
        else
        {
            if (this.Operacion == 'PERSISTENCIA|-5')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error de Comunicación con Escritorio Digital, el Requerimiento no ha sido generado.'));           
            }
            else if (this.Operacion == 'PERSISTENCIA|-4')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error de Auntenticacion en Escritorio Digital, el Requerimiento no ha sido generado.')); 
            }
            else if (this.Operacion == 'PERSISTENCIA|-3')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error, el Requerimiento no ha sido generado en Escritorio Digital.')); 
            }
            else if (this.Operacion == 'PERSISTENCIA|-2')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'));           
            }
            else if (this.Operacion == 'PERSISTENCIA|-1')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.')); 
            }
            else if (this.Operacion == 'PERSISTENCIA|0')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.'));          
            }
            else if (this.Operacion == 'DERIVARCASO|1')
            {
                this.ErrorDerivacion = 'SI';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'El Usuario actual no tiene un RUT válido ingresado.'));          
                MensajeDerivarCaso = 'El Usuario actual no tiene un RUT válido ingresado.';
            }
            else if (this.Operacion == 'DERIVARCASO|-3')
            {
                this.ErrorDerivacion = 'SI';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));          
                MensajeDerivarCaso = 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.';
            }
            else if (this.Operacion == 'DERIVARCASO|3')
            {
                this.ErrorDerivacion = 'SI';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));          
                MensajeDerivarCaso = 'Se ha producido un error al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.';
            }
            else if (this.Operacion == 'DERIVARCASO|4')
            {
                this.ErrorDerivacion = 'SI';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'El Requerimiento asociado al Caso, no ha sido creado en Escritorio Digital.'));          
                MensajeDerivarCaso = 'El Requerimiento asociado al Caso, no ha sido creado en Escritorio Digital.';
            } 
            else if (this.Operacion == 'DERIVARCASO|6')
            {               
                if (!Test.isRunningTest()) 
                { 
                    MensajeDerivarCaso = Apexpages.currentPage().GetParameters().get('MensajeDerivarCaso');
                }
                if (MensajeDerivarCaso != '')
                {
                    if (!Test.isRunningTest()) 
                    { 
                       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, MensajeDerivarCaso));    
                    }            	
                }
                else
                {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error inesperado Tmp. Derivacion'));    
                    MensajeDerivarCaso = 'Error inesperado Tmp. Derivacion';
                }
                this.ErrorDerivacion = 'SI';
            } 
            else if (this.Operacion == 'DERIVARCASO|7')
            {
                this.ErrorDerivacion = 'NO';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Actualmente no es posible derivar este tipo de Requerimiento.'));          
                MensajeDerivarCaso = 'Actualmente no es posible derivar este tipo de Requerimiento.';
            } 
            else if (this.Operacion == 'CAMBIOESTADO|-1')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error inesperado al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));          
            }
            else if (this.Operacion == 'CAMBIOESTADO|2')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Se ha producido un error al intentar cambiar el Estado del Requerimiento en Escritorio Digital, inténtelo nuevamente, en caso de que el error persista comuniquese con el Administrador del Sistema.'));          
            }
            else if (this.Operacion == 'CAMBIOESTADO|3')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error de Auntenticacion en Escritorio Digital. Revise datos de Usuario.'));          
            }
            else if (this.Operacion == 'COMUNICATION')
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Ha ocurrido un error de Comunicación con Escritorio Digital, intente mas tarde.')); 
            }
            else 
            {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, this.Operacion));          
            }                                
   		}
    }
    
    public EscritorioDigitalError_Controller(ApexPages.StandardController controller)
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
        }
        
        this.ErrorDerivacion = '';
        this.Caso = (Case)controller.getRecord();  
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
        this.ID = this.Caso.Id;
        this.NumeroCaso = this.Caso.CaseNumber;
        this.RUTTitular = this.Caso.RUT__c;
        this.NombreTitular = this.Caso.Nombre_Completo_Razon_Social__c;
        this.DetalleSolicitud = this.Caso.Detalle_Solicitud__c;  
        
     //   String DetalleSolicitud = EscritorioDigital_Internal.CodigoSolicitud(this.DetalleSolicitud);
        
        this.EtiquetaSolicitud = EscritorioDigital_Internal.Etiqueta(this.DetalleSolicitud);
        
        if (EtiquetaSolicitud == '')
        {
         	this.EtiquetaSolicitud = this.DetalleSolicitud;   
        }
            
        
        
        this.TipoRequerimientoSF = this.Caso.Tipo_de_Requerimiento__c;
        
        if (this.Caso.Id_Requerimiento_EscritorioDigital__c != null && this.Caso.Id_Requerimiento_EscritorioDigital__c != '')
        {
            this.IdRequerimiento = this.Caso.Id_Requerimiento_EscritorioDigital__c;
            this.TipoRequerimiento = this.Caso.Tipo_Requerimiento_EscritorioDigital__c;
            
            /*    if (this.Caso.Tipo_Requerimiento_EscritorioDigital__c !=  null  && this.Caso.Tipo_Requerimiento_EscritorioDigital__c != '')
{
this.Solicitante = EscritorioDigital_Internal.Solicitante(this.TipoRequerimiento);
}
*/           
            
            this.Solicitante = EscritorioDigital_Internal.Solicitante(this.TipoRequerimiento);
            this.Panel = 'REQ_DETAIL';
        }
        else
        {
            this.Panel = 'REQ_NOT_FOUND';
        }
        
        if (!Test.isRunningTest()) 
        { 
            this.LoadAlerta();
        }
    }
    
    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.ID);
        return page;
    }

	public PageReference eliminarRequerimiento()
    {
     	this.Caso.Id_Requerimiento_EscritorioDigital__c = '';
        this.Caso.Tipo_Requerimiento_EscritorioDigital__c = '';
        Update Caso;
        
        return null;
    }
    
   
    
}