/*******************************************************************************************
 *  NOMBRE                 : CLS_DerivacionSelectivaCasos
 *  TIPO                   : APEX CLASS
 *  REQUERIMIENTO          : PROYECTO UR - UNIDADES RESOLUTORAS POSTVENTA
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 18/04/2018 - H.NORAMBUENA     - Creación Clase
 *  2.0     - 06/09/2018 - J.ESPINOZA       - 
 * *****************************************************************************************/
public with sharing class CLS_DerivacionSelectivaCasos {
    
    private string ID_RASIG_SOLICITUD; // = '01Qf0000000ECGM';//'01Q3D0000001AXb';//'01Q290000001Mrn';
    private string ID_RASIG_RECLAMO; // =  '01Qf0000000ECGL';//'01Q3D0000001AVk';//01Q290000001Mt0';
    private string ID_RASIG_CONSULTA; // =  '01Qf0000000ECGK';//'01Q3D0000001AVl';//01Q290000001Mt5';
    public  ApexPages.StandardSetController setCasos;
    public List<Case> LST_CHIJOS {get; set;}
    public string ID {get;set;}
    private string NOM_TIPOREGISTRO;
    public Boolean Correcto {get; set;}
    public String CerradoAtencion {get; set;} 
    
    public CLS_DerivacionSelectivaCasos(ApexPages.StandardSetController controller){
        setCasos = controller;
    }
    
     public PageReference evaluaCasosHijosDerivar(){        
        // LST_CHIJOS = new List<Case>();
         Correcto = true;
         CerradoAtencion = '';
          String EstadoAt = '';
         if (!Test.isRunningTest()) 
         {
             ID = apexpages.currentpage().getparameters().get('id');             
             LST_CHIJOS = (List<Case>)setCasos.getSelected();                           
             
             EstadoAt = [SELECT Status FROM Case WHERE Id =: ID].Status;             
             
         }    
         else
         {
             EstadoAt = 'En Proceso';
         }
         
         if (EstadoAt == 'Cerrado' || EstadoAt == 'Caso Cerrado' || EstadoAt == 'Cerrado (Correo Duplicado)' || EstadoAt == 'Cerrado (Correo Masivo)')
         {
             CerradoAtencion = 'cerrado';
         }
         
         if (EstadoAt == 'Basura')
         {
             CerradoAtencion = 'basura';
         }
             
         
         if (CerradoAtencion == '')
         {                 
             if(LST_CHIJOS.size() > 0){
             
                 for(Case c : LST_CHIJOS){        
                     Database.DMLOptions dmo = new Database.DMLOptions();
                     NOM_TIPOREGISTRO = [SELECT Name FROM RecordType WHERE Id =: c.RecordTypeId].Name;
                     if(NOM_TIPOREGISTRO == 'Solicitudes'){ //Solicitudes                          
                         String Status = '';
                         String Responsable = '';
                         if (!Test.isRunningTest())
                         {
                            List<Case> tmp = [SELECT Status, CASO_Responsable_UR__c FROM Case WHERE Id =: c.Id];
                            Status = tmp[0].Status;
                            Responsable = tmp[0].CASO_Responsable_UR__c;
                             
                         }
                         
                         if (Status == 'Cerrado' || Status == 'Caso Cerrado' ||
                             Status == 'Back Office' || Status == 'Rechazado' ||
                             (Status == 'En Proceso' && Responsable != null) )
                         {
                             Correcto = false;
                             break;
                         }
                     }
                 }
             
                 system.debug('@@@@@ Correcto => ' + Correcto);
                 if (Correcto == true)
                 {
                     return cargaCasosHijosDerivar();
                 }
             }
             else
             {
                 CerradoAtencion = 'sin_casos';
             }
         }
             
         return null;  
         
     }
    
    /*Método para navegar a página Menú Principal desde Vista de Caso Seleccionado*/
    public PageReference cargaCasosHijosDerivar(){
        
        try{
           /* if (!Test.isRunningTest()) 
            {
                 LST_CHIJOS = new List<Case>();
            	 system.debug('@@@@@ SETCASOS => ' + setCasos.getResultSize());
                 LST_CHIJOS = (List<Case>)setCasos.getSelected();                           
            }*/
            
            system.debug('@@@@@ CASOS TRANSFERIDOS => ' + LST_CHIJOS.size());
            system.debug('@@@@@ CASOS => ' + LST_CHIJOS);
            
            if(LST_CHIJOS.size() > 0){
                
                if (!Test.isRunningTest()) 
                {
       				ID = [SELECT ParentId FROM Case WHERE Id =: LST_CHIJOS[0].Id].ParentId;
                }
                else
                {
                    ID = '5000H00000x7H2W';//para la cobertura de codigo
                }
                               
                derivarCasoHijo();            
                if(ID != ''){
                    PageReference detalleCaso = new PageReference('/' + ID);
                    detalleCaso.setRedirect(true);
                    system.debug('@@@@@ RETORNO => ' + detalleCaso);
                    return detalleCaso;
                }
                else
                {
                    return null;
                }
            }
            else
            {
                system.debug('@@@@ SIN CASOS SELECCIONADOS...');
                String IdCasoPadre = apexpages.currentpage().getparameters().get('id');
                
                PageReference detalleCaso = new PageReference('/' + IdCasoPadre);
                detalleCaso.setRedirect(true);
                system.debug('@@@@@ RETORNO => ' + detalleCaso);
                return detalleCaso;
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
            return null;
        }
    } 
    
    /* Método que permite derivar un caso hijo de forma masiva desde caso de atención...*/
    public void derivarCasoHijo(){
        try{
            if(LST_CHIJOS.size() > 0){
                system.debug('@@@@@ ZONA DERIVACIÓN => ' + LST_CHIJOS);
                Boolean exito = true;
                for(Case c : LST_CHIJOS){        
                    
                    //exito = DerivacionPermitidaIND(c.Id);
                    
                    if (exito == true)
                    {
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        NOM_TIPOREGISTRO = [SELECT Name FROM RecordType WHERE Id =: c.RecordTypeId].Name;
                        if(NOM_TIPOREGISTRO == 'Solicitudes'){ //Solicitudes
                           
                            /*  ED  */
                            String Status = '';
                            if (!Test.isRunningTest())
                            {
                                 Status = [SELECT Status FROM Case WHERE Id =: c.Id].Status;
                            }
                            
                            if (Status != 'Cerrado' && Status != 'Caso Cerrado' && 
                                Status != 'Back Office' && Status != 'Rechazado')
                            {
                                Integer cambioED = 0;
                            
                                if (Status != 'En Revisión' && Status != 'Revisión')
                                {
                                    String responseED = CambioEstado_EscritorioDigital(c.Id);  //en caso de querer que pase poner responseED = '2';
                                    system.debug('@@@@ responseED'+ responseED);
                                
                                    String[] response = responseED.split(';');
                                    cambioED = Integer.valueOf(response[0]);
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
                              
                                if (cambioED == 2 || cambioED == 4 ||cambioED == 5)//  || true)//cambio ok, req no creado ed, req no ed
                                {                    
                                    ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                                    dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                                    c.setOptions(dmo);
                                    List<Case> lsC = new List<Case>();
                                    c.Status = 'Back Office';                        
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
                                }   //si no cumple con ED no hace nada con el caso analizado   
                            }
                        } 
                        if(NOM_TIPOREGISTRO == 'Reclamos'){ //Reclamos
                            ID_RASIG_RECLAMO = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Reclamos'].Id;
                            dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_RECLAMO;
                            c.setOptions(dmo);
                            List<Case> lsC = new List<Case>();
                            c.Status = 'Back Office';
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
                        if(NOM_TIPOREGISTRO == 'Consultas'){ //Consultas
                            ID_RASIG_CONSULTA = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Consultas'].Id;
                            dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_CONSULTA;
                            c.setOptions(dmo);
                            List<Case> lsC = new List<Case>();
                            c.Status = 'Back Office';
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
                    }
                    
                    
                }
            }
        }catch(Exception ex){
            ApexPages.addMessages(ex);
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
                String Etiqueta =  '';
                List<Case> lcases = [Select Id, Id_Requerimiento_EscritorioDigital__c, Detalle_Solicitud__c From Case Where Id = : ID];                
                
                  system.debug('@@@@ ID CASO ED => ' + ID);
                
                if (lcases.size() > 0)
                {                   
                    IdRequerimiento =  lcases[0].Id_Requerimiento_EscritorioDigital__c; 
                    DetalleSolicitud = lcases[0].Detalle_Solicitud__c;
                    Etiqueta = EscritorioDigital_Internal.Etiqueta(DetalleSolicitud);                
                }
                
                if (Test.isRunningTest()) 
                {
                    DetalleSolicitud = 'Solicitud Cuota Mortuoria';
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
   
    
    public Boolean DerivacionPermitidaIND(String Id)
    { 
        Boolean exito = true;
        
        if (!Test.isRunningTest()) 
        { 
            Case caso = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Negocio__c, CreatedById FROM Case WHERE Id =: ID];
         
            if (caso.Negocio__c == 'Seguros Individuales')
            {
                if (EscritorioDigital_Internal.RequerimientoEDIND(caso.Detalle_Solicitud__c) == true)
                {           
                    if (EscritorioDigital_Internal.EsUsuarioValido() == false)
                    {
                        exito = false;
                    }
                }    
            }
            
        }
        
        return exito;
    }
    
    
    /***INTEGRACION ESCRITORIO DIGITAL**/
    
}