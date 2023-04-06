/*******************************************************************************************
 *  NOMBRE                 : CTR_DerivarCaso
 *  TIPO				   : APEX CLASS
 *  REQUERIMIENTO          : MANTENCION UR - ED
 *  DESCRIPCION            :
 * 
 * *****************************************************************************************
 *  VERSIÓN - FECHA C/M  - RESPONSABLE      - OBSERVACIONES
 *  1.0     - 2018/12/17 - J.ESPINOZA       - Creación Clase
 * 
 * *****************************************************************************************/
public class CTR_DerivarCaso {
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
            
            //Case c;

           // if (!Test.isRunningTest()) 
            //{
                Case tmp = [SELECT Id, OwnerId, OwnerId__c, Email_Deriva_Caso__c FROM Case WHERE Id =: ID];
                if (String.isBlank(tmp.OwnerId__c))
                {
                    User u = [SELECT Id, Email FROM User WHERE Id =: tmp.OwnerId];
                    tmp.Email_Deriva_Caso__c = u.Email;
                    tmp.OwnerId__c = tmp.OwnerId;
                    update tmp;
                }

                Case c = [SELECT Id, RecordTypeId, Detalle_Solicitud__c, OwnerId, Status, Negocio__c, CASO_Responsable_UR__c, Id_Responsable_UR__c, CreatedById FROM Case WHERE Id =: ID];
               
                system.debug('@@@@ Estado Caso'+ c.Status);
                
                Boolean DerPermitida = true;

            	if (!Test.isRunningTest())
                {
                    DerPermitida = CLS_DerivarCaso_Comun.DerivacionPermitida(ID);
                } 
            	
            	if (DerPermitida == false)
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_UR_ErrorDerivacion?idCaso='+ ID);                                           
                    page.getParameters().put('Error', 'DERIVACION_NO_PERMITIDA');   
                    return page;
                }
                    
                      
            /*}
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
            } */
            system.debug('@@@@ ID'+ ID);           
            system.debug('@@@@ Ic.RecordTypeId'+ c.RecordTypeId);           

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
                String mensaje ='';
                system.debug('@@@@ Estado Caso --> '+ c.Status);
                
                String cambioED  = CLS_DerivarCaso_Comun.RequerimientoEscritorioDigital(ID, UserInfo.getUserId());
                system.debug('@@@@ responseED'+ cambioED);                      

                if (Test.isRunningTest()) 
                {
                    cambioED = 'REQUERIMIENTO_NO_ED';
                }
                
                system.debug('@@@@ Cambio ED'+ cambioED);

                if (cambioED == 'REQUERIMIENTO_NO_ED' || cambioED == 'CAMBIO_ESTADO_OK' || 
                    cambioED == 'REQUERIMIENTO_ESTADO_INGRESADO' || cambioED == 'REQUERIMIENTO_ESTADO_FINALIZADO' )//cambio ok, req no ed
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
                else if (cambioED == 'REQUERIMIENTO_NO_CREADO_ED')//requerimiento corresponde a ED pero no ha sido creado
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_ED_PendienteDerivacion?idCaso='+ ID);  
                    
                    return page;
                } 
                else 
                {
                    PageReference page = new PageReference ('/apex/SEC_VF_ED_ErrorDerivacion?idCaso='+ ID);     
                    system.debug('@@@@ Error salida --> '+ cambioED); 
                    page.getParameters().put('Error', cambioED);            
                    
                    if (cambioED == 'VALUETECH_ERROR') //cuando ocurra error en Valuetech (ejemplo)
                    {
                        page.getParameters().put('Mensaje', mensaje);                
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
                
                if(caso != null)
                {                 
                     CLS_DerivarCaso_Comun.ValidaPropietarioCaso(caso);
                }
            }catch(Exception ex)
            {
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
}