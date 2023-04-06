/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-10-2020
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   07-10-2020   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public  class CTR_AperturaCierreCaso {
    
    public String IDCASO {get; set;}
    public Case Caso {get; set;}    
    public Boolean Botonera {get; set;} 
    public String CODMENSAJE {get; set;}
    public String Poliza {get; set;}

    /*************************************************** Caso  Atención ***************************************************/
 
    //Cierre de Caso Atencion    
    public PageReference CierreAtencion_cargaCaso(){
        try
        {
            this.CODMENSAJE = '';

            this.IDCASO = apexpages.currentpage().getparameters().get('id');

            User UsuarioSF = [SELECT Id, ProfileId FROM User WHERE Id =: UserInfo.getUserId()];

            Profile perfil = [SELECT Id FROM Profile WHERE Name =  'BI'];
    
            Boolean perfilExcepcion = false;

            if (UsuarioSF.ProfileId == perfil.Id)
            {
                perfilExcepcion = true;
            }  

            System.debug('@@@@|IDCASO '+ this.IDCASO); 
            
            List<Case> Hijos = new List<Case>();            
            
            if(this.IDCASO != '')
            {
                this.Caso = GetCaso(IDCASO);                           
                
                if (perfilExcepcion == false)
                {
                    if(String.isBlank(this.Caso.Tipo_de_Solicitante__c) || String.isBlank(this.Caso.Negocio__c))
                    {
                        this.CODMENSAJE = 'campos_vacios';     
                    }    
                }
                
                if (String.isBlank(this.CODMENSAJE))
                {
                    if (this.Caso.Status == 'En Proceso' || this.Caso.Status == 'Nuevo')
                    {                    
                        Hijos = [SELECT Id, Status FROM Case WHERE Status != 'Rechazado' AND Status != 'Basura' 
                        AND Status != 'Cerrado' AND Status != 'Cerrado (Correo Duplicado)' AND Status != 'Cerrado (Correo Masivo)' 
                        AND ParentId =: this.IDCASO];                    
                    }
                    
                    System.debug('@@@@|Hijos.size '+Hijos.size()); 
                    
                    if (Hijos.size() > 0)
                    {
                        this.CODMENSAJE = 'hijos_sin_cerrar';               
                    }
                    else {
                        this.Caso.Casos_Hijos_cerrados__c = true;
                        update this.Caso;
                    }
                }
                
                return null;                
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public PageReference CierreAtencion_guardarCaso()
    {   
        try {
            this.Caso.Status = 'Cerrado';
            this.Caso.Entrega_Respuesta__c = true;
             update this.Caso;    
        } catch (Exception ex) {
            System.debug('@@@@ ERROR --> '+ex);
        }    
        
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;            
    }
    //Cierre de Caso Atencion
    

    //Apertura de Caso Atencion   
    public PageReference AperturaAtencion_cargaCaso(){
        try
        {
            this.IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
            
            if(this.IDCASO != '')
            {
                this.Caso = GetCaso(IDCASO);
               	                               
                if (this.Caso.Status != 'Cerrado')
                {                     
                   PageReference page = new PageReference ('/apex/SEC_VF_CS_AperturaAtencion_Error?id='+ this.IDCASO); 
                   page.setRedirect(true);
      			   return page;
                }
                
                return null;                
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public PageReference AperturaAtencion_cargaCasoError(){
        try
        {
            this.IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+ this.IDCASO); 
            
            if(this.IDCASO != ''){
                this.Caso = GetCaso(IDCASO);               		

                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No se puede cambiar el Estado del Caso seleccionado ya que este no se encuentra actualmente en Estado Cerrado.'));
                
                return null;
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public PageReference AperturaAtencion_GuardarCaso()
    {
        this.Caso.Status = 'En Proceso'; 
        this.Caso.Entrega_Respuesta__c = false;
        update this.Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }

    //Apertura de Caso Atencion   
    
    /*************************************************** Caso  Atención ***************************************************/


    /*************************************************** Caso  Requerimiento ***************************************************/

    //Cierre de Caso Requerimiento

    public PageReference CierreRequerimiento_cargaCaso(){
        try
        {
            this.IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+ this.IDCASO); 
                        
            if(this.IDCASO != ''){
              	this.Caso = GetCaso(IDCASO);
               	
/*
                if (this.Caso.Tipo_de_Requerimiento__c == 'Reclamos')
                {
                    Map<Id, Attachment> mapAdjuntos = New Map<Id, Attachment>([Select Id, ParentId, Name from Attachment where ParentId =: this.IDCASO]);

                    Boolean tieneCartaClienteCheck = false;
                    Boolean tieneAdjuntoCartaRespuesta = false;
                    Boolean tieneAdjuntoCartaCliente = false;
                    
                    for (Attachment a : mapAdjuntos.values()) {
                        
                        // Val 1: Carta respuesta reclamo ejecutiva
                        if (a.Name.StartsWithIgnoreCase('RESPUESTA') ){
                            tieneAdjuntoCartaRespuesta = true;
                            continue;
                        }                
                    }
                    // Si el caso no tiene carta de respuesta.
                    if (!tieneAdjuntoCartaRespuesta){
                        CODMENSAJE = 'adjunto_respuesta';
                        //c.addError('No se ha adjuntado la carta de respuesta, no se puede cerrar el reclamo. El nombre del archivo debe empezar por \'Respuesta\'.');
                        //continue;
                    }
                
                }
                */
                String mensajeError = '';

                if (this.Caso.Status == 'En Proceso')//
                {
                    mensajeError = 'caso_enproceso_sinasignar';                       
                }
                else if (this.Caso.Status == 'Nuevo')//
                {
                    mensajeError = 'caso_nuevosinasignar';                       
                }               
                
                List<asignacion_UR__c> asignaciones = [select Id from asignacion_UR__c where Detalle_Solicitud__c =: this.Caso.Detalle_Solicitud__c and Responsable__c != null]; 
                system.debug('@@@@ Detalle_Solicitud__c --> '+ this.Caso.Detalle_Solicitud__c);
                system.debug('@@@@ Asignaciones UR --> '+asignaciones);
                if (asignaciones.size() > 0)
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_CS_CierreRequerimiento_Error?id='+ this.IDCASO+'&mensaje='+mensajeError);                    
                    page.setRedirect(true);
                    return page;
                }
                                
                return null;
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    public PageReference CierreRequerimiento_cargaCasoError(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            String mensajeError = apexpages.currentpage().getparameters().get('mensaje');
            System.debug('@@@@|IDCASO '+IDCASO); 
            Botonera = false;
                        
            if(IDCASO != '')
            {
           		this.Caso = GetCaso(IDCASO);
               
                Caso.Entrega_Respuesta__c = false;
                
                if (mensajeError == 'caso_enproceso_sinasignar')
                {
                    Botonera = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'El Requerimiento que desea Cerrar posee asignadas Reglas de Derivación a UR.'));                
                } 
                else if (mensajeError == 'caso_nuevosinasignar')
                {
                    Botonera = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'El Requerimiento que desea Cerrar posee asignadas Reglas de Derivación a UR.'));                
                }
                
                return null;
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
        
    public PageReference CierreRequerimiento_guardarCaso()
    {
        this.Caso.Status = 'Cerrado';
        this.Caso.Entrega_Respuesta__c = true;
        update this.Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }

    //Cierre de Caso Requerimiento

    //Apertura de Caso Requerimiento

   public PageReference AperturaRequerimiento_validaAtencion()
   {
       try
        {
            this.IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+this.IDCASO); 
                        
            if(IDCASO != ''){
                
                Case CasoPrincipal = new Case();
                
                this.Caso = [SELECT Id, ParentId
                             FROM Case
                             WHERE Id =: this.IDCASO];
                
                CasoPrincipal = [select Id, Status from Case where ID =: this.Caso.ParentId][0];
                              
                if (CasoPrincipal.Status == 'Cerrado' ||  CasoPrincipal.Status == 'Cerrado (Correo Duplicado)' || CasoPrincipal.Status == 'Cerrado (Correo Masivo)') 
                {
                    this.CODMENSAJE = 'caso_padre_cerrado';
                    return null;
                }
                else
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_CS_AperturaRequerimiento?id='+ this.IDCASO);                    
                    page.setRedirect(true);
                    return page;
                }                
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
   }
    
    public PageReference AperturaRequerimiento_cargaCaso(){
        try
        {
            this.IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+ this.IDCASO); 
                        
            if(this.IDCASO != ''){
               // this.Caso = new Case();
               
                //if (!Test.isRunningTest()) 
                //{
                    this.Caso = GetCaso(IDCASO);
               		/* this.Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId, ParentId
                               FROM Case
                               WHERE Id =: this.IDCASO];*/
                //}
                                
                
                return null;
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }
        catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
    }
    
    
    public PageReference AperturaRequerimiento_GuardarCaso()
    {
        this.Caso.Status =  'En Proceso';
        this.Caso.Entrega_Respuesta__c = false;
        update this.Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }

    //Apertura de Caso Requerimiento

    /*************************************************** Caso  Requerimiento ***************************************************/

    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }
    
    public Case GetCaso(String Id)
    {
        this.Poliza = 'No Seleccionada';
        try
        {
            Case caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId, ParentId, CASO_Deriva_a_UR__c, Casos_Hijos_cerrados__c, Tipo_de_Solicitante__c  
                               FROM Case
                               WHERE Id =: Id];
        
            if (String.isBlank(this.Caso.CASO_N_Poliza__c) == false)
            {
                this.Poliza = this.Caso.CASO_N_Poliza__c;
            }
            
            return caso;
        }
        catch(Exception ex)
        {          
            return null;
        }
        
        
    }
}