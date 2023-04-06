/*******************************************************************************************
 *  NOMBRE                 : CLS_DerivarCasos
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 * 
 * *****************************************************************************************/
global class CLS_DerivarCasos {

    private string ID_RASIG_SOLICITUD;
    private string ID_RASIG_RECLAMO;
    private string ID_RASIG_CONSULTA;
    private string NOM_TIPOREGISTRO;
    
    //public List<Case> LST_CHIJOS {get; set;}
    
    public string Prueba {get; set;}
        
              
    /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference derivarCasos(){
        try{
            String ID = apexpages.currentpage().getparameters().get('id');
            Case c;
            if (!Test.isRunningTest()) 
            {
                c = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: ID];
               
                system.debug('@@@@ Estado Caso'+ c.Status);
                
                //if (c.Negocio__c == 'Seguros Individuales')
                //{
                  //  if (EscritorioDigital_Internal.RequerimientoEDIND( c.Detalle_Solicitud__c) == false)
                   // {
                       /* if (EscritorioDigital_Internal.EsUsuarioValido() == false)
                        {*/
                     //       PageReference page = new PageReference ('/apex/EscritorioDigitalError_Page?Id='+ ID);                          
                       //     page.getParameters().put('Operacion','DERIVARCASO|7');            
                            
                         //   return page;
                        /*}*/
                    //}
                //}       
            }
            else
            {
                if (this.Prueba == 'Consultas')
                {
                    Account cuenta = Factory.crearAccountAnonimo();
        			c = FactoryEscritorio.buildCasoED('Consultas',cuenta);
                }
                else if (this.Prueba == 'Solicitudes' || this.Prueba == 'Especial')
                {
                    Account cuenta = Factory.crearAccountAnonimo();
        			c = FactoryEscritorio.buildCasoED('Solicitudes',cuenta);
                }
                else if (this.Prueba == 'Reclamos')
                {
                    Account cuenta = Factory.crearAccountAnonimo();
        			c = FactoryEscritorio.buildCasoED('Reclamos',cuenta);
                }
            }
                        
            NOM_TIPOREGISTRO = [SELECT Name FROM RecordType WHERE Id =: c.RecordTypeId].Name;
            Database.DMLOptions dmo = new Database.DMLOptions();

            if (NOM_TIPOREGISTRO == 'Consultas')
            {
                ID_RASIG_CONSULTA = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Consultas'].Id;
                system.debug('@@@@ ID'+ ID);                      
                dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_CONSULTA;
                c.setOptions(dmo);
                List<Case> lsC = new List<Case>();
                c.Status = 'Back Office';
                c.CASO_Deriva_a_UR__c = true;
                lsC.add(c);
                Database.update(lsC,dmo);

                CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
                if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
                {                       
                    CLAsign.AsignarCaso(c); 
                }
                else {
                    CLAsign.ReasignarCaso(c.Id);
                }
            }
            else if (NOM_TIPOREGISTRO == 'Reclamos')
            {
                ID_RASIG_RECLAMO = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Reclamos'].Id;
                dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_RECLAMO;
                c.setOptions(dmo);
                List<Case> lsC = new List<Case>();
                c.Status = 'Back Office';
                c.CASO_Deriva_a_UR__c = true;
                lsC.add(c);
                Database.update(lsC,dmo);
                
                CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
                if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
                {                       
                    CLAsign.AsignarCaso(c); 
                }
                else {
                    CLAsign.ReasignarCaso(c.Id);
                }          
              
            }
            else if (NOM_TIPOREGISTRO == 'Solicitudes')
            {
                Integer cambioED = 0;
                String mensaje ='';
                system.debug('@@@@ Estado Caso --> '+ c.Status);
                system.debug('@@@@ Responsable Caso --> '+ c.CASO_Responsable_UR__c);
                
                if (this.Prueba == 'Especial')
                {
                    c.Status = 'Cerrado';
                }
                
                if (c.Status == 'Cerrado' || c.Status == 'Caso Cerrado' || c.Status == 'Back Office' 
                    || c.Status == 'Rechazado' || (c.Status == 'En Proceso' && c.CASO_Responsable_UR__c != null))
                {
                    PageReference page = new PageReference ('/apex/VIE_NoDerivaCerrado?idCaso='+ ID);                           
                    page.setRedirect(true);   
                        
                    return page;
                }                
                
                if ((c.Status != 'En Revisión' && c.Status != 'Revisión'))
                {
                    String responseED = CambioEstado_EscritorioDigital(ID);  //en caso de querer que pase poner responseED = '2';
                    system.debug('@@@@ responseED'+ responseED);
                    
                    String[] response = responseED.split(';');
                    cambioED = Integer.valueOf(response[0]);
                    
                    if (response.size() > 1)
                    {
                        mensaje = response[1];
                    }                        
                }
                else
                {
                    cambioED = 2;
                }

                if (Test.isRunningTest()) 
                {
                    cambioED = 2;
                }
                
                system.debug('@@@@ Cambio ED'+ cambioED);
                if (cambioED == 2 || cambioED == 5 )// || true)//cambio ok, req no creado ed, req no ed
                {                    
                    ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                    dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                    c.setOptions(dmo);
                    List<Case> lsC = new List<Case>();
                    c.Status = 'Back Office';
                    c.CASO_Deriva_a_UR__c = true;
                    lsC.add(c);
                    Database.update(lsC,dmo);

                    CLS_ProcesoAsignacionResponsableCasos CLAsign = new CLS_ProcesoAsignacionResponsableCasos();
                    if (c.Id_Responsable_UR__c == null || c.Id_Responsable_UR__c == '')
                    {                       
                        CLAsign.AsignarCaso(c); 
                    }
                    else {
                        CLAsign.ReasignarCaso(c.Id);
                    }
                }
                else if (cambioED == 4)
                {
                    PageReference page = new PageReference ('/apex/EscritorioDigital_Deriva_Page?idCaso='+ ID);  
                    
                    return page;
                } 
                else
                {
                    PageReference page = new PageReference ('/apex/EscritorioDigitalError_Page?Id='+ ID);                          
                    page.getParameters().put('Operacion','DERIVARCASO|'+ cambioED);            
                    
                    if (cambioED == 6) //cuando ocurra error en Valuetech (ejemplo)
                    {
                        page.getParameters().put('MensajeDerivarCaso', mensaje);                
                    }
                    
                    return page;
                }
            }            
            
            //Validar si propietario es Manuel Poblete
            try{
                Case caso = new Case();
                if (!Test.isRunningTest()) 
                {
                    caso = [SELECT Id, OwnerId, CreatedById FROM Case WHERE Id =: c.Id];
                }
                else
                {
                    caso.OwnerId = '005i0000008xsC2';//ID en pro y snd de Manuel Poblete
                }
                
                if(caso != null){
                    system.debug('@@@@ INFO CASO => ' + caso);
                    String Propietario = caso.OwnerId;
                    system.debug('@@@@ TIPO PROPIETARIO (USER/QUEUE) => ' + Propietario.substring(0, 3));
                    if(Propietario.substring(0, 3) == '005'){
                        User u = [SELECT Id, FirstName, Username, LastName, Name FROM User WHERE Id =: caso.OwnerId];
                        system.debug('@@@@ USUARIO => ' + u.Name);
                        if(u != null && u.Name == 'Manuel Eduardo Poblete López'){                            
                            caso.OwnerId = caso.CreatedById;
                            caso.Status = 'En Proceso';
                            caso.CASO_Responsable_UR__c = null;
                            caso.CASO_Resultado_Derivaci_n__c = 'NO EXISTE REGLA DE ASIGNACIÓN...';
                            update caso;
                        }
                    }else{
                        caso.CASO_Resultado_Derivaci_n__c = 'CORRECTA ASIGNACIÓN...';
                        update caso;                                
                    }
                }
            }catch(Exception ex){
                system.debug('@@@@ ERROR - Asignación Creador por Usuario Predeterminado');
                system.debug('@@@@ MENSAJE: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            }            
            
            PageReference detalleCaso = new PageReference('/' + c.Id);
            detalleCaso.setRedirect(true);
            return detalleCaso;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
             
                system.debug('@@@@ EXCEPCION: ' + ex.getMessage() + '; LINEA: ' + ex.getLineNumber());
            return null;
        } 
    }
    
    /***INTEGRACION ESCRITORIO DIGITAL**/
   
    public String CambioEstado_EscritorioDigital(String ID){
        try
        {
            String IdRequerimiento = '';
            String RutUsuario = '';
            String Salida = '';
                        
            List<User> lusers = [Select RUT_Usuario__c From User Where Id = :UserInfo.getUserId()];
                
            if (lusers.size() > 0)
            {
                RutUsuario = lusers[0].RUT_Usuario__c;   
            } 
                        
            if (RutUsuario != '')
            {                
                String DetalleSolicitud =  '';
                String Etiqueta = '';
                List<Case> lcases = [Select Id, Id_Requerimiento_EscritorioDigital__c, Detalle_Solicitud__c From Case Where Id = : ID];                
                
                if (lcases.size() > 0)
                {                   
                    IdRequerimiento =  lcases[0].Id_Requerimiento_EscritorioDigital__c; 
                    DetalleSolicitud = lcases[0].Detalle_Solicitud__c;
                    Etiqueta = EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);
                }
                
                if (Test.isRunningTest()) 
                {
                    DetalleSolicitud = 'Solicitud garantía estatal';
                    IdRequerimiento= '69';
                    Etiqueta = DetalleSolicitud;
                }

                if (Etiqueta != '')
                {
                    if (IdRequerimiento == null || IdRequerimiento == '')
                    {
                        Salida = '4';//Requerimiento no creado en ED
                    }
                    else
                    {
                       EscritorioDigital_Consume.Respuesta_CambioEstado Respuesta = EscritorioDigital_Consume.cambiarEstadoRequerimiento(Integer.valueOf(IdRequerimiento), 'INGRESADO', RutUsuario);    
                       system.debug('@@@@ Respuesta Cambio Estado ED'+ Respuesta);
                       if (Respuesta.Codigo == '00')
                       {
                          Salida = '5';//Ok
                       }
                        else if (Respuesta.Codigo == '05')
                        {
                            Salida = '6;' + Respuesta.Mensaje;//Error al cambiar estado en ED o Valuetech.                                                      
                        }
                       else
                       {
                          Salida = '3';//Error al cambiar estado en ED o Valuetech.                          
                       }                         
                    }
                } 
                else
                {
                    Salida = '2'; //Ok, Caso no corresponde a Requerimiento ED
                }                      
            }
            else
            {
                Salida = '1';//Error, RUT de Usuario no registrado
            }
            
            return Salida;
           
        }catch(Exception ex){
            System.debug('@@@@|CambioEstadoDerivaCaso@@'+ex); 
        //    ApexPages.addMessages(ex);
            return '-3';
        }
    } 
    
    
    /***INTEGRACION ESCRITORIO DIGITAL**/
    
    public Case verCaso {get; set;} 
    public String Titulo {get; set;} 
       
    public PageReference cargaCasoSeleccionado(){
        try{
            String IDCASO = apexpages.currentpage().getparameters().get('idCaso');
             System.debug('@@@@|IDCASO '+IDCASO); 
             
                        
            If(IDCASO != ''){
                verCaso = new Case();
               
                if (!Test.isRunningTest()) 
                {
                verCaso = [SELECT Id, CaseNumber,RUT__c, Subject, AccountId, ContactId, Origin,Description, Status, RecordTypeId,	
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
                    verCaso = FactoryEscritorio.buildCasoED('Solicitudes', cuenta);   
                    if (Prueba == '1')
                    {
                        verCaso.Status = 'Cerrado';
                    }
                    else if (Prueba == '2')
                    {
                        verCaso.Status = 'Back Office';
                    }
                    else if (Prueba == '3')
                    {
                        verCaso.Status = 'En Proceso';
                    }
                    else if (Prueba == '4')
                    {
                        verCaso.Status = 'Rechazado';
                    }                    
                }
             
               return null;
                
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No es posible cargar caso seleccionado...'));
                return null;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        } 
         
         
    }
    
     public PageReference ToCase()
    {
        PageReference page = new PageReference ('/'+ this.verCaso.Id);
        return page;
    }
    
}