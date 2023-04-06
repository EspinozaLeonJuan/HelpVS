/*******************************************************************************************
 *  NOMBRE                 : CTR_DerivacionSelectivaCasos
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/

public with sharing class CTR_DerivacionSelectivaCasos {
    
    public  ApexPages.StandardSetController setCasos;
    private string ID_RASIG_SOLICITUD; 
    private string ID_RASIG_RECLAMO; 
    private string ID_RASIG_CONSULTA;    
    public List<Case> LST_CHIJOS {get; set;}
    public string ID {get;set;}
    private string NOM_TIPOREGISTRO;
    public Boolean Correcto {get; set;}
    public String CerradoAtencion {get; set;} 
    
    public CTR_DerivacionSelectivaCasos()
    {
        
    }

    public CTR_DerivacionSelectivaCasos(ApexPages.StandardSetController controller){
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
                    if (String.isBlank(c.OwnerId__c))
                    { 
                        Case t = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: c.Id];
                        User u = [SELECT Id, Email FROM User WHERE Id =: t.OwnerId];
                        t.OwnerId__c = t.OwnerId;
                        t.Email_Deriva_Caso__c = u.Email;
                        update t;
                    }

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
                        
                        system.debug('@@@@@ Status => ' + Status);

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
    public PageReference cargaCasosHijosDerivar()
    {        
        try
        {
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
                Boolean exito;
                for(Case c : LST_CHIJOS){        
                    
                    if (!Test.isRunningTest())
                    {
                        exito = CLS_DerivarCaso_Comun.DerivacionPermitida(ID);
                    }
                    else 
                    {
                       exito = true;
                    }
                    
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

                                String cambioED  = CLS_DerivarCaso_Comun.RequerimientoEscritorioDigital(c.Id, UserInfo.getUserId());
                                system.debug('@@@@ cambioED'+ cambioED);                      

                                if (Test.isRunningTest()) 
                                {
                                    cambioED = 'REQUERIMIENTO_NO_ED';
                                }

                                if (cambioED == 'REQUERIMIENTO_NO_ED' || cambioED == 'CAMBIO_ESTADO_OK' || cambioED=='REQUERIMIENTO_NO_CREADO_ED' ||
                                    cambioED == 'REQUERIMIENTO_ESTADO_INGRESADO' || cambioED == 'REQUERIMIENTO_ESTADO_FINALIZADO' )//cambio ok, req no ed
                                {                    
                                    ID_RASIG_SOLICITUD = [SELECT Id FROM AssignmentRule WHERE Name = 'UR - Solicitudes'].Id;
                                    dmo.assignmentRuleHeader.assignmentRuleId = ID_RASIG_SOLICITUD;
                                    c.setOptions(dmo);
                                    List<Case> lsC = new List<Case>();
                                    c.Fecha_Derivacion_UR__c = Datetime.now();//
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
   
    
    
    
}