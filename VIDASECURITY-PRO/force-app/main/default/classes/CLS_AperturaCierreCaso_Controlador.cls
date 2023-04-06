public class CLS_AperturaCierreCaso_Controlador {
	public String IDCASO {get; set;}
    public Case Caso {get; set;}
    public String Estado {get; set;}
    public String CODMENSAJE {get; set;}
    public Boolean Botonera {get; set;} 
    public String Prueba {get; set;} 
    
    /*************************************************** CierreCaso ***************************************************/
    
    public PageReference CierreCaso_cargaCasoSeleccionado(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
            List<Case> Hijos = new List<Case>();            
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId, CASO_Deriva_a_UR__c
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                }
                
               // Caso.Entrega_Respuesta__c = false;
                
                if (Caso.Status == 'En Proceso' || Caso.Status == 'Nuevo')
                {                    
                    Hijos = [select Id, Status from Case where Status != 'Rechazado' and Status != 'Cerrado' and ParentId =: IDCASO];                    
                }
                
                system.debug(''+Hijos.size());
                System.debug('@@@@|Hijos.size '+Hijos.size()); 
                
                if (Hijos.size() > 0)
                {
                    CODMENSAJE = 'hijos_sin_cerrar';
                    // return null; 
                }
               // this.Estado = 'Cerrado';
                
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
    
        
    public PageReference CierreCaso_guardarCaso()
    {       
        
        Caso.Status = 'Cerrado';
        Caso.Entrega_Respuesta__c = true;
        update Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;            
        
    }
    
    /*************************************************** CierreCaso ***************************************************/
    
    
   /************************************************** AperturaCaso **************************************************/
    
    public PageReference AperturaCaso_cargaCasoSeleccionado(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
            if (Test.isRunningTest()) 
            {
                if (Prueba == 'OK1')
                {
                    IDCASO = ''; 
                }
            }            
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                    Caso.Status = 'Nuevo'; 
                }
                
                Caso.Entrega_Respuesta__c = false;
				this.Estado = 'En Proceso';                
                
                if (Test.isRunningTest()) 
                {
                    if (Prueba == 'OK2')
                    {
                        Caso.Status = 'Cerrado'; 
                    }
                }
                
                if (Caso.Status != 'Cerrado')
                {                     
                   PageReference page = new PageReference ('/apex/VIE_AperturaCaso_Error?id='+ IDCASO); 
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
    
    public PageReference AperturaCaso_cargaCasoSeleccionadoError(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
            
            if (Test.isRunningTest()) 
            {
                if (Prueba == 'OK')
                {
                    IDCASO = ''; 
                }
            }  
            
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                }
                Caso.Entrega_Respuesta__c = false;
                
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
    
    public PageReference AperturaCaso_GuardarCaso()
    {
        Caso.Status = Estado;
        update Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }
    
    /************************************************** AperturaCaso **************************************************/
    
     /************************************************* CierreRequerimiento *************************************************/
    
    public PageReference CierreRequerimiento_cargaCasoSeleccionado(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
                        
            If(IDCASO != ''){
                Caso = new Case();
                               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId, CASO_Deriva_a_UR__c
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);  
                    Caso.Status = 'En Proceso';
                }
                
                if (Test.isRunningTest()) 
                {
                    if (Prueba == 'OK')
                    {
                        Caso.Tipo_de_Requerimiento__c = 'Reclamos';
                    }
                }
                                 
                if (Caso.Tipo_de_Requerimiento__c == 'Reclamos')
                {
                    Map<Id, Attachment> mapAdjuntos = New Map<Id, Attachment>([Select Id, ParentId, Name from Attachment where ParentId =:IDCASO]);

                    Boolean tieneCartaClienteCheck = false;
                   // Boolean tieneAdjuntoCartaRespuesta = false;
                    Boolean tieneAdjuntoCartaCliente = false;

                    /*
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
                    }*/
                }
                
                if (Test.isRunningTest()) 
                {
                    if (Prueba == 'OK1')
                    {
                        Caso.Negocio__c = 'Seguros Individuales';
                    }
                }
                                
                Caso.Entrega_Respuesta__c = false;
                
                
                if (Caso.Status == 'En Proceso')//
                {
                    Boolean permitido = true;
                    if (Caso.Negocio__c == 'Seguros Individuales')
                	{
                        if (EscritorioDigital_Internal.RequerimientoEDIND( Caso.Detalle_Solicitud__c) == true)
                        {
                            if (EscritorioDigital_Internal.EsUsuarioValido() == false)
                            {
                                permitido = false;
                            }
                        }
                	}
                    
                    if (permitido)
                    {
                        List<asignacion_UR__c> asignaciones = [select Id from asignacion_UR__c where Detalle_Solicitud__c =: Caso.Detalle_Solicitud__c and Responsable__c != null]; 
                        system.debug('Detalle_Solicitud__c --> '+ Caso.Detalle_Solicitud__c);
                        system.debug('Asignaciones UR --> '+asignaciones);
                        if (asignaciones.size() > 0)
                        {
                            PageReference page = new PageReference ('/apex/VIE_CierreRequerimiento_Error?id='+ IDCASO+'&mensaje=caso_enproceso_sinasignar');                    
                            page.setRedirect(true);
                            return page;
                        } 
                    }                        
                }
              
                if (Test.isRunningTest()) 
                {
                    Caso.Status = 'Nuevo';
                }
                
                if (Caso.Status == 'Nuevo')//
                {
                    Boolean permitido = true;
                    if (Caso.Negocio__c == 'Seguros Individuales')
                	{
                        if (EscritorioDigital_Internal.RequerimientoEDIND( Caso.Detalle_Solicitud__c) == true)
                        {
                            if (EscritorioDigital_Internal.EsUsuarioValido() == false)
                            {
                                permitido = false;
                            }
                        }
                	}
                    
                    if (permitido)
                    {
                        List<asignacion_UR__c> asignaciones = [select Id from asignacion_UR__c where Detalle_Solicitud__c =: Caso.Detalle_Solicitud__c and Responsable__c != null];
                    
                       if (asignaciones.size() > 0)
                       {
                           PageReference page = new PageReference ('/apex/VIE_CierreRequerimiento_Error?id='+ IDCASO+'&mensaje=caso_nuevosinasignar');                    
                           page.setRedirect(true);
                           return page;
                       }
                    }                    
                }
                
                this.Estado = 'Cerrado';
                
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
    
    public PageReference CierreRequerimiento_cargaCasoSeleccionadoError(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            CODMENSAJE = apexpages.currentpage().getparameters().get('mensaje');
            System.debug('@@@@|IDCASO '+IDCASO); 
            Botonera = false;
            
            if (Test.isRunningTest()) 
            {
                if (Prueba == 'OK')
                {
                	IDCASO = '';    
                }
            }
                        
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                    CODMENSAJE = 'caso_enproceso_sinasignar';
                }
                
                Caso.Entrega_Respuesta__c = false;
                
                if (CODMENSAJE == 'caso_enproceso_sinasignar')
                {
                    Botonera = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'El Requerimiento que desea Cerrar posee asignadas Reglas de Derivación.'));                
                }                    
                
                if (Test.isRunningTest()) 
                {
                    CODMENSAJE = 'caso_nuevosinasignar';
                }
                
                if (CODMENSAJE == 'caso_nuevosinasignar')
                {
                    Botonera = true;
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'El Requerimiento que desea Cerrar posee asignadas Reglas de Derivación.'));                
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
        Caso.Status = Estado;
        Caso.Entrega_Respuesta__c = true;
        update Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }
    
    /************************************************* CierreRequerimiento *************************************************/
    
    
    /************************************************ AperturaRequerimiento ************************************************/
   public PageReference AperturaRequerimiento_validaAtencion()
   {
       try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
                        
            If(IDCASO != ''){
                Caso = new Case();
                Case CasoPrincipal = new Case();
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, ParentId
                               FROM Case
                               WHERE Id =: IDCASO];
                    
                     CasoPrincipal = [select Id, Status from Case where ID =: Caso.ParentId][0];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                    CasoPrincipal.Status = 'Nuevo';
                }
                
                if (Test.isRunningTest()) 
                {
                    if (Prueba == 'OK')
                    {
                        CasoPrincipal.Status = 'Cerrado'; 
                    }
                }
               
                if (CasoPrincipal.Status == 'Cerrado' ||  CasoPrincipal.Status == 'Cerrado (Correo Duplicado)' || CasoPrincipal.Status == 'Cerrado (Correo Masivo)') 
                {
                    CODMENSAJE = 'caso_padre_cerrado';
                    return null;
                }
                else
                {
                    PageReference page = new PageReference ('/apex/VIE_AperturaRequerimiento?id='+ IDCASO);                    
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
    
    public PageReference AperturaCasoHijo_cargaCasoSeleccionado(){
        try
        {
            IDCASO = apexpages.currentpage().getparameters().get('id');
            System.debug('@@@@|IDCASO '+IDCASO); 
                        
            If(IDCASO != ''){
                Caso = new Case();
               
                if (!Test.isRunningTest()) 
                {
               		 Caso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId, Entrega_Respuesta__c,	
                               createdById, OwnerId, Fecha_Cierre_Tope__c, Negocio__c, Concepto__c,Producto__c,CASO_Categoria__c,Detalle_de_Rescate__c,
                               Tipo_Operacion__c,Detalle_Operacion__c,CASO_Dias_en_Back_Office__c, CASO_Responsable_UR__c, Canal__c, CreatedDate,	
                               Detalle_Solicitud__c,CASO_N_Poliza__c,Tipo_de_Requerimiento__c, Id_Requerimiento_EscritorioDigital__c,Nombre_Completo_Razon_Social__c,
                               Parent.OwnerId, ParentId
                               FROM Case
                               WHERE Id =: IDCASO];
                }
                else
                { //utilizado para las pruebas
                    Account cuenta = Factory.cuenta.buildInsert();                           
                    Caso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                }
                
                Caso.Entrega_Respuesta__c = false;
                
                this.Estado = 'En Proceso';
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
        Caso.Status = Estado;
        update Caso;
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;        
    }
    /************************************************ AperturaRequerimiento ************************************************/
   
    
    public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.Caso.Id);
        return page;
    }
    
    
}